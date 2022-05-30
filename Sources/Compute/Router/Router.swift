//
//  Router.swift
//  
//
//  Created by Andrew Barba on 4/4/22.
//

public final class Router {

    public typealias Handler = (IncomingRequest, OutgoingResponse) async throws -> Void

    public let prefix: String

    private var middleware: [Handler] = []

    private let router: TrieRouter<Handler>

    public init(prefix path: String = "") {
        self.prefix = path
        self.router = TrieRouter()
    }

    @discardableResult
    private func add(method: HTTPMethod, path: String, handler: @escaping Handler) -> Self {
        let pathComponents = buildPathComponents(method: method, path: path).map(PathComponent.init)
        router.register(handler, at: pathComponents)
        return self
    }

    private func handler(for req: inout IncomingRequest) -> Handler? {
        let path = buildPathComponents(method: req.method, path: req.url.path)
        return router.route(path: path, parameters: &req.pathParams)
    }

    private func buildPathComponents(method: HTTPMethod, path: String) -> [String] {
        let parts = path.components(separatedBy: "/").filter { $0.isEmpty == false }
        return ["__\(method.rawValue)__", "__\(prefix)__"] + parts
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
    public func put (_ path: String, _ handler: @escaping Handler) -> Self {
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
        guard res.didSend == false else {
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
