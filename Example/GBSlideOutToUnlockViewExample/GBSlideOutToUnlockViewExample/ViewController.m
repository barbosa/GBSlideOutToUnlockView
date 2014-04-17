//
//  ViewController.m
//  GBSlideOutToUnlockViewExample
//
//  Created by Gustavo Barbosa on 4/16/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

#import "ViewController.h"
#import "GBSlideOutToUnlockView.h"

@interface ViewController ()<GBSlideOutToUnlockViewDelegate>
{
    UILabel *currentState;
    GBSlideOutToUnlockView *slideToUnlockView;
}
@end

@implementation ViewController

- (void)loadView
{
    slideToUnlockView = [[GBSlideOutToUnlockView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    slideToUnlockView.delegate = self;
    slideToUnlockView.tintColor = [UIColor purpleColor];
    self.view = slideToUnlockView;
}

- (void)viewDidLoad
{
    currentState = [UILabel new];
    currentState.text = @"Initial";
    [currentState sizeToFit];
    
    [self setCurrentStateLabelPosition];
    
    [self.view addSubview:currentState];
}

- (void)setCurrentStateLabelPosition
{
    CGFloat x = self.view.center.x;
    CGFloat y = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(currentState.frame);
    currentState.center = CGPointMake(x, y);
}

#pragma mark - GBSlideOutToUnlockViewDelegate

- (void)slideOutToUnlockViewDidStartToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    NSLog(@"did start");
    currentState.text = @"Started";
    [currentState sizeToFit];
    [self setCurrentStateLabelPosition];
}

- (void)slideOutToUnlockViewDidEndToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    NSLog(@"did end");
    currentState.text = @"Ended";
    [currentState sizeToFit];
    [self setCurrentStateLabelPosition];
}

- (void)slideOutToUnlockViewDidUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    NSLog(@"Did unlock");
    currentState.text = @"Unlocked";
    [currentState sizeToFit];
    [self setCurrentStateLabelPosition];
}

@end
