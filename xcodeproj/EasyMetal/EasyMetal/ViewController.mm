//
//  ViewController.m
//  EasyMetal
//
//  Created by yyuser on 2019/1/9.
//  Copyright © 2019年 YudaMo.cn@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "EMTestMetal.h"
@interface ViewController ()
@property (nonatomic, assign) TestMetalA *ta;
@property (nonatomic, assign) TestMetalB *tb;
@property (nonatomic, assign) TestMetalC *tc;
@end

@implementation ViewController

- (void)dealloc {
    delete _ta;
    delete _tb;
    delete _tc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _ta = new TestMetalA();
    _ta->test();
    _tb = new TestMetalB();
    _tb->test();
    _tc = new TestMetalC();
    double tic = CACurrentMediaTime();
    _tc->test();
    double toc = CACurrentMediaTime();
    printf("TestMetalC cost cpu time %f ms\n", 1000 * (toc - tic));
    printf("Done.\n");
}

//- (void)test0 {
//    MTLuint hd_device = 0;
//    MTLuint hd_queue = 0;
//    MTLuint hd_buf0 = 0;
//    MTLuint hd_buf1 = 0;
//    MTLuint hd_tex = 0; // 128 x 128 x 8
//    MTLuint hd_cmdbuf = 0;
//
//    mtlGenDevice(&hd_device);
//    mtlSetCurrentDevice(hd_device);
//    mtlGenQueueFromCurrentDevice(0, &hd_queue);
//    mtlSetCurrentQueue(hd_queue);
//
//    const size_t fm_n = 1;
//    const size_t fm_w = 128;
//    const size_t fm_h = 128;
//    const size_t fm_c = 8;
//
//    void *p = NULL;
//    size_t size_aligned = (((fm_n * fm_w * fm_h * fm_c * sizeof(half) + 4095) >> 12) << 12);
//    posix_memalign(&p, 4096, size_aligned);
//    half *pf = (half *)p;
//
//    for (size_t n = 0; n < fm_n; n++) {
//        for (size_t c = 0; c < fm_c; c++) {
//            for (size_t h = 0; h < fm_h; h++) {
//                for (size_t w = 0; w < fm_w; w++) {
//                    pf[n * fm_c * fm_h * fm_w + c * fm_h * fm_w + h * fm_w + w] = n + c + h + w;
//                }
//            }
//        }
//    }
//
//    mtlGenBufferFromCurrentDeviceWithDataNoCopy(MTL_RESOURCE_OPTION_STORAGEMODE_SHARED, fm_n * fm_w * fm_h * fm_c * sizeof(half), p, &hd_buf0);
//    mtlGenBufferFromCurrentDevice(MTL_RESOURCE_OPTION_STORAGEMODE_SHARED, fm_n * fm_w * fm_h * fm_c * sizeof(half), &hd_buf1);
//
//    mtlGenCommandBufferFromCurrentQueue(&hd_cmdbuf);
//    mtlSetCurrentCommandBuffer(hd_cmdbuf);
//
//
//
//    mtlSetCurrentDevice(0);
//}


@end
