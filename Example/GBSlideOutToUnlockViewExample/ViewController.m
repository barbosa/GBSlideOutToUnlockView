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
    __weak IBOutlet UILabel *currentStateLabel;
    __weak IBOutlet GBSlideOutToUnlockView *unlockView;
}
@end

@implementation ViewController

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
