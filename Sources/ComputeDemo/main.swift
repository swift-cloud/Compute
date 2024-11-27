import Compute

private let token =
    """
    eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJleHAiOjE2NzUzNjU0MjgsImlzcyI6ImZhc3RseSJ9.QL2Pm1JnXV_vAYK7ijeD4U1CBjOTLihNMDZ-qfvjkKOTUiK1jyxGEwjZfeApijRaOtQT8fVkdPnKjF-tBiUzkA
    """

try await onIncomingRequest { req, res in
    let jwt = try JWT(token: token)
    let verified: Bool
    do {
        try jwt.verify(key: fanoutPublicKey, issuer: "fastly", expiration: false)
        verified = true
    } catch {
        verified = false
    }
    try await res.send([
        "verified": verified,
        "signature": jwt.signature.toHexString(),
        "jwt": JWT(claims: ["a": "b"], secret: "hello-world").token,
    ])
}
