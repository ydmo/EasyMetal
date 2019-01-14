//
//  EMTestMTLBuffer.m
//  EMTests
//
//  Created by yyuser on 2019/1/9.
//  Copyright © 2019年 YudaMo.cn@gmail.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EMTestMetal.h"
@interface EMTestUnits : XCTestCase
@property (nonatomic, assign) TestMetalA *ta;
@end

@implementation EMTestUnits

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _ta = new TestMetalA();
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    delete _ta;
}

- (void)testExampleA {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    _ta->test();
}

@end
