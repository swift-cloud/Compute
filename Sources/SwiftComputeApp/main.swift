import SwiftCompute

print("Hello, Compute.")

print("env:hostname", Environment.Compute.hostname)

print("env:region", Environment.Compute.region)

print("env:service_id", Environment.Compute.serviceId)

print("env:service_version", Environment.Compute.serviceVersion)

do {
    let dict = try FastlyDictionary(name: "swift")
    print("dict open!")
    let value = try dict.get(key: "auth")
    print("value:", value)


    let logger = try Logger(name: "Logentries")
    print("logger open!")
    let bytes = try logger.write("Hello", "World")
    print("logged bytes:", bytes)
} catch {
    print("error:", error)
}
