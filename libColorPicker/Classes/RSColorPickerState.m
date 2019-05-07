//
//  RSColorPickerState.m
//  RSColorPicker
//
//  Created by Alex Nichol on 12/16/13.
//

#import "RSColorPickerState.h"


@implementation RSColorPickerState

@synthesize brightness, alpha;

- (CGFloat)hue {
    return [self calculateHue];
}

- (CGFloat)saturation {
    return [self calculateSaturation];
}

- (UIColor *)color {
    return [UIColor colorWithHue:self.hue saturation:self.saturation brightness:brightness alpha:alpha];
}

+ (RSColorPickerState *)stateForPoint:(CGPoint)point size:(CGSize)size padding:(CGFloat)padding{
    BOOL isRectangle = size.width != size.height;
    BOOL isHorizon = size.width > size.height;
    if(isRectangle){
        if(isHorizon){
            CGPoint scaledRelativePoint = CGPointMake(point.x,size.height/2);
            return [[RSColorPickerState alloc] initWithScaledRelativePoint:scaledRelativePoint brightness:1 alpha:1 size:size];
        }else {
            CGPoint scaledRelativePoint = CGPointMake(size.width/2,point.y);
            return [[RSColorPickerState alloc] initWithScaledRelativePoint:scaledRelativePoint brightness:1 alpha:1 size:size];
        }
    } else{
        // calculate everything we need to know
        CGPoint relativePoint = CGPointMake((CGFloat) (point.x - (size.width / 2.0)), (CGFloat) ((size.width / 2.0) - point.y));
        CGPoint scaledRelativePoint = relativePoint;
        scaledRelativePoint.x /= (size.width / 2.0) - padding;
        scaledRelativePoint.y /= (size.width / 2.0) - padding;
        return [[RSColorPickerState alloc] initWithScaledRelativePoint:scaledRelativePoint brightness:1 alpha:1 size:size];
    }
}

- (id)initWithScaledRelativePoint:(CGPoint)p brightness:(CGFloat)V alpha:(CGFloat)A size:(CGSize)size{
    if ((self = [super init])) {
        scaledRelativePoint = p;
        brightness = V;
        alpha = A;
        wheelSize = size;
    }
    return self;
}

- (id)initWithColor:(UIColor *)_selectionColor size:(CGSize)size{
    if ((self = [super init])) {
        wheelSize = size;

        CGFloat rgba[4];
        RSGetComponentsForColor(rgba, _selectionColor);
        UIColor * selectionColor = [UIColor colorWithRed:rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]];
        CGFloat hue, saturation;
        [selectionColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        scaledRelativePoint = [self calculatePointWithHue:hue saturation:saturation];//_calculatePoint(hue, saturation);
    }
    return self;
}


- (CGPoint)selectionLocationWithSize:(CGSize)size padding:(CGFloat)padding {
    BOOL isRectangle = size.width != size.height;
    BOOL isHorizon = size.width > size.height;
    if(isRectangle) {
        return scaledRelativePoint;

    }else{
        CGPoint unscaled = scaledRelativePoint;
        unscaled.x *= (size.width / 2.0) - padding;
        unscaled.y *= (size.height / 2.0) - padding;
        return CGPointMake((CGFloat) (unscaled.x + (size.width / 2.0)), (CGFloat) ((size.height / 2.0) - unscaled.y));
    }
}

#pragma mark - Modification

- (RSColorPickerState *)stateBySettingBrightness:(CGFloat)newBright {
    brightness = newBright;
    return self;
}

- (RSColorPickerState *)stateBySettingAlpha:(CGFloat)newAlpha {
    alpha = newAlpha;
    return self;
}

- (RSColorPickerState *)stateBySettingHue:(CGFloat)newHue {
    CGPoint newPoint = [self calculatePointWithHue:newHue saturation:self.saturation];
    scaledRelativePoint = newPoint;
    return self;
}

- (RSColorPickerState *)stateBySettingSaturation:(CGFloat)newSaturation {
    CGPoint newPoint = [self calculatePointWithHue:self.hue saturation:newSaturation];
    scaledRelativePoint = newPoint;
    return self;
}

#pragma mark - Debugging

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: %p { ", NSStringFromClass([self class]), (__bridge void *) self];

    [description appendFormat:@"scaledPoint:%@ ", NSStringFromCGPoint(scaledRelativePoint)];
    [description appendFormat:@"brightness:%f ", brightness];
    [description appendFormat:@"alpha:%f", alpha];

    [description appendString:@"} >"];
    return description;
}


#pragma mark - Helper Functions

-(CGFloat)calculateHue {
    BOOL isRectangle = wheelSize.width != wheelSize.height;
    BOOL isHorizon = wheelSize.width > wheelSize.height;
    if(isRectangle) {
        CGFloat len = wheelSize.width > wheelSize.height ? wheelSize.width : wheelSize.height;
        if (isHorizon) {
            CGFloat angle = (CGFloat) ((fabsf(scaledRelativePoint.x) / len));
            return angle;
        }else{
            CGFloat angle = (CGFloat) ((fabsf(scaledRelativePoint.y) / len));
            return angle;
        }
    }else{
        CGFloat angle = (CGFloat) atan2(scaledRelativePoint.y, scaledRelativePoint.x);
        if (angle < 0) angle += M_PI * 2;
        return (CGFloat) (angle / (M_PI * 2));
    }
}

-(CGFloat) calculateSaturation{
    //色块
    BOOL isRectangle = wheelSize.width != wheelSize.height;
    if(isRectangle) {
        return 1;
    }

    //色轮
    CGFloat radius = (CGFloat) sqrt(pow(scaledRelativePoint.x, 2) + pow(scaledRelativePoint.y, 2));
    if (radius > 1) {
        radius = 1;
    }
    return radius;
}
-(CGPoint) calculatePointWithHue:(CGFloat)hue saturation:(CGFloat)saturation{
    //色块
    BOOL isRectangle = wheelSize.width != wheelSize.height;
    BOOL isHorizon = wheelSize.width > wheelSize.height;
    if(isRectangle) {
        CGFloat len = wheelSize.width > wheelSize.height ? wheelSize.width : wheelSize.height;
        if (isHorizon) {
            CGFloat angle = (CGFloat) (hue * (2.0 * M_PI));
            CGFloat pointX = angle * len;
            return CGPointMake(pointX, wheelSize.height/2);
        }else{
            CGFloat angle = (CGFloat) (hue * (2.0 * M_PI));
            CGFloat pointY = angle * len;
            return CGPointMake(wheelSize.width/2, pointY);
        }
    }

    //色轮 convert to HSV
    CGFloat angle = (CGFloat) (hue * (2.0 * M_PI));
    CGFloat pointX = (CGFloat) (cos(angle) * saturation);
    CGFloat pointY = (CGFloat) (sin(angle) * saturation);
    return CGPointMake(pointX, pointY);
}


@end

