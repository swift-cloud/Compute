//
//  OutgoingResponse.swift
//
//
//  Created by Andrew Barba on 1/13/22.
//

public actor OutgoingResponse {

    internal private(set) var response: Fastly.Response

    internal let body: WritableBody

    internal var didSendAndClose = false

    internal var didSendStream = false

    internal var didSend: Bool {
        didSendAndClose || didSendStream
    }

    public internal(set) var headers: Headers

    public var status: Int {
        get {
            let value = try? response.getStatus()
            return value ?? 200
        }
        set {
            try? response.setStatus(newValue)
        }
    }

    public var contentType: String? {
        get { headers[.contentType] }
        set { headers[.contentType] = newValue }
    }

    internal init(writableBody: Bool) throws {
        let response = try Fastly.Response()
        self.response = response
        self.body = WritableBody(try .init(), writable: writableBody)
        self.headers = Headers(response)
    }

    @discardableResult
    private func defaultContentType(_ value: String) throws -> Self {
        if contentType == nil {
            contentType = value
        }
        return self
    }

    private func sendAndClose() async throws {
        defer {
            didSendAndClose = true
        }
        try await response.send(body.body, streaming: false)
    }

    private func sendAndStream() async throws {
        guard didSendStream == false else {
            return
        }
        defer {
            didSendStream = true
        }
        if headers[.contentLength] != nil, Fastly.Environment.viceroy == false {
            try response.setFramingHeadersMode(.manuallyFromHeaders)
        }
        try await response.send(body.body, streaming: true)
    }

    @discardableResult
    public func contentType(_ value: String) -> Self {
        contentType = value
        return self
    }

    @discardableResult
    public func status(_ newValue: Int) -> Self {
        status = newValue
        return self
    }

    @discardableResult
    public func status(_ newValue: HTTPStatus) -> Self {
        status = newValue.rawValue
        return self
    }

    @discardableResult
    public func header(_ name: String, _ value: String?) -> Self {
        headers[name] = value
        return self
    }

    @discardableResult
    public func header(_ name: HTTPHeader, _ value: String?) -> Self {
        headers[name] = value
        return self
    }

    public func end() async throws {
        try await body.close()
    }

    public func cancel() throws {
        try response.close()
    }
}

// MARK: - Send

extension OutgoingResponse {

    public func send<T>(
        _ value: T,
        encoder: JSONEncoder = .init(),
        contentType: String = "application/json"
    ) async throws where T: Encodable & Sendable {
        try defaultContentType(contentType)
        try await body.write(value, encoder: encoder)
        try await sendAndClose()
    }

    public func send(_ jsonObject: [String: Sendable]) async throws {
        try defaultContentType("application/json")
        try await body.write(jsonObject)
        try await sendAndClose()
    }

    public func send(_ jsonArray: [Sendable]) async throws {
        try defaultContentType("application/json")
        try await body.write(jsonArray)
        try await sendAndClose()
    }

    public func send(_ text: String) async throws {
        try defaultContentType("text/plain")
        let data = text.data(using: .utf8) ?? .init()
        try await send(data)
    }

    public func send(html text: String) async throws {
        try defaultContentType("text/html")
        let data = text.data(using: .utf8) ?? .init()
        try await send(data)
    }

    public func send(xml text: String) async throws {
        try defaultContentType("application/xml")
        let data = text.data(using: .utf8) ?? .init()
        try await send(data)
    }

    public func send(_ body: ReadableBody) async throws {
        try await append(body).end()
    }

    public func send(_ data: Data) async throws {
        let bytes: [UInt8] = .init(data)
        try await send(bytes)
    }

    public func send(_ bytes: [UInt8]) async throws {
        try await body.write(bytes)
        try await sendAndClose()
    }

    public func send() async throws {
        if status == 200 {
            status = 204
        }
        try await sendAndClose()
    }
}

// MARK: - Append

extension OutgoingResponse {

    @discardableResult
    public func pipeFrom(_ sources: ReadableBody...) async throws -> Self {
        try await sendAndStream()
        for source in sources {
            try await body.pipeFrom(source, preventClose: true)
        }
        return self
    }

    @discardableResult
    public func pipeFrom(_ sources: [ReadableBody]) async throws -> Self {
        try await sendAndStream()
        for source in sources {
            try await body.pipeFrom(source, preventClose: true)
        }
        return self
    }

    @discardableResult
    public func append(_ sources: ReadableBody...) async throws -> Self {
        try await sendAndStream()
        for source in sources {
            try await body.append(source)
        }
        return self
    }

    @discardableResult
    public func append(_ sources: [ReadableBody]) async throws -> Self {
        try await sendAndStream()
        for source in sources {
            try await body.append(source)
        }
        return self
    }
}

// MARK: - Write

extension OutgoingResponse {

    @discardableResult
    public func write<T>(_ value: T, encoder: JSONEncoder = .init()) async throws -> Self
    where T: Encodable & Sendable {
        try await sendAndStream()
        try await body.write(value, encoder: encoder)
        return self
    }

