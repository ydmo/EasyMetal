//                       佛光普照
//                      / | | | \
//                     / | | | | \
//
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
//
//
//     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//               佛祖保佑    🙏    上线无BUG
//
//  easymetal.h
//  EasyMetal
//
//  Created by yyuser on 2019/1/9.
//  Copyright © 2019年 YudaMo.cn@gmail.com. All rights reserved.
//

#ifndef _EASYMETAL_H_
#define _EASYMETAL_H_

#define MTL_API
#define EM_AVALIABLE 1

#include <stdio.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
    
    typedef unsigned long   MTLidx;
    typedef unsigned long   MTLulong;
    typedef unsigned long   MTLsizeul;
    typedef unsigned long   MTLenum;
    typedef unsigned int    MTLuint;
    typedef unsigned int    MTLbitfield;
    typedef unsigned int    MTLsizeu;
    typedef unsigned short  MTLushort;
    typedef unsigned char   MTLboolean;
    typedef unsigned char   MTLubyte;
    typedef long            MTLlong;
    typedef int             MTLint;
    typedef int             MTLsizei;
    typedef int             MTLclampx;
    typedef int             MTLfixed;
    typedef short           MTLshort;
    typedef char            MTLchar;
    typedef char            MTLbyte;
    typedef unsigned short  MTLhalf;
    typedef unsigned short  MTLclamph;
    typedef float           MTLfloat;
    typedef float           MTLclampf;
    typedef void            MTLvoid;
    
    struct MTLsizei2 {
        MTLsizei x;
        MTLsizei y;
    };
    MTL_API MTLsizei2 MTLsizei2Make(MTLsizei x, MTLsizei y);
    
    struct MTLsizeu2 {
        MTLsizeu x;
        MTLsizeu y;
    };
    MTL_API MTLsizeu2 MTLsizeu2Make(MTLsizeu x, MTLsizeu y);
    
    struct MTLsizeu3 {
        MTLsizeu x;
        MTLsizeu y;
        MTLsizeu z;
    };
    MTL_API MTLsizeu3 MTLsizeu3Make(MTLsizeu x, MTLsizeu y, MTLsizeu z);
    
    struct MTLsizeu4 {
        MTLsizeu x;
        MTLsizeu y;
        MTLsizeu z;
        MTLsizeu w;
    };
    MTL_API MTLsizeu4 MTLsizeu4Make(MTLsizeu x, MTLsizeu y, MTLsizeu z, MTLsizeu w);
    
    struct MTLTexRegion {
        MTLsizeu3 origin;
        MTLsizeu3 size;
    };
    MTL_API MTLTexRegion MTLTexRegionMake(MTLsizeu x, MTLsizeu y, MTLsizeu z, MTLsizeu w, MTLsizeu h, MTLsizeu depth);
    
#pragma mark MTLDevice
    // for MTLDevice
    MTL_API MTLvoid mtlGenDevice(MTLuint *__device);
    MTL_API MTLvoid mtlBindDevice(MTLuint __device);
    MTL_API MTLvoid mtlSetCurrentDevice(MTLuint __device);
    MTL_API MTLvoid mtlDelDevice(MTLuint *__device);
    
    
#pragma mark MTLCommandQueue
    // for MTLCommandQueue
    MTL_API MTLvoid mtlGenQueueFromCurrentDevice(MTLuint __maxbuffer, MTLuint *__queue);
    MTL_API MTLvoid mtlBindQueue(MTLuint __queue);
    MTL_API MTLvoid mtlSetCurrentQueue(MTLuint __queue);
    MTL_API MTLvoid mtlDelQueue(MTLuint *__queue);
    
    
#pragma mark MTLLibrary
    // for MTLLibrary
    MTL_API MTLvoid mtlGenLibraryFromCurrentDevice(MTLuint *__library);
    MTL_API MTLvoid mtlGenLibraryFromCurrentDeviceWithSource(const MTLchar *__shaders, MTLuint *__library);
    MTL_API MTLvoid mtlGenLibraryFromCurrentDeviceWithMetalLib(const MTLchar *__metallibpath, MTLuint *__library);
    MTL_API MTLvoid mtlGenLibraryFromCurrentDeviceWithMetalLibURL(const MTLchar *__metalliburl, MTLuint *__library); // API_AVAILABLE(macos(10.13), ios(11.0));
    MTL_API MTLvoid mtlBindLibrary(MTLuint __library);
    MTL_API MTLvoid mtlSetCurrentLibrary(MTLuint __library);
    MTL_API MTLvoid mtlDelLibrary(MTLuint *__library);
    
    
