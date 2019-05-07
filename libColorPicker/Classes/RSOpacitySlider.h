//
// Created by Luo Wei on 2017/5/13.
// Copyright (c) 2017 wodedata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSOpacitySlider;

@protocol RSOpacitySliderDelegate<NSObject>

- (void)opacitySlider:(RSOpacitySlider *)opacitySlider opacityChanged:(float)value;

@end

@interface RSOpacitySlider : UISlider

@property (nonatomic, weak) IBOutlet id<RSOpacitySliderDelegate> delegate;

@end