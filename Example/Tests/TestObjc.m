//
//  TestObjc.m
//  RHBKit_Tests
//
//  Created by Lazar Otasevic on 20.01.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import RHBKit;
@import CoreData;

@interface MySingleton: NSObject
@end

@implementation MySingleton
RHB_SINGLETON(sharedInstance);
@end

@interface TestObjc : XCTestCase

@end

@implementation TestObjc

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testOrientation {

    OrientationTracker *ot = [[OrientationTracker alloc] initWithAxisThreshold:0.85 snapAngle:0.1];
    [ot startTracking:^(OrientationTracker * tracker) {


    }];
}

-(void)testColor {

    CGFloat red,green,blue;
    UIColor * c = [[UIColor alloc] initWithColorReference:0x010203];
    [c getRed:&red green:&green blue:&blue alpha:nil];
    XCTAssert(red == 0x01/255.0);
    XCTAssert(green == 0x02/255.0);
    XCTAssert(blue == 0x03/255.0);
}

-(void)testDeinit {

    __block int i = 0;
    {
        RHB_DEFER {
            i++;
        }];
        XCTAssert(i==0);
    }
    XCTAssert(i==1);
}

-(void)testCoreData {

    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithName:@"Tests" in:[NSBundle bundleForClass:[self class]]];

    XCTAssert(model != nil);
}

-(void)testCasting {

    id x = @[@1, @""];
    NSLog(@"x: %@", x);
    NSArray *arr = [NSArray rhb_dynamicCast:x];
    NSDictionary *dic = [NSDictionary rhb_dynamicCast:x];
    XCTAssertNotNil(arr, @"");
    XCTAssertNil(dic, @"");
}

-(void)testMemoryUsage {

    XCTAssert([RHBDiagnostics memoryUsed] > 0, @"");
}

@end
