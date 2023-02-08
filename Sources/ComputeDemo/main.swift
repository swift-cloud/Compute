import Compute
import Crypto

private let token =
    """
    eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJleHAiOjE2NzUzNjU0MjgsImlzcyI6ImZhc3RseSJ9.QL2Pm1JnXV_vAYK7ijeD4U1CBjOTLihNMDZ-qfvjkKOTUiK1jyxGEwjZfeApijRaOtQT8fVkdPnKjF-tBiUzkA
    """

try await onIncomingRequest { req, res in
    let jwt = try JWT(token: token)
    let message = token.components(separatedBy: ".").dropLast().joined(separator: ".")
    let pk = ECDSA.PublicKey(pem: fanoutPublicKey, curve: .secp256r1)
    let sig = ECDSA.Signature(data: .init(jwt.signature))
    let verified = pk.verify(message: message, signature: sig)
    try await res.send(["v": verified])
}
