//
//  Router+Tokamak.swift
//  
//
//  Created by Andrew Barba on 11/27/22.
//

#if canImport(TokamakStaticHTML)
@_exported import TokamakCore
@_exported import TokamakStaticHTML
#else
import SwiftUI

struct StaticHTMLRenderer {
    init(_ view: any View) {}
    func render() -> String { fatalError("Please add TokamakStaticHTML (github.com/TokamakUI/Tokamak) to your Package.swift") }
}
#endif

#if canImport(TokamakStaticHTML) || canImport(SwiftUI)
extension Router {

    typealias ViewHandler<T: View> = (IncomingRequest, OutgoingResponse) async throws -> T

    @discardableResult
    func get<T: View>(_ path: String, _ handler: @autoclosure @escaping () -> T) -> Self {
        return get(path) { _, _ in handler() }
    }

    @discardableResult
    func get<T: View>(_ path: String, _ handler: @escaping ViewHandler<T>) -> Self {
        return get(path, render(handler))
    }

    @discardableResult
    func post<T: View>(_ path: String, _ handler: @autoclosure @escaping () -> T) -> Self {
        return post(path) { _, _ in handler() }
    }

    @discardableResult
    func post<T: View>(_ path: String, _ handler: @escaping ViewHandler<T>) -> Self {
        return post(path, render(handler))
    }

    private func render<T: View>(_ handler: @escaping ViewHandler<T>) -> Router.Handler {
        return { req, res in
            RequestKey.defaultValue = req
            ResponseKey.defaultValue = res
            let view = try await handler(req, res)
                .environment(\.request, req)
                .environment(\.response, res)
            let html = StaticHTMLRenderer(view).render()
            try await res.status(.ok).send(html: html)
        }
    }
}

private struct RequestKey: EnvironmentKey {
    static var defaultValue: Compute.IncomingRequest?
}

extension EnvironmentValues {
    var request: IncomingRequest {
        get { self[RequestKey.self] ?? RequestKey.defaultValue! }
        set { self[RequestKey.self] = newValue }
    }
}

private struct ResponseKey: EnvironmentKey {
    static var defaultValue: Compute.OutgoingResponse?
}

extension EnvironmentValues {
    var response: OutgoingResponse {
        get { self[ResponseKey.self] ?? ResponseKey.defaultValue! }
        set { self[ResponseKey.self] = newValue }
    }
}
#endif
