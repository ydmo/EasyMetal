//
//  File.metal
//  EasyMetal
//
//  Created by yyuser on 2019/1/9.
//  Copyright © 2019年 YudaMo.cn@gmail.com. All rights reserved.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct Param0 {
    ushort fm_n;
    ushort fm_c;
    ushort fm_h;
    ushort fm_w;
};

kernel void unittest_mtlbuffer0(
                                const device uint *srcbuf   [[buffer(0)]],
                                device uint *dstbuf         [[buffer(1)]],
                                constant Param0 &param      [[buffer(2)]],
                                uint3  gid                [[thread_position_in_grid]]
                                ) {
    if(gid.z >= param.fm_n * param.fm_c || gid.y >= param.fm_h || gid.x > param.fm_w) return;
    dstbuf[gid.z * param.fm_h * param.fm_w + gid.y * param.fm_w + gid.x] = srcbuf[gid.z * param.fm_h * param.fm_w + gid.y * param.fm_w + gid.x] + 1;
}

//
kernel void unittest_buffer2texture(
                                    const device half4 *srcBuf                  [[buffer(0)]],
                                    texture2d_array<half, access::write> dstTex [[texture(0)]],
                                    uint3  gid                                  [[thread_position_in_grid]]
                                    ) {
    if(gid.z >= dstTex.get_array_size() || gid.y >= dstTex.get_width() || gid.x > dstTex.get_height()) return;
    dstTex.write(srcBuf[gid.z * dstTex.get_height() * dstTex.get_width() + gid.y * dstTex.get_width() + gid.x] + half(0.5h), gid.xy, gid.z);
}

kernel void unittest_texture2texture(
                                     texture2d_array<half, access::sample> srcTex   [[texture(0)]],
                                     texture2d_array<half, access::write> dstTex    [[texture(1)]],
                                     uint3  gid                                     [[thread_position_in_grid]]
                                     ) {
    if(gid.z >= dstTex.get_array_size() || gid.y >= dstTex.get_width() || gid.x > dstTex.get_height()) return;
    dstTex.write(srcTex.read(gid.xy, gid.z) * half4(dstTex.get_array_size(), dstTex.get_height(), dstTex.get_width(), 1), gid.xy, gid.z);
}

