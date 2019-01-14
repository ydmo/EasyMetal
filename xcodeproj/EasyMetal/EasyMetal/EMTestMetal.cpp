//
//  EMTestMetal.cpp
//  EMTests
//
//  Created by yyuser on 2019/1/10.
//  Copyright © 2019年 YudaMo.cn@gmail.com. All rights reserved.
//

#include "EMTestMetal.h"

TestMetalA::TestMetalA() {
    
    _fm_n = 32;
    _fm_c = 8;
    _fm_w = 128;
    _fm_h = 128;
    
    // new device
    mtlGenDevice(&_dev);
    assert(_dev > 0);
    mtlDelDevice(&_dev);
    assert(_dev == 0);
    mtlGenDevice(&_dev);
    assert(_dev > 0);
    mtlSetCurrentDevice(_dev);
    
    // new library
    mtlGenLibraryFromCurrentDevice(&_lib);
    assert(_lib > 0);
    mtlSetCurrentLibrary(_lib);
    
    // new commandqueue
    mtlGenQueueFromCurrentDevice(0, &_queue);
    assert(_queue > 0);
    mtlSetCurrentQueue(_queue);
    
    // new mtlfunction
    MTLuint _func = 0;
    mtlGenFunctionFromLibrary("unittest_mtlbuffer0", _lib, &_func);
    assert(_func > 0);
    // new pipeline state
    mtlGenComputePipelineStateFromDeviceWithFunction(_dev, _func, &_pipeline);
    assert(_pipeline > 0);

    MTLsizeu bestthreadwidth = 0, maxthreadsnum = 0;
    mtlGetBestThreadWidthFromComputePipelineState(_pipeline, &bestthreadwidth);
    mtlGetMaxThreadsPerGroupFromComputePipelineState(_pipeline, &maxthreadsnum);
    assert(bestthreadwidth > 0);
    assert(maxthreadsnum > 0);
    
    _threadsperthreadsgroupx = bestthreadwidth;
    _threadsperthreadsgroupy = maxthreadsnum / bestthreadwidth;
    _threadsperthreadsgroupz = 1;
    _threadgroupspergridx = (_fm_w + _threadsperthreadsgroupx - 1) / _threadsperthreadsgroupx;
    _threadgroupspergridy = (_fm_h + _threadsperthreadsgroupy - 1) / _threadsperthreadsgroupy;
    _threadgroupspergridz = _fm_n * _fm_c;
    
    // new a buffers
    MTLvoid *_p = NULL;
    size_t size_aligned = (((_fm_n * _fm_w * _fm_h * _fm_c * sizeof(MTLuint) + 4095) >> 12) << 12);
    posix_memalign(&_p, 4096, size_aligned);
    MTLuint *pf = (MTLuint *)_p;
    for (size_t n = 0; n < _fm_n; n++) {
        for (size_t c = 0; c < _fm_c; c++) {
            for (size_t h = 0; h < _fm_h; h++) {
                for (size_t w = 0; w < _fm_w; w++) {
                    pf[n * _fm_c * _fm_h * _fm_w + c * _fm_h * _fm_w + h * _fm_w + w] = (MTLuint)(n + c + h + w);
                }
            }
        }
    }
    MTLuint _buffer0 = 0;
    mtlGenBufferFromCurrentDeviceWithData(MTL_RESOURCE_OPTION_STORAGEMODE_SHARED, (MTLsizeu)(_fm_n * _fm_w * _fm_h * _fm_c * sizeof(MTLuint)), _p, &_buffer0);
    free(_p);
    assert(_buffer0 > 0);
    _buffers.push_back(_buffer0);
    
    MTLuint _buffer1 = 0;
    mtlGenBufferFromCurrentDevice(MTL_RESOURCE_OPTION_STORAGEMODE_SHARED, (MTLsizeu)(_fm_n * _fm_w * _fm_h * _fm_c * sizeof(MTLuint)), &_buffer1);
    assert(_buffer1 > 1);
    _buffers.push_back(_buffer0);
}

TestMetalA::~TestMetalA() { }

