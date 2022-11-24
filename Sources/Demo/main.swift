import Compute

let router = Router()

router.get("/") { req, res in
    let data = try await fetch("https://httpbin.org/json", .options(
        cachePolicy: .ttl(60),
        cacheKey: "meow"
    ))
    try await res.status(200).send(data.jsonObject())
}

try await router.listen()
