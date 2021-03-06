//
//  RSColorFunctions.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 3/12/13.
//

#import "RSColorFunctions.h"

#import "CGContextCreator.h"

BMPixel RSPixelFromHSV(CGFloat H, CGFloat S, CGFloat V)
{
    if (S == 0) {
        return BMPixelMake(V, V, V, 1.0);
    }
    if (H == 1) {
        H = 0;
    }

    CGFloat var_h = H * 6.0;
    // Verified `H` is never <0 so (int) is OK:
    int var_i = (int)var_h;
    CGFloat var_1 = V * (1.0 - S);

    if (var_i == 0) {
        CGFloat var_3 = V * (1.0 - S * (1.0 - (var_h - var_i)));
        return BMPixelMake(V, var_3, var_1, 1.0);
    } else if (var_i == 1) {
        CGFloat var_2 = V * (1.0 - S * (var_h - var_i));
        return BMPixelMake(var_2, V, var_1, 1.0);
    } else if (var_i == 2) {
        CGFloat var_3 = V * (1.0 - S * (1.0 - (var_h - var_i)));
        return BMPixelMake(var_1, V, var_3, 1.0);
    } else if (var_i == 3) {
        CGFloat var_2 = V * (1.0 - S * (var_h - var_i));
        return BMPixelMake(var_1, var_2, V, 1.0);
    } else if (var_i == 4) {
        CGFloat var_3 = V * (1.0 - S * (1.0 - (var_h - var_i)));
        return BMPixelMake(var_3, var_1, V, 1.0);
    }
    CGFloat var_2 = V * (1.0 - S * (var_h - var_i));
    return BMPixelMake(V, var_1, var_2, 1.0);
}


void RSHSVFromPixel(BMPixel pixel, CGFloat *h, CGFloat *s, CGFloat *v)
{
    UIColor *color = [UIColor colorWithRed:pixel.red green:pixel.green blue:pixel.blue alpha:1];
    [color getHue:h saturation:s brightness:v alpha:NULL];
}

void RSGetComponentsForColor(CGFloat *components, UIColor *color)
{
    // First try to get the components the right way

    if ([color getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]]) {
        return;
    } else if ([color getWhite:&components[0] alpha:&components[3]]) {
        components[1] = components[0];
        components[2] = components[0];
        return;
    }

    // *Then* resort to this good old hack.
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4] = {0};
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);


    for (int component = 0; component < 4; component++) {
        components[component] = resultingPixel[component] / 255.0;
    }

    if (components[3] > 0)
    {
        components[0] /= components[3];
        components[1] /= components[3];
        components[2] /= components[3];
    }
}

UIImage * RSUIImageWithScale(UIImage *img, CGFloat scale)
{
    return [UIImage imageWithCGImage:img.CGImage scale:scale orientation:UIImageOrientationUp];
}

/**
 * Returns image that looks like a checkered background.
 */
UIImage * RSOpacityBackgroundImage(CGFloat length, CGFloat scale, UIColor *color) {
    NSCAssert(scale > 0, @"Tried to create opacity background image with scale 0");
    NSCAssert(length > 0, @"Tried to create opacity background image with length 0");

    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, length*0.5, length*0.5)];
    UIBezierPath *rectangle2Path = [UIBezierPath bezierPathWithRect:CGRectMake(length*0.5, length*0.5, length*0.5, length*0.5)];
    UIBezierPath *rectangle3Path = [UIBezierPath bezierPathWithRect:CGRectMake(0, length*0.5, length*0.5, length*0.5)];
    UIBezierPath *rectangle4Path = [UIBezierPath bezierPathWithRect:CGRectMake(length*0.5, 0, length*0.5, length*0.5)];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(length, length), NO, scale);

    [color setFill];
    [rectanglePath fill];
    [rectangle2Path fill];

    [[UIColor whiteColor] setFill];
    [rectangle3Path fill];
    [rectangle4Path fill];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return RSUIImageWithScale(image, scale);
}

