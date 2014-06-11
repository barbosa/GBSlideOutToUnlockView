//
//  GBSlideOutToUnlockView.h
//  GBSlideOutToUnlockView
//
//  Created by Gustavo Barbosa on 4/16/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBSlideOutToUnlockView;

#pragma mark - Protocol

/**
 *  The delegate of a GBSlideOutToUnlockView must adopt the GBSlideOutToUnlockViewDelegate protocol.
 *  Optional methods of the protocol allow the delegate to handle events for given states.
 */
@protocol GBSlideOutToUnlockViewDelegate <NSObject>

@optional

/**
 *  Tells the delegate that the slideOutToUnlockView object did start to drag.
 *
 *  @param slideOutToUnlockView The slideOutToUnlockView object that started the drag.
 */
- (void)slideOutToUnlockViewDidStartToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView;

/**
 *  Tells the delegate that the slideOutToUnlockView object did end to drag.
 *
 *  @param slideOutToUnlockView The slideOutToUnlockView object that ended the drag.
 */
- (void)slideOutToUnlockViewDidEndToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView;

/**
 *  Tells the delegate that the slideOutToUnlockView object did unlock successfully.
 *
 *  @param slideOutToUnlockView The slideOutToUnlockView object that did unlock.
 */
- (void)slideOutToUnlockViewDidUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView;

/**
 *  Tells the delegate that the slideOutToUnlockView object did fail to unlock.
 *
 *  @param slideOutToUnlockView The slideOutToUnlockView object that fails to unlock.
 */
- (void)slideOutToUnlockViewDidNotUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView;

/**
 *  Tells the delegate that the component's draggable image has moved some distance.
 *
 *  @param slideOutView The slideOutToUnlockView object being dragged.
 *  @param distance     Total distance between the componet's center point and the current point.
 */
- (void)slideOutToUnlockView:(GBSlideOutToUnlockView *)slideOutView didDragDistance:(CGFloat)distance;

@end


#pragma mark - Interface

/**
 *  GBSlideOutToUnlockView offers a very simple way to perform an unlock action
 *  from inside to outside.
 */
@interface GBSlideOutToUnlockView : UIView

/**
 *  The object implementing GBSlideOutToUnlockViewDelegate protocol that will handle
 *  the unlock messasages.
 */
@property (nonatomic, weak) id<GBSlideOutToUnlockViewDelegate> delegate;

/**
 *  The inner circle's radius.
 */
@property (nonatomic, assign) CGFloat innerCircleRadius;

/**
 *  The outer circle's radius.
 */
@property (nonatomic, assign) CGFloat outerCircleRadius;

/**
 *  The inner circle's drawing color.
 */
@property (nonatomic, strong) UIColor *innerCircleColor;

/**
 *  The outer circle's drawing color.
 */
@property (nonatomic, strong) UIColor *outerCircleColor;

/**
 *  The draggable buttons's background color.
 */
@property (nonatomic, strong) UIColor *draggableButtonBackgroundColor;

/**
 *  The draggable button image's tint color.
 */
@property (nonatomic, strong) UIColor *draggableImageTintColor;

/**
 *  The draggable button's image.
 */
@property (nonatomic, strong) UIImage *draggableImage;

@end
