//
// Created by Luo Wei on 2017/5/13.
// Copyright (c) 2017 wodedata. All rights reserved.
//

#import "RSBrightnessSlider.h"
#import "RSColorFunctions.h"


@implementation RSBrightnessSlider {

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

    UIImage *normalImg = [UIImage circleWithColor:[UIColor whiteColor] size:CGSizeMake(16, 16)];
    [self setThumbImage:normalImg forState:UIControlStateNormal];

    self.enabled = YES;
    self.userInteractionEnabled = YES;

    [self addTarget:self action:@selector(myValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)myValueChanged:(id)notif {
    if([self.delegate respondsToSelector:@selector(brightnessSlide:valueChanged:)]){
        [self.delegate brightnessSlide:self valueChanged:self.value];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
    NSArray *colors = @[(id)[UIColor colorWithWhite:0 alpha:1].CGColor,
            (id)[UIColor colorWithWhite:1 alpha:1].CGColor];

    CGGradientRef myGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);

    CGContextDrawLinearGradient(ctx, myGradient, CGPointZero, CGPointMake(rect.size.width, 0), 0);
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(space);
}

+ (UIImage *)circleWithColor:(UIColor *)color {
    static UIImage *circle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 20.f), NO, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);

        CGRect rect = CGRectMake(0, 0, 20, 20);
        CGContextSetFillColorWithColor(ctx, [color CGColor]);
        CGContextFillEllipseInRect(ctx, rect);

        CGContextRestoreGState(ctx);
        circle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    });
    return circle;
}

@end