#pragma mark MTLFence
    // for MTLFence
    MTL_API MTLvoid mtlGenFenceFromCurrentDevice(MTLuint *__fence);
    MTL_API MTLvoid mtlBindFence(MTLuint __fence);
    MTL_API MTLvoid mtlSetCurrentFence(MTLuint __fence);
    MTL_API MTLvoid mtlEncoderUpdateFence(MTLvoid);
    MTL_API MTLvoid mtlDelFence(MTLuint *__fence);
    
    
#pragma mark MTLHeap
    // for MTLHeap
#define MTL_STORAGEMODE_SHARED      0
#define MTL_STORAGEMODE_MANAGED     1 // API_AVAILABLE(macos(10.11)) API_UNAVAILABLE(ios)
#define MTL_STORAGEMODE_PRIVATE     2
#define MTL_STORAGEMODE_MEMLESS     3 // API_AVAILABLE(ios(10.0)) API_UNAVAILABLE(macos)
#define MTL_CPUCACHEMODE_DEFAULT    0
#define MTL_CPUCACHEMODE_WRITECOMB  1
    MTL_API MTLvoid mtlGenHeapFromCurrentDevice(MTLenum __storagemode, MTLenum __cpucachemode, MTLsizeu __size, MTLuint *__heap);
    MTL_API MTLvoid mtlBindHeap(MTLuint __heap);
    MTL_API MTLvoid mtlSetCurrentHeap(MTLuint __heap);
    MTL_API MTLvoid mtlDelHeap(MTLuint *__heap);
    
    
#pragma mark MTLTexture
    // for MTLTexture
    /* Texture targets */
#define MTL_TEXTURE_1D              0
#define MTL_TEXTURE_1D_ARRAY        1
#define MTL_TEXTURE_2D              2
#define MTL_TEXTURE_2D_ARRAY        3
#define MTL_TEXTURE_2D_MAP          4
#define MTL_TEXTURE_CUBE            5
#define MTL_TEXTURE_CUBE_ARRAY      6 // API_AVAILABLE(macos(10.11), ios(11.0))
#define MTL_TEXTURE_3D              7
#define MTL_TEXTURE_2D_MAP_ARRAY    8 // API_AVAILABLE(macos(10.14)) API_UNAVAILABLE(ios)
#define MTL_TEXTURE_BUFFER          9 // API_AVAILABLE(macos(10.14), ios(12.0))
    /* common formats */
#define MTL_INVALID                 0
#define MTL_ALPHA_8UNORM            1
#define MTL_R_8UNORM                10
#define MTL_R_16UNORM               20
#define MTL_RG_8UNORM               30
#define MTL_RG_16UNORM              60
#define MTL_RGBA_8UNORM             70
#define MTL_BGRA_8UNORM             80
#define MTL_R_16F                   25
#define MTL_RG_16F                  65
#define MTL_RGBA_16F                115
#define MTL_R_32F                   55
#define MTL_RG_32F                  105
#define MTL_RGBA_32F                125
    /* common usages */ // API_AVAILABLE(macos(10.11), ios(9.0))
#define MTL_UNKNOW                  0x0000
#define MTL_READ                    0x0001
#define MTL_WRITE                   0x0002
#define MTL_TARGET                  0x0004
#define MTL_PIXELFORMATVIEW         0x0010
    MTL_API MTLvoid mtlGenTextureFromCurrentDevice(MTLenum __target, MTLenum __format, MTLenum __usage, MTLsizei __width, MTLsizei __height, MTLsizei __depth, MTLsizei __level, MTLsizei __arraylength, MTLuint *__texture);
    MTL_API MTLvoid mtlGenTextureFromCurrentDeviceWithModes(MTLenum __storagemode, MTLenum __cpucachemode, MTLenum __target, MTLenum __format, MTLenum __usage, MTLsizei __width, MTLsizei __height, MTLsizei __depth, MTLsizei __level, MTLsizei __arraylength, MTLuint *__texture);
    MTL_API MTLvoid mtlGenTextureFromCurrentHeap(MTLenum __target, MTLenum __format, MTLenum __usage, MTLsizei __width, MTLsizei __height, MTLsizei __depth, MTLsizei __level, MTLsizei __arraylength, MTLuint *__texture);
    MTL_API MTLvoid mtlBindTexture(MTLuint __texture);
    MTL_API MTLvoid mtlSetCurrentTexture(MTLuint __texture);
    MTL_API MTLvoid mtlMakeTextureAliasable(MTLuint __texture);
    MTL_API MTLvoid mtlMakeCurrentTextureAliasable(MTLvoid);
    MTL_API MTLvoid mtlDelTexture(MTLuint *__texture);
    MTL_API MTLvoid mtlGetBytesFromTexture(MTLuint __texture, MTLsizeu __slice, MTLsizeu __bytesperrow, MTLTexRegion __region, MTLvoid *__bytes);
    MTL_API MTLvoid mtlSetBytesToTexture(MTLuint __texture, MTLsizeu __slice, MTLsizeu __bytesperrow, MTLTexRegion __region, MTLvoid *__bytes);
    MTL_API MTLvoid mtlGetWidthFromCurrentTexture(MTLsizei *__width);
    MTL_API MTLvoid mtlGetHeightFromCurrentTexture(MTLsizei *__height);
    MTL_API MTLvoid mtlGetWidthFromTexture(MTLuint __texture, MTLsizei *__width);
    MTL_API MTLvoid mtlGetHeightFromTexture(MTLuint __texture, MTLsizei *__height);
    
