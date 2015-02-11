# GBSlideOutToUnlockView


[![Version](http://cocoapod-badges.herokuapp.com/v/GBSlideOutToUnlockView/badge.png)](http://cocoadocs.org/docsets/GBSlideOutToUnlockView)
[![Platform](http://cocoapod-badges.herokuapp.com/p/GBSlideOutToUnlockView/badge.png)](http://cocoadocs.org/docsets/GBSlideOutToUnlockView)

## Installation

GBSlideOutToUnlockView is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

```ruby
pod "GBSlideOutToUnlockView"
```

But if you don't use CocoaPods, you can just copy the `Classes` folder into your project and add the PNG files inside the `Assets` folder into you projects.

## Screenshots

![Component example](https://raw.github.com/barbosa/GBSlideOutToUnlockView/master/screenshot.gif)

*Note: The "Unlocked/did not unlock" label is presented only in the Example project. It is not contained inside the component.*

## Usage

To create a **slide to unlock** component programmatically, just instantiate a new `GBSlideOutToUnlockView` with a frame and add it to some view, for example:

```objc
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GBSlideOutToUnlockView *slideToUnlockView = [[GBSlideOutToUnlockView alloc] initWithFrame:containerView.bounds];
    slideToUnlockView.delegate = self;
    [containerView addSubview:slideToUnlockView];
}
```

And then, implement its protocol to handle its events:

```objc
@protocol GBSlideOutToUnlockViewDelegate <NSObject>
@optional
- (void)slideOutToUnlockViewDidStartToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView;
- (void)slideOutToUnlockViewDidEndToDrag:(GBSlideOutToUnlockView *)slideOutToUnlockView;
- (void)slideOutToUnlockViewDidUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView;
- (void)slideOutToUnlockViewDidNotUnlock:(GBSlideOutToUnlockView *)slideOutToUnlockView;
- (void)slideOutToUnlockView:(GBSlideOutToUnlockView *)slideOutView didDragDistance:(CGFloat)distance;
@end
```

You can easily customize your instance of `GBSlideOutToUnlockView` using the properties below

```objc

@property (nonatomic, assign) CGFloat innerCircleRadius;
@property (nonatomic, assign) CGFloat outerCircleRadius;

@property (nonatomic, strong) UIColor *innerCircleColor;
@property (nonatomic, strong) UIColor *outerCircleColor;

@property (nonatomic, strong) UIColor *draggableButtonBackgroundColor;
@property (nonatomic, strong) UIColor *draggableImageTintColor;

@property (nonatomic, strong) UIImage *draggableImage;
```

## Author

Gustavo Barbosa [@gustavocsb](http://twitter.com/gustavocsb)

## License

Copyright (c) 2015 Gustavo Barbosa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
