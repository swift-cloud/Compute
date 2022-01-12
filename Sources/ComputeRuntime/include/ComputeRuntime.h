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
extern uint32_t fastly_abi__init(uint64_t abi_version);

/* FASTLY_DICTIONARY */

__attribute__((__import_module__("fastly_dictionary"),__import_name__("open")))
extern uint32_t fastly_dictionary__open(char* name, int32_t name_len, int32_t* result);

__attribute__((__import_module__("fastly_dictionary"),__import_name__("get")))
extern uint32_t fastly_dictionary__get(int32_t h, char* key, int32_t key_len, char* value, int32_t value_max_len, int32_t* result);

#endif /* ComputeRuntime_h */