void cb(MTLint argc, va_list argl) {
    //vprintf("%d,%d,%d,%d,%d\n", ap);
    MTLsizeu _fm_n = va_arg( argl, MTLsizeu );
    MTLsizeu _fm_c = va_arg( argl, MTLsizeu );
    MTLsizeu _fm_h = va_arg( argl, MTLsizeu );
    MTLsizeu _fm_w = va_arg( argl, MTLsizeu );
    MTLuint buffer = va_arg( argl, MTLuint );
    
    MTLvoid *_p = NULL;
    size_t size_aligned = (((_fm_n * _fm_w * _fm_h * _fm_c * sizeof(MTLuint) + 4095) >> 12) << 12);
    posix_memalign(&_p, 4096, size_aligned);
    memset(_p, 0, size_aligned);
    mtlGetBytesFromBuffer(buffer, _fm_n * _fm_c * _fm_w * _fm_h * sizeof(MTLuint), _p);
    MTLuint *pf = (MTLuint *)_p;
    for (size_t n = 0; n < _fm_n; n++) {
        for (size_t c = 0; c < _fm_c; c++) {
            for (size_t h = 0; h < _fm_h; h++) {
                for (size_t w = 0; w < _fm_w; w++) {
                    assert(pf[n * _fm_c * _fm_h * _fm_w + c * _fm_h * _fm_w + h * _fm_w + w] == (MTLuint)(n + c + h + w) + 1);
                }
            }
        }
    }
    free(_p);
};

void TestMetalA::test(void) {
    mtlGenCommandBufferFromCurrentQueue(&_cmdbuf);
    assert(_cmdbuf > 0);
    mtlSetCurrentCommandBuffer(_cmdbuf);
    
    mtlGenCurrentEncoderFromCurrentCommandBuffer();
    mtlCurrentEncoderSetPipelineState(_pipeline);
    mtlCurrentEncoderSetBuffer(_buffers[0], 0, 0);
    mtlCurrentEncoderSetBuffer(_buffers[1], 0, 1);
    ushort fmsize[4] = {static_cast<ushort>(_fm_n), static_cast<ushort>(_fm_c), static_cast<ushort>(_fm_h), static_cast<ushort>(_fm_w)};
    mtlCurrentEncoderSetBytes(fmsize, sizeof(ushort) * 4, 2);
    mtlCurrentEncoderSetDispatchSize(
                                     _threadgroupspergridx,
                                     _threadgroupspergridy,
                                     _threadgroupspergridz,
                                     _threadsperthreadsgroupx,
                                     _threadsperthreadsgroupy,
                                     _threadsperthreadsgroupz
                                     );
    mtlCurrentEncoderSetEndCoding();
    
    MTLCallBack mcb = cb;
    mtlSetCompletedBlockToCurrentCommandBuffer(mcb, 5, _fm_n, _fm_c, _fm_h, _fm_w, _buffers[1]);
    
    mtlCommitCurrentCommandBuffer();
    mtlWaitUntilCurrentCommandBufferComplete();
    
    MTLfloat gputime = 0;
    mtlGetCurrentCommandBufferGPUTime(&gputime);
    printf("GPU Cost %f ms\n", 1000 * gputime);
}

struct vhalf4 {
    half x;
    half y;
    half z;
    half w;
};
vhalf4 vhalf4_make(float a, float b, float c, float d) {
    vhalf4 res;
    res.x = a;
    res.y = b;
    res.z = c;
    res.w = d;
    return res;
}

