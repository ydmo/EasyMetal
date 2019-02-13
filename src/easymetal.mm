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
//  easymetal.cpp
//  EasyMetal
//
//  Created by yyuser on 2019/1/9.
//  Copyright © 2019年 YudaMo.cn@gmail.com. All rights reserved.
//

#include "easymetal.h"

// metal ...
#include <Foundation/Foundation.h>
#include <Metal/Metal.h>

// c11 ...
#include <stdio.h>
#include <assert.h>
#include <iostream>
#include <map>
#include <unordered_map>
#include <list>

// metal helper ...
#include "idevs.h"

class API_AVAILABLE(ios(10.0)) MTLResources {
public:
    // using unordered_map for fast hash searching ..
    std::unordered_map<MTLuint, id<MTLDevice>>                  _devs;
    std::unordered_map<MTLuint, id<MTLLibrary>>                 _libs;
    std::unordered_map<MTLuint, id<MTLCommandQueue>>            _queues;
    std::unordered_map<MTLuint, id<MTLFence>>                   _fences;
    std::unordered_map<MTLuint, id<MTLHeap>>                    _heaps;
    std::unordered_map<MTLuint, id<MTLCommandBuffer>>           _cmdbufs;
    std::unordered_map<MTLuint, id<MTLComputeCommandEncoder>>   _cmdencoders;
    std::unordered_map<MTLuint, id<MTLTexture>>                 _textures;
    std::unordered_map<MTLuint, id<MTLBuffer>>                  _buffers;
    std::unordered_map<MTLuint, MTLFunctionConstantValues *>    _funcconstvalses;
    std::unordered_map<MTLuint, id<MTLFunction>>                _computefunctions;
    std::unordered_map<MTLuint, id<MTLComputePipelineState>>    _computepipelinestates;
    
    // current resource ...
    std::pair<MTLuint, id<MTLDevice>>                           _current_dev;
    std::pair<MTLuint, id<MTLLibrary>>                          _current_lib;
    std::pair<MTLuint, id<MTLCommandQueue>>                     _current_queue;
    std::pair<MTLuint, id<MTLFence>>                            _current_fence;
    std::pair<MTLuint, id<MTLHeap>>                             _current_heap;
    std::pair<MTLuint, id<MTLCommandBuffer>>                    _current_cmdbuf;
    std::pair<MTLuint, id<MTLComputeCommandEncoder>>            _current_cmdencoder;
    std::pair<MTLuint, id<MTLTexture>>                          _current_texture;
    std::pair<MTLuint, id<MTLBuffer>>                           _current_buffer;
    std::pair<MTLuint, MTLFunctionConstantValues *>             _current_funcconstvals;
    std::pair<MTLuint, id<MTLFunction>>                         _current_computefunction;
    
public:
    MTLResources() {
        _devs.clear();
        _libs.clear();
        _queues.clear();
        _fences.clear();
        _heaps.clear();
        _cmdbufs.clear();
        _cmdencoders.clear();
        _textures.clear();
        _buffers.clear();
        _funcconstvalses.clear();
        _computefunctions.clear();
        _computepipelinestates.clear();
        //
        _current_dev = std::make_pair(MTLuint(0), nil);
        _current_lib = std::make_pair(MTLuint(0), nil);
        _current_queue = std::make_pair(MTLuint(0), nil);
        _current_fence = std::make_pair(MTLuint(0), nil);
        _current_heap = std::make_pair(MTLuint(0), nil);
        _current_cmdbuf = std::make_pair(MTLuint(0), nil);
        _current_cmdencoder = std::make_pair(MTLuint(0), nil);
        _current_texture = std::make_pair(MTLuint(0), nil);
        _current_buffer = std::make_pair(MTLuint(0), nil);
        _current_funcconstvals = std::make_pair(MTLuint(0), nil);
        _current_computefunction = std::make_pair(MTLuint(0), nil);
    }
};

API_AVAILABLE(ios(10.0))
static MTLResources s_metalresources;

#pragma mark MTLDevice

