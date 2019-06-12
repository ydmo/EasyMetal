//
//  easymetal_extern.h
//  EasyMetal
//
//  Created by Yuda Mo on 2019/6/11.
//  Copyright © 2019 YudaMo.cn@gmail.com. All rights reserved.
//

#ifndef easymetal_extern_h
#define easymetal_extern_h

// easymetal ...
#include "easymetal.h"

// system ...
#include "TargetConditionals.h"
#if !(TARGET_OS_SIMULATOR)
#define MTL_AVALIABLE 1
#endif

#if MTL_AVALIABLE

// metal ...
#include <Metal/Metal.h>

MTL_API id<MTLDevice> mtlGetidDevice(MTLuint __device);
MTL_API id<MTLLibrary> mtlGetidLibrary(MTLuint __library);
MTL_API id<MTLCommandBuffer> mtlGetidCommandBuffer(MTLuint __cmdbuf);
MTL_API id<MTLComputeCommandEncoder> mtlGetidComputeCommandEncoder(MTLuint __encoder);
MTL_API id<MTLTexture> mtlGetidTexture(MTLuint __texture);
MTL_API id<MTLBuffer> mtlGetidBuffer(MTLuint __buffer);

#endif // MTL_AVALIABLE

#endif /* easymetal_extern_h */
