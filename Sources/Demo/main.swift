import Compute

let router = Router()

router.get("/") { req, res in
    print("fingerprint:", req.clientFingerprint() ?? "(null)")
    try await res.status(200).send("Hello, Swift")
}

try await router.listen()
