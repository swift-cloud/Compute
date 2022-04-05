//
//  Router.swift
//  
//
//  Created by Andrew Barba on 4/4/22.
//

public final class Router {

    public typealias Handler = (IncomingRequest, OutgoingResponse) async throws -> Void

    public typealias PathComponents = [String]

    public typealias PathParameters = [String: String]

    public let prefix: String

    private var handlers: [String: [(paths: [String], handler: Handler)]]

    public init(prefix path: String = "") {
        self.prefix = path
        self.handlers = [:]
    }

    @discardableResult
    internal func add(method: HTTPMethod, path: String, handler: @escaping Handler) -> Self {
        let parts = path.components(separatedBy: "/").filter { $0.count > 0 }
        handlers[method.rawValue, default: []].append((parts, handler))
        return self
    }

    internal func handler(for req: IncomingRequest) -> (handler: Handler, pathComponents: PathParameters)? {
        guard let _handlers = handlers[req.method.rawValue] else {
            return nil
        }

        let parts = req.url.path.components(separatedBy: "/").filter { $0.count > 0 }

        for handler in _handlers {
            if isMatchingPath(internalComponents: handler.paths, externalComponents: parts) {
                let pathParamaters = parsePathParameters(internalComponents: handler.paths, externalComponents: parts)
                return (handler.handler, pathParamaters)
            }
        }

        return nil
    }

    private func parsePathParameters(internalComponents: PathComponents, externalComponents: PathComponents) -> PathParameters {
        guard internalComponents.count <= externalComponents.count else {
            return [:]
        }

        var pathParamaters: PathParameters = [:]

        for (index, component) in internalComponents.enumerated() {
            if component.starts(with: ":") {
                let key = component.replacingOccurrences(of: ":", with: "")
                pathParamaters[key] = externalComponents[index]
            }
        }

        return pathParamaters
    }

    private func isMatchingPath(internalComponents: PathComponents, externalComponents: PathComponents) -> Bool {
        guard internalComponents.count <= externalComponents.count else {
            return false
        }

        for (index, component) in internalComponents.enumerated() {
            if component == "*" {
                return true
            }
            guard component == externalComponents[index] || component.starts(with: ":") else {
                return false
            }
        }

        return internalComponents.count == externalComponents.count
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
}

extension Router {

    public func run(_ req: IncomingRequest, _ res: OutgoingResponse) async throws {
        guard let (handler, pathParams) = handler(for: req) else {
            return try await res.status(404).send("Not Found: \(req.url.path)")
        }
        var req = req
        req.pathParams = pathParams
        try await handler(req, res)
    }
}
