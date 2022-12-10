import Compute

try await onIncomingRequest { req, res in
    try await res.send(ProcessInfo.processInfo.environment)
}