#pragma mark MTLBuffer
    // for MTLBuffer
#define MTL_RESOURCE_OPTION_CPUCACHEMODE_DEFAULT            0
#define MTL_RESOURCE_OPTION_CPUCACHEMODE_WRITECOMBINED      1
#define MTL_RESOURCE_OPTION_STORAGEMODE_SHARED              0
#define MTL_RESOURCE_OPTION_STORAGEMODE_PRIVATE             32
#define MTL_RESOURCE_OPTION_STORAGEMODE_MANAGED             16
#define MTL_RESOURCE_OPTION_STORAGEMODE_MEMLESS             48
#define MTL_RESOURCE_OPTION_HAZARDTRACKINGMODE_UNTRACK      256
    
    MTL_API MTLvoid mtlGenBufferFromCurrentDevice(MTLenum __option, MTLsizeu __size, MTLuint *__buffer);
    MTL_API MTLvoid mtlGenBufferFromCurrentHeap(MTLenum __option, MTLsizeu __size, MTLuint *__buffer);
    MTL_API MTLvoid mtlGenBufferFromCurrentDeviceWithData(MTLenum __option, MTLsizeu __size, MTLvoid *__data, MTLuint *__buffer);
    MTL_API MTLvoid mtlGenBufferFromCurrentDeviceWithDataNoCopy(MTLenum __option, MTLsizeu __size, MTLvoid *__data, MTLuint *__buffer);
    MTL_API MTLvoid mtlGenBufferFromDevice(MTLuint __device, MTLenum __option, MTLsizeu __size, MTLuint *__buffer);
    MTL_API MTLvoid mtlGenBufferFromHeap(MTLuint __heap, MTLenum __option, MTLsizeu __size, MTLuint *__buffer);
    MTL_API MTLvoid mtlGenBufferFromDeviceWithData(MTLuint __device, MTLenum __option, MTLsizeu __size, MTLvoid *__data, MTLuint *__buffer);
    MTL_API MTLvoid mtlGenBufferFromDeviceWithDataNoCopy(MTLuint __device, MTLenum __option, MTLsizeu __size, MTLvoid *__data, MTLuint *__buffer);
    MTL_API MTLvoid mtlBindBuffer(MTLuint __buffer);
    MTL_API MTLvoid mtlSetCurrentBuffer(MTLuint __buffer);
    MTL_API MTLvoid mtlGetBytesFromBuffer(MTLuint __buffer, MTLsizeu __size, MTLvoid *__bytes);
    MTL_API MTLvoid mtlDelBuffer(MTLuint *__buffer);
    
#pragma mark MTLFunctionConstantValues
    // for MTLFunctionConstantValues :
