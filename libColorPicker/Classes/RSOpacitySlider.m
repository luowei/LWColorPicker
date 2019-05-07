//
// Created by Luo Wei on 2017/5/13.
// Copyright (c) 2017 wodedata. All rights reserved.
//

#import "RSOpacitySlider.h"
#import "RSColorFunctions.h"


@implementation RSOpacitySlider {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (void)initRoutine {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3;
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
    self.continuous = YES;

    [self setThumbImage:[UIImage circleWithColor:[UIColor whiteColor] size:CGSizeMake(16, 16)] forState:UIControlStateNormal];

    self.enabled = YES;
    self.userInteractionEnabled = YES;

    [self addTarget:self action:@selector(myValueChanged:) forControlEvents:UIControlEventValueChanged];
}

-  (void)didMoveToWindow {
    if (!self.window) return;

    UIImage *backgroundImage = RSOpacityBackgroundImage(16.f, self.window.screen.scale, [UIColor colorWithWhite:0.5 alpha:1.0]);
    self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}

- (void)myValueChanged:(id)notif {
    if([self.delegate respondsToSelector:@selector(opacitySlider:opacityChanged:)]){
        [self.delegate opacitySlider:self opacityChanged:self.value];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
    NSArray *colors = @[(id) [UIColor colorWithWhite:0 alpha:0].CGColor,(id) [UIColor colorWithWhite:1 alpha:1].CGColor];

    CGGradientRef myGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);

    CGContextDrawLinearGradient(ctx, myGradient, CGPointZero, CGPointMake(rect.size.width, 0), 0);
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(space);
}


@end