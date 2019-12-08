//
//  GenerateOperation.m
//  RSColorPicker
//
//  Created by Ryan on 7/22/13.
//

#import "RSGenerateOperation.h"
#import "ANImageBitmapRep.h"
#import "RSColorFunctions.h"

@implementation RSGenerateOperation

- (id)initWithSize:(CGSize)size andPadding:(CGFloat)padding {
    if ((self = [self init])) {
        _wheelSize = size;
        _padding = padding;
    }
    return self;
}

- (void)main {
    BOOL isRectangle = _wheelSize.width != _wheelSize.height;
    if(isRectangle){
        [self colorRectangleBitMapWithWidth:_wheelSize.width height:_wheelSize.height];
    }else{
        [self colorWheelBitMap];
    }
}

//HSV 色块
- (void)colorRectangleBitMapWithWidth:(CGFloat)width height:(CGFloat)height {
    BMPoint repSize = BMPointMake((long) width, (long) height);

    // Create fresh
    ANImageBitmapRep *rep = [[ANImageBitmapRep alloc] initWithSize:repSize];

    BOOL isHorizon = width > height;
//    CGFloat relRadius = isHorizon ? width : height ;//radius - _padding;
    CGFloat relX, relY;

    int i, x, y;
    int arrSize = (int) (width * height);
    size_t arrDataSize = sizeof(float) * arrSize;

    // data
    float *preComputeX = (float *)malloc(arrDataSize);
    float *preComputeY = (float *)malloc(arrDataSize);
    // output
    //float *atan2Vals = (float *)malloc(arrDataSize);
    float *len2Vals = (float *)malloc(arrDataSize);
    float *distVals = (float *)malloc(arrDataSize);

    i = 0;
    for (x = 0; x < width; x++) {
        relX = isHorizon ? x : 0;
        for (y = 0; y < height; y++) {
            relY =  isHorizon ? 0 : y;

            preComputeY[i] = relY;
            preComputeX[i] = relX;
            i++;
        }
    }

    // Use Accelerate.framework to compute the distance and angle of every
    // pixel from the center of the bitmap.
    if(isHorizon){
        vvfabsf(len2Vals, preComputeX, &arrSize);
    }else{
        vvfabsf(len2Vals, preComputeY, &arrSize);
    }
    //vvatan2f(atan2Vals, preComputeY, preComputeX, &arrSize);
    vDSP_vdist(preComputeX, 1, preComputeY, 1, distVals, 1, arrSize);

    // Compution done, free these
    free(preComputeX);
    free(preComputeY);

    i = 0;
    for (x = 0; x < width; x++) {
        for (y = 0; y < height; y++) {
            CGFloat len = isHorizon ? width : height;
            CGFloat angle = (CGFloat) ((len2Vals[i]/len) * (2.0 * M_PI));
            if (angle < 0.0) angle = (CGFloat) ((2.0 * M_PI) + angle);
            CGFloat perc_angle = (CGFloat) (angle / (2.0 * M_PI));

//            CGFloat r_distance = fmin(distVals[i], relRadius);
//            CGFloat saturation = r_distance/relRadius;  //饱和度
            CGFloat saturation = 1;

            BMPixel thisPixel = RSPixelFromHSV(perc_angle, saturation, 1); // full brightness
            [rep setPixel:thisPixel atPoint:BMPointMake(x, y)];

            i++;
        }
    }

    // Bitmap generated, free these
//    free(atan2Vals);
    free(len2Vals);
    free(distVals);

    self.bitmap = rep;
}

//HSV 色轮
- (void)colorWheelBitMap {
    CGFloat _diameter = _wheelSize.width;
    BMPoint repSize = BMPointMake((long) _diameter, (long) _diameter);

    // Create fresh
    ANImageBitmapRep *rep = [[ANImageBitmapRep alloc] initWithSize:repSize];

    CGFloat radius = (CGFloat) (_diameter / 2.0);
    CGFloat relRadius = radius - _padding;
    CGFloat relX, relY;

    int i, x, y;
    int arrSize = (int) powf(_diameter, 2);
    size_t arrDataSize = sizeof(float) * arrSize;

    // data
    float *preComputeX = (float *)malloc(arrDataSize);
    float *preComputeY = (float *)malloc(arrDataSize);
    // output
    float *atan2Vals = (float *)malloc(arrDataSize);
    float *distVals = (float *)malloc(arrDataSize);

    i = 0;
    for (x = 0; x < _diameter; x++) {
        relX = x - radius;
        for (y = 0; y < _diameter; y++) {
            relY = radius - y;

            preComputeY[i] = relY;
            preComputeX[i] = relX;
            i++;
        }
    }

    // Use Accelerate.framework to compute the distance and angle of every
    // pixel from the center of the bitmap.
    vvatan2f(atan2Vals, preComputeY, preComputeX, &arrSize);
    vDSP_vdist(preComputeX, 1, preComputeY, 1, distVals, 1, arrSize);

    // Compution done, free these
    free(preComputeX);
    free(preComputeY);

    i = 0;
    for (x = 0; x < _diameter; x++) {
        for (y = 0; y < _diameter; y++) {
            CGFloat r_distance = (CGFloat) fmin(distVals[i], relRadius);

            CGFloat angle = atan2Vals[i];
            if (angle < 0.0) angle = (CGFloat) ((2.0 * M_PI) + angle);

            CGFloat perc_angle = (CGFloat) (angle / (2.0 * M_PI));
            BMPixel thisPixel = RSPixelFromHSV(perc_angle, r_distance/relRadius, 1); // full brightness
            [rep setPixel:thisPixel atPoint:BMPointMake(x, y)];

            i++;
        }
    }

    // Bitmap generated, free these
    free(atan2Vals);
    free(distVals);

    self.bitmap = rep;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return self.bitmap == nil;
}

- (BOOL)isFinished {
    return !self.isExecuting;
}

@end
