//
//  Router.swift
//
//
//  Created by Andrew Barba on 4/4/22.
//

@MainActor
public final class Router {

    public typealias Handler = (IncomingRequest, OutgoingResponse) async throws -> Void

    public let prefix: String

    private var middleware: [Handler] = []

    private let router: TrieRouter<Handler>

    public init(prefix path: String = "/") {
        self.prefix = path
        self.router = TrieRouter()
    }

    @discardableResult
    private func add(method: HTTPMethod, path: String, handler: @escaping Handler) -> Self {
        let pathComponents = path.components(separatedBy: "/").filter { $0.isEmpty == false }
        let prefixComponents = prefix.components(separatedBy: "/").filter { $0.isEmpty == false }
        let combinedComponents = [method.rawValue] + prefixComponents + pathComponents
        router.register(handler, at: combinedComponents.map { .init(stringLiteral: $0) })
        return self
    }

    private func handler(for req: inout IncomingRequest) -> Handler? {
        let pathComponents = req.url.pathComponents.dropFirst()
        return router.route(
            path: [req.method.rawValue] + pathComponents, parameters: &req.pathParams)
    }
}

extension Router {

    @discardableResult
    public func listen() async throws -> Self {
        try await onIncomingRequest { req, res in
            try await self.run(req, res)
        }
        return self
    }
}

extension Router {

    @discardableResult
    public func get(_ path: String, _ handler: @escaping Handler) -> Self {
        add(method: .head, path: path, handler: handler)
        return add(method: .get, path: path, handler: handler)
    }

    @discardableResult
    public func post(_ path: String, _ handler: @escaping Handler) -> Self {
        return add(method: .post, path: path, handler: handler)
    }

    @discardableResult
    public func put(_ path: String, _ handler: @escaping Handler) -> Self {
        return add(method: .put, path: path, handler: handler)
    }

    @discardableResult
    public func delete(_ path: String, _ handler: @escaping Handler) -> Self {
        return add(method: .delete, path: path, handler: handler)
    }

    @discardableResult
    public func options(_ path: String, _ handler: @escaping Handler) -> Self {
        return add(method: .options, path: path, handler: handler)
    }

    @discardableResult
    public func patch(_ path: String, _ handler: @escaping Handler) -> Self {
        return add(method: .patch, path: path, handler: handler)
    }

    @discardableResult
    public func head(_ path: String, _ handler: @escaping Handler) -> Self {
        return add(method: .head, path: path, handler: handler)
    }

    @discardableResult
    public func all(_ path: String, _ handler: @escaping Handler) -> Self {
        for method in HTTPMethod.allCases {
            add(method: method, path: path, handler: handler)
        }
        return self
    }
}

extension Router {

    @discardableResult
    public func use(_ handler: @escaping Handler) -> Self {
        middleware.append(handler)
        return self
    }
}

extension Router {

    public func run(_ req: IncomingRequest, _ res: OutgoingResponse) async throws {
        // Run all middleware
        for middlewareHandler in middleware {
            try await middlewareHandler(req, res)
        }

        // Check if response was already sent
        guard await res.didSend == false else {
            return
        }

        // Create mutable copy if the request
        var req = req

        // Find matching handler
        guard let handler = handler(for: &req) else {
            return try await res.status(404).send("Not Found: \(req.url.path)")
        }

        // Run handler
        try await handler(req, res)
    }
}
