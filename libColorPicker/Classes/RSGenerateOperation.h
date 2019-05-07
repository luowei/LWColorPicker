//
//  GenerateOperation.h
//  RSColorPicker
//
//  Created by Ryan on 7/22/13.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@class ANImageBitmapRep;

@interface RSGenerateOperation : NSOperation

-(id)initWithSize:(CGSize)size andPadding:(CGFloat)padding;

@property (readonly) CGSize wheelSize;
@property (readonly) CGFloat padding;

@property ANImageBitmapRep *bitmap;

@end
