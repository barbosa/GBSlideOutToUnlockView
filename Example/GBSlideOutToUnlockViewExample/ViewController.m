//
//  ViewController.m
//  GBSlideOutToUnlockViewExample
//
//  Created by Gustavo Barbosa on 4/16/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

#import "ViewController.h"
#import "GBSlideOutToUnlockView.h"

static CGFloat const kHorizontalMargin = 20.0f;

@interface ViewController ()<GBSlideOutToUnlockViewDelegate>
{
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UILabel *currentStateLabel;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GBSlideOutToUnlockView *slideToUnlockView = [[GBSlideOutToUnlockView alloc] initWithFrame:containerView.bounds];
    slideToUnlockView.delegate = self;
    slideToUnlockView.outerCircleRadius = CGRectGetWidth(containerView.bounds) / 2.0f - 2*kHorizontalMargin;
    [containerView addSubview:slideToUnlockView];
}

#pragma mark - GBSlideOutToUnlockViewDelegate

- (void)slideOutToUnlockViewDidStartToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    currentStateLabel.text = @"Started";
    currentStateLabel.backgroundColor = [UIColor blackColor];
}

- (void)slideOutToUnlockViewDidUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    currentStateLabel.text = @"Unlocked";
    currentStateLabel.backgroundColor = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
}

- (void)slideOutToUnlockViewDidNotUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    currentStateLabel.text = @"Did not unlock";
    currentStateLabel.backgroundColor = [UIColor colorWithRed:0.7 green:0 blue:0 alpha:1];
}

@end
