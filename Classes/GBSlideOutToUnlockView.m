//
//  GBSlideOutToUnlockView.m
//  GBSlideOutToUnlockView
//
//  Created by Gustavo Barbosa on 4/16/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

#import "GBSlideOutToUnlockView.h"

#import <QuartzCore/QuartzCore.h>


static CGFloat const kDefaultInnerCircleRadius = 25.0f;

@interface GBSlideOutToUnlockView ()
{
    BOOL _unlockOnRelease;
    CGFloat _distanceMoved;
}

@property (nonatomic, strong) UIButton *dragButton;
@property (nonatomic, strong) UIView *animationDotView;

@end


@implementation GBSlideOutToUnlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Acessors

- (CGFloat)innerCircleRadius
{
    return _innerCircleRadius ?: kDefaultInnerCircleRadius;
}

- (CGFloat)outerCircleRadius
{
    if (_outerCircleRadius)
        return _outerCircleRadius;
    
    CGFloat horizontalSize = CGRectGetWidth(self.bounds);
    CGFloat verticalSize = CGRectGetHeight(self.bounds);
    
    return MIN(horizontalSize, verticalSize) / 2.0f;
}

- (UIColor *)innerCircleColor
{
    return _innerCircleColor ?: self.tintColor;
}

- (UIColor *)outerCircleColor
{
    return _outerCircleColor ?: self.tintColor;
}

- (UIColor *)draggableButtonBackgroundColor
{
    return _draggableButtonBackgroundColor ?: self.tintColor;
}

- (UIColor *)draggableImageTintColor
{
    return _draggableImageTintColor ?: [UIColor whiteColor];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [self drawCircleWithRadius:self.innerCircleRadius color:self.innerCircleColor];
    [self drawCircleWithRadius:self.outerCircleRadius color:self.outerCircleColor];
    
    [self addRedeemImageAtCenter];
    [self addPanGestureRecognizerToImage];
}

- (void)drawCircleWithRadius:(CGFloat)radius color:(UIColor *)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGRect circle = CGRectMake(self.center.x - radius,
                               self.center.y - radius,
                               2 * radius,
                               2 * radius);
    
    CGContextAddEllipseInRect(context, circle);
    CGContextStrokePath(context);
}

- (void)addRedeemImageAtCenter
{
    _dragButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dragButton.frame = CGRectMake(0, 0, 2*self.innerCircleRadius, 2*self.innerCircleRadius);
    _dragButton.backgroundColor = self.draggableButtonBackgroundColor;
    _dragButton.tintColor = self.draggableImageTintColor;
    _dragButton.layer.cornerRadius = self.innerCircleRadius;
    _dragButton.clipsToBounds = YES;
    
    UIImage *image = _draggableImage ?: [UIImage imageNamed:@"drag_button"];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)])
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_dragButton setImage:image forState:UIControlStateNormal];
    
    [self addSubview:_dragButton];
    
    _dragButton.center = self.center;
}

#pragma mark - Gesture Recognizers

- (void)addPanGestureRecognizerToImage
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_dragButton addGestureRecognizer:panGesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _distanceMoved = 0.0f;
        if ([_delegate respondsToSelector:@selector(slideOutToUnlockViewDidStartToDrag:)]) {
            [_delegate slideOutToUnlockViewDidStartToDrag:self];
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self];
        _dragButton.center = CGPointMake(self.center.x + translation.x,
                                         self.center.y + translation.y);
        _distanceMoved = sqrt(pow(_dragButton.center.x-self.center.x, 2) + pow(_dragButton.center.y-self.center.y, 2));
        
        if ([self.delegate respondsToSelector:@selector(slideOutToUnlockView:didDragDistance:)])
            [self.delegate slideOutToUnlockView:self didDragDistance:_distanceMoved];
        
        _unlockOnRelease = _distanceMoved > self.outerCircleRadius + self.innerCircleRadius;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if ([self.delegate respondsToSelector:@selector(slideOutToUnlockViewDidEndToDrag:)])
            [self.delegate slideOutToUnlockViewDidEndToDrag:self];
        
        if (_unlockOnRelease) {
            if ([self.delegate respondsToSelector:@selector(slideOutToUnlockViewDidUnlock:)])
                [self.delegate slideOutToUnlockViewDidUnlock:self];
        } else {
            if ([self.delegate respondsToSelector:@selector(slideOutToUnlockViewDidNotUnlock:)])
                [self.delegate slideOutToUnlockViewDidNotUnlock:self];
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            _dragButton.center = self.center;
        }];
    }
}

@end