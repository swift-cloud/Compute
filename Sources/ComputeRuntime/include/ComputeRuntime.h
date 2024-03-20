//
//  ComputeRuntime.h
//  
//
//  Created by Andrew Barba on 1/11/22.
//

#ifndef ComputeRuntime_h
#define ComputeRuntime_h

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-attributes"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define WASM_IMPORT(module, name) __attribute__((import_module(module), import_name(name)))

typedef uint32_t WasiHandle;

/* FASTLY_ABI */

WASM_IMPORT("fastly_abi", "init")
int fastly_abi__init(uint64_t abi_version);

/* FASTLY_DICTIONARY */

WASM_IMPORT("fastly_dictionary", "open")
int fastly_dictionary__open(const char* name, size_t name_len, WasiHandle* handle);

WASM_IMPORT("fastly_dictionary", "get")
int fastly_dictionary__get(WasiHandle handle, const char* key, size_t key_len, uint8_t* value, size_t value_max_len, size_t* nwritten);

/* FASTLY_LOG */

WASM_IMPORT("fastly_log", "endpoint_get")
int fastly_log__endpoint_get(const char* name, size_t name_len, WasiHandle* handle);

WASM_IMPORT("fastly_log", "write")
int fastly_log__write(WasiHandle handle, const char* msg, size_t msg_len, size_t* nwritten);

/* FASTLY_GEO */

WASM_IMPORT("fastly_geo", "lookup")
int fastly_geo__lookup(const uint8_t* ip, size_t ip_len, uint8_t* value, size_t value_max_len, size_t* nwritten);

/* FASTLY_OBJECT_STORE */

WASM_IMPORT("fastly_object_store", "open")
int fastly_object_store__open(const char* name, size_t name_len, WasiHandle* handle);

WASM_IMPORT("fastly_object_store", "lookup")
int fastly_object_store__lookup(WasiHandle handle, const char* key, size_t key_len, uint32_t* body_handle);

WASM_IMPORT("fastly_object_store", "insert")
int fastly_object_store__insert(WasiHandle handle, const char* key, size_t key_len, uint32_t body_handle);

/* FASTLY_SECRET_STORE */

WASM_IMPORT("fastly_secret_store", "open")
int fastly_secret_store__open(const char* name, size_t name_len, WasiHandle* handle);

WASM_IMPORT("fastly_secret_store", "get")
int fastly_secret_store__lookup(WasiHandle handle, const char* key, size_t key_len, uint32_t* secret_handle);

WASM_IMPORT("fastly_secret_store", "plaintext")
int fastly_secret_store__plaintext(WasiHandle secret_handle, uint8_t* value, size_t value_max_len, size_t* nwritten);

/* FASTLY_HTTP_BODY */

WASM_IMPORT("fastly_http_body", "new")
int fastly_http_body__new(WasiHandle* handle);

WASM_IMPORT("fastly_http_body", "append")
int fastly_http_body__append(WasiHandle dest, WasiHandle src);

WASM_IMPORT("fastly_http_body", "close")
int fastly_http_body__close(WasiHandle handle);

WASM_IMPORT("fastly_http_body", "abandon")
int fastly_http_body__abandon(WasiHandle handle);

WASM_IMPORT("fastly_http_body", "write")
int fastly_http_body__write(WasiHandle handle, const uint8_t* data, size_t data_len, int body_end, size_t* nwritten);

WASM_IMPORT("fastly_http_body", "read")
int fastly_http_body__read(WasiHandle handle, uint8_t* data, size_t data_max_len, size_t* nwritten);

/* FASTLY_HTTP_REQ */

WASM_IMPORT("fastly_http_req", "new")
int fastly_http_req__new(WasiHandle* handle);

WASM_IMPORT("fastly_http_req", "body_downstream_get")
int fastly_http_req__body_downstream_get(uint32_t* req, uint32_t* body);

WASM_IMPORT("fastly_http_req", "cache_override_set")
int fastly_http_req__cache_override_set(WasiHandle req_handle, uint32_t tag, uint32_t ttl,
                                        uint32_t stale_while_revalidate);

WASM_IMPORT("fastly_http_req", "cache_override_v2_set")
int fastly_http_req__cache_override_v2_set(WasiHandle req_handle, uint32_t tag, uint32_t ttl,
                                           uint32_t stale_while_revalidate,
                                           const char *surrogate_key, size_t surrogate_key_len);

WASM_IMPORT("fastly_http_req", "close")
int fastly_http_req__close(WasiHandle handle);

WASM_IMPORT("fastly_http_req", "method_get")
int fastly_http_req__method_get(WasiHandle handle, uint8_t* value, size_t value_max_len, size_t* nwritten);

WASM_IMPORT("fastly_http_req", "uri_get")
int fastly_http_req__uri_get(WasiHandle handle, uint8_t* value, size_t value_max_len, size_t* nwritten);

WASM_IMPORT("fastly_http_req", "version_get")
int fastly_http_req__version_get(WasiHandle handle, int* version);

WASM_IMPORT("fastly_http_req", "method_set")
int fastly_http_req__method_set(WasiHandle handle, const char* method, size_t method_len);

WASM_IMPORT("fastly_http_req", "uri_set")
int fastly_http_req__uri_set(WasiHandle handle, const char* uri, size_t uri_len);

WASM_IMPORT("fastly_http_req", "version_set")
int fastly_http_req__version_set(WasiHandle handle, int version);

WASM_IMPORT("fastly_http_req", "downstream_client_ip_addr")
int fastly_http_req__downstream_client_ip_addr(uint8_t* octets, size_t* nwritten);

WASM_IMPORT("fastly_http_req", "header_names_get")
int fastly_http_req__header_names_get(WasiHandle req_handle, uint8_t *name, size_t name_len, uint32_t cursor,
                                      int64_t *ending_cursor, size_t *nwritten);

WASM_IMPORT("fastly_http_req", "original_header_names_get")
int fastly_http_req__original_header_names_get(uint8_t *buf, size_t buf_len, uint32_t cursor,
                                               int64_t *ending_cursor, size_t *nwritten);

WASM_IMPORT("fastly_http_req", "original_header_count")
int fastly_http_req__original_header_count(uint32_t *count);

WASM_IMPORT("fastly_http_req", "header_value_get")
int fastly_http_req__header_value_get(WasiHandle resp_handle, const char *name, size_t name_len,
                                      uint8_t* value, size_t value_max_len, size_t* nwritten);

WASM_IMPORT("fastly_http_req", "header_insert")
int fastly_http_req__header_insert(WasiHandle resp_handle, const char *name, size_t name_len,
                                   const char *value, size_t value_len);

WASM_IMPORT("fastly_http_req", "header_append")
int fastly_http_req__header_append(WasiHandle resp_handle, const char *name, size_t name_len,
                                   const char *value, size_t value_len);

WASM_IMPORT("fastly_http_req", "header_remove")
int fastly_http_req__header_remove(WasiHandle resp_handle, const char *name, size_t name_len);

WASM_IMPORT("fastly_http_req", "send")
int fastly_http_req__send(WasiHandle req_handle, uint32_t body_handle, const char *backend,
                          size_t backend_len, WasiHandle *resp_handle_out,
                          uint32_t *resp_body_handle_out);

WASM_IMPORT("fastly_http_req", "send_async")
int fastly_http_req__send_async(WasiHandle req_handle, uint32_t body_handle, const char *backend,
                                size_t backend_len, uint32_t *pending_req_out);

WASM_IMPORT("fastly_http_req", "auto_decompress_response_set")
int fastly_http_req__auto_decompress_response_set(WasiHandle req_handle, uint32_t encodings);

WASM_IMPORT("fastly_http_req", "send_async_streaming")
int fastly_http_req__send_async_streaming(WasiHandle req_handle, uint32_t body_handle,
                                          const char *backend, size_t backend_len,
                                          uint32_t *pending_req_out);

WASM_IMPORT("fastly_http_req", "pending_req_poll")
int fastly_http_req__pending_req_poll(WasiHandle req_handle, uint32_t *is_done_out,
                                      WasiHandle *resp_handle_out, uint32_t *resp_body_handle_out);

WASM_IMPORT("fastly_http_req", "pending_req_wait")
int fastly_http_req__pending_req_wait(WasiHandle req_handle, WasiHandle *resp_handle_out,
                                      uint32_t *resp_body_handle_out);

WASM_IMPORT("fastly_http_req", "pending_req_select")
int fastly_http_req__pending_req_select(WasiHandle req_handles[], size_t req_handles_len,
                                        uint32_t *done_idx_out, WasiHandle *resp_handle_out,
                                        uint32_t *resp_body_handle_out);

WASM_IMPORT("fastly_http_req", "framing_headers_mode_set")
int fastly_http_req__framing_headers_mode_set(WasiHandle req_handle, uint32_t mode);

WASM_IMPORT("fastly_http_req", "redirect_to_websocket_proxy")
int fastly_http_req__redirect_to_websocket_proxy(const char *backend, size_t backend_len);

WASM_IMPORT("fastly_http_req", "redirect_to_grip_proxy")
int fastly_http_req__redirect_to_grip_proxy(const char *backend, size_t backend_len);

WASM_IMPORT("fastly_http_req", "downstream_tls_ja3_md5")
int fastly_http_req__downstream_tls_ja3_md5(uint8_t *value, size_t *nwritten);

WASM_IMPORT("fastly_http_req", "downstream_tls_ja4")
int fastly_http_req__downstream_tls_ja4(uint8_t *value, size_t max_len, size_t* nwritten_out);

typedef struct DynamicBackendConfig {
    const char* host_override;
    size_t host_override_len;
    size_t connect_timeout_ms;
    size_t first_byte_timeout_ms;
    size_t between_bytes_timeout_ms;
    size_t ssl_min_version;
    size_t ssl_max_version;
    const char* cert_hostname;
    size_t cert_hostname_len;
    const char* ca_cert;
    size_t ca_cert_len;
    const char* ciphers;
    size_t ciphers_len;
    const char* sni_hostname;
    size_t sni_hostname_len;
} DynamicBackendConfig;

WASM_IMPORT("fastly_http_req", "register_dynamic_backend")
int fastly_http_req__register_dynamic_backend(const char *name,
                                              size_t name_len,
                                              const char *target,
                                              size_t target_len,
                                              uint32_t backend_config_mask,
                                              DynamicBackendConfig *backend_configuration);

/* FASTLY_HTTP_RESP */

WASM_IMPORT("fastly_http_resp", "new")
int fastly_http_resp__new(WasiHandle* handle);

WASM_IMPORT("fastly_http_resp", "close")
int fastly_http_resp__close(WasiHandle handle);

WASM_IMPORT("fastly_http_resp", "send_downstream")
int fastly_http_resp__send_downstream(WasiHandle resp_handle, uint32_t body_handle, int streaming);

WASM_IMPORT("fastly_http_resp", "version_get")
int fastly_http_resp__version_get(WasiHandle handle, int* version);

WASM_IMPORT("fastly_http_resp", "status_get")
int fastly_http_resp__status_get(WasiHandle handle, int* status);

WASM_IMPORT("fastly_http_resp", "version_set")
int fastly_http_resp__version_set(WasiHandle handle, int version);

WASM_IMPORT("fastly_http_resp", "status_set")
int fastly_http_resp__status_set(WasiHandle handle, int status);

WASM_IMPORT("fastly_http_resp", "header_names_get")
int fastly_http_resp__header_names_get(WasiHandle resp_handle, uint8_t *name, size_t name_len, uint32_t cursor,
                                       int64_t *ending_cursor, size_t *nwritten);

WASM_IMPORT("fastly_http_resp", "header_value_get")
int fastly_http_resp__header_value_get(WasiHandle resp_handle, const char *name, size_t name_len,
                                       uint8_t* value, size_t value_max_len, size_t* nwritten);

WASM_IMPORT("fastly_http_resp", "header_insert")
int fastly_http_resp__header_insert(WasiHandle resp_handle, const char *name, size_t name_len,
                                    const char *value, size_t value_len);

WASM_IMPORT("fastly_http_resp", "header_append")
int fastly_http_resp__header_append(WasiHandle resp_handle, const char *name, size_t name_len,
                                    const char *value, size_t value_len);

WASM_IMPORT("fastly_http_resp", "header_remove")
int fastly_http_resp__header_remove(WasiHandle resp_handle, const char *name, size_t name_len);

WASM_IMPORT("fastly_http_resp", "framing_headers_mode_set")
int fastly_http_resp__framing_headers_mode_set(WasiHandle resp_handle, uint32_t mode);

WASM_IMPORT("fastly_http_resp", "http_keepalive_mode_set")
int fastly_http_resp__http_keepalive_mode_set(WasiHandle resp_handle, uint32_t mode);

/* FASTLY_CACHE */

typedef struct CacheLookupConfig {
    // * A full request handle, but used only for its headers
    WasiHandle request_headers;
} CacheLookupConfig;

typedef struct CacheGetBodyConfig {
    uint64_t start;
    uint64_t end;
} CacheGetBodyConfig;

typedef struct CacheWriteConfig {
    uint64_t max_age_ns;
    uint32_t request_headers;
    const uint8_t *vary_rule_ptr;
    size_t vary_rule_len;
    uint64_t initial_age_ns;
    uint64_t stale_while_revalidate_ns;
    const uint8_t *surrogate_keys_ptr;
    size_t surrogate_keys_len;
    uint64_t length;
    const uint8_t *user_metadata_ptr;
    size_t user_metadata_len;
} CacheWriteConfig;

WASM_IMPORT("fastly_cache", "lookup")
int cache_lookup(const char *cache_key, size_t cache_key_len, uint32_t options_mask,
                 CacheLookupConfig *config,
                 WasiHandle *ret);

WASM_IMPORT("fastly_cache", "insert")
int fastly_cache__cache_insert(const char *cache_key, size_t cache_key_len, uint32_t options_mask,
                               CacheWriteConfig *config, WasiHandle *ret);

WASM_IMPORT("fastly_cache", "transaction_lookup")
int fastly_cache__cache_transaction_lookup(const char *cache_key, size_t cache_key_len, uint32_t options_mask,
                                           CacheLookupConfig *config,
                                           WasiHandle *ret);

WASM_IMPORT("fastly_cache", "transaction_insert_and_stream_back")
int fastly_cache__cache_transaction_insert_and_stream_back(WasiHandle handle, uint32_t options_mask, CacheWriteConfig *config,
                                                           WasiHandle *ret_body,
                                                           WasiHandle *ret_cache);

WASM_IMPORT("fastly_cache", "transaction_cancel")
int fastly_cache__cache_transaction_cancel(WasiHandle handle);

WASM_IMPORT("fastly_cache", "get_state")
int fastly_cache__cache_get_state(WasiHandle handle, uint8_t *ret);

WASM_IMPORT("fastly_cache", "get_length")
int fastly_cache__cache_get_length(WasiHandle handle, uint64_t *ret);

WASM_IMPORT("fastly_cache", "get_age_ns")
int fastly_cache__cache_get_age_ns(WasiHandle handle, uint64_t *ret);

WASM_IMPORT("fastly_cache", "get_hits")
int fastly_cache__cache_get_hits(WasiHandle handle, uint64_t *ret);

WASM_IMPORT("fastly_cache", "get_body")
int fastly_cache__cache_get_body(WasiHandle handle, uint32_t options_mask,
                                 CacheGetBodyConfig *config,
                                 WasiHandle *ret);

/* FASTLY_DEVICE */

WASM_IMPORT("fastly_device_detection", "lookup")
int fastly_device__device_detection_lookup(const char *user_agent, size_t user_agent_len, uint8_t *buf,
                                           size_t buf_len, size_t *nwritten);

#pragma GCC diagnostic pop
#endif /* ComputeRuntime_h */
