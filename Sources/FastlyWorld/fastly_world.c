#include "fastly_world.h"


typedef struct {
    bool is_err;
    union {
        fastly_error_t err;
    } val;
} fastly_result_void_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_user_agent_t ok;
        fastly_error_t err;
    } val;
} fastly_result_user_agent_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_body_handle_t ok;
        fastly_error_t err;
    } val;
} fastly_result_body_handle_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_list_u8_t ok;
        fastly_error_t err;
    } val;
} fastly_result_list_u8_error_t;

typedef struct {
    bool is_err;
    union {
        uint32_t ok;
        fastly_error_t err;
    } val;
} fastly_result_u32_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_log_endpoint_handle_t ok;
        fastly_error_t err;
    } val;
} fastly_result_log_endpoint_handle_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_world_string_t ok;
        fastly_error_t err;
    } val;
} fastly_result_string_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_request_handle_t ok;
        fastly_error_t err;
    } val;
} fastly_result_request_handle_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_list_string_t ok;
        fastly_error_t err;
    } val;
} fastly_result_list_string_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_option_string_t ok;
        fastly_error_t err;
    } val;
} fastly_result_option_string_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_option_list_string_t ok;
        fastly_error_t err;
    } val;
} fastly_result_option_list_string_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_http_version_t ok;
        fastly_error_t err;
    } val;
} fastly_result_http_version_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_response_t ok;
        fastly_error_t err;
    } val;
} fastly_result_response_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_pending_request_handle_t ok;
        fastly_error_t err;
    } val;
} fastly_result_pending_request_handle_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_option_response_t ok;
        fastly_error_t err;
    } val;
} fastly_result_option_response_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_tuple2_u32_response_t ok;
        fastly_error_t err;
    } val;
} fastly_result_tuple2_u32_response_error_t;

typedef struct {
    bool is_err;
    union {
        bool ok;
        fastly_error_t err;
    } val;
} fastly_result_bool_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_response_handle_t ok;
        fastly_error_t err;
    } val;
} fastly_result_response_handle_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_http_status_t ok;
        fastly_error_t err;
    } val;
} fastly_result_http_status_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_dictionary_handle_t ok;
        fastly_error_t err;
    } val;
} fastly_result_dictionary_handle_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_object_store_handle_t ok;
        fastly_error_t err;
    } val;
} fastly_result_object_store_handle_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_option_body_handle_t ok;
        fastly_error_t err;
    } val;
} fastly_result_option_body_handle_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_option_fd_t ok;
        fastly_error_t err;
    } val;
} fastly_result_option_fd_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_secret_store_handle_t ok;
        fastly_error_t err;
    } val;
} fastly_result_secret_store_handle_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_option_secret_handle_t ok;
        fastly_error_t err;
    } val;
} fastly_result_option_secret_handle_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_option_u32_t ok;
        fastly_error_t err;
    } val;
} fastly_result_option_u32_error_t;

typedef struct {
    bool is_err;
    union {
        fastly_purge_result_t ok;
        fastly_error_t err;
    } val;
} fastly_result_purge_result_error_t;

typedef struct {
    bool is_err;
    union {
    } val;
} compute_at_edge_result_void_void_t;

__attribute__((import_module("fastly"), import_name("abi-init")))
void __wasm_import_fastly_abi_init(int64_t, int32_t);