#define MTL_DATATYPE_NONE   0
#define MTL_DATATYPE_STRUCT   1
#define MTL_DATATYPE_ARRAY    2
#define MTL_DATATYPE_FLOAT    3
#define MTL_DATATYPE_FLOAT2   4
#define MTL_DATATYPE_FLOAT3   5
#define MTL_DATATYPE_FLOAT4   6
#define MTL_DATATYPE_FLOAT2x2   7
#define MTL_DATATYPE_FLOAT2x3   8
#define MTL_DATATYPE_FLOAT2x4   9
#define MTL_DATATYPE_FLOAT3x2   10
#define MTL_DATATYPE_FLOAT3x3   11
#define MTL_DATATYPE_FLOAT3x4   12
#define MTL_DATATYPE_FLOAT4x2   13
#define MTL_DATATYPE_FLOAT4x3   14
#define MTL_DATATYPE_FLOAT4x4   15
#define MTL_DATATYPE_HALF    16
#define MTL_DATATYPE_HALF2   17
#define MTL_DATATYPE_HALF3   18
#define MTL_DATATYPE_HALF4   19
#define MTL_DATATYPE_HALF2x2   20
#define MTL_DATATYPE_HALF2x3   21
#define MTL_DATATYPE_HALF2x4   22
#define MTL_DATATYPE_HALF3x2   23
#define MTL_DATATYPE_HALF3x3   24
#define MTL_DATATYPE_HALF3x4   25
#define MTL_DATATYPE_HALF4x2   26
#define MTL_DATATYPE_HALF4x3   27
#define MTL_DATATYPE_HALF4x4   28
#define MTL_DATATYPE_INT    29
#define MTL_DATATYPE_INT2   30
#define MTL_DATATYPE_INT3   31
#define MTL_DATATYPE_INT4   32
#define MTL_DATATYPE_UINT    33
#define MTL_DATATYPE_UINT2   34
#define MTL_DATATYPE_UINT3   35
#define MTL_DATATYPE_UINT4   36
#define MTL_DATATYPE_SHORT    37
#define MTL_DATATYPE_SHORT2   38
#define MTL_DATATYPE_SHORT3   39
#define MTL_DATATYPE_SHORT4   40
#define MTL_DATATYPE_USHORT   41
#define MTL_DATATYPE_USHORT2   42
#define MTL_DATATYPE_USHORT3   43
#define MTL_DATATYPE_USHORT4   44
#define MTL_DATATYPE_CHAR    45
#define MTL_DATATYPE_CHAR2   46
#define MTL_DATATYPE_CHAR3   47
#define MTL_DATATYPE_CHAR4   48
#define MTL_DATATYPE_UCHAR    49
#define MTL_DATATYPE_UCHAR2   50
#define MTL_DATATYPE_UCHAR3   51
#define MTL_DATATYPE_UCHAR4   52
#define MTL_DATATYPE_BOOL    53
#define MTL_DATATYPE_BOOL2   54
#define MTL_DATATYPE_BOOL3   55
#define MTL_DATATYPE_BOOL4   56
    MTL_API MTLvoid mtlGenFunctionConstantValues(MTLuint *__constvals);
    MTL_API MTLvoid mtlSetFunctionConstantValuesWithIndex(MTLuint __constvals, MTLvoid *__data, MTLenum __datatype, MTLidx __index);
    MTL_API MTLvoid mtlSetFunctionConstantValuesWithName(MTLuint __constvals, MTLvoid *__data, MTLenum __datatype, const MTLchar * __name);
    MTL_API MTLvoid mtlBindFunctionConstantValues(MTLuint __constvals);
    MTL_API MTLvoid mtlSetCurrentFunctionConstantValues(MTLuint __constvals);
    MTL_API MTLvoid mtlSetCurrentFunctionConstantValuesWithIndex(MTLvoid *__data, MTLenum __datatype, MTLidx __index);
    MTL_API MTLvoid mtlSetCurrentFunctionConstantValuesWithName(MTLvoid *__data, MTLenum __datatype, const MTLchar * __name);
    MTL_API MTLvoid mtlDelFunctionConstantValues(MTLuint *__constvals);
    
    
#pragma mark MTLFunction
    // for MTLFunction :
    MTL_API MTLvoid mtlGenFunctionFromLibrary(const MTLchar * __name, MTLuint __library, MTLuint *__funtion);
    MTL_API MTLvoid mtlGenFunctionFromLibraryWithCurrentConstantValues(const MTLchar * __name, MTLuint __library, MTLuint *__funtion);
    MTL_API MTLvoid mtlGenFunctionFromLibraryWithConstantValues(const MTLchar * __name, MTLuint __library, MTLuint __constvals, MTLuint *__funtion);
    MTL_API MTLvoid mtlGenFunction(const MTLchar * __name, MTLuint *__funtion);
    MTL_API MTLvoid mtlGenFunctionWithCurrentConstantValues(const MTLchar * __name, MTLuint *__funtion);
    MTL_API MTLvoid mtlGenFunctionWithConstantValues(const MTLchar * __name, MTLuint __constvals, MTLuint *__funtion);
    MTL_API MTLvoid mtlBindFunction(MTLuint __funtion);
    MTL_API MTLvoid mtlSetCurrentFunction(MTLuint __funtion);
    MTL_API MTLvoid mtlDelFunction(MTLuint *__funtion);
    
    
