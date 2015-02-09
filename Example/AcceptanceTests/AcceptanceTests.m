//
//  AcceptanceTests.m
//  AcceptanceTests
//
//  Created by Gustavo Barbosa on 2/9/15.
//  Copyright (c) 2015 Gustavo Barbosa. All rights reserved.
//

#import <KIF/KIF.h>
#import "GBSlideOutToUnlockView.h"

#pragma mark - Dummy delegate

@interface DummyDelegate : NSObject <GBSlideOutToUnlockViewDelegate>
@property (nonatomic, assign) BOOL unlocked;
@end

@implementation DummyDelegate

- (void)slideOutToUnlockViewDidNotUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    _unlocked = NO;
}

- (void)slideOutToUnlockViewDidUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    _unlocked = YES;
}

@end

#pragma mark - Tests

@interface AcceptanceTests : KIFTestCase
{
    GBSlideOutToUnlockView *unlockView;
    UIButton *dragButton;
    DummyDelegate *delegate;
}
@end

@implementation AcceptanceTests

- (void)beforeEach
{
    delegate = [DummyDelegate new];
    unlockView = (GBSlideOutToUnlockView *)[tester waitForViewWithAccessibilityLabel:@"unlock view"];
    unlockView.delegate = delegate;

    dragButton = (UIButton *)[tester waitForTappableViewWithAccessibilityLabel:@"drag button"];
}

- (void)testDragToInsideDoNotUnlockIt
{
    CGPoint currentPoint = [dragButton convertPoint:dragButton.center fromView:dragButton.superview];
    CGPoint insidePoint = CGPointMake(
        currentPoint.x + (arc4random() % (int)unlockView.outerCircleRadius),
        currentPoint.y + (arc4random() % (int)unlockView.outerCircleRadius)
    );
    [dragButton dragFromPoint:currentPoint toPoint:insidePoint];

    XCTAssertFalse(delegate.unlocked);
}
//
//- (void)testDragToOutsideUnlockIt
//{
//    CGPoint currentPoint = [dragButton convertPoint:dragButton.center fromView:dragButton.superview];
//    CGPoint outsidePoint = CGPointMake(
//        currentPoint.x + (arc4random() % (int)unlockView.outerCircleRadius) * 2.0,
//        currentPoint.y + (arc4random() % (int)unlockView.outerCircleRadius) * 2.0
//    );
//    [dragButton dragFromPoint:currentPoint toPoint:outsidePoint];
//    
//    XCTAssertTrue(delegate.unlocked);
//}

@end
