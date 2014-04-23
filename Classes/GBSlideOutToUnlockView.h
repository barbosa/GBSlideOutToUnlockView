//
//  GBSlideOutToUnlockView.h
//  GBSlideOutToUnlockViewExample
//
//  Created by Gustavo Barbosa on 4/16/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBSlideOutToUnlockView;


@protocol GBSlideOutToUnlockViewDelegate <NSObject>
@optional
- (void)slideOutToUnlockViewDidStartToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView;
- (void)slideOutToUnlockViewDidEndToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView; //TODO implement

// didReachUnlockArea?

- (void)slideOutToUnlockViewDidUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView;
@end


@interface GBSlideOutToUnlockView : UIView

@property (nonatomic, weak) id<GBSlideOutToUnlockViewDelegate> delegate;
@property (nonatomic, assign) CGFloat innerCircleRadius;
@property (nonatomic, assign) CGFloat outerCircleRadius;

@property (nonatomic, strong) UIImage *draggableImage;

@end
