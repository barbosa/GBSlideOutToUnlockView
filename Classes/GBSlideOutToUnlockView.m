//
//  GBSlideOutToUnlockView.m
//  GBSlideOutToUnlockViewExample
//
//  Created by Gustavo Barbosa on 4/16/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

#import "GBSlideOutToUnlockView.h"

#import <QuartzCore/QuartzCore.h>

#define MARGIN 60.0f
#define SMALL_CIRCLE_RADIUS 25.0f

@interface GBSlideOutToUnlockView ()
{
    CGFloat _bigCircleRadius;
    BOOL _unlockOnRelease;
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

- (void)drawRect:(CGRect)rect
{
    [self drawBigCircle];
    [self drawSmallCircle];
    [self addAnimationDotView];
    [self addRedeemImageAtCenter];
    [self addPanGestureRecognizerToImage];
}

- (void)drawBigCircle
{
    _bigCircleRadius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2) - MARGIN;
    [self drawCircleWithRadius:_bigCircleRadius];
}

- (void)drawCircleWithRadius:(CGFloat)radius
{
    CGPoint center;
    center.x = CGRectGetMinX(self.bounds) + CGRectGetWidth(self.bounds)/2;
    center.y = CGRectGetMinY(self.bounds) + CGRectGetHeight(self.bounds)/2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
    
    CGRect circle = CGRectMake(center.x - radius,
                               center.y - radius,
                               2 * radius,
                               2 * radius);
    
    CGContextAddEllipseInRect(context, circle);
    CGContextStrokePath(context);
}

- (void)drawSmallCircle
{
    [self drawCircleWithRadius:SMALL_CIRCLE_RADIUS];
}

- (void)addAnimationDotView
{
    CGFloat size = 10.0f;
    _animationDotView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size, size)];
    _animationDotView.backgroundColor = self.tintColor;
    _animationDotView.layer.cornerRadius = size / 2;
    [self addSubview:_animationDotView];
    
    _animationDotView.center = CGPointMake(self.center.x, self.center.y - _bigCircleRadius);
}

- (void)addRedeemImageAtCenter
{
    UIImage *image = [UIImage imageNamed:@"icone_erro"];
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.userInteractionEnabled = YES;
    _imageView.backgroundColor = self.tintColor;
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.layer.cornerRadius = SMALL_CIRCLE_RADIUS;
    _imageView.clipsToBounds = YES;
    
    CGRect imageFrame = _imageView.frame;
    imageFrame.size = CGSizeMake(2*SMALL_CIRCLE_RADIUS, 2*SMALL_CIRCLE_RADIUS);
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
        _unlockOnRelease = sqrt(pow(_imageView.center.x-self.center.x, 2) + pow(_imageView.center.y-self.center.y, 2)) > _bigCircleRadius + SMALL_CIRCLE_RADIUS;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (_unlockOnRelease) {
            [self.delegate slideOutToUnlockViewDidUnlock:self];
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            _imageView.center = self.center;
        }];
    }
}

- (void)startAnimating
{
    CAKeyframeAnimation *circlePathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    circlePathAnimation.duration = 2.0f;
    circlePathAnimation.removedOnCompletion = NO;
    circlePathAnimation.calculationMode = kCAAnimationCubic;
    circlePathAnimation.repeatCount = INFINITY;
    
    CGMutablePathRef circularPath = CGPathCreateMutable();
    CGRect pathRect = CGRectMake(self.center.x - _bigCircleRadius,
                                 self.center.y - _bigCircleRadius,
                                 2 * _bigCircleRadius,
                                 2 * _bigCircleRadius);
    CGPathAddEllipseInRect(circularPath, NULL, pathRect);
    circlePathAnimation.path = circularPath;
    CGPathRelease(circularPath);
    
    [_animationDotView.layer addAnimation:circlePathAnimation forKey:nil];
}

- (void)stopAnimating
{
    [_animationDotView.layer removeAllAnimations];
}

@end