import Compute

print("Hello, Compute.")

print("env:hostname", Environment.Compute.hostname)

print("env:region", Environment.Compute.region)

print("env:service_id", Environment.Compute.serviceId)

print("env:service_version", Environment.Compute.serviceVersion)

do {
    let dict = try Dictionary(name: "swift")
    print("dict:open")
    print("dict:foo", try dict.get(key: "foo") ?? "(null)")
    print("dict:auth", try dict.get(key: "auth") ?? "(null)")
    print("dict:xxx", try dict.get(key: "xxx") ?? "(null)")

    let logger = try Logger(name: "Logentries")
    print("logger:open")
    let bytes = try logger.write("Hello", "World", "🔥")
    print("logged:bytes", bytes)

    print("ip:74.108.65.199", try Geo.lookup(ipV4: "74.108.65.199"))
} catch {
    print("error:", error)
}

onIncomingRequest { req, res in
    print("req:method", req.method)
    print("req:uri", req.url)
    print("req:version", req.httpVersion)

    res.status(201)

    try res.body.write("Hello, World")
    try res.send()
    print("sent 1")
}
