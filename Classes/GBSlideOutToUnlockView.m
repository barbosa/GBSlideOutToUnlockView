//
//  GBSlideOutToUnlockView.m
//  GBSlideOutToUnlockViewExample
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
    
    CGRect outerCircleRect;
    CGRect innerCircleRect;
}

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *animationDotView;

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

- (void)drawRect:(CGRect)rect
{
    outerCircleRect = [self drawCircleWithRadius:self.outerCircleRadius];
    innerCircleRect = [self drawCircleWithRadius:self.innerCircleRadius];
    
    [self addRedeemImageAtCenter];
    [self addPanGestureRecognizerToImage];
}

- (CGRect)drawCircleWithRadius:(CGFloat)radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
    
    CGRect circle = CGRectMake(self.center.x - radius,
                               self.center.y - radius,
                               2 * radius,
                               2 * radius);
    
    CGContextAddEllipseInRect(context, circle);
    CGContextStrokePath(context);
    
    return circle;
}

- (void)addRedeemImageAtCenter
{
    CGFloat radius = self.innerCircleRadius;
    
    UIImage *image = _draggableImage ?: [UIImage imageNamed:@"drag_button"];
    
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.userInteractionEnabled = YES;
    _imageView.backgroundColor = self.tintColor;
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.layer.cornerRadius = radius;
    _imageView.clipsToBounds = YES;
    
    CGRect imageFrame = _imageView.frame;
    imageFrame.size = CGSizeMake(2*radius, 2*radius);
    _imageView.frame = imageFrame;
    
    [self addSubview:_imageView];
    _imageView.center = self.center;
}

- (void)addPanGestureRecognizerToImage
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_imageView addGestureRecognizer:panGesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(slideOutToUnlockViewDidStartToDrag:)]) {
            [_delegate slideOutToUnlockViewDidStartToDrag:self];
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self];
        _imageView.center = CGPointMake(self.center.x + translation.x,
                                        self.center.y + translation.y);
        _unlockOnRelease = sqrt(pow(_imageView.center.x-self.center.x, 2) + pow(_imageView.center.y-self.center.y, 2)) > self.outerCircleRadius + self.innerCircleRadius;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (_unlockOnRelease) {
            if ([self.delegate respondsToSelector:@selector(slideOutToUnlockViewDidUnlock:)])
                [self.delegate slideOutToUnlockViewDidUnlock:self];
        } else {
            if ([self.delegate respondsToSelector:@selector(slideOutToUnlockViewDidNotUnlock:)])
                [self.delegate slideOutToUnlockViewDidNotUnlock:self];
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            _imageView.center = self.center;
        }];
    }
}

@end