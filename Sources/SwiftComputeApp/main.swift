import SwiftCompute

print("Hello, Compute!")

do {
    let dict = try FastlyDictionary(name: "swift")
    print("dict open!")
    let value = try dict.get(key: "auth")
    print("value:", value)
} catch {
    print("error:", error)
}