    @discardableResult
    public func write(_ jsonObject: [String: Sendable]) async throws -> Self {
        try await sendAndStream()
        try await body.write(jsonObject)
        return self
    }

    @discardableResult
    public func write(_ jsonArray: [Sendable]) async throws -> Self {
        try await sendAndStream()
        try await body.write(jsonArray)
        return self
    }

    @discardableResult
    public func write(_ text: String) async throws -> Self {
        try await sendAndStream()
        try await body.write(text)
        return self
    }

    @discardableResult
    public func write(_ data: Data) async throws -> Self {
        try await sendAndStream()
        try await body.write(data)
        return self
    }

    @discardableResult
    public func write(_ bytes: [UInt8]) async throws -> Self {
        try await sendAndStream()
        try await body.write(bytes)
        return self
    }
}

// MARK: - Redirect

extension OutgoingResponse {

    public func redirect(_ location: String, permanent: Bool = false) async throws {
        status = permanent ? 308 : 307
        headers[.location] = location
        try await send("Redirecting to \(location)")
    }
}

// MARK: - Proxy

extension OutgoingResponse {

    public func proxy(_ response: FetchResponse, streaming: Bool = true) async throws {
        status = response.status
        for (key, value) in response.headers.entries() {
            guard invalidProxyHeaders.contains(key) == false else { continue }
            headers[key] = headers[key] ?? value
        }
        if streaming {
            try await append(response.body).end()
        } else {
            try await send(response.bytes())
        }
    }
}

private let invalidProxyHeaders: Set<String> = [
    HTTPHeader.altSvc.rawValue,
    HTTPHeader.transferEncoding.rawValue,
]

// MARK: - CORS

extension OutgoingResponse {

    @discardableResult
    public func cors(
        origin: String = "*",
        methods: [HTTPMethod] = [.get, .head, .put, .patch, .post, .delete, .query],
        allowHeaders: [HTTPHeaderRepresentable]? = nil,
        allowCredentials: Bool? = nil,
        exposeHeaders: [HTTPHeaderRepresentable]? = nil,
        maxAge: Int = 600
    ) -> Self {
        headers[.accessControlAllowOrigin] = origin
        headers[.accessControlAllowMethods] = methods.map { $0.rawValue }.joined(separator: ", ")
        headers[.accessControlAllowHeaders] =
            allowHeaders?.map { $0.stringValue }.joined(separator: ", ") ?? "*"
        headers[.accessControlAllowCredentials] = allowCredentials?.description
        headers[.accessControlExposeHeaders] = exposeHeaders?.map { $0.stringValue }.joined(
            separator: ", ")
        headers[.accessControlMaxAge] = String(maxAge)
        return self
    }
}

// MARK: - Compression

extension OutgoingResponse {

    @discardableResult
    public func compress() -> Self {
        headers[.xCompressHint] = "on"
        return self
    }
}

// MARK: - HTTP3

extension OutgoingResponse {

    @discardableResult
    public func upgradeToHTTP3(maxAge: Int = 86400) -> Self {
        headers[.altSvc] =
            #"h3=":443";ma=\#(maxAge),h3-29=":443";ma=\#(maxAge),h3-27=":443";ma=\#(maxAge)"#
        return self
    }
}

// MARK: - Cookie

extension OutgoingResponse {

    public enum CookieOption {
        public enum SameSite: String {
            case strict = "Strict"
            case lax = "Lax"
            case none = "None"
        }

        // Domain=
        case domain(_ domain: String)

        // Expires=
        // TODO: enable this once DateFormatter.dateFormat is available in WASM
        // case expires(_ date: Date)

        // HttpOnly
        case httpOnly

        // Max-Age=
        case maxAge(_ seconds: TimeInterval)

        // Path=
        case path(_ path: String)

        // SameSite=
        case sameSite(_ value: SameSite)

        // Secure
        case secure

        var value: String {
            switch self {
            case .domain(let domain):
                return "Domain=\(domain)"
            // TODO: enable this once DateFormatter.dateFormat is available in WASM
            // case .expires(let date):
            //     return "Expires=\(DateFormatter.httpDate.string(from: date))"
            case .httpOnly:
                return "HttpOnly"
            case .maxAge(let seconds):
                return "Max-Age=\(Int(seconds))"
            case .path(let path):
                return "Path=\(path)"
            case .sameSite(let value):
                return "SameSite=\(value.rawValue)"
            case .secure:
                return "Secure"
            }
        }
    }

    @discardableResult
    public func cookie(
        _ name: String,
        _ value: String,
        _ options: CookieOption...
    ) -> Self {
        return cookie(name, value, options)
    }

    @discardableResult
    public func cookie(
        _ name: String,
        _ value: String,
        _ options: [CookieOption]
    ) -> Self {
        let encodedName =
            name.addingPercentEncoding(withAllowedCharacters: .javascriptURLAllowed) ?? name
        let encodedValue =
            value.addingPercentEncoding(withAllowedCharacters: .javascriptURLAllowed) ?? value
        let parts = ["\(encodedName)=\(encodedValue)"] + options.map(\.value)
        let header = parts.joined(separator: "; ")
        headers.append(.setCookie, header)
        return self
    }
}