UIColor * RSRandomColorOpaque(BOOL isOpaque) {
    /*
     From https://gist.github.com/kylefox/1689973

     ***

     Distributed under The MIT License:
     http://opensource.org/licenses/mit-license.php

     Permission is hereby granted, free of charge, to any person obtaining
     a copy of this software and associated documentation files (the
     "Software"), to deal in the Software without restriction, including
     without limitation the rights to use, copy, modify, merge, publish,
     distribute, sublicense, and/or sell copies of the Software, and to
     permit persons to whom the Software is furnished to do so, subject to
     the following conditions:

     The above copyright notice and this permission notice shall be
     included in all copies or substantial portions of the Software.

     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
     LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
     OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
     WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

     Alpha modifications for RSColorPicker test project
     */

    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    CGFloat alpha = 1;

    if (!isOpaque) {
        alpha = ( arc4random() % 128 / 256.0 ) + 0.5;
    }

    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}


/**
 * Returns Image with hourglass looking slider that looks something like:
 *
 *  6 ______ 5
 *    \    /
 *   7 \  / 4
 *    ->||<--- cWidth (Center Width)
 *      ||
 *   8 /  \ 3
 *    /    \
 *  1 ------ 2
 */
UIImage * RSHourGlassThumbImage(CGSize size, CGFloat cWidth){

    //Set Size
    CGFloat width = size.width;
    CGFloat height = size.height;

    //Setup Context
    CGContextRef ctx = [CGContextCreator newARGBBitmapContextWithSize:size];

    //Set Colors
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);

    //Draw Slider, See Diagram above for point numbers
    CGFloat yDist83 = sqrtf(3)/2*width;
    CGFloat yDist74 = height - yDist83;
    CGPoint addLines[] = {
            CGPointMake(0, -1),                          //Point 1
            CGPointMake(width, -1),                      //Point 2
            CGPointMake(width/2+cWidth/2, yDist83),      //Point 3
            CGPointMake(width/2+cWidth/2, yDist74),      //Point 4
            CGPointMake(width, height+1),                //Point 5
            CGPointMake(0, height+1),                    //Point 6
            CGPointMake(width/2-cWidth/2, yDist74),      //Point 7
            CGPointMake(width/2-cWidth/2, yDist83)       //Point 8
    };
    //Fill Path
    CGContextAddLines(ctx, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextFillPath(ctx);

    //Stroke Path
    CGContextAddLines(ctx, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);

    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    return image;
}

/**
 * Returns image that looks like a square arrow loop, something like:
 *
 * +-----+
 * | +-+ | ------------------------
 * | | | |                       |
 * ->| |<--- loopSize.width     loopSize.height
 * | | | |                       |
 * | +-+ | ------------------------
 * +-----+
 */
UIImage * RSArrowLoopThumbImage(CGSize size, CGSize loopSize){

    //Setup Rects
    CGRect outsideRect = CGRectMake(0, 0, size.width, size.height);
    CGRect insideRect;
    insideRect.size = loopSize;
    insideRect.origin.x = (size.width - loopSize.width)/2;
    insideRect.origin.y = (size.height - loopSize.height)/2;

    //Setup Context
    CGContextRef ctx = [CGContextCreator newARGBBitmapContextWithSize:size];

    //Set Colors
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);

    CGMutablePathRef loopPath = CGPathCreateMutable();
    CGPathAddRect(loopPath, nil, outsideRect);
    CGPathAddRect(loopPath, nil, insideRect);


    //Fill Path
    CGContextAddPath(ctx, loopPath);
    CGContextEOFillPath(ctx);

    //Stroke Path
    CGContextAddRect(ctx, insideRect);
    CGContextStrokePath(ctx);

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);

    //Memory
    CGPathRelease(loopPath);
    CGContextRelease(ctx);

    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    return image;
}


@implementation UIImage(CircleColor)

+ (UIImage *)circleWithColor:(UIColor *)color size:(CGSize)size {
//    static UIImage *circle = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//    });



    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextFillEllipseInRect(ctx, rect);

    CGContextRestoreGState(ctx);
    UIImage *circle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return circle;
}

@end
