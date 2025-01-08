//
//  Stubs.swift
//
//
//  Created by Andrew Barba on 2/2/22.
//

/// Note:
/// Define all runtime functions stub which are imported from Compute environment.
/// SwiftPM doesn't support WebAssembly target yet, so we need to define them to
/// avoid link failure.
/// When running with Compute runtime library, they are ignored completely.
#if !arch(wasm32)
    import ComputeRuntime

    /* FASTLY_ABI */

    func fastly_abi__init(_ abi_version: UInt64) -> Int32 { fatalError() }

    /* FASTLY_DICTIONARY */

    func fastly_dictionary__open(
        _ name: UnsafePointer<CChar>!, _ name_len: Int, _ handle: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_dictionary__get(
        _ handle: WasiHandle, _ key: UnsafePointer<CChar>!, _ key_len: Int,
        _ value: UnsafeMutablePointer<UInt8>!, _ value_max_len: Int,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    /* FASTLY_LOG */

    func fastly_log__endpoint_get(
        _ name: UnsafePointer<CChar>!, _ name_len: Int, _ handle: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_log__write(
        _ handle: WasiHandle, _ msg: UnsafePointer<CChar>!, _ msg_len: Int,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    /* FASTLY_GEO */

    func fastly_geo__lookup(
        _ ip: UnsafePointer<UInt8>!, _ ip_len: Int, _ value: UnsafeMutablePointer<UInt8>!,
        _ value_max_len: Int, _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    /* FASTLY_OBJECT_STORE */

    func fastly_object_store__open(
        _ name: UnsafePointer<CChar>!, _ name_len: Int, _ handle: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_object_store__lookup(
        _ handle: WasiHandle, _ key: UnsafePointer<CChar>!, _ key_len: Int,
        _ body_handle: UnsafeMutablePointer<UInt32>!
    ) -> Int32 { fatalError() }

    func fastly_object_store__insert(
        _ handle: WasiHandle, _ key: UnsafePointer<CChar>!, _ key_len: Int, _ body_handle: UInt32
    ) -> Int32 { fatalError() }

    /* FASTLY_SECRET_STORE */

    func fastly_secret_store__open(
        _ name: UnsafePointer<CChar>!, _ name_len: Int, _ handle: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_secret_store__lookup(
        _ handle: WasiHandle, _ key: UnsafePointer<CChar>!, _ key_len: Int,
        _ secret_handle: UnsafeMutablePointer<UInt32>!
    ) -> Int32 { fatalError() }

    func fastly_secret_store__plaintext(
        _ secret_handle: WasiHandle, _ value: UnsafeMutablePointer<UInt8>!, _ value_max_len: Int,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    /* FASTLY_HTTP_BODY */

    func fastly_http_body__new(_ handle: UnsafeMutablePointer<WasiHandle>!) -> Int32 {
        fatalError()
    }

    func fastly_http_body__append(_ dest: WasiHandle, _ src: WasiHandle) -> Int32 { fatalError() }

    func fastly_http_body__close(_ handle: WasiHandle) -> Int32 { fatalError() }

    func fastly_http_body__abandon(_ handle: WasiHandle) -> Int32 { fatalError() }

    func fastly_http_body__write(
        _ handle: WasiHandle, _ data: UnsafePointer<UInt8>!, _ data_len: Int, _ body_end: Int32,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    func fastly_http_body__read(
        _ handle: WasiHandle, _ data: UnsafeMutablePointer<UInt8>!, _ data_max_len: Int,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    /* FASTLY_HTTP_REQ */

    func fastly_http_req__new(_ handle: UnsafeMutablePointer<WasiHandle>!) -> Int32 { fatalError() }

    func fastly_http_req__body_downstream_get(
        _ req: UnsafeMutablePointer<WasiHandle>!, _ body: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__cache_override_set(
        _ req_handle: WasiHandle, _ tag: UInt32, _ ttl: UInt32, _ stale_while_revalidate: UInt32
    ) -> Int32 { fatalError() }

    func fastly_http_req__cache_override_v2_set(
        _ req_handle: WasiHandle, _ tag: UInt32, _ ttl: UInt32, _ stale_while_revalidate: UInt32,
        _ surrogate_key: UnsafePointer<CChar>!, _ surrogate_key_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_req__close(_ handle: WasiHandle) -> Int32 { fatalError() }

    func fastly_http_req__method_get(
        _ handle: WasiHandle, _ value: UnsafeMutablePointer<UInt8>!, _ value_max_len: Int,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__uri_get(
        _ handle: WasiHandle, _ value: UnsafeMutablePointer<UInt8>!, _ value_max_len: Int,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__version_get(_ handle: WasiHandle, _ version: UnsafeMutablePointer<Int32>!)
        -> Int32
    { fatalError() }

    func fastly_http_req__method_set(
        _ handle: WasiHandle, _ method: UnsafePointer<CChar>!, _ method_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_req__uri_set(
        _ handle: WasiHandle, _ uri: UnsafePointer<CChar>!, _ uri_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_req__version_set(_ handle: WasiHandle, _ version: Int32) -> Int32 {
        fatalError()
    }

    func fastly_http_req__downstream_client_ip_addr(
        _ octets: UnsafeMutablePointer<UInt8>!, _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__header_names_get(
        _ req_handle: WasiHandle, _ name: UnsafeMutablePointer<UInt8>!, _ name_len: Int,
        _ cursor: UInt32, _ ending_cursor: UnsafeMutablePointer<Int64>!,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__original_header_names_get(
        _ buf: UnsafeMutablePointer<UInt8>!, _ buf_len: Int, _ cursor: UInt32,
        _ ending_cursor: UnsafeMutablePointer<Int64>!, _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__original_header_count(_ count: UnsafeMutablePointer<WasiHandle>!) -> Int32
    { fatalError() }

    func fastly_http_req__header_value_get(
        _ resp_handle: WasiHandle, _ name: UnsafePointer<CChar>!, _ name_len: Int,
        _ value: UnsafeMutablePointer<UInt8>!, _ value_max_len: Int,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__header_insert(
        _ resp_handle: WasiHandle, _ name: UnsafePointer<CChar>!, _ name_len: Int,
        _ value: UnsafePointer<CChar>!, _ value_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_req__header_append(
        _ resp_handle: WasiHandle, _ name: UnsafePointer<CChar>!, _ name_len: Int,
        _ value: UnsafePointer<CChar>!, _ value_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_req__header_remove(
        _ resp_handle: WasiHandle, _ name: UnsafePointer<CChar>!, _ name_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_req__send(
        _ req_handle: WasiHandle, _ body_handle: WasiHandle, _ backend: UnsafePointer<CChar>!,
        _ backend_len: Int, _ resp_handle_out: UnsafeMutablePointer<WasiHandle>!,
        _ resp_body_handle_out: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__send_async(
        _ req_handle: WasiHandle, _ body_handle: WasiHandle, _ backend: UnsafePointer<CChar>!,
        _ backend_len: Int, _ pending_req_out: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__send_async_streaming(
        _ req_handle: WasiHandle, _ body_handle: WasiHandle, _ backend: UnsafePointer<CChar>!,
        _ backend_len: Int, _ pending_req_out: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__pending_req_poll(
        _ req_handle: WasiHandle, _ is_done_out: UnsafeMutablePointer<UInt32>!,
        _ resp_handle_out: UnsafeMutablePointer<WasiHandle>!,
        _ resp_body_handle_out: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__pending_req_wait(
        _ req_handle: WasiHandle, _ resp_handle_out: UnsafeMutablePointer<WasiHandle>!,
        _ resp_body_handle_out: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__pending_req_select(
        _ req_handles: UnsafeMutablePointer<WasiHandle>!, _ req_handles_len: Int,
        _ done_idx_out: UnsafeMutablePointer<WasiHandle>!,
        _ resp_handle_out: UnsafeMutablePointer<WasiHandle>!,
        _ resp_body_handle_out: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__auto_decompress_response_set(
        _ req_handle: WasiHandle, _ encodings: UInt32
    ) -> Int32 { fatalError() }

    func fastly_http_req__framing_headers_mode_set(_ req_handle: WasiHandle, _ mode: UInt32)
        -> Int32
    { fatalError() }

    func fastly_http_req__redirect_to_websocket_proxy(
        _ backend: UnsafePointer<CChar>!, _ backend_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_req__redirect_to_grip_proxy(
        _ backend: UnsafePointer<CChar>!, _ backend_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_req__register_dynamic_backend(
        _ name: UnsafePointer<CChar>!, _ name_len: Int, _ target: UnsafePointer<CChar>!,
        _ target_len: Int, _ backend_config_mask: UInt32,
        _ backend_configuration: UnsafeMutablePointer<DynamicBackendConfig>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__downstream_tls_ja3_md5(
        _ value: UnsafeMutablePointer<UInt8>!, _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    func fastly_http_req__downstream_tls_ja4(
        _ value: UnsafeMutablePointer<UInt8>!,
        _ max_len: Int,
        _ nwritten_out: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    /* FASTLY_HTTP_RESP */

    func fastly_http_resp__new(_ handle: UnsafeMutablePointer<WasiHandle>!) -> Int32 {
        fatalError()
    }

    func fastly_http_resp__close(_ handle: WasiHandle) -> Int32 { fatalError() }

    func fastly_http_resp__send_downstream(
        _ resp_handle: WasiHandle, _ body_handle: WasiHandle, _ streaming: Int32
    ) -> Int32 { fatalError() }

    func fastly_http_resp__version_get(
        _ handle: WasiHandle, _ version: UnsafeMutablePointer<Int32>!
    ) -> Int32 { fatalError() }

    func fastly_http_resp__status_get(_ handle: WasiHandle, _ status: UnsafeMutablePointer<Int32>!)
        -> Int32
    { fatalError() }

    func fastly_http_resp__version_set(_ handle: WasiHandle, _ version: Int32) -> Int32 {
        fatalError()
    }

    func fastly_http_resp__status_set(_ handle: WasiHandle, _ status: Int32) -> Int32 {
        fatalError()
    }

    func fastly_http_resp__header_names_get(
        _ resp_handle: WasiHandle, _ name: UnsafeMutablePointer<UInt8>!, _ name_len: Int,
        _ cursor: UInt32, _ ending_cursor: UnsafeMutablePointer<Int64>!,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    func fastly_http_resp__header_value_get(
        _ resp_handle: WasiHandle, _ name: UnsafePointer<CChar>!, _ name_len: Int,
        _ value: UnsafeMutablePointer<UInt8>!, _ value_max_len: Int,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

    func fastly_http_resp__header_insert(
        _ resp_handle: WasiHandle, _ name: UnsafePointer<CChar>!, _ name_len: Int,
        _ value: UnsafePointer<CChar>!, _ value_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_resp__header_append(
        _ resp_handle: WasiHandle, _ name: UnsafePointer<CChar>!, _ name_len: Int,
        _ value: UnsafePointer<CChar>!, _ value_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_resp__header_remove(
        _ resp_handle: WasiHandle, _ name: UnsafePointer<CChar>!, _ name_len: Int
    ) -> Int32 { fatalError() }

    func fastly_http_resp__framing_headers_mode_set(_ resp_handle: WasiHandle, _ mode: UInt32)
        -> Int32
    { fatalError() }

    func fastly_http_resp__http_keepalive_mode_set(_ resp_handle: WasiHandle, _ mode: UInt32)
        -> Int32
    { fatalError() }

    func fastly_cache__cache_transaction_lookup(
        _ cache_key: UnsafePointer<CChar>!,
        _ cache_key_len: Int,
        _ options_mask: UInt32,
        _ config: UnsafeMutablePointer<CacheLookupConfig>!,
        _ ret: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_cache__cache_transaction_insert_and_stream_back(
        _ handle: WasiHandle,
        _ options_mask: UInt32,
        _ config: UnsafeMutablePointer<CacheWriteConfig>!,
        _ ret_body: UnsafeMutablePointer<WasiHandle>!,
        _ ret_cache: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_cache__cache_get_state(
        _ handle: WasiHandle,
        _ ret: UnsafeMutablePointer<UInt8>!
    ) -> Int32 { fatalError() }

    func fastly_cache__cache_get_age_ns(
        _ handle: WasiHandle,
        _ ret: UnsafeMutablePointer<UInt64>!
    ) -> Int32 { fatalError() }

    func fastly_cache__cache_get_length(
        _ handle: WasiHandle,
        _ ret: UnsafeMutablePointer<UInt64>!
    ) -> Int32 { fatalError() }

    func fastly_cache__cache_get_hits(
        _ handle: WasiHandle,
        _ ret: UnsafeMutablePointer<UInt64>!
    ) -> Int32 { fatalError() }

    func fastly_cache__cache_get_body(
        _ handle: WasiHandle,
        _ options_mask: UInt32,
        _ config: UnsafeMutablePointer<CacheGetBodyConfig>!,
        _ ret: UnsafeMutablePointer<WasiHandle>!
    ) -> Int32 { fatalError() }

    func fastly_cache__cache_transaction_cancel(_ handle: WasiHandle) -> Int32 { fatalError() }

    func fastly_device__device_detection_lookup(
        _ user_agent: UnsafePointer<CChar>!,
        _ user_agent_len: Int,
        _ buf: UnsafeMutablePointer<UInt8>!,
        _ buf_len: Int,
        _ nwritten: UnsafeMutablePointer<Int>!
    ) -> Int32 { fatalError() }

#endif
