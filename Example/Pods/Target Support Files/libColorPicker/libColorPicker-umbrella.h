#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ANImageBitmapRep.h"
#import "BitmapContextRep.h"
#import "NSImage+ANImageBitmapRep.h"
#import "OSCommonImage.h"
#import "UIImage+ANImageBitmapRep.h"
#import "CGContextCreator.h"
#import "CGImageContainer.h"
#import "BitmapContextManipulator.h"
#import "BitmapCropManipulator.h"
#import "BitmapDrawManipulator.h"
#import "BitmapRotationManipulator.h"
#import "BitmapScaleManipulator.h"
#import "BGRSLoupeLayer.h"
#import "RSBrightnessSlider.h"
#import "RSColorFunctions.h"
#import "RSColorPickerState.h"
#import "RSColorPickerView.h"
#import "RSGenerateOperation.h"
#import "RSOpacitySlider.h"
#import "RSSelectionLayer.h"

FOUNDATION_EXPORT double libColorPickerVersionNumber;
FOUNDATION_EXPORT const unsigned char libColorPickerVersionString[];

