/* This file was generated by upbc (the upb compiler) from the input
 * file:
 *
 *     xds/core/v3/resource.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated. */

#ifndef XDS_CORE_V3_RESOURCE_PROTO_UPBDEFS_H_
#define XDS_CORE_V3_RESOURCE_PROTO_UPBDEFS_H_

#if COCOAPODS==1
  #include  "third_party/upb/upb/def.h"
#else
  #include  "upb/def.h"
#endif
#if COCOAPODS==1
  #include  "third_party/upb/upb/port_def.inc"
#else
  #include  "upb/port_def.inc"
#endif
#ifdef __cplusplus
extern "C" {
#endif

#if COCOAPODS==1
  #include  "third_party/upb/upb/def.h"
#else
  #include  "upb/def.h"
#endif

#if COCOAPODS==1
  #include  "third_party/upb/upb/port_def.inc"
#else
  #include  "upb/port_def.inc"
#endif

extern upb_def_init xds_core_v3_resource_proto_upbdefinit;

UPB_INLINE const upb_msgdef *xds_core_v3_Resource_getmsgdef(upb_symtab *s) {
  _upb_symtab_loaddefinit(s, &xds_core_v3_resource_proto_upbdefinit);
  return upb_symtab_lookupmsg(s, "xds.core.v3.Resource");
}

#ifdef __cplusplus
}  /* extern "C" */
#endif

#if COCOAPODS==1
  #include  "third_party/upb/upb/port_undef.inc"
#else
  #include  "upb/port_undef.inc"
#endif

#endif  /* XDS_CORE_V3_RESOURCE_PROTO_UPBDEFS_H_ */
