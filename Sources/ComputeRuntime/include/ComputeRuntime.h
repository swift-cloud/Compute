//
//  ComputeRuntime.h
//  
//
//  Created by Andrew Barba on 1/11/22.
//

#ifndef ComputeRuntime_h
#define ComputeRuntime_h

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define WASM_IMPORT(module, name) __attribute__((import_module(module), import_name(name)))

/* FASTLY_ABI */

WASM_IMPORT("fastly_abi", "init")
extern int fastly_abi__init(uint64_t abi_version);

/* FASTLY_DICTIONARY */

WASM_IMPORT("fastly_dictionary", "open")
extern int fastly_dictionary__open(const char* name, size_t name_len, int* handle);

WASM_IMPORT("fastly_dictionary", "get")
extern int fastly_dictionary__get(int32_t h, const char* key, size_t key_len, uint8_t* value, size_t value_max_len, size_t* nwritten);

/* FASTLY_LOG */

WASM_IMPORT("fastly_log", "endpoint_get")
extern int fastly_log__endpoint_get(const char* name, size_t name_len, int* handle);

WASM_IMPORT("fastly_log", "write")
extern int fastly_log__write(int handle, const char* msg, size_t msg_len, size_t* nwritten);

/* FASTLY_GEO */

WASM_IMPORT("fastly_geo", "lookup")
extern int fastly_geo__lookup(const uint8_t* ip, size_t ip_len, uint8_t* value, size_t value_max_len, size_t* nwritten);

/* FASTLY_HTTP_BODY */

WASM_IMPORT("fastly_http_body", "new")
extern int fastly_http_body__new(int* handle);

WASM_IMPORT("fastly_http_body", "append")
extern int fastly_http_body__append(int dest, int src);

WASM_IMPORT("fastly_http_body", "close")
extern int fastly_http_body__close(int handle);

WASM_IMPORT("fastly_http_body", "write")
extern int fastly_http_body__write(int handle, const uint8_t* data, size_t data_len, int body_end, size_t* nwritten);

WASM_IMPORT("fastly_http_body", "read")
extern int fastly_http_body__read(int handle, uint8_t* data, size_t data_max_len, size_t* nwritten);

/* FASTLY_HTTP_REQ */

WASM_IMPORT("fastly_http_req", "new")
extern int fastly_http_req__new(int* handle);

WASM_IMPORT("fastly_http_req", "body_downstream_get")
extern int fastly_http_req__body_downstream_get(int* req, int* body);

WASM_IMPORT("fastly_http_req", "close")
extern int fastly_http_req__close(int handle);

WASM_IMPORT("fastly_http_req", "method_get")
extern int fastly_http_req__method_get(int handle, uint8_t* value, size_t value_max_len, size_t* nwritten);

WASM_IMPORT("fastly_http_req", "uri_get")
extern int fastly_http_req__uri_get(int handle, uint8_t* value, size_t value_max_len, size_t* nwritten);

WASM_IMPORT("fastly_http_req", "version_get")
extern int fastly_http_req__version_get(int handle, int* version);

WASM_IMPORT("fastly_http_req", "method_set")
extern int fastly_http_req__method_set(int handle, const char* method, size_t method_len);

WASM_IMPORT("fastly_http_req", "uri_set")
extern int fastly_http_req__uri_set(int handle, const char* uri, size_t uri_len);

WASM_IMPORT("fastly_http_req", "version_set")
extern int fastly_http_req__version_set(int handle, int version);

WASM_IMPORT("fastly_http_req", "downstream_client_ip_addr")
extern int fastly_http_req__downstream_client_ip_addr(uint8_t* octets, size_t* nwritten);

/* FASTLY_HTTP_RESP */

WASM_IMPORT("fastly_http_resp", "new")
extern int fastly_http_resp__new(int* handle);

WASM_IMPORT("fastly_http_resp", "close")
extern int fastly_http_resp__close(int handle);

WASM_IMPORT("fastly_http_resp", "send_downstream")
extern int fastly_http_resp__send_downstream(int resp_handle, int body_handle, int streaming);

WASM_IMPORT("fastly_http_resp", "version_get")
extern int fastly_http_resp__version_get(int handle, int* version);

WASM_IMPORT("fastly_http_resp", "status_get")
extern int fastly_http_resp__status_get(int handle, int* status);

WASM_IMPORT("fastly_http_resp", "version_set")
extern int fastly_http_resp__version_set(int handle, int version);

WASM_IMPORT("fastly_http_resp", "status_set")
extern int fastly_http_resp__status_set(int handle, int status);

#endif /* ComputeRuntime_h */
