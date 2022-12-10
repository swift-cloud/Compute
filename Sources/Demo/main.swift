import Compute

try await onIncomingRequest { req, res in
    for _ in Array(0...1000) {
        let jwt = try JWT(claims: ["user_id": UUID().uuidString], secret: UUID().uuidString)
        try await res.write(jwt.token + "\n")
    }
    try await res.end()
}
