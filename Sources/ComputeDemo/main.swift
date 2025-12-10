import Compute

private let token =
    """
    eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJleHAiOjE2NzUzNjU0MjgsImlzcyI6ImZhc3RseSJ9.QL2Pm1JnXV_vAYK7ijeD4U1CBjOTLihNMDZ-qfvjkKOTUiK1jyxGEwjZfeApijRaOtQT8fVkdPnKjF-tBiUzkA
    """

try await onIncomingRequest { req, res in
    let jwt = try JWT<EmptyJWTPayload>(token: token)
    try jwt.verify(key: fanoutPublicKey, issuer: "fastly", expiration: false)
    try await res.send(jwt)
}