TestMetalB::TestMetalB() {
    _fm_c = 32;
    _fm_w = 128;
    _fm_h = 128;
    
    // new device
    _dev = 0;
    mtlGenDevice(&_dev);
    assert(_dev);
    mtlSetCurrentDevice(_dev);
    
    // new heap (metal texture pool)
    _heap = 0;
    mtlGenHeapFromCurrentDevice(MTL_STORAGEMODE_PRIVATE, MTL_CPUCACHEMODE_WRITECOMB, 128 * 128 * 32 * 2 * sizeof(half), &_heap);
    assert(_heap);
    mtlSetCurrentHeap(_heap);
    
    // new library
    _lib = 0;
    mtlGenLibraryFromCurrentDevice(&_lib);
    assert(_lib);
    mtlSetCurrentLibrary(_lib);
    
    // new commandqueue
    mtlGenQueueFromCurrentDevice(0, &_queue);
    mtlSetCurrentQueue(_queue);
    
    // new input buffer
    MTLvoid *_p = NULL;
    size_t size_aligned = (((_fm_c * _fm_w * _fm_h * sizeof(MTLuint) + 4095) >> 12) << 12);
    posix_memalign(&_p, 4096, size_aligned);
    vhalf4 *pf = (vhalf4 *)_p;
    for (size_t slice = 0; slice < (_fm_c + 3) / 4; slice++) {
        for (size_t h = 0; h < _fm_h; h++) {
            for (size_t w = 0; w < _fm_w; w++) {
                pf[slice * _fm_h * _fm_w + h * _fm_w + w] = vhalf4_make(
                                                                        slice * 1.f / ((_fm_c + 3) / 4) - 0.5f,
                                                                        h * 1.f / _fm_h - 0.5f,
                                                                        w * 1.f / _fm_w - 0.5f,
                                                                        -0.5f
                                                                        );
            }
        }
    }
    MTLuint _buffer0 = 0;
    mtlGenBufferFromCurrentDeviceWithData(MTL_RESOURCE_OPTION_STORAGEMODE_SHARED, (MTLsizeu)(_fm_w * _fm_h * _fm_c * sizeof(MTLuint)), _p, &_buffer0);
    free(_p);
    _buffers.push_back(_buffer0);
    
    // resize handle vector: _textures
    _textures.resize(2);
    
    // new mid-texture 0
    //mtlGenTextureFromHeap(MTL_TEXTURE_2D_ARRAY, MTL_RGBA_16F, MTL_READ|MTL_WRITE, _fm_w, _fm_h, 1, 0, (_fm_c+3)/4, &_textures[0]);
    
    // new dst-texture 1
    mtlGenTextureFromCurrentDevice(MTL_TEXTURE_2D_ARRAY, MTL_RGBA_16F, MTL_READ|MTL_WRITE, _fm_w, _fm_h, 1, 1, (_fm_c+3)/4, &_textures[1]);
    assert(_textures[1]);
    
    // new pipeline from function: unittest_buffer2texture
    {
        // new mtlfunction
        MTLuint _func = 0;
        mtlGenFunctionFromLibrary("unittest_buffer2texture", _lib, &_func);
        // new pipeline state
        _pipeline0 = 0;
        mtlGenComputePipelineStateFromDeviceWithFunction(_dev, _func, &_pipeline0);
        assert(_pipeline0);
        
        MTLsizeu bestthreadwidth = 0, maxthreadsnum = 0;
        mtlGetBestThreadWidthFromComputePipelineState(_pipeline0, &bestthreadwidth);
        mtlGetMaxThreadsPerGroupFromComputePipelineState(_pipeline0, &maxthreadsnum);
        assert(bestthreadwidth > 0);
        assert(maxthreadsnum > 0);
        
        _threadsperthreadgroup0.x = bestthreadwidth;
        _threadsperthreadgroup0.y = maxthreadsnum / bestthreadwidth;
        _threadsperthreadgroup0.z = 1;
        _threadgrouppergrid0.x = (_fm_w + _threadsperthreadgroup0.x - 1) / _threadsperthreadgroup0.x;
        _threadgrouppergrid0.y = (_fm_h + _threadsperthreadgroup0.y - 1) / _threadsperthreadgroup0.y;
        _threadgrouppergrid0.z = (_fm_c + 3) / 4;
    }
    
    // new pipeline from function: unittest_buffer2texture
    {
        MTLuint _func = 0;
        mtlGenFunctionFromLibrary("unittest_texture2texture", _lib, &_func);
        assert(_func);
        // new pipeline state
        _pipeline1 = 0;
        mtlGenComputePipelineStateFromDeviceWithFunction(_dev, _func, &_pipeline1);
        assert(_pipeline1);
        
        MTLsizeu bestthreadwidth = 0, maxthreadsnum = 0;
        mtlGetBestThreadWidthFromComputePipelineState(_pipeline1, &bestthreadwidth);
        mtlGetMaxThreadsPerGroupFromComputePipelineState(_pipeline1, &maxthreadsnum);
        assert(bestthreadwidth > 0);
        assert(maxthreadsnum > 0);
        
        _threadsperthreadgroup1.x = bestthreadwidth;
        _threadsperthreadgroup1.y = maxthreadsnum / bestthreadwidth;
        _threadsperthreadgroup1.z = 1;
        _threadgrouppergrid1.x = (_fm_w + _threadsperthreadgroup1.x - 1) / _threadsperthreadgroup1.x;
        _threadgrouppergrid1.y = (_fm_h + _threadsperthreadgroup1.y - 1) / _threadsperthreadgroup1.y;
        _threadgrouppergrid1.z = (_fm_c + 3) / 4;
    }
}

