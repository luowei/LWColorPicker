//
// Created by Luo Wei on 2017/5/13.
// Copyright (c) 2017 wodedata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSBrightnessSlider;

@protocol RSBrightnessSliderDelegate<NSObject>

- (void)brightnessSlide:(RSBrightnessSlider *)brightnessSlider valueChanged:(float)value;

@end

@interface RSBrightnessSlider : UISlider

@property (nonatomic, weak) IBOutlet id<RSBrightnessSliderDelegate> delegate;

@end