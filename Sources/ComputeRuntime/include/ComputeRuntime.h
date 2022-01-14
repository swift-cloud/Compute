//
//  ComputeRuntime.h
//  
//
//  Created by Andrew Barba on 1/11/22.
//

#ifndef ComputeRuntime_h
#define ComputeRuntime_h
#ifdef __cplusplus
"C" {
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define WASM_IMPORT(module, name) __attribute__((import_module(module), import_name(name)))

    /* FASTLY_ABI */

    WASM_IMPORT("fastly_abi", "init")
    int fastly_abi__init(uint64_t abi_version);

    /* FASTLY_DICTIONARY */

    WASM_IMPORT("fastly_dictionary", "open")
    int fastly_dictionary__open(const char* name, size_t name_len, int* handle);

    WASM_IMPORT("fastly_dictionary", "get")
    int fastly_dictionary__get(int32_t h, const char* key, size_t key_len, uint8_t* value, size_t value_max_len, size_t* nwritten);

    /* FASTLY_LOG */

    WASM_IMPORT("fastly_log", "endpoint_get")
    int fastly_log__endpoint_get(const char* name, size_t name_len, int* handle);

    WASM_IMPORT("fastly_log", "write")
    int fastly_log__write(int handle, const char* msg, size_t msg_len, size_t* nwritten);

    /* FASTLY_GEO */

    WASM_IMPORT("fastly_geo", "lookup")
    int fastly_geo__lookup(const uint8_t* ip, size_t ip_len, uint8_t* value, size_t value_max_len, size_t* nwritten);

    /* FASTLY_HTTP_BODY */

    WASM_IMPORT("fastly_http_body", "new")
    int fastly_http_body__new(int* handle);

    WASM_IMPORT("fastly_http_body", "append")
    int fastly_http_body__append(int dest, int src);

    WASM_IMPORT("fastly_http_body", "close")
    int fastly_http_body__close(int handle);

    WASM_IMPORT("fastly_http_body", "write")
    int fastly_http_body__write(int handle, const uint8_t* data, size_t data_len, int body_end, size_t* nwritten);

    WASM_IMPORT("fastly_http_body", "read")
    int fastly_http_body__read(int handle, uint8_t* data, size_t data_max_len, size_t* nwritten);

    /* FASTLY_HTTP_REQ */

    WASM_IMPORT("fastly_http_req", "new")
    int fastly_http_req__new(int* handle);

    WASM_IMPORT("fastly_http_req", "body_downstream_get")
    int fastly_http_req__body_downstream_get(int* req, int* body);

    WASM_IMPORT("fastly_http_req", "cache_override_set")
    int fastly_http_req__cache_override_set(int req_handle, int tag, uint32_t ttl,
                                            uint32_t stale_while_revalidate);

    WASM_IMPORT("fastly_http_req", "cache_override_v2_set")
    int fastly_http_req__cache_override_v2_set(int req_handle, int tag, uint32_t ttl,
                                               uint32_t stale_while_revalidate,
                                               const char *surrogate_key, size_t surrogate_key_len);

    WASM_IMPORT("fastly_http_req", "close")
    int fastly_http_req__close(int handle);

    WASM_IMPORT("fastly_http_req", "method_get")
    int fastly_http_req__method_get(int handle, uint8_t* value, size_t value_max_len, size_t* nwritten);

    WASM_IMPORT("fastly_http_req", "uri_get")
    int fastly_http_req__uri_get(int handle, uint8_t* value, size_t value_max_len, size_t* nwritten);

    WASM_IMPORT("fastly_http_req", "version_get")
    int fastly_http_req__version_get(int handle, int* version);

    WASM_IMPORT("fastly_http_req", "method_set")
    int fastly_http_req__method_set(int handle, const char* method, size_t method_len);

    WASM_IMPORT("fastly_http_req", "uri_set")
    int fastly_http_req__uri_set(int handle, const char* uri, size_t uri_len);

    WASM_IMPORT("fastly_http_req", "version_set")
    int fastly_http_req__version_set(int handle, int version);

    WASM_IMPORT("fastly_http_req", "downstream_client_ip_addr")
    int fastly_http_req__downstream_client_ip_addr(uint8_t* octets, size_t* nwritten);

    WASM_IMPORT("fastly_http_req", "header_value_get")
    int fastly_http_req__header_value_get(int resp_handle, const char *name, size_t name_len,
                                          uint8_t* value, size_t value_max_len, size_t* nwritten);

    WASM_IMPORT("fastly_http_req", "header_insert")
    int fastly_http_req__header_insert(int resp_handle, const char *name, size_t name_len,
                                       const char *value, size_t value_len);

    WASM_IMPORT("fastly_http_req", "header_append")
    int fastly_http_req__header_append(int resp_handle, const char *name, size_t name_len,
                                       const char *value, size_t value_len);

    WASM_IMPORT("fastly_http_req", "header_remove")
    int fastly_http_req__header_remove(int resp_handle, const char *name, size_t name_len);

    WASM_IMPORT("fastly_http_req", "send")
    int fastly_http_req__send(int req_handle, int body_handle, const char *backend,
                              size_t backend_len, int *resp_handle_out,
                              int *resp_body_handle_out);

    WASM_IMPORT("fastly_http_req", "send_async")
    int fastly_http_req__send_async(int req_handle, int body_handle, const char *backend,
                                    size_t backend_len, int *pending_req_out);

    WASM_IMPORT("fastly_http_req", "send_async_streaming")
    int fastly_http_req__send_async_streaming(int req_handle, int body_handle,
                                              const char *backend, size_t backend_len,
                                              int *pending_req_out);

    WASM_IMPORT("fastly_http_req", "pending_req_poll")
    int fastly_http_req__pending_req_poll(int req_handle, uint32_t *is_done_out,
                                          int *resp_handle_out, int *resp_body_handle_out);

    WASM_IMPORT("fastly_http_req", "pending_req_wait")
    int fastly_http_req__pending_req_wait(int req_handle, int *resp_handle_out,
                                          int *resp_body_handle_out);

    WASM_IMPORT("fastly_http_req", "pending_req_select")
    int fastly_http_req__pending_req_select(int req_handles[], size_t req_handles_len,
                                            uint32_t *done_idx_out, int *resp_handle_out,
                                            int *resp_body_handle_out);

    /* FASTLY_HTTP_RESP */

    WASM_IMPORT("fastly_http_resp", "new")
    int fastly_http_resp__new(int* handle);

    WASM_IMPORT("fastly_http_resp", "close")
    int fastly_http_resp__close(int handle);

    WASM_IMPORT("fastly_http_resp", "send_downstream")
    int fastly_http_resp__send_downstream(int resp_handle, int body_handle, int streaming);

    WASM_IMPORT("fastly_http_resp", "version_get")
    int fastly_http_resp__version_get(int handle, int* version);

    WASM_IMPORT("fastly_http_resp", "status_get")
    int fastly_http_resp__status_get(int handle, int* status);

    WASM_IMPORT("fastly_http_resp", "version_set")
    int fastly_http_resp__version_set(int handle, int version);

    WASM_IMPORT("fastly_http_resp", "status_set")
    int fastly_http_resp__status_set(int handle, int status);

    WASM_IMPORT("fastly_http_resp", "header_value_get")
    int fastly_http_resp__header_value_get(int resp_handle, const char *name, size_t name_len,
                                           uint8_t* value, size_t value_max_len, size_t* nwritten);

    WASM_IMPORT("fastly_http_resp", "header_insert")
    int fastly_http_resp__header_insert(int resp_handle, const char *name, size_t name_len,
                                        const char *value, size_t value_len);

    WASM_IMPORT("fastly_http_resp", "header_append")
    int fastly_http_resp__header_append(int resp_handle, const char *name, size_t name_len,
                                        const char *value, size_t value_len);

    WASM_IMPORT("fastly_http_resp", "header_remove")
    int fastly_http_resp__header_remove(int resp_handle, const char *name, size_t name_len);

#ifdef __cplusplus
}
#endif
#endif /* ComputeRuntime_h */