#pragma mark MTLComputePipelineState
    // for MTLComputePipelineState: Metal's ComputePipelineState is similar to OpenGL's Compute Program
    MTL_API MTLvoid mtlGenComputePipelineStateFromDeviceWithFunction(MTLuint __device, MTLuint __function, MTLuint *__pipelinestate);
    MTL_API MTLvoid mtlGenComputePipelineStateFromDeviceWithCurrentFunction(MTLuint __device, MTLuint *__pipelinestate);
    MTL_API MTLvoid mtlGenComputePipelineStateFromCurrentDeviceWithFunction(MTLuint __function, MTLuint *__pipelinestate);
    MTL_API MTLvoid mtlGenComputePipelineStateFromCurrentDeviceWithCurrentFunction(MTLuint *__pipelinestate);
    MTL_API MTLvoid mtlGetMaxThreadsPerGroupFromComputePipelineState(MTLuint __pipelinestate, MTLsizeu *__maxthreadnum);
    MTL_API MTLvoid mtlGetBestThreadWidthFromComputePipelineState(MTLuint __pipelinestate, MTLsizeu *__maxthreadwidth);
    MTL_API MTLvoid mtlDelComputePipelineState(MTLuint *__pipelinestate);
    
    
#pragma mark MTLCommandBuffer
    // for MTLCommandBuffer
    typedef MTLvoid(*MTLCallBack) (MTLint argc, va_list argl);
    MTL_API MTLvoid mtlGenCommandBufferFromCurrentQueue(MTLuint *__cmdbuf);
    MTL_API MTLvoid mtlBindCommandBuffer(MTLuint __cmdbuf);
    MTL_API MTLvoid mtlSetCurrentCommandBuffer(MTLuint __cmdbuf);
    MTL_API MTLvoid mtlSetCompletedBlockToCurrentCommandBuffer(MTLCallBack __lamdablock, int argc, ...);
    MTL_API MTLvoid mtlCommitCurrentCommandBuffer(MTLvoid);
    MTL_API MTLvoid mtlWaitUntilCurrentCommandBufferScheduled(MTLvoid);
    MTL_API MTLvoid mtlWaitUntilCurrentCommandBufferComplete(MTLvoid);
    MTL_API MTLvoid mtlGetCurrentCommandBufferGPUTime(MTLfloat *__gputime);
    MTL_API MTLvoid mtlDelCommandBuffer(MTLuint *__cmdbuf);
    
    
#pragma mark MTLComputeCommandEncoder
    // for MTLComputeCommandEncoder
    MTL_API MTLvoid mtlGenEncoderFromCommandBuffer(MTLuint __cmdbuf, MTLuint *__encoder);
    MTL_API MTLvoid mtlGenEncoderFromCurrentCommandBuffer(MTLuint *__encoder);
    MTL_API MTLvoid mtlBindEncoder(MTLuint __encoder);
    MTL_API MTLvoid mtlSetCurrentEncoder(MTLuint __encoder);
    MTL_API MTLvoid mtlDelEncoder(MTLuint *__encoder);
    // encode one pass temporarily ...
    MTL_API MTLvoid mtlGenCurrentEncoderFromCurrentCommandBuffer(MTLvoid);
    MTL_API MTLvoid mtlCurrentEncoderSetPipelineState(MTLuint __pipelinestate);
    MTL_API MTLvoid mtlCurrentEncoderSetBytes(MTLvoid *__bytes, MTLuint __length, MTLidx __index);
    MTL_API MTLvoid mtlCurrentEncoderSetBuffer(MTLuint __buffer, MTLidx __offset, MTLidx __index);
    MTL_API MTLvoid mtlCurrentEncoderSetTexture(MTLuint __texture, MTLidx __index);
    MTL_API MTLvoid mtlCurrentEncoderSetDispatchSize(MTLsizeu __threadgroupspergridx, MTLsizeu __threadgroupspergridy, MTLsizeu __threadgroupspergridz, MTLsizeu __threadsperthreadsgroupx, MTLsizeu __threadsperthreadsgroupy, MTLsizeu __threadsperthreadsgroupz);
    MTL_API MTLvoid mtlCurrentEncoderSetDispatchSize3(MTLsizeu3 __threadgroupspergrid, MTLsizeu3 __threadsperthreadgroup);
    MTL_API MTLvoid mtlCurrentEncoderWaitForCurrentFence(MTLvoid);
    MTL_API MTLvoid mtlCurrentEncoderWaitForFence(MTLuint __fence);
    MTL_API MTLvoid mtlCurrentEncoderUpdateCurrentFence(MTLvoid);
    MTL_API MTLvoid mtlCurrentEncoderUpdateFence(MTLuint __fence);
    MTL_API MTLvoid mtlCurrentEncoderSetEndCoding(MTLvoid);
    
#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif /* _EASYMETAL_H_ */


