//
//  ComputeRuntime.h
//  
//
//  Created by Andrew Barba on 1/11/22.
//

#ifndef ComputeRuntime_h
#define ComputeRuntime_h

#include <stdlib.h>
#include <stdint.h>

/* FASTLY_ABI */

__attribute__((__import_module__("fastly_abi"),__import_name__("init")))
extern int fastly_abi__init(uint64_t abi_version);

/* FASTLY_DICTIONARY */

__attribute__((__import_module__("fastly_dictionary"),__import_name__("open")))
extern int fastly_dictionary__open(const char* name, int name_len, int* handle);

__attribute__((__import_module__("fastly_dictionary"),__import_name__("get")))
extern int fastly_dictionary__get(int32_t h, const char* key, int key_len, uint8_t* value, int value_max_len, int* value_len);

/* FASTLY_LOG */

__attribute__((__import_module__("fastly_log"),__import_name__("endpoint_get")))
extern int fastly_log__endpoint_get(const char* name, int name_len, int* handle);

__attribute__((__import_module__("fastly_log"),__import_name__("write")))
extern int fastly_log__write(int handle, const char* msg, int msg_len, int* result);

/* FASTLY_GEO */

__attribute__((__import_module__("fastly_geo"),__import_name__("lookup")))
extern int fastly_geo__lookup(const uint8_t* ip, int ip_len, uint8_t* value, int value_max_len, int* value_len);

/* FASTLY_HTTP_BODY */

__attribute__((__import_module__("fastly_http_body"),__import_name__("new")))
extern int fastly_http_body__new(int* handle);

__attribute__((__import_module__("fastly_http_body"),__import_name__("append")))
extern int fastly_http_body__append(int dest, int src);

__attribute__((__import_module__("fastly_http_body"),__import_name__("close")))
extern int fastly_http_body__close(int handle);

__attribute__((__import_module__("fastly_http_body"),__import_name__("write")))
extern int fastly_http_body__write(int handle, const uint8_t* data, int data_len, int body_end, int* result);

__attribute__((__import_module__("fastly_http_body"),__import_name__("read")))
extern int fastly_http_body__read(int handle, uint8_t* data, int data_max_len, int* data_len);

/* FASTLY_HTTP_REQ */

__attribute__((__import_module__("fastly_http_req"),__import_name__("new")))
extern int fastly_http_req__new(int* handle);

__attribute__((__import_module__("fastly_http_req"),__import_name__("body_downstream_get")))
extern int fastly_http_req__body_downstream_get(int* req, int* body);

__attribute__((__import_module__("fastly_http_req"),__import_name__("close")))
extern int fastly_http_req__close(int handle);

__attribute__((__import_module__("fastly_http_req"),__import_name__("method_get")))
extern int fastly_http_req__method_get(int handle, uint8_t* value, int value_max_len, int* value_len);

__attribute__((__import_module__("fastly_http_req"),__import_name__("uri_get")))
extern int fastly_http_req__uri_get(int handle, uint8_t* value, int value_max_len, int* value_len);

__attribute__((__import_module__("fastly_http_req"),__import_name__("version_get")))
extern int fastly_http_req__version_get(int handle, int* version);

#endif /* ComputeRuntime_h */