TestMetalB::~TestMetalB() {
    
}

void TestMetalB::test(void) {
    mtlGenCommandBufferFromCurrentQueue(&_cmdbuf);
    assert(_cmdbuf > 0);
    mtlSetCurrentCommandBuffer(_cmdbuf);
    
    _textures[0] = 0;
    mtlGenTextureFromHeap(MTL_TEXTURE_2D_ARRAY, MTL_RGBA_16F, MTL_READ|MTL_WRITE, _fm_w, _fm_h, 1, 1, (_fm_c+3)/4, &_textures[0]);
    assert(_textures[0]);
    
    mtlGenCurrentEncoderFromCurrentCommandBuffer();
    
    mtlCurrentEncoderSetPipelineState(_pipeline0);
    mtlCurrentEncoderSetBuffer(_buffers[0], 0, 0);
    mtlCurrentEncoderSetTexture(_textures[0], 0);
    mtlCurrentEncoderSetDispatchSize3(_threadgrouppergrid0, _threadsperthreadgroup0);
    
    mtlCurrentEncoderSetPipelineState(_pipeline1);
    mtlCurrentEncoderSetTexture(_textures[0], 0);
    mtlCurrentEncoderSetTexture(_textures[1], 1);
    mtlCurrentEncoderSetDispatchSize3(_threadgrouppergrid1, _threadsperthreadgroup1);
    
    mtlCurrentEncoderSetEndCoding();
    
    mtlMakeTextureAliasable(_textures[0]);
    
    mtlCommitCurrentCommandBuffer();
    mtlWaitUntilCurrentCommandBufferComplete();
    
    MTLfloat gputime = 0;
    mtlGetCurrentCommandBufferGPUTime(&gputime);
    printf("GPU Cost %f ms\n", 1000 * gputime);
    
    MTLvoid *_p = NULL;
    size_t size_aligned = (((_fm_c * _fm_w * _fm_h * sizeof(MTLuint) + 4095) >> 12) << 12);
    posix_memalign(&_p, 4096, size_aligned);
    vhalf4 *pf = (vhalf4 *)_p;
    MTLTexRegion region;
    region.origin.x = 0;
    region.origin.y = 0;
    region.origin.z = 0;
    region.size.x = _fm_w;
    region.size.y = _fm_h;
    region.size.z = 1;
    for (MTLsizeu slice = 0; slice < (_fm_c + 3) / 4; slice++) {
        mtlGetBytesFromTexture(_textures[1], slice, _fm_w * 4 * sizeof(half), region, pf + slice * _fm_h * _fm_w);
        for (MTLsizeu h = 0; h < _fm_h; h++) {
            for (MTLsizeu w = 0; w < _fm_w; w++) {
                assert( fabs( pf[slice * _fm_h * _fm_w + h * _fm_w + w].x - slice) < 1e-3 );
                assert( fabs( pf[slice * _fm_h * _fm_w + h * _fm_w + w].y - h) < 1e-3 );
                assert( fabs( pf[slice * _fm_h * _fm_w + h * _fm_w + w].z - w) < 1e-3 );
            }
        }
    }
    
    free(_p);
}

TestMetalC::TestMetalC() {
    
    MTLsizeu _fm_c = 32;
    MTLsizeu _fm_w = 128;
    MTLsizeu _fm_h = 128;
    
    // new device
    _dev = 0;
    mtlGenDevice(&_dev);
    mtlSetCurrentDevice(_dev);
    
    // new library
    _lib = 0;
    mtlGenLibraryFromCurrentDevice(&_lib);
    mtlSetCurrentLibrary(_lib);
    
    // new commandqueue
    _queue = 0;
    mtlGenQueueFromCurrentDevice(0, &_queue);
    mtlSetCurrentQueue(_queue);
    
    // new a texture
    MTLuint tex = 0;
    mtlGenTextureFromCurrentDevice(MTL_TEXTURE_2D_ARRAY, MTL_RGBA_16F, MTL_READ|MTL_WRITE, _fm_w, _fm_h, 1, 1, (_fm_c+3)/4, &tex);
    _textures.push_back(tex);
    
}

TestMetalC::~TestMetalC() {
    
}

void TestMetalC::test(void) {
    for (int i = 0; i < 1000; i++) {
        mtlSetCurrentTexture(_textures[0]);
    }
}
