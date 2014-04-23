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
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UILabel *currentStateLabel;
    GBSlideOutToUnlockView *slideToUnlockView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    slideToUnlockView = [[GBSlideOutToUnlockView alloc] initWithFrame:containerView.bounds];
    slideToUnlockView.delegate = self;
    slideToUnlockView.tintColor = [UIColor purpleColor];
    slideToUnlockView.outerCircleRadius = CGRectGetWidth(containerView.bounds) / 2.0 - 2*20;
    [containerView addSubview:slideToUnlockView];
}

#pragma mark - GBSlideOutToUnlockViewDelegate

- (void)slideOutToUnlockViewDidStartToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    currentStateLabel.text = @"Started";
}

- (void)slideOutToUnlockViewDidUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    currentStateLabel.text = @"Unlocked";
}

- (void)slideOutToUnlockViewDidNotUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView
{
    currentStateLabel.text = @"Did not unlock";
}

@end
