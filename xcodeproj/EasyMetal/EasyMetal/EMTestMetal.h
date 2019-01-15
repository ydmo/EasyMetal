//
//  EMTestMetal.h
//  EMTests
//
//  Created by yyuser on 2019/1/10.
//  Copyright © 2019年 YudaMo.cn@gmail.com. All rights reserved.
//

#ifndef EMTestMetal_h
#define EMTestMetal_h

#include <vector>
#include <stdio.h>
#include <assert.h>
#include <stdarg.h>

#include <EM/easymetal.h>
#include <EM/ieee_half.h>

class TestMetal
{
public:
    MTLuint _dev;
    MTLuint _lib;
    MTLuint _queue;
    MTLuint _cmdbuf;
    std::vector<MTLuint> _buffers;
    std::vector<MTLuint> _textures;
    TestMetal() { };
    ~TestMetal() { };
    virtual void test(void) = 0;
};

class TestMetalA : public TestMetal {
public:
    TestMetalA();
    ~TestMetalA();
    void test(void);

public:
    MTLsizeu _fm_n;// = 32;
    MTLsizeu _fm_c;// = 8;
    MTLsizeu _fm_w;// = 128;
    MTLsizeu _fm_h;// = 128;
    MTLuint _pipeline;
    MTLsizeu _threadgroupspergridx;
    MTLsizeu _threadgroupspergridy;
    MTLsizeu _threadgroupspergridz;
    MTLsizeu _threadsperthreadsgroupx;
    MTLsizeu _threadsperthreadsgroupy;
    MTLsizeu _threadsperthreadsgroupz;
};

class TestMetalB : public TestMetal {
public:
    TestMetalB();
    ~TestMetalB();
    void test(void);
    
public:
    MTLuint _heap;
    MTLsizeu _fm_c;
    MTLsizeu _fm_w;
    MTLsizeu _fm_h;
    
    MTLuint _pipeline0;
    MTLsizeu3 _threadgrouppergrid0;
    MTLsizeu3 _threadsperthreadgroup0;
    
    MTLuint _pipeline1;
    MTLsizeu3 _threadgrouppergrid1;
    MTLsizeu3 _threadsperthreadgroup1;
};

class TestMetalC : public TestMetal {
public:
    TestMetalC();
    ~TestMetalC();
    void test(void);
};

#endif /* EMTestMetal_h */