__attribute__((import_module("fastly"), import_name("uap-parse")))
void __wasm_import_fastly_uap_parse(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-body-new")))
void __wasm_import_fastly_http_body_new(int32_t);

__attribute__((import_module("fastly"), import_name("http-body-append")))
void __wasm_import_fastly_http_body_append(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-body-read")))
void __wasm_import_fastly_http_body_read(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-body-write")))
void __wasm_import_fastly_http_body_write(int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-body-close")))
void __wasm_import_fastly_http_body_close(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("log-endpoint-get")))
void __wasm_import_fastly_log_endpoint_get(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("log-write")))
void __wasm_import_fastly_log_write(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-cache-override-set")))
void __wasm_import_fastly_http_req_cache_override_set(int32_t, int32_t, int32_t, int32_t, int32_t, int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-downstream-client-ip-addr")))
void __wasm_import_fastly_http_req_downstream_client_ip_addr(int32_t);

__attribute__((import_module("fastly"), import_name("http-req-downstream-client-h2-fingerprint")))
void __wasm_import_fastly_http_req_downstream_client_h2_fingerprint(int32_t);

__attribute__((import_module("fastly"), import_name("http-req-downstream-tls-cipher-openssl-name")))
void __wasm_import_fastly_http_req_downstream_tls_cipher_openssl_name(int32_t);

__attribute__((import_module("fastly"), import_name("http-req-downstream-tls-protocol")))
void __wasm_import_fastly_http_req_downstream_tls_protocol(int32_t);

__attribute__((import_module("fastly"), import_name("http-req-downstream-tls-client-hello")))
void __wasm_import_fastly_http_req_downstream_tls_client_hello(int32_t);

__attribute__((import_module("fastly"), import_name("http-req-downstream-tls-client-certificate")))
void __wasm_import_fastly_http_req_downstream_tls_client_certificate(int32_t);

__attribute__((import_module("fastly"), import_name("http-req-downstream-tls-client-cert-verify-result")))
void __wasm_import_fastly_http_req_downstream_tls_client_cert_verify_result(int32_t);

__attribute__((import_module("fastly"), import_name("http-req-downstream-tls-ja3-md5")))
void __wasm_import_fastly_http_req_downstream_tls_ja3_md5(int32_t);

__attribute__((import_module("fastly"), import_name("http-req-new")))
void __wasm_import_fastly_http_req_new(int32_t);

__attribute__((import_module("fastly"), import_name("http-req-header-names-get")))
void __wasm_import_fastly_http_req_header_names_get(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-header-value-get")))
void __wasm_import_fastly_http_req_header_value_get(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-header-values-get")))
void __wasm_import_fastly_http_req_header_values_get(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-header-values-set")))
void __wasm_import_fastly_http_req_header_values_set(int32_t, int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-header-insert")))
void __wasm_import_fastly_http_req_header_insert(int32_t, int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-header-append")))
void __wasm_import_fastly_http_req_header_append(int32_t, int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-header-remove")))
void __wasm_import_fastly_http_req_header_remove(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-method-get")))
void __wasm_import_fastly_http_req_method_get(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-method-set")))
void __wasm_import_fastly_http_req_method_set(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-uri-get")))
void __wasm_import_fastly_http_req_uri_get(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-uri-set")))
void __wasm_import_fastly_http_req_uri_set(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-version-get")))
void __wasm_import_fastly_http_req_version_get(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-version-set")))
void __wasm_import_fastly_http_req_version_set(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-send")))
void __wasm_import_fastly_http_req_send(int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-send-async")))
void __wasm_import_fastly_http_req_send_async(int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-send-async-streaming")))
void __wasm_import_fastly_http_req_send_async_streaming(int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-pending-req-poll")))
void __wasm_import_fastly_http_req_pending_req_poll(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-pending-req-wait")))
void __wasm_import_fastly_http_req_pending_req_wait(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-pending-req-select")))
void __wasm_import_fastly_http_req_pending_req_select(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-key-is-valid")))
void __wasm_import_fastly_http_req_key_is_valid(int32_t);

__attribute__((import_module("fastly"), import_name("http-req-close")))
void __wasm_import_fastly_http_req_close(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-auto-decompress-response-set")))
void __wasm_import_fastly_http_req_auto_decompress_response_set(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-upgrade-websocket")))
void __wasm_import_fastly_http_req_upgrade_websocket(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-redirect-to-websocket-proxy")))
void __wasm_import_fastly_http_req_redirect_to_websocket_proxy(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-redirect-to-grip-proxy")))
void __wasm_import_fastly_http_req_redirect_to_grip_proxy(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-framing-headers-mode-set")))
void __wasm_import_fastly_http_req_framing_headers_mode_set(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-req-register-dynamic-backend")))
void __wasm_import_fastly_http_req_register_dynamic_backend(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-new")))
void __wasm_import_fastly_http_resp_new(int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-header-names-get")))
void __wasm_import_fastly_http_resp_header_names_get(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-header-value-get")))
void __wasm_import_fastly_http_resp_header_value_get(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-header-values-get")))
void __wasm_import_fastly_http_resp_header_values_get(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-header-values-set")))
void __wasm_import_fastly_http_resp_header_values_set(int32_t, int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-header-insert")))
void __wasm_import_fastly_http_resp_header_insert(int32_t, int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-header-append")))
void __wasm_import_fastly_http_resp_header_append(int32_t, int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-header-remove")))
void __wasm_import_fastly_http_resp_header_remove(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-version-get")))
void __wasm_import_fastly_http_resp_version_get(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-version-set")))
void __wasm_import_fastly_http_resp_version_set(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-send-downstream")))
void __wasm_import_fastly_http_resp_send_downstream(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-status-get")))
void __wasm_import_fastly_http_resp_status_get(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-status-set")))
void __wasm_import_fastly_http_resp_status_set(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-close")))
void __wasm_import_fastly_http_resp_close(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("http-resp-framing-headers-mode-set")))
void __wasm_import_fastly_http_resp_framing_headers_mode_set(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("dictionary-open")))
void __wasm_import_fastly_dictionary_open(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("dictionary-get")))
void __wasm_import_fastly_dictionary_get(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("geo-lookup")))
void __wasm_import_fastly_geo_lookup(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("object-store-open")))
void __wasm_import_fastly_object_store_open(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("object-store-lookup")))
void __wasm_import_fastly_object_store_lookup(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("object-store-lookup-as-fd")))
void __wasm_import_fastly_object_store_lookup_as_fd(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("object-store-insert")))
void __wasm_import_fastly_object_store_insert(int32_t, int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("secret-store-open")))
void __wasm_import_fastly_secret_store_open(int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("secret-store-get")))
void __wasm_import_fastly_secret_store_get(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("secret-store-plaintext")))
void __wasm_import_fastly_secret_store_plaintext(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("async-io-select")))
void __wasm_import_fastly_async_io_select(int32_t, int32_t, int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("async-io-is-ready")))
void __wasm_import_fastly_async_io_is_ready(int32_t, int32_t);

__attribute__((import_module("fastly"), import_name("purge-surrogate-key")))
void __wasm_import_fastly_purge_surrogate_key(int32_t, int32_t, int32_t, int32_t);

__attribute__((weak, export_name("cabi_realloc")))
void *cabi_realloc(void *ptr, size_t orig_size, size_t org_align, size_t new_size) {
    void *ret = realloc(ptr, new_size);
    if (!ret) abort();
    return ret;
}

// Helper Functions

void fastly_user_agent_free(fastly_user_agent_t *ptr) {
    fastly_world_string_free(&ptr->family);
    fastly_world_string_free(&ptr->major);
    fastly_world_string_free(&ptr->minor);
    fastly_world_string_free(&ptr->patch);
}

void fastly_purge_result_free(fastly_purge_result_t *ptr) {
    fastly_world_string_free(&ptr->id);
}

void fastly_option_string_free(fastly_option_string_t *ptr) {
    if (ptr->is_some) {
        fastly_world_string_free(&ptr->val);
    }
}

void fastly_geo_data_free(fastly_geo_data_t *ptr) {
    fastly_option_string_free(&ptr->as_name);
    fastly_option_string_free(&ptr->city);
    fastly_option_string_free(&ptr->conn_speed);
    fastly_option_string_free(&ptr->conn_type);
    fastly_option_string_free(&ptr->continent);
    fastly_option_string_free(&ptr->country_code);
    fastly_option_string_free(&ptr->country_code3);
    fastly_option_string_free(&ptr->country_name);
    fastly_option_string_free(&ptr->gmt_offset);
    fastly_option_string_free(&ptr->postal_code);
    fastly_option_string_free(&ptr->proxy_description);
    fastly_option_string_free(&ptr->proxy_type);
    fastly_option_string_free(&ptr->region);
}

void fastly_dynamic_backend_config_free(fastly_dynamic_backend_config_t *ptr) {
    fastly_option_string_free(&ptr->host_override);
    fastly_option_string_free(&ptr->cert_hostname);
    fastly_option_string_free(&ptr->ca_cert);
    fastly_option_string_free(&ptr->ciphers);
    fastly_option_string_free(&ptr->sni_hostname);
}

void fastly_list_u8_free(fastly_list_u8_t *ptr) {
    if (ptr->len > 0) {
        free(ptr->ptr);
    }
}

void fastly_list_string_free(fastly_list_string_t *ptr) {
    for (size_t i = 0; i < ptr->len; i++) {
        fastly_world_string_free(&ptr->ptr[i]);
    }
    if (ptr->len > 0) {
        free(ptr->ptr);
    }
}

void fastly_option_list_string_free(fastly_option_list_string_t *ptr) {
    if (ptr->is_some) {
        fastly_list_string_free(&ptr->val);
    }
}

void fastly_list_pending_request_handle_free(fastly_list_pending_request_handle_t *ptr) {
    if (ptr->len > 0) {
        free(ptr->ptr);
    }
}

void fastly_list_async_handle_free(fastly_list_async_handle_t *ptr) {
    if (ptr->len > 0) {
        free(ptr->ptr);
    }
}

void fastly_world_string_set(fastly_world_string_t *ret, const char*s) {
    ret->ptr = (char*) s;
    ret->len = strlen(s);
}

void fastly_world_string_dup(fastly_world_string_t *ret, const char*s) {
    ret->len = strlen(s);
    ret->ptr = cabi_realloc(NULL, 0, 1, ret->len * 1);
    memcpy(ret->ptr, s, ret->len * 1);
}

void fastly_world_string_free(fastly_world_string_t *ret) {
    if (ret->len > 0) {
        free(ret->ptr);
    }
    ret->ptr = NULL;
    ret->len = 0;
}

// Component Adapters

bool fastly_abi_init(uint64_t abi_version, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_abi_init((int64_t) (abi_version), ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_uap_parse(fastly_world_string_t *user_agent, fastly_user_agent_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[36];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_uap_parse((int32_t) (*user_agent).ptr, (int32_t) (*user_agent).len, ptr);
    fastly_result_user_agent_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_user_agent_t) {
                (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) },
                (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 12))), (size_t)(*((int32_t*) (ptr + 16))) },
                (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 20))), (size_t)(*((int32_t*) (ptr + 24))) },
                (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 28))), (size_t)(*((int32_t*) (ptr + 32))) },
            };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_body_new(fastly_body_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[8];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_body_new(ptr);
    fastly_result_body_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint32_t) (*((int32_t*) (ptr + 4)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_body_append(fastly_body_handle_t dest, fastly_body_handle_t src, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_body_append((int32_t) (dest), (int32_t) (src), ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_body_read(fastly_body_handle_t h, uint32_t chunk_size, fastly_list_u8_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_body_read((int32_t) (h), (int32_t) (chunk_size), ptr);
    fastly_result_list_u8_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_list_u8_t) { (uint8_t*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_body_write(fastly_body_handle_t h, fastly_list_u8_t *buf, fastly_body_write_end_t end, uint32_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[8];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_body_write((int32_t) (h), (int32_t) (*buf).ptr, (int32_t) (*buf).len, (int32_t) end, ptr);
    fastly_result_u32_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint32_t) (*((int32_t*) (ptr + 4)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_body_close(fastly_body_handle_t h, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_body_close((int32_t) (h), ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_log_endpoint_get(fastly_world_string_t *name, fastly_log_endpoint_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[8];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_log_endpoint_get((int32_t) (*name).ptr, (int32_t) (*name).len, ptr);
    fastly_result_log_endpoint_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint32_t) (*((int32_t*) (ptr + 4)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_log_write(fastly_log_endpoint_handle_t h, fastly_world_string_t *msg, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_log_write((int32_t) (h), (int32_t) (*msg).ptr, (int32_t) (*msg).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_cache_override_set(fastly_request_handle_t h, fastly_http_cache_override_tag_t tag, uint32_t *maybe_ttl, uint32_t *maybe_stale_while_revalidate, fastly_world_string_t *maybe_sk, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    fastly_option_u32_t ttl;
    ttl.is_some = maybe_ttl != NULL;if (maybe_ttl) {
        ttl.val = *maybe_ttl;
    }
    fastly_option_u32_t stale_while_revalidate;
    stale_while_revalidate.is_some = maybe_stale_while_revalidate != NULL;if (maybe_stale_while_revalidate) {
        stale_while_revalidate.val = *maybe_stale_while_revalidate;
    }
    fastly_option_string_t sk;
    sk.is_some = maybe_sk != NULL;if (maybe_sk) {
        sk.val = *maybe_sk;
    }
    int32_t option;
    int32_t option1;
    if ((ttl).is_some) {
        const uint32_t *payload0 = &(ttl).val;
        option = 1;
        option1 = (int32_t) (*payload0);
    } else {
        option = 0;
        option1 = 0;
    }
    int32_t option4;
    int32_t option5;
    if ((stale_while_revalidate).is_some) {
        const uint32_t *payload3 = &(stale_while_revalidate).val;
        option4 = 1;
        option5 = (int32_t) (*payload3);
    } else {
        option4 = 0;
        option5 = 0;
    }
    int32_t option8;
    int32_t option9;
    int32_t option10;
    if ((sk).is_some) {
        const fastly_world_string_t *payload7 = &(sk).val;
        option8 = 1;
        option9 = (int32_t) (*payload7).ptr;
        option10 = (int32_t) (*payload7).len;
    } else {
        option8 = 0;
        option9 = 0;
        option10 = 0;
    }
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_cache_override_set((int32_t) (h), tag, option, option1, option4, option5, option8, option9, option10, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_downstream_client_ip_addr(fastly_list_u8_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_downstream_client_ip_addr(ptr);
    fastly_result_list_u8_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_list_u8_t) { (uint8_t*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_downstream_client_h2_fingerprint(fastly_list_u8_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_downstream_client_h2_fingerprint(ptr);
    fastly_result_list_u8_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_list_u8_t) { (uint8_t*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_downstream_tls_cipher_openssl_name(fastly_world_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_downstream_tls_cipher_openssl_name(ptr);
    fastly_result_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_downstream_tls_protocol(fastly_world_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_downstream_tls_protocol(ptr);
    fastly_result_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_downstream_tls_client_hello(fastly_list_u8_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_downstream_tls_client_hello(ptr);
    fastly_result_list_u8_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_list_u8_t) { (uint8_t*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_downstream_tls_client_certificate(fastly_list_u8_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_downstream_tls_client_certificate(ptr);
    fastly_result_list_u8_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_list_u8_t) { (uint8_t*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_downstream_tls_client_cert_verify_result(fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_downstream_tls_client_cert_verify_result(ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_downstream_tls_ja3_md5(fastly_list_u8_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_downstream_tls_ja3_md5(ptr);
    fastly_result_list_u8_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_list_u8_t) { (uint8_t*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_new(fastly_request_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[8];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_new(ptr);
    fastly_result_request_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint32_t) (*((int32_t*) (ptr + 4)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_header_names_get(fastly_request_handle_t h, fastly_list_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_header_names_get((int32_t) (h), ptr);
    fastly_result_list_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_list_string_t) { (fastly_world_string_t*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_header_value_get(fastly_request_handle_t h, fastly_world_string_t *name, fastly_option_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[16];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_header_value_get((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, ptr);
    fastly_result_option_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_string_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 8))), (size_t)(*((int32_t*) (ptr + 12))) };
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_header_values_get(fastly_request_handle_t h, fastly_world_string_t *name, fastly_option_list_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[16];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_header_values_get((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, ptr);
    fastly_result_option_list_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_list_string_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (fastly_list_string_t) { (fastly_world_string_t*)(*((int32_t*) (ptr + 8))), (size_t)(*((int32_t*) (ptr + 12))) };
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_header_values_set(fastly_request_handle_t h, fastly_world_string_t *name, fastly_list_string_t *values, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_header_values_set((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, (int32_t) (*values).ptr, (int32_t) (*values).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_header_insert(fastly_request_handle_t h, fastly_world_string_t *name, fastly_world_string_t *value, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_header_insert((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, (int32_t) (*value).ptr, (int32_t) (*value).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_header_append(fastly_request_handle_t h, fastly_world_string_t *name, fastly_world_string_t *value, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_header_append((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, (int32_t) (*value).ptr, (int32_t) (*value).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_header_remove(fastly_request_handle_t h, fastly_world_string_t *name, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_header_remove((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_method_get(fastly_request_handle_t h, fastly_world_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_method_get((int32_t) (h), ptr);
    fastly_result_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_method_set(fastly_request_handle_t h, fastly_world_string_t *method, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_method_set((int32_t) (h), (int32_t) (*method).ptr, (int32_t) (*method).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_uri_get(fastly_request_handle_t h, fastly_world_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_uri_get((int32_t) (h), ptr);
    fastly_result_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_uri_set(fastly_request_handle_t h, fastly_world_string_t *uri, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_uri_set((int32_t) (h), (int32_t) (*uri).ptr, (int32_t) (*uri).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_version_get(fastly_request_handle_t h, fastly_http_version_t *ret, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_version_get((int32_t) (h), ptr);
    fastly_result_http_version_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_version_set(fastly_request_handle_t h, fastly_http_version_t version, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_version_set((int32_t) (h), (int32_t) version, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_send(fastly_request_handle_t h, fastly_body_handle_t b, fastly_world_string_t *backend, fastly_response_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_send((int32_t) (h), (int32_t) (b), (int32_t) (*backend).ptr, (int32_t) (*backend).len, ptr);
    fastly_result_response_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_response_t) {
                (uint32_t) (*((int32_t*) (ptr + 4))),
                (uint32_t) (*((int32_t*) (ptr + 8))),
            };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_send_async(fastly_request_handle_t h, fastly_body_handle_t b, fastly_world_string_t *backend, fastly_pending_request_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[8];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_send_async((int32_t) (h), (int32_t) (b), (int32_t) (*backend).ptr, (int32_t) (*backend).len, ptr);
    fastly_result_pending_request_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint32_t) (*((int32_t*) (ptr + 4)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_send_async_streaming(fastly_request_handle_t h, fastly_body_handle_t b, fastly_world_string_t *backend, fastly_pending_request_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[8];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_send_async_streaming((int32_t) (h), (int32_t) (b), (int32_t) (*backend).ptr, (int32_t) (*backend).len, ptr);
    fastly_result_pending_request_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint32_t) (*((int32_t*) (ptr + 4)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_pending_req_poll(fastly_pending_request_handle_t h, fastly_option_response_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[16];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_pending_req_poll((int32_t) (h), ptr);
    fastly_result_option_response_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_response_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (fastly_response_t) {
                        (uint32_t) (*((int32_t*) (ptr + 8))),
                        (uint32_t) (*((int32_t*) (ptr + 12))),
                    };
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_pending_req_wait(fastly_pending_request_handle_t h, fastly_response_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_pending_req_wait((int32_t) (h), ptr);
    fastly_result_response_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_response_t) {
                (uint32_t) (*((int32_t*) (ptr + 4))),
                (uint32_t) (*((int32_t*) (ptr + 8))),
            };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_pending_req_select(fastly_list_pending_request_handle_t *h, fastly_tuple2_u32_response_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[16];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_pending_req_select((int32_t) (*h).ptr, (int32_t) (*h).len, ptr);
    fastly_result_tuple2_u32_response_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_tuple2_u32_response_t) {
                (uint32_t) (*((int32_t*) (ptr + 4))),
                (fastly_response_t) {
                    (uint32_t) (*((int32_t*) (ptr + 8))),
                    (uint32_t) (*((int32_t*) (ptr + 12))),
                },
            };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_key_is_valid(bool *ret, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_key_is_valid(ptr);
    fastly_result_bool_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_close(fastly_request_handle_t h, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_close((int32_t) (h), ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_auto_decompress_response_set(fastly_request_handle_t h, fastly_content_encodings_t encodings, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_auto_decompress_response_set((int32_t) (h), encodings, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_upgrade_websocket(fastly_world_string_t *backend, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_upgrade_websocket((int32_t) (*backend).ptr, (int32_t) (*backend).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_redirect_to_websocket_proxy(fastly_world_string_t *backend, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_redirect_to_websocket_proxy((int32_t) (*backend).ptr, (int32_t) (*backend).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_redirect_to_grip_proxy(fastly_world_string_t *backend, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_redirect_to_grip_proxy((int32_t) (*backend).ptr, (int32_t) (*backend).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_framing_headers_mode_set(fastly_request_handle_t h, fastly_framing_headers_mode_t mode, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_framing_headers_mode_set((int32_t) (h), (int32_t) mode, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_req_register_dynamic_backend(fastly_world_string_t *prefix, fastly_world_string_t *target, fastly_dynamic_backend_config_t *config, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[108];
    int32_t ptr = (int32_t) &ret_area;
    *((int32_t*)(ptr + 4)) = (int32_t) (*prefix).len;
    *((int32_t*)(ptr + 0)) = (int32_t) (*prefix).ptr;
    *((int32_t*)(ptr + 12)) = (int32_t) (*target).len;
    *((int32_t*)(ptr + 8)) = (int32_t) (*target).ptr;
    if (((*config).host_override).is_some) {
        const fastly_world_string_t *payload0 = &((*config).host_override).val;
        *((int8_t*)(ptr + 16)) = 1;
        *((int32_t*)(ptr + 24)) = (int32_t) (*payload0).len;
        *((int32_t*)(ptr + 20)) = (int32_t) (*payload0).ptr;
    } else {
        *((int8_t*)(ptr + 16)) = 0;
    }
    if (((*config).connect_timeout).is_some) {
        const uint32_t *payload2 = &((*config).connect_timeout).val;
        *((int8_t*)(ptr + 28)) = 1;
        *((int32_t*)(ptr + 32)) = (int32_t) (*payload2);
    } else {
        *((int8_t*)(ptr + 28)) = 0;
    }
    if (((*config).first_byte_timeout).is_some) {
        const uint32_t *payload4 = &((*config).first_byte_timeout).val;
        *((int8_t*)(ptr + 36)) = 1;
        *((int32_t*)(ptr + 40)) = (int32_t) (*payload4);
    } else {
        *((int8_t*)(ptr + 36)) = 0;
    }
    if (((*config).between_bytes_timeout).is_some) {
        const uint32_t *payload6 = &((*config).between_bytes_timeout).val;
        *((int8_t*)(ptr + 44)) = 1;
        *((int32_t*)(ptr + 48)) = (int32_t) (*payload6);
    } else {
        *((int8_t*)(ptr + 44)) = 0;
    }
    if (((*config).use_ssl).is_some) {
        const bool *payload8 = &((*config).use_ssl).val;
        *((int8_t*)(ptr + 52)) = 1;
        *((int8_t*)(ptr + 53)) = *payload8;
    } else {
        *((int8_t*)(ptr + 52)) = 0;
    }
    if (((*config).ssl_min_version).is_some) {
        const fastly_tls_version_t *payload10 = &((*config).ssl_min_version).val;
        *((int8_t*)(ptr + 54)) = 1;
        *((int8_t*)(ptr + 55)) = (int32_t) *payload10;
    } else {
        *((int8_t*)(ptr + 54)) = 0;
    }
    if (((*config).ssl_max_version).is_some) {
        const fastly_tls_version_t *payload12 = &((*config).ssl_max_version).val;
        *((int8_t*)(ptr + 56)) = 1;
        *((int8_t*)(ptr + 57)) = (int32_t) *payload12;
    } else {
        *((int8_t*)(ptr + 56)) = 0;
    }
    if (((*config).cert_hostname).is_some) {
        const fastly_world_string_t *payload14 = &((*config).cert_hostname).val;
        *((int8_t*)(ptr + 60)) = 1;
        *((int32_t*)(ptr + 68)) = (int32_t) (*payload14).len;
        *((int32_t*)(ptr + 64)) = (int32_t) (*payload14).ptr;
    } else {
        *((int8_t*)(ptr + 60)) = 0;
    }
    if (((*config).ca_cert).is_some) {
        const fastly_world_string_t *payload16 = &((*config).ca_cert).val;
        *((int8_t*)(ptr + 72)) = 1;
        *((int32_t*)(ptr + 80)) = (int32_t) (*payload16).len;
        *((int32_t*)(ptr + 76)) = (int32_t) (*payload16).ptr;
    } else {
        *((int8_t*)(ptr + 72)) = 0;
    }
    if (((*config).ciphers).is_some) {
        const fastly_world_string_t *payload18 = &((*config).ciphers).val;
        *((int8_t*)(ptr + 84)) = 1;
        *((int32_t*)(ptr + 92)) = (int32_t) (*payload18).len;
        *((int32_t*)(ptr + 88)) = (int32_t) (*payload18).ptr;
    } else {
        *((int8_t*)(ptr + 84)) = 0;
    }
    if (((*config).sni_hostname).is_some) {
        const fastly_world_string_t *payload20 = &((*config).sni_hostname).val;
        *((int8_t*)(ptr + 96)) = 1;
        *((int32_t*)(ptr + 104)) = (int32_t) (*payload20).len;
        *((int32_t*)(ptr + 100)) = (int32_t) (*payload20).ptr;
    } else {
        *((int8_t*)(ptr + 96)) = 0;
    }
    int32_t ptr21 = (int32_t) &ret_area;
    __wasm_import_fastly_http_req_register_dynamic_backend(ptr, ptr21);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr21 + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr21 + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_new(fastly_response_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[8];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_new(ptr);
    fastly_result_response_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint32_t) (*((int32_t*) (ptr + 4)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_header_names_get(fastly_response_handle_t h, fastly_list_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_header_names_get((int32_t) (h), ptr);
    fastly_result_list_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_list_string_t) { (fastly_world_string_t*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_header_value_get(fastly_response_handle_t h, fastly_world_string_t *name, fastly_option_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[16];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_header_value_get((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, ptr);
    fastly_result_option_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_string_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 8))), (size_t)(*((int32_t*) (ptr + 12))) };
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_header_values_get(fastly_response_handle_t h, fastly_world_string_t *name, fastly_option_list_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[16];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_header_values_get((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, ptr);
    fastly_result_option_list_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_list_string_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (fastly_list_string_t) { (fastly_world_string_t*)(*((int32_t*) (ptr + 8))), (size_t)(*((int32_t*) (ptr + 12))) };
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_header_values_set(fastly_response_handle_t h, fastly_world_string_t *name, fastly_list_string_t *values, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_header_values_set((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, (int32_t) (*values).ptr, (int32_t) (*values).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_header_insert(fastly_response_handle_t h, fastly_world_string_t *name, fastly_world_string_t *value, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_header_insert((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, (int32_t) (*value).ptr, (int32_t) (*value).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_header_append(fastly_response_handle_t h, fastly_world_string_t *name, fastly_world_string_t *value, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_header_append((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, (int32_t) (*value).ptr, (int32_t) (*value).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_header_remove(fastly_response_handle_t h, fastly_world_string_t *name, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_header_remove((int32_t) (h), (int32_t) (*name).ptr, (int32_t) (*name).len, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_version_get(fastly_response_handle_t h, fastly_http_version_t *ret, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_version_get((int32_t) (h), ptr);
    fastly_result_http_version_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_version_set(fastly_response_handle_t h, fastly_http_version_t version, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_version_set((int32_t) (h), (int32_t) version, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_send_downstream(fastly_response_handle_t h, fastly_body_handle_t b, bool streaming, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_send_downstream((int32_t) (h), (int32_t) (b), streaming, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_status_get(fastly_response_handle_t h, fastly_http_status_t *ret, fastly_error_t *err) {
    __attribute__((aligned(2)))
    uint8_t ret_area[4];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_status_get((int32_t) (h), ptr);
    fastly_result_http_status_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint16_t) ((int32_t) (*((uint16_t*) (ptr + 2))));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 2)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_status_set(fastly_response_handle_t h, fastly_http_status_t status, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_status_set((int32_t) (h), (int32_t) (status), ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_close(fastly_response_handle_t h, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_close((int32_t) (h), ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_http_resp_framing_headers_mode_set(fastly_response_handle_t h, fastly_framing_headers_mode_t mode, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_http_resp_framing_headers_mode_set((int32_t) (h), (int32_t) mode, ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_dictionary_open(fastly_world_string_t *name, fastly_dictionary_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[8];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_dictionary_open((int32_t) (*name).ptr, (int32_t) (*name).len, ptr);
    fastly_result_dictionary_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint32_t) (*((int32_t*) (ptr + 4)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_dictionary_get(fastly_dictionary_handle_t h, fastly_world_string_t *key, fastly_option_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[16];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_dictionary_get((int32_t) (h), (int32_t) (*key).ptr, (int32_t) (*key).len, ptr);
    fastly_result_option_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_string_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 8))), (size_t)(*((int32_t*) (ptr + 12))) };
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_geo_lookup(fastly_list_u8_t *addr_octets, fastly_world_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_geo_lookup((int32_t) (*addr_octets).ptr, (int32_t) (*addr_octets).len, ptr);
    fastly_result_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_object_store_open(fastly_world_string_t *name, fastly_object_store_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[8];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_object_store_open((int32_t) (*name).ptr, (int32_t) (*name).len, ptr);
    fastly_result_object_store_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint32_t) (*((int32_t*) (ptr + 4)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_object_store_lookup(fastly_object_store_handle_t store, fastly_world_string_t *key, fastly_option_body_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_object_store_lookup((int32_t) (store), (int32_t) (*key).ptr, (int32_t) (*key).len, ptr);
    fastly_result_option_body_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_body_handle_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (uint32_t) (*((int32_t*) (ptr + 8)));
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_object_store_lookup_as_fd(fastly_object_store_handle_t store, fastly_world_string_t *key, fastly_option_fd_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_object_store_lookup_as_fd((int32_t) (store), (int32_t) (*key).ptr, (int32_t) (*key).len, ptr);
    fastly_result_option_fd_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_fd_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (uint32_t) (*((int32_t*) (ptr + 8)));
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_object_store_insert(fastly_object_store_handle_t store, fastly_world_string_t *key, fastly_body_handle_t body_handle, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_object_store_insert((int32_t) (store), (int32_t) (*key).ptr, (int32_t) (*key).len, (int32_t) (body_handle), ptr);
    fastly_result_void_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_secret_store_open(fastly_world_string_t *name, fastly_secret_store_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[8];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_secret_store_open((int32_t) (*name).ptr, (int32_t) (*name).len, ptr);
    fastly_result_secret_store_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (uint32_t) (*((int32_t*) (ptr + 4)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_secret_store_get(fastly_secret_store_handle_t store, fastly_world_string_t *key, fastly_option_secret_handle_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_secret_store_get((int32_t) (store), (int32_t) (*key).ptr, (int32_t) (*key).len, ptr);
    fastly_result_option_secret_handle_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_secret_handle_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (uint32_t) (*((int32_t*) (ptr + 8)));
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_secret_store_plaintext(fastly_secret_handle_t secret, fastly_option_string_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[16];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_secret_store_plaintext((int32_t) (secret), ptr);
    fastly_result_option_string_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_string_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 8))), (size_t)(*((int32_t*) (ptr + 12))) };
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_async_io_select(fastly_list_async_handle_t *hs, uint32_t timeout_ms, fastly_option_u32_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_async_io_select((int32_t) (*hs).ptr, (int32_t) (*hs).len, (int32_t) (timeout_ms), ptr);
    fastly_result_option_u32_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            fastly_option_u32_t option;
            switch ((int32_t) (*((uint8_t*) (ptr + 4)))) {
                case 0: {
                    option.is_some = false;
                    break;
                }
                case 1: {
                    option.is_some = true;
                    option.val = (uint32_t) (*((int32_t*) (ptr + 8)));
                    break;
                }
            }

            result.val.ok = option;
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_async_io_is_ready(fastly_async_handle_t handle, bool *ret, fastly_error_t *err) {
    __attribute__((aligned(1)))
    uint8_t ret_area[2];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_async_io_is_ready((int32_t) (handle), ptr);
    fastly_result_bool_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 1)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

bool fastly_purge_surrogate_key(fastly_world_string_t *surrogate_key, bool soft_purge, fastly_purge_result_t *ret, fastly_error_t *err) {
    __attribute__((aligned(4)))
    uint8_t ret_area[12];
    int32_t ptr = (int32_t) &ret_area;
    __wasm_import_fastly_purge_surrogate_key((int32_t) (*surrogate_key).ptr, (int32_t) (*surrogate_key).len, soft_purge, ptr);
    fastly_result_purge_result_error_t result;
    switch ((int32_t) (*((uint8_t*) (ptr + 0)))) {
        case 0: {
            result.is_err = false;
            result.val.ok = (fastly_purge_result_t) {
                (fastly_world_string_t) { (char*)(*((int32_t*) (ptr + 4))), (size_t)(*((int32_t*) (ptr + 8))) },
            };
            break;
        }
        case 1: {
            result.is_err = true;
            result.val.err = (int32_t) (*((uint8_t*) (ptr + 4)));
            break;
        }
    }
    if (!result.is_err) {
        *ret = result.val.ok;
        return 1;
    } else {
        *err = result.val.err;
        return 0;
    }
}

__attribute__((export_name("compute-at-edge#serve")))
int32_t __wasm_export_compute_at_edge_serve(int32_t arg, int32_t arg0) {
    compute_at_edge_request_t arg1 = (compute_at_edge_request_t) {
        (uint32_t) (arg),
        (uint32_t) (arg0),
    };
    compute_at_edge_result_void_void_t ret;
    ret.is_err = !compute_at_edge_serve(&arg1);

    int32_t result;
    if ((ret).is_err) {
        result = 1;
    } else {
        result = 0;
    }
    return result;
}

extern void __component_type_object_force_link_fastly_world(void);
void __component_type_object_force_link_fastly_world_public_use_in_this_compilation_unit(void) {
    __component_type_object_force_link_fastly_world();
}
