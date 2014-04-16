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
@end

@implementation ViewController

- (void)loadView
{
    GBSlideOutToUnlockView *slideToUnlockView = [[GBSlideOutToUnlockView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    slideToUnlockView.delegate = self;
    self.view = slideToUnlockView;
}

#pragma mark - GBSlideOutToUnlockViewDelegate

- (void)slideOutToUnlockViewDidStartToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    NSLog(@"did start");
}

- (void)slideOutToUnlockViewDidEndToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    NSLog(@"did end");
}

- (void)slideOutToUnlockViewDidUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    NSLog(@"Did unlock");
}

@end