MTLvoid mtlGenDevice(MTLuint *__device) {
    if (@available(iOS 10.0, *)) {
        if (getGPUAvaliableFlag()) {
            id<MTLDevice> dev = MTLCreateSystemDefaultDevice();
            if (dev) {
                for (auto it = s_metalresources._devs.begin(); it != s_metalresources._devs.end(); it++) {
                    if(it->second == nil) {
                        *__device = it->first;
                        it->second = dev;
                        return;
                    }
                }
                *__device = MTLuint(s_metalresources._devs.size() + 1);
                s_metalresources._devs.insert(std::make_pair(*__device, dev));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlBindDevice(MTLuint __device) {
    assert(__device);
    if (@available(iOS 10.0, *)) {
        for (auto it = s_metalresources._devs.begin(); it != s_metalresources._devs.end(); it++) {
            if(it->first == __device) {
                s_metalresources._current_dev = std::make_pair(it->first, it->second);
                return;
            }
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetCurrentDevice(MTLuint __device) {
    mtlBindDevice(__device);
}

MTLvoid mtlDelDevice(MTLuint *__device) {
    assert(*__device);
    if (@available(iOS 10.0, *)) {
        for (auto it = s_metalresources._devs.begin(); it != s_metalresources._devs.end(); it++) {
            if(it->first == *__device) {
                it->second = nil;
                *__device = 0;
                if (s_metalresources._current_dev.second == it->second) {
                    s_metalresources._current_dev = std::make_pair(0, nil);
                }
                return;
            }
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

#pragma mark MTLCommandQueue

MTLvoid mtlGenQueueFromCurrentDevice(MTLuint __maxbuffer, MTLuint *__queue) {
    *__queue = 0;
    if (@available(iOS 10.0, *)) {
        id<MTLCommandQueue> queue = __maxbuffer? [s_metalresources._current_dev.second newCommandQueueWithMaxCommandBufferCount:__maxbuffer] : [s_metalresources._current_dev.second newCommandQueue];
        if (queue) {
            for (auto it = s_metalresources._queues.begin(); it != s_metalresources._queues.end(); it++) {
                if(it->second == nil) {
                    *__queue = it->first;
                    it->second = queue;
                    return;
                }
            }
            *__queue = MTLuint(s_metalresources._queues.size() + 1);
            s_metalresources._queues.insert(std::make_pair(*__queue, queue));
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlBindQueue(MTLuint __queue) {
    assert(__queue);
    if (@available(iOS 10.0, *)) {
        for (auto it = s_metalresources._queues.begin(); it != s_metalresources._queues.end(); it++) {
            if (it->first == __queue) {
                s_metalresources._current_queue = std::make_pair(it->first, it->second);
                return;
            }
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetCurrentQueue(MTLuint __queue) {
    mtlBindQueue(__queue);
}

MTLvoid mtlDelQueue(MTLuint *__queue) {
    assert(*__queue);
    if (@available(iOS 10.0, *)) {
        for (auto it = s_metalresources._queues.begin(); it != s_metalresources._queues.end(); it++) {
            if (it->first == *__queue) {
                it->second = nil;
                *__queue = 0;
                if (s_metalresources._current_queue.second == it->second) {
                    s_metalresources._current_queue = std::make_pair(0, nil);
                }
                return;
            }
        }
    }
    else {
        assert(0);
    }
    assert(0);
}


#pragma mark MTLLibrary

MTLvoid mtlGenLibraryFromCurrentDevice(MTLuint *__library) {
    *__library = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_dev.second) {
            id<MTLLibrary> lib = [s_metalresources._current_dev.second newDefaultLibrary];
            if (lib) {
                for (auto it = s_metalresources._libs.begin(); it != s_metalresources._libs.end(); it++) {
                    if (it->second == nil) {
                        *__library = it->first;
                        it->second = lib;
                        return;
                    }
                }
                *__library = MTLuint(s_metalresources._libs.size() + 1);
                s_metalresources._libs.insert(std::make_pair(*__library, lib));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenLibraryFromCurrentDeviceWithSource(const MTLchar *__shaders, MTLuint *__library) {
    *__library = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_dev.second) {
            NSError *error = nil;
            MTLCompileOptions *options = [[MTLCompileOptions alloc] init];
            [options setFastMathEnabled:YES];
            if (@available(iOS 12.0, *)) {
                [options setLanguageVersion:MTLLanguageVersion2_1];
            }
            else if (@available(iOS 11.0, *)) {
                [options setLanguageVersion:MTLLanguageVersion2_0];
            }
            else if (@available(iOS 10.0, *)) {
                [options setLanguageVersion:MTLLanguageVersion1_2];
            }
            else if (@available(iOS 9.0, *)) {
                [options setLanguageVersion:MTLLanguageVersion1_1];
            }
            else {
                assert(0);
            }
            id<MTLLibrary> lib = [s_metalresources._current_dev.second newLibraryWithSource:[NSString stringWithUTF8String:__shaders] options:options error:&error];
            if (lib && error == nil) {
                for (auto it = s_metalresources._libs.begin(); it != s_metalresources._libs.end(); it++) {
                    if (it->second == nil) {
                        *__library = it->first;
                        it->second = lib;
                        return;
                    }
                }
                *__library = MTLuint(s_metalresources._libs.size() + 1);
                s_metalresources._libs.insert(std::make_pair(*__library, lib));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenLibraryFromCurrentDeviceWithMetalLib(const MTLchar *__metallibpath, MTLuint *__library) {
    *__library = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_dev.second) {
            NSError *error = nil;
            id<MTLLibrary> lib = [s_metalresources._current_dev.second newLibraryWithFile:[NSString stringWithUTF8String:__metallibpath] error:&error];
            if (lib && error == nil) {
                for (auto it = s_metalresources._libs.begin(); it != s_metalresources._libs.end(); it++) {
                    if (it->second == nil) {
                        *__library = it->first;
                        it->second = lib;
                        return;
                    }
                }
                *__library = MTLuint(s_metalresources._libs.size() + 1);
                s_metalresources._libs.insert(std::make_pair(*__library, lib));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenLibraryFromCurrentDeviceWithMetalLibURL(const MTLchar *__metalliburl, MTLuint *__library) { // API_AVAILABLE(macos(10.13), ios(11.0));
    *__library = 0;
    if (@available(iOS 11.0, *)) {
        if (s_metalresources._current_dev.second) {
            NSError *error = nil;
            id<MTLLibrary> lib = [s_metalresources._current_dev.second newLibraryWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:__metalliburl]] error:&error];
            if (lib && error == nil) {
                for (auto it = s_metalresources._libs.begin(); it != s_metalresources._libs.end(); it++) {
                    if (it->second == nil) {
                        *__library = it->first;
                        it->second = lib;
                        return;
                    }
                }
                *__library = MTLuint(s_metalresources._libs.size() + 1);
                s_metalresources._libs.insert(std::make_pair(*__library, lib));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlBindLibrary(MTLuint __library) {
    assert(__library);
    if (@available(iOS 10.0, *)) {
        for (auto it = s_metalresources._libs.begin(); it != s_metalresources._libs.end(); it++) {
            if (it->first == __library) {
                s_metalresources._current_lib = std::make_pair(it->first, it->second);
                return;
            }
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetCurrentLibrary(MTLuint __library) {
    mtlBindLibrary(__library);
}

MTLvoid mtlDelLibrary(MTLuint *__library) {
    assert(*__library);
    if (@available(iOS 10.0, *)) {
        for (auto it = s_metalresources._libs.begin(); it != s_metalresources._libs.end(); it++) {
            if (it->first == *__library) {
                it->second = nil;
                *__library = 0;
                if (s_metalresources._current_lib.second == it->second) {
                    s_metalresources._current_lib = std::make_pair(0, nil);
                }
                return;
            }
        }
    }
    else {
        assert(0);
    }
    assert(0);
}


#pragma mark MTLFence

MTLvoid mtlGenFenceFromCurrentDevice(MTLuint *__fence) {
    *__fence = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_dev.second) {
            id<MTLFence> fence = [s_metalresources._current_dev.second newFence];
            if (fence) {
                for (auto it = s_metalresources._fences.begin(); it != s_metalresources._fences.end(); it++) {
                    if (it->second == nil) {
                        *__fence = it->first;
                        it->second = fence;
                        return;
                    }
                }
                *__fence = MTLuint(s_metalresources._fences.size() + 1);
                s_metalresources._fences.insert(std::make_pair(*__fence, fence));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(*__fence);
}

MTLvoid mtlBindFence(MTLuint __fence) {
    assert(__fence);
    if (@available(iOS 10.0, *)) {
        for (auto it = s_metalresources._fences.begin(); it != s_metalresources._fences.end(); it++) {
            if (it->first == __fence) {
                s_metalresources._current_fence = std::make_pair(it->first, it->second);
                return;
            }
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetCurrentFence(MTLuint __fence) {
    mtlBindFence(__fence);
}

MTLvoid mtlEncoderUpdateFence(MTLvoid) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_fence.second) {
            if (s_metalresources._current_cmdencoder.second) {
                [s_metalresources._current_cmdencoder.second updateFence:s_metalresources._current_fence.second];
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlDelFence(MTLuint *__fence) {
    assert(__fence);
    if (@available(iOS 10.0, *)) {
        for (auto it = s_metalresources._fences.begin(); it != s_metalresources._fences.end(); it++) {
            if (it->first == *__fence) {
                it->second = nil;
                *__fence = 0;
                if (s_metalresources._current_fence.second == it->second) {
                    s_metalresources._current_fence = std::make_pair(0, nil);
                }
                return;
            }
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

#pragma mark MTLHeap

MTLvoid mtlGenHeapFromCurrentDevice(MTLenum __storagemode, MTLenum __cpucachemode, MTLsizeu __size, MTLuint *__heap) {
    *__heap = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_dev.second) {
            MTLHeapDescriptor *heapDescriptor = [MTLHeapDescriptor new];
            heapDescriptor.cpuCacheMode = MTLCPUCacheMode(__cpucachemode);
            heapDescriptor.storageMode = MTLStorageMode(__storagemode);
            heapDescriptor.size = __size;
            id<MTLHeap> heap = [s_metalresources._current_dev.second newHeapWithDescriptor:heapDescriptor];
            if (heap) {
                for (auto it = s_metalresources._heaps.begin(); it != s_metalresources._heaps.end(); it++) {
                    if (it->second == nil) {
                        *__heap = it->first;
                        it->second = heap;
                        return;
                    }
                }
                *__heap = MTLuint(s_metalresources._heaps.size() + 1);
                s_metalresources._heaps.insert(std::make_pair(*__heap, heap));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlBindHeap(MTLuint __heap) {
    assert(__heap);
    if (@available(iOS 10.0, *)) {
        for (auto it = s_metalresources._heaps.begin(); it != s_metalresources._heaps.end(); it++) {
            if (it->first == __heap) {
                s_metalresources._current_heap = std::make_pair(it->first, it->second);
                return;
            }
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetCurrentHeap(MTLuint __heap) {
    mtlBindHeap(__heap);
}

MTLvoid mtlDelHeap(MTLuint *__heap) {
    assert(*__heap);
    if (@available(iOS 10.0, *)) {
        for (auto it = s_metalresources._heaps.begin(); it != s_metalresources._heaps.end(); it++) {
            if (it->first == *__heap) {
                it->second = nil;
                *__heap = 0;
                if (s_metalresources._current_heap.second == it->second) {
                    s_metalresources._current_heap = std::make_pair(0, nil);
                }
                return;
            }
        }
    }
    else {
        assert(0);
    }
    assert(0);
}


#pragma mark MTLTexture

MTLvoid mtlGenTextureFromCurrentDevice(MTLenum __target, MTLenum __format, MTLenum __usage, MTLsizei __width, MTLsizei __height, MTLsizei __depth, MTLsizei __level, MTLsizei __arraylength, MTLuint *__texture) {
    mtlGenTextureFromCurrentDeviceWithModes(MTL_STORAGEMODE_SHARED, MTL_CPUCACHEMODE_DEFAULT, __target, __format, __usage, __width, __height, __depth, __level, __arraylength, __texture);
}

MTL_API MTLvoid mtlGenTextureFromCurrentDeviceWithModes(MTLenum __storagemode, MTLenum __cpucachemode, MTLenum __target, MTLenum __format, MTLenum __usage, MTLsizei __width, MTLsizei __height, MTLsizei __depth, MTLsizei __level, MTLsizei __arraylength, MTLuint *__texture) {
    *__texture = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_dev.second) {
            MTLTextureDescriptor *descriptor = [[MTLTextureDescriptor alloc] init];
            [descriptor setStorageMode:(MTLStorageMode)__storagemode];
            [descriptor setCpuCacheMode:(MTLCPUCacheMode)__cpucachemode];
            [descriptor setTextureType:(MTLTextureType)(__target)];
            [descriptor setPixelFormat:(MTLPixelFormat)(__format)];
            [descriptor setUsage:(MTLTextureUsage)(__usage)];
            [descriptor setWidth:(NSUInteger)(__width)];
            [descriptor setHeight:(NSUInteger)(__height)];
            [descriptor setDepth:(NSUInteger)(__depth)];
            [descriptor setMipmapLevelCount:(NSUInteger)(__level)];
            [descriptor setArrayLength:(NSUInteger)(__arraylength)];
            id<MTLTexture> tex = [s_metalresources._current_dev.second newTextureWithDescriptor:descriptor];
            if (tex) {
                for (auto it = s_metalresources._textures.begin(); it != s_metalresources._textures.end(); it++) {
                    if (it->second == nil) {
                        it->second = tex;
                        *__texture = it->first;
                        return;
                    }
                }
                *__texture = MTLuint(s_metalresources._textures.size() + 1);
                s_metalresources._textures.insert(std::make_pair(*__texture, tex));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenTextureFromCurrentHeap(MTLenum __target, MTLenum __format, MTLenum __usage, MTLsizei __width, MTLsizei __height, MTLsizei __depth, MTLsizei __level, MTLsizei __arraylength, MTLuint *__texture) {
    *__texture = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_heap.second) {
            MTLTextureDescriptor *descriptor = [[MTLTextureDescriptor alloc] init];
            [descriptor setStorageMode:(MTLStorageMode)s_metalresources._current_heap.second.storageMode];
            [descriptor setCpuCacheMode:(MTLCPUCacheMode)MTLCPUCacheModeWriteCombined];
            [descriptor setTextureType:(MTLTextureType)(__target)];
            [descriptor setPixelFormat:(MTLPixelFormat)(__format)];
            [descriptor setUsage:(MTLTextureUsage)(__usage)];
            [descriptor setWidth:(NSUInteger)(__width)];
            [descriptor setHeight:(NSUInteger)(__height)];
            [descriptor setDepth:(NSUInteger)(__depth)];
            [descriptor setMipmapLevelCount:(NSUInteger)(__level)];
            [descriptor setArrayLength:(NSUInteger)(__arraylength)];
            id<MTLTexture> tex = [s_metalresources._current_heap.second newTextureWithDescriptor:descriptor];
            if (tex) {
                for (auto it = s_metalresources._textures.begin(); it != s_metalresources._textures.end(); it++) {
                    if (it->second == nil) {
                        it->second = tex;
                        *__texture = it->first;
                        return;
                    }
                }
                *__texture = MTLuint(s_metalresources._textures.size() + 1);
                s_metalresources._textures.insert(std::make_pair(*__texture, tex));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlBindTexture(MTLuint __texture) {
    assert(__texture);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._textures.find(__texture);
        if (it != s_metalresources._textures.end()) {
            s_metalresources._current_texture = std::make_pair(it->first, it->second);
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetCurrentTexture(MTLuint __texture) {
    mtlBindTexture(__texture);
}

MTL_API MTLvoid mtlMakeTextureAliasable(MTLuint __texture) {
    assert(__texture);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._textures.find(__texture);
        if (it != s_metalresources._textures.end()) {
            [it->second makeAliasable];
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlMakeCurrentTextureAliasable(MTLvoid) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_texture.second) {
            [s_metalresources._current_texture.second makeAliasable];
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlDelTexture(MTLuint *__texture) {
    assert(*__texture);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._textures.find(*__texture);
        if (it != s_metalresources._textures.end()) {
            if (it->first == *__texture) {
                it->second = nil;
                *__texture = 0;
                if (s_metalresources._current_texture.second == it->second) {
                    s_metalresources._current_texture = std::make_pair(0, nil);
                }
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlGetBytesFromTexture(MTLuint __texture, MTLsizeu __slice, MTLsizeu __bytesperrow, MTLTexRegion __region, MTLvoid *__bytes) {
    assert(__texture);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._textures.find(__texture);
        if (it != s_metalresources._textures.end()) {
            if (it->first == __texture && it->second != nil) {
                [it->second getBytes:__bytes
                         bytesPerRow:__bytesperrow
                       bytesPerImage:0
                          fromRegion:MTLRegionMake3D(__region.origin.x, __region.origin.y, __region.origin.z, __region.size.x, __region.size.y, __region.size.z)
                         mipmapLevel:0
                               slice:__slice];
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlSetBytesToTexture(MTLuint __texture, MTLsizeu __slice, MTLsizeu __bytesperrow, MTLTexRegion __region, MTLvoid *__bytes) {
    assert(__texture);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._textures.find(__texture);
        if (it != s_metalresources._textures.end()) {
            if (it->first == __texture && it->second != nil) {
                [it->second replaceRegion:MTLRegionMake3D(__region.origin.x, __region.origin.y, __region.origin.z, __region.size.x, __region.size.y, __region.size.z)
                              mipmapLevel:0
                                    slice:__slice
                                withBytes:__bytes
                              bytesPerRow:__bytesperrow
                            bytesPerImage:0];
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

#pragma mark MTLBuffer

MTLvoid mtlGenBufferFromCurrentDevice(MTLenum __option, MTLsizeu __size, MTLuint *__buffer) {
    *__buffer = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_dev.second) {
            id<MTLBuffer> buff = [s_metalresources._current_dev.second newBufferWithLength:(NSUInteger)__size options:(MTLResourceOptions)__option];
            if (buff) {
                for (auto it = s_metalresources._buffers.begin(); it != s_metalresources._buffers.end(); it++) {
                    if (it->second == nil) {
                        it->second = buff;
                        *__buffer = it->first;
                        return;
                    }
                }
                *__buffer = MTLuint(s_metalresources._buffers.size() + 1);
                s_metalresources._buffers.insert(std::make_pair(*__buffer, buff));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenBufferFromCurrentHeap(MTLenum __option, MTLsizeu __size, MTLuint *__buffer) {
    *__buffer = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_heap.second) {
            id<MTLBuffer> buff = [s_metalresources._current_heap.second newBufferWithLength:(NSUInteger)__size options:(MTLResourceOptions)__option];
            if (buff) {
                for (auto it = s_metalresources._buffers.begin(); it != s_metalresources._buffers.end(); it++) {
                    if (it->second == nil) {
                        it->second = buff;
                        *__buffer = it->first;
                        return;
                    }
                }
                *__buffer = MTLuint(s_metalresources._buffers.size() + 1);
                s_metalresources._buffers.insert(std::make_pair(*__buffer, buff));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenBufferFromCurrentDeviceWithData(MTLenum __option, MTLsizeu __size, MTLvoid *__data, MTLuint *__buffer) {
    *__buffer = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_dev.second) {
            id<MTLBuffer> buff = [s_metalresources._current_dev.second newBufferWithBytes:__data length:(NSUInteger)__size options:(MTLResourceOptions)__option];
            if (buff) {
                for (auto it = s_metalresources._buffers.begin(); it != s_metalresources._buffers.end(); it++) {
                    if (it->second == nil) {
                        it->second = buff;
                        *__buffer = it->first;
                        return;
                    }
                }
                *__buffer = MTLuint(s_metalresources._buffers.size() + 1);
                s_metalresources._buffers.insert(std::make_pair(*__buffer, buff));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenBufferFromCurrentDeviceWithDataNoCopy(MTLenum __option, MTLsizeu __size, MTLvoid *__data, MTLuint *__buffer) {
    *__buffer = 0;
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_dev.second) {
            id<MTLBuffer> buff = [s_metalresources._current_dev.second newBufferWithBytesNoCopy:__data
                                                                                         length:(NSUInteger)__size
                                                                                        options:(MTLResourceOptions)__option
                                                                                    deallocator:^(void * _Nonnull pointer, NSUInteger length) { /*do nothing*/}];
            if (buff) {
                for (auto it = s_metalresources._buffers.begin(); it != s_metalresources._buffers.end(); it++) {
                    if (it->second == nil) {
                        it->second = buff;
                        *__buffer = it->first;
                        return;
                    }
                }
                *__buffer = MTLuint(s_metalresources._buffers.size() + 1);
                s_metalresources._buffers.insert(std::make_pair(*__buffer, buff));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlBindBuffer(MTLuint __buffer) {
    assert(__buffer);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._buffers.find(__buffer);
        if (it != s_metalresources._buffers.end()) {
            if (it->second) {
                s_metalresources._current_buffer = std::make_pair(it->first, it->second);
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetCurrentBuffer(MTLuint __buffer) {
    mtlBindBuffer(__buffer);
}

MTL_API MTLvoid mtlGetBytesFromBuffer(MTLuint __buffer, MTLsizeu __size, MTLvoid *__bytes) {
    assert(__buffer);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._buffers.find(__buffer);
        if (it != s_metalresources._buffers.end()) {
            if (it->second) {
                memcpy(__bytes, it->second.contents, __size);
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlDelBuffer(MTLuint *__buffer) {
    assert(*__buffer);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._buffers.find(*__buffer);
        if (it != s_metalresources._buffers.end()) {
            it->second = nil;
            *__buffer = 0;
            if (s_metalresources._current_buffer.second == it->second) {
                s_metalresources._current_buffer = std::make_pair(0, nil);
            }
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

#pragma mark MTLFunctionConstantValues

MTLvoid mtlGenFunctionConstantValues(MTLuint *__constvals) {
    if (@available(iOS 10.0, *)) {
        MTLFunctionConstantValues *vals = [[MTLFunctionConstantValues alloc] init];
        if (vals) {
            for (auto it = s_metalresources._funcconstvalses.begin(); it != s_metalresources._funcconstvalses.end(); it++) {
                if (it->second == nil) {
                    it->second = vals;
                    *__constvals = it->first;
                    return;
                }
            }
            *__constvals = MTLuint(s_metalresources._funcconstvalses.size() + 1);
            s_metalresources._funcconstvalses.insert(std::make_pair(*__constvals, vals));
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetFunctionConstantValuesWithIndex(MTLuint __constvals, MTLvoid *__data, MTLenum __datatype, MTLidx __index) {
    assert(__data);
    assert(__constvals);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._funcconstvalses.find(__constvals);
        if (it != s_metalresources._funcconstvalses.end()) {
            [it->second setConstantValue:__data type:(MTLDataType)__datatype atIndex:(NSUInteger)__index];
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetFunctionConstantValuesWithName(MTLuint __constvals, MTLvoid *__data, MTLenum __datatype, const MTLchar * __name) {
    assert(__data);
    assert(__name);
    assert(__constvals);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._funcconstvalses.find(__constvals);
        if (it != s_metalresources._funcconstvalses.end()) {
            [it->second setConstantValue:__data type:(MTLDataType)__datatype withName:[NSString stringWithUTF8String:__name]];
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlBindFunctionConstantValues(MTLuint __constvals) {
    assert(__constvals);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._funcconstvalses.find(__constvals);
        if (it != s_metalresources._funcconstvalses.end()) {
            s_metalresources._current_funcconstvals = std::make_pair(it->first, it->second);
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetCurrentFunctionConstantValues(MTLuint __constvals) {
    mtlBindFunctionConstantValues(__constvals);
}

MTLvoid mtlSetCurrentFunctionConstantValuesWithIndex(MTLvoid *__data, MTLenum __datatype, MTLidx __index) {
    assert(__data);
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_funcconstvals.second) {
            [s_metalresources._current_funcconstvals.second setConstantValue:__data type:(MTLDataType)__datatype atIndex:(NSUInteger)__index];
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlSetCurrentFunctionConstantValuesWithName(MTLvoid *__data, MTLenum __datatype, const MTLchar * __name) {
    assert(__data);
    assert(__name);
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_funcconstvals.second) {
            [s_metalresources._current_funcconstvals.second setConstantValue:__data type:(MTLDataType)__datatype withName:[NSString stringWithUTF8String:__name]];
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlDelFunctionConstantValues(MTLuint *__constvals) {
    assert(*__constvals);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._funcconstvalses.find(*__constvals);
        if (it != s_metalresources._funcconstvalses.end()) {
            if (it->second != nil) {
                it->second = nil;
                *__constvals = 0;
                if (s_metalresources._current_funcconstvals.second == it->second) {
                    s_metalresources._current_funcconstvals = std::make_pair(0, nil);
                }
                return;
            }
            else {
                assert(0); // already deleted
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}


#pragma mark MTLFunction

MTLvoid mtlGenFunctionFromLibrary(const MTLchar * __name, MTLuint __library, MTLuint *__funtion) {
    assert(__name);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._libs.find(__library);
        if (it != s_metalresources._libs.end()) {
            id<MTLFunction> func = [it->second newFunctionWithName:[NSString stringWithUTF8String:__name]];
            if (func) {
                for (auto it = s_metalresources._computefunctions.begin(); it != s_metalresources._computefunctions.end(); it++) {
                    if (it->second == nil) {
                        it->second = func;
                        *__funtion = it->first;
                        return;
                    }
                }
                *__funtion = MTLuint(s_metalresources._computefunctions.size() + 1);
                s_metalresources._computefunctions.insert(std::make_pair(*__funtion, func));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenFunctionFromLibraryWithCurrentConstantValues(const MTLchar * __name, MTLuint __library, MTLuint *__funtion) {
    assert(__name);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._libs.find(__library);
        if (it != s_metalresources._libs.end()) {
            if (s_metalresources._current_funcconstvals.second) {
                NSError *error = nil;
                id<MTLFunction> func = [it->second newFunctionWithName:[NSString stringWithUTF8String:__name] constantValues:s_metalresources._current_funcconstvals.second error:&error];
                if (func && (error == nil)) {
                    for (auto it = s_metalresources._computefunctions.begin(); it != s_metalresources._computefunctions.end(); it++) {
                        if (it->second == nil) {
                            it->second = func;
                            *__funtion = it->first;
                            return;
                        }
                    }
                    *__funtion = MTLuint(s_metalresources._computefunctions.size() + 1);
                    s_metalresources._computefunctions.insert(std::make_pair(*__funtion, func));
                    return;
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenFunctionFromLibraryWithConstantValues(const MTLchar * __name, MTLuint __library, MTLuint __constvals, MTLuint *__funtion) {
    assert(__name);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._libs.find(__library);
        if (it != s_metalresources._libs.end()) {
            auto it_val = s_metalresources._funcconstvalses.find(__constvals);
            if (it_val != s_metalresources._funcconstvalses.end()) {
                if (it_val->second) {
                    NSError *error = nil;
                    id<MTLFunction> func = [it->second newFunctionWithName:[NSString stringWithUTF8String:__name] constantValues:it_val->second error:&error];
                    if (func && (error == nil)) {
                        for (auto it = s_metalresources._computefunctions.begin(); it != s_metalresources._computefunctions.end(); it++) {
                            if (it->second == nil) {
                                it->second = func;
                                *__funtion = it->first;
                                return;
                            }
                        }
                        *__funtion = MTLuint(s_metalresources._computefunctions.size() + 1);
                        s_metalresources._computefunctions.insert(std::make_pair(*__funtion, func));
                        return;
                    }
                    else {
                        assert(0);
                    }
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    
    assert(0);
}

MTLvoid mtlGenFunctionFromCurrentLibrary(const MTLchar * __name, MTLuint *__funtion) {
    assert(__name);
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_lib.second) {
            id<MTLFunction> func = [s_metalresources._current_lib.second newFunctionWithName:[NSString stringWithUTF8String:__name]];
            if (func) {
                for (auto it = s_metalresources._computefunctions.begin(); it != s_metalresources._computefunctions.end(); it++) {
                    if (it->second == nil) {
                        it->second = func;
                        *__funtion = it->first;
                        return;
                    }
                }
                *__funtion = MTLuint(s_metalresources._computefunctions.size() + 1);
                s_metalresources._computefunctions.insert(std::make_pair(*__funtion, func));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenFunctionFromCurrentLibraryWithCurrentConstantValues(const MTLchar * __name, MTLuint *__funtion) {
    assert(__name);
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_lib.second) {
            if (s_metalresources._current_funcconstvals.second) {
                NSError *error = nil;
                id<MTLFunction> func = [s_metalresources._current_lib.second newFunctionWithName:[NSString stringWithUTF8String:__name] constantValues:s_metalresources._current_funcconstvals.second error:&error];
                if (func && error == nil) {
                    for (auto it = s_metalresources._computefunctions.begin(); it != s_metalresources._computefunctions.end(); it++) {
                        if (it->second == nil) {
                            it->second = func;
                            *__funtion = it->first;
                            return;
                        }
                    }
                    *__funtion = MTLuint(s_metalresources._computefunctions.size() + 1);
                    s_metalresources._computefunctions.insert(std::make_pair(*__funtion, func));
                    return;
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlGenFunctionFromCurrentLibraryWithConstantValues(const MTLchar * __name, MTLuint __constvals, MTLuint *__funtion) {
    assert(__name);
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_lib.second) {
            auto it_val = s_metalresources._funcconstvalses.find(__constvals);
            if (it_val != s_metalresources._funcconstvalses.end()) {
                if (it_val->second) {
                    NSError *error = nil;
                    id<MTLFunction> func = [s_metalresources._current_lib.second newFunctionWithName:[NSString stringWithUTF8String:__name] constantValues:it_val->second error:&error];
                    if (func && error == nil) {
                        for (auto it = s_metalresources._computefunctions.begin(); it != s_metalresources._computefunctions.end(); it++) {
                            if (it->second == nil) {
                                it->second = func;
                                *__funtion = it->first;
                                return;
                            }
                        }
                        *__funtion = MTLuint(s_metalresources._computefunctions.size() + 1);
                        s_metalresources._computefunctions.insert(std::make_pair(*__funtion, func));
                        return;
                    }
                    else {
                        assert(0);
                    }
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlBindFunction(MTLuint __funtion) {
    assert(__funtion);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._computefunctions.find(__funtion);
        if (it != s_metalresources._computefunctions.end()) {
            if (it->second) {
                s_metalresources._current_computefunction = std::make_pair(it->first, it->second);
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    //
    assert(0);
}

MTLvoid mtlSetCurrentFunction(MTLuint __funtion) {
    mtlBindFunction(__funtion);
}

MTLvoid mtlDelFunction(MTLuint *__funtion) {
    assert(*__funtion);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._computefunctions.find(*__funtion);
        if (it != s_metalresources._computefunctions.end()) {
            if (it->second) {
                it->second = nil;
                if (s_metalresources._current_computefunction.second == it->second) {
                    s_metalresources._current_computefunction = std::make_pair(0, nil);
                }
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    //
    assert(0);
}

#pragma mark MTLComputePipelineState

MTLvoid mtlGenComputePipelineStateFromDeviceWithFunction(MTLuint __device, MTLuint __function, MTLuint *__pipelinestate) {
    if (@available(iOS 10.0, *)) {
        auto it_func = s_metalresources._computefunctions.find(__function);
        if (it_func != s_metalresources._computefunctions.end()) {
            if (it_func->second) {
                auto it_dev = s_metalresources._devs.find(__device);
                if (it_dev != s_metalresources._devs.end()) {
                    if (it_dev->second) {
                        NSError *error = nil;
                        id<MTLComputePipelineState> pipeline = [it_dev->second newComputePipelineStateWithFunction:it_func->second error:&error];
                        if (pipeline && error == nil) {
                            for (auto it = s_metalresources._computepipelinestates.begin(); it != s_metalresources._computepipelinestates.end(); it++) {
                                if (it->second == nil) {
                                    it->second = pipeline;
                                    *__pipelinestate = it->first;
                                    return;
                                }
                            }
                            *__pipelinestate = MTLuint(s_metalresources._computepipelinestates.size() + 1);
                            s_metalresources._computepipelinestates.insert(std::make_pair(*__pipelinestate, pipeline));
                            return;
                        }
                    }
                    else {
                        assert(0);
                    }
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    //
    assert(0);
}

MTLvoid mtlGenComputePipelineStateFromDeviceWithCurrentFunction(MTLuint __device, MTLuint *__pipelinestate) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_computefunction.second) {
            auto it_dev = s_metalresources._devs.find(__device);
            if (it_dev != s_metalresources._devs.end()) {
                if (it_dev->second) {
                    NSError *error = nil;
                    id<MTLComputePipelineState> pipeline = [it_dev->second newComputePipelineStateWithFunction:s_metalresources._current_computefunction.second error:&error];
                    if (pipeline && error == nil) {
                        for (auto it = s_metalresources._computepipelinestates.begin(); it != s_metalresources._computepipelinestates.end(); it++) {
                            if (it->second == nil) {
                                it->second = pipeline;
                                *__pipelinestate = it->first;
                                return;
                            }
                        }
                        *__pipelinestate = MTLuint(s_metalresources._computepipelinestates.size() + 1);
                        s_metalresources._computepipelinestates.insert(std::make_pair(*__pipelinestate, pipeline));
                        return;
                    }
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    //
    assert(0);
}

MTLvoid mtlGenComputePipelineStateFromCurrentDeviceWithFunction(MTLuint __function, MTLuint *__pipelinestate) {
    if (@available(iOS 10.0, *)) {
        auto it_func = s_metalresources._computefunctions.find(__function);
        if (it_func != s_metalresources._computefunctions.end()) {
            if (it_func->second) {
                if (s_metalresources._current_dev.second) {
                    NSError *error = nil;
                    id<MTLComputePipelineState> pipeline = [s_metalresources._current_dev.second newComputePipelineStateWithFunction:it_func->second error:&error];
                    if (pipeline && error == nil) {
                        for (auto it = s_metalresources._computepipelinestates.begin(); it != s_metalresources._computepipelinestates.end(); it++) {
                            if (it->second == nil) {
                                it->second = pipeline;
                                *__pipelinestate = it->first;
                                return;
                            }
                        }
                        *__pipelinestate = MTLuint(s_metalresources._computepipelinestates.size() + 1);
                        s_metalresources._computepipelinestates.insert(std::make_pair(*__pipelinestate, pipeline));
                        return;
                    }
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    //
    assert(0);
}

MTLvoid mtlGenComputePipelineStateFromCurrentDeviceWithCurrentFunction(MTLuint *__pipelinestate) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_computefunction.second) {
            if (s_metalresources._current_dev.second) {
                NSError *error = nil;
                id<MTLComputePipelineState> pipeline = [s_metalresources._current_dev.second newComputePipelineStateWithFunction:s_metalresources._current_computefunction.second error:&error];
                if (pipeline && error == nil) {
                    for (auto it = s_metalresources._computepipelinestates.begin(); it != s_metalresources._computepipelinestates.end(); it++) {
                        if (it->second == nil) {
                            it->second = pipeline;
                            *__pipelinestate = it->first;
                            return;
                        }
                    }
                    *__pipelinestate = MTLuint(s_metalresources._computepipelinestates.size() + 1);
                    s_metalresources._computepipelinestates.insert(std::make_pair(*__pipelinestate, pipeline));
                    return;
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    //
    assert(0);
}

MTL_API MTLvoid mtlGetMaxThreadsPerGroupFromComputePipelineState(MTLuint __pipelinestate, MTLsizeu *__maxthreadnum) {
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._computepipelinestates.find(__pipelinestate);
        if (it != s_metalresources._computepipelinestates.end()) {
            if (it->second) {
                *__maxthreadnum = MTLsizeu([it->second maxTotalThreadsPerThreadgroup]);
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlGetBestThreadWidthFromComputePipelineState(MTLuint __pipelinestate, MTLsizeu *__maxthreadwidth) {
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._computepipelinestates.find(__pipelinestate);
        if (it != s_metalresources._computepipelinestates.end()) {
            if (it->second) {
                *__maxthreadwidth = MTLsizeu([it->second threadExecutionWidth]);
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTLvoid mtlDelComputePipelineState(MTLuint *__pipelinestate) {
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._computepipelinestates.find(*__pipelinestate);
        if (it != s_metalresources._computepipelinestates.end()) {
            if (it->second) {
                it->second = nil;
                *__pipelinestate = 0;
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    //
    assert(0);
}

#pragma mark MTLCommandBuffer

MTL_API MTLvoid mtlGenCommandBufferFromCurrentQueue(MTLuint *__cmdbuf) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_queue.second) {
            id<MTLCommandBuffer> cmdbuf = [s_metalresources._current_queue.second commandBuffer];
            if (cmdbuf) {
                for (auto it = s_metalresources._cmdbufs.begin(); it != s_metalresources._cmdbufs.end(); it++) {
                    if (it->second == nil) {
                        it->second = cmdbuf;
                        *__cmdbuf = it->first;
                        return;
                    }
                }
                *__cmdbuf = MTLuint(s_metalresources._cmdbufs.size() + 1);
                s_metalresources._cmdbufs.insert(std::make_pair(*__cmdbuf, cmdbuf));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    //
    assert(0);
}

MTL_API MTLvoid mtlBindCommandBuffer(MTLuint __cmdbuf) {
    assert(__cmdbuf);
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._cmdbufs.find(__cmdbuf);
        if (it != s_metalresources._cmdbufs.end()) {
            if (it->second) {
                s_metalresources._current_cmdbuf = std::make_pair(it->first, it->second);
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlSetCurrentCommandBuffer(MTLuint __cmdbuf) {
    mtlBindCommandBuffer(__cmdbuf);
}

MTL_API MTLvoid mtlSetCompletedBlockToCurrentCommandBuffer(MTLCallBack __lamdablock, int argc, ...) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdbuf.second) {
            va_list ap;
            va_start(ap, argc);
            [s_metalresources._current_cmdbuf.second addCompletedHandler:^(id<MTLCommandBuffer> cb) { __lamdablock(argc, ap); }];
            va_end(ap);
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCommitCurrentCommandBuffer(MTLvoid) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdbuf.second) {
            [s_metalresources._current_cmdbuf.second commit];
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlWaitUntilCurrentCommandBufferScheduled(MTLvoid) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdbuf.second) {
            [s_metalresources._current_cmdbuf.second waitUntilScheduled];
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlWaitUntilCurrentCommandBufferComplete(MTLvoid) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdbuf.second) {
            [s_metalresources._current_cmdbuf.second waitUntilCompleted];
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlGetCurrentCommandBufferGPUTime(MTLfloat *__gputime) {
    if (@available(iOS 10.3, *)) {
        if (s_metalresources._current_cmdbuf.second) {
            *__gputime = MTLfloat(s_metalresources._current_cmdbuf.second.GPUEndTime - s_metalresources._current_cmdbuf.second.GPUStartTime);
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlDelCommandBuffer(MTLuint *__cmdbuf) {
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._cmdbufs.find(*__cmdbuf);
        if (it != s_metalresources._cmdbufs.end()) {
            if (it->second) {
                it->second = nil;
                *__cmdbuf = 0;
                if (s_metalresources._current_cmdbuf.second == it->second) {
                    s_metalresources._current_cmdbuf = std::make_pair(0, nil);
                }
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}


#pragma mark MTLComputeCommandEncoder
// for MTLComputeCommandEncoder
MTL_API MTLvoid mtlGenEncoderFromCommandBuffer(MTLuint __cmdbuf, MTLuint *__encoder) {
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._cmdbufs.find(__cmdbuf);
        if (it != s_metalresources._cmdbufs.end()) {
            if (it->second) {
                id<MTLComputeCommandEncoder> cencoder = [it->second computeCommandEncoder];
                if (cencoder) {
                    for (auto it = s_metalresources._cmdencoders.begin(); it != s_metalresources._cmdencoders.end(); it++) {
                        if (it->second == nil) {
                            *__encoder = it->first;
                            it->second = cencoder;
                            return;
                        }
                    }
                    *__encoder = MTLuint(s_metalresources._cmdencoders.size() + 1);
                    s_metalresources._cmdencoders.insert(std::make_pair(*__encoder, cencoder));
                    return;
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlGenEncoderFromCurrentCommandBuffer(MTLuint *__encoder) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdbuf.second) {
            id<MTLComputeCommandEncoder> cencoder = [s_metalresources._current_cmdbuf.second computeCommandEncoder];
            if (cencoder) {
                for (auto it = s_metalresources._cmdencoders.begin(); it != s_metalresources._cmdencoders.end(); it++) {
                    if (it->second == nil) {
                        *__encoder = it->first;
                        it->second = cencoder;
                        return;
                    }
                }
                *__encoder = MTLuint(s_metalresources._cmdencoders.size() + 1);
                s_metalresources._cmdencoders.insert(std::make_pair(*__encoder, cencoder));
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlBindEncoder(MTLuint __encoder) {
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._cmdencoders.find(__encoder);
        if (it != s_metalresources._cmdencoders.end()) {
            if (it->second) {
                s_metalresources._current_cmdencoder = std::make_pair(it->first, it->second);
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlSetCurrentEncoder(MTLuint __encoder) {
    mtlBindEncoder(__encoder);
}

MTL_API MTLvoid mtlDelEncoder(MTLuint *__encoder) {
    if (@available(iOS 10.0, *)) {
        auto it = s_metalresources._cmdencoders.find(*__encoder);
        if (it != s_metalresources._cmdencoders.end()) {
            if (it->second) {
                it->second = nil;
                *__encoder = 0;
                if (s_metalresources._current_cmdencoder.second == it->second) {
                    s_metalresources._current_cmdencoder = std::make_pair(0, nil);
                }
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

// encode one pass temporarily ...
MTL_API MTLvoid mtlGenCurrentEncoderFromCurrentCommandBuffer(MTLvoid) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdbuf.second) {
            id<MTLComputeCommandEncoder> cencoder = [s_metalresources._current_cmdbuf.second computeCommandEncoder];
            if (cencoder) {
                s_metalresources._current_cmdencoder = std::make_pair(0, cencoder);
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCurrentEncoderSetPipelineState(MTLuint __pipelinestate) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdencoder.second) {
            auto it_pipeline = s_metalresources._computepipelinestates.find(__pipelinestate);
            if(it_pipeline != s_metalresources._computepipelinestates.end()) {
                if (it_pipeline->second) {
                    [s_metalresources._current_cmdencoder.second setComputePipelineState:it_pipeline->second];
                    return;
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCurrentEncoderSetBytes(MTLvoid *__bytes, MTLuint __length, MTLidx __index) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdencoder.second) {
            if (__bytes) {
                [s_metalresources._current_cmdencoder.second setBytes:__bytes length:__length atIndex:__index];
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCurrentEncoderSetBuffer(MTLuint __buffer, MTLidx __offset, MTLidx __index) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdencoder.second) {
            auto it_buf = s_metalresources._buffers.find(__buffer);
            if (it_buf != s_metalresources._buffers.end()) {
                if(it_buf->second) {
                    [s_metalresources._current_cmdencoder.second setBuffer:it_buf->second
                                                                    offset:__offset
                                                                   atIndex:__index];
                    return;
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCurrentEncoderSetTexture(MTLuint __texture, MTLidx __index) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdencoder.second) {
            auto it_tex = s_metalresources._textures.find(__texture);
            if (it_tex != s_metalresources._textures.end()) {
                if (it_tex->second) {
                    [s_metalresources._current_cmdencoder.second setTexture:it_tex->second atIndex:__index];
                    return;
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCurrentEncoderSetDispatchSize(
                                                 MTLsizeu __threadgroupspergridx,
                                                 MTLsizeu __threadgroupspergridy,
                                                 MTLsizeu __threadgroupspergridz,
                                                 MTLsizeu __threadsperthreadsgroupx,
                                                 MTLsizeu __threadsperthreadsgroupy,
                                                 MTLsizeu __threadsperthreadsgroupz
                                                 ) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdencoder.second) {
            [s_metalresources._current_cmdencoder.second dispatchThreadgroups:MTLSizeMake(__threadgroupspergridx, __threadgroupspergridy, __threadgroupspergridz)
                                                        threadsPerThreadgroup:MTLSizeMake(__threadsperthreadsgroupx, __threadsperthreadsgroupy, __threadsperthreadsgroupz)];
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCurrentEncoderSetDispatchSize3(MTLsizeu3 __threadgroupspergrid, MTLsizeu3 __threadsperthreadgroup) {
    mtlCurrentEncoderSetDispatchSize(__threadgroupspergrid.x, __threadgroupspergrid.y, __threadgroupspergrid.z,
                                     __threadsperthreadgroup.x, __threadsperthreadgroup.y, __threadsperthreadgroup.z);
}

MTL_API MTLvoid mtlCurrentEncoderWaitForCurrentFence(MTLvoid) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdencoder.second) {
            if (s_metalresources._current_fence.second) {
                [s_metalresources._current_cmdencoder.second waitForFence:s_metalresources._current_fence.second];
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCurrentEncoderWaitForFence(MTLuint __fence) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdencoder.second) {
            auto it_fence = s_metalresources._fences.find(__fence);
            if (it_fence != s_metalresources._fences.end()) {
                if (it_fence->second) {
                    [s_metalresources._current_cmdencoder.second waitForFence:it_fence->second];
                    return;
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCurrentEncoderUpdateCurrentFence(MTLvoid) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdencoder.second) {
            if (s_metalresources._current_fence.second) {
                [s_metalresources._current_cmdencoder.second updateFence:s_metalresources._current_fence.second];
                return;
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCurrentEncoderUpdateFence(MTLuint __fence) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdencoder.second) {
            auto it_fence = s_metalresources._fences.find(__fence);
            if (it_fence != s_metalresources._fences.end()) {
                if (it_fence->second) {
                    [s_metalresources._current_cmdencoder.second updateFence:it_fence->second];
                    return;
                }
                else {
                    assert(0);
                }
            }
            else {
                assert(0);
            }
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}

MTL_API MTLvoid mtlCurrentEncoderSetEndCoding(MTLvoid) {
    if (@available(iOS 10.0, *)) {
        if (s_metalresources._current_cmdencoder.second) {
            [s_metalresources._current_cmdencoder.second endEncoding];
            s_metalresources._current_cmdencoder = std::make_pair(0, nil);
            return;
        }
        else {
            assert(0);
        }
    }
    else {
        assert(0);
    }
    assert(0);
}
