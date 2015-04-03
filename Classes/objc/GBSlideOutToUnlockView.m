//
//  GBSlideOutToUnlockView.m
//  GBSlideOutToUnlockView
//
//  Created by Gustavo Barbosa on 4/16/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

#import "GBSlideOutToUnlockView.h"

#import <QuartzCore/QuartzCore.h>

CGPoint p_fixedCenter(CGRect frame) {
    CGFloat _fixedX = (CGRectGetMaxX(frame) - CGRectGetMinX(frame)) / 2.0;
    CGFloat _fixedY = (CGRectGetMaxY(frame) - CGRectGetMinY(frame)) / 2.0;
    return CGPointMake(_fixedX, _fixedY);
}

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

@synthesize draggableButtonBackgroundColor = _draggableButtonBackgroundColor;

#pragma mark - Ctors

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
#if !TARGET_INTERFACE_BUILDER
        [self setupViews];
#endif
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Setup

- (void)setupViews
{
    self.backgroundColor = [UIColor clearColor];
    [self addRedeemImageAtCenter];
    [self addPanGestureRecognizerToImage];
}

- (void)prepareForInterfaceBuilder
{
    [self setupViews];
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

- (void)setDraggableButtonBackgroundColor:(UIColor *)draggableButtonBackgroundColor
{
    _draggableButtonBackgroundColor = draggableButtonBackgroundColor;
    _dragButton.backgroundColor = _draggableButtonBackgroundColor;
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
}

- (void)drawCircleWithRadius:(CGFloat)radius color:(UIColor *)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, color.CGColor);

    CGRect circle = CGRectMake(p_fixedCenter(self.frame).x - radius,
                               p_fixedCenter(self.frame).y - radius,
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

    _dragButton.center = p_fixedCenter(self.frame);
}

#pragma mark - Gesture Recognizers

- (void)addPanGestureRecognizerToImage
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_dragButton addGestureRecognizer:panGesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint _fixedCenter = p_fixedCenter(self.frame);
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _distanceMoved = 0.0f;
        if ([_delegate respondsToSelector:@selector(slideOutToUnlockViewDidStartToDrag:)]) {
            [_delegate slideOutToUnlockViewDidStartToDrag:self];
        }
    }

    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self];
        _dragButton.center = CGPointMake(_fixedCenter.x + translation.x,
                                         _fixedCenter.y + translation.y);
        _distanceMoved = sqrt(pow(_dragButton.center.x-_fixedCenter.x, 2) + pow(_dragButton.center.y-_fixedCenter.y, 2));

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
            _dragButton.center = _fixedCenter;
        }];
    }
}

@end