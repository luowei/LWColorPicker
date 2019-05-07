//
//  LWViewController.m
//  libColorPicker
//
//  Created by luowei on 05/07/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import <libColorPicker/RSColorPickerView.h>
#import <libColorPicker/RSColorFunctions.h>
#import <libColorPicker/RSBrightnessSlider.h>
#import <libColorPicker/RSOpacitySlider.h>
#import <Masonry/View+MASAdditions.h>
#import "LWViewController.h"

@interface LWViewController () <RSColorPickerViewDelegate>

@property(nonatomic, strong) RSColorPickerView *colorPickerView;
@property(nonatomic, strong) RSColorPickerView *rectColorPickerView;
@property(nonatomic, strong) RSBrightnessSlider *brightnessSlider;
@property(nonatomic, strong) RSOpacitySlider *opacitySlider;

@property(nonatomic, strong) UIButton *whiteColorBtn;

@property(nonatomic, strong) UIView *colorIndicator;
@end

@implementation LWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];



    //色标按钮
    self.whiteColorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.whiteColorBtn];
    [self.whiteColorBtn setImage:[UIImage circleWithColor:[UIColor whiteColor] size:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.whiteColorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(60);
        make.width.height.mas_equalTo(40);
    }];

    self.whiteColorBtn.layer.cornerRadius = 4;
    self.whiteColorBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    [self.whiteColorBtn addTarget:self action:@selector(whiteColorBtnAction:) forControlEvents:UIControlEventTouchUpInside];


    //色相选择器
    self.colorPickerView = [RSColorPickerView new];
    [self.view addSubview:self.colorPickerView];
    [self.colorPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(130);
        make.left.equalTo(self.view).offset(8);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(36);
    }];

    self.colorPickerView.layer.cornerRadius = 4;
    self.colorPickerView.delegate = self;




    //饱和度
    self.brightnessSlider = [RSBrightnessSlider new];
    [self.view addSubview:self.brightnessSlider];
    [self.brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.colorPickerView);
        make.left.equalTo(self.colorPickerView.mas_right).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(36);
    }];

    self.brightnessSlider.value = 1.0;
    [self.brightnessSlider addTarget:self action:@selector(brightnessSlideChanged:) forControlEvents:UIControlEventValueChanged];


    //透明度
    self.opacitySlider = [RSOpacitySlider new];
    [self.view addSubview:self.opacitySlider];
    [self.opacitySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.brightnessSlider);
        make.left.equalTo(self.brightnessSlider.mas_right).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(36);
    }];

    self.opacitySlider.value = 1.0;
    [self.opacitySlider addTarget:self action:@selector(opacitySliderChanged:) forControlEvents:UIControlEventValueChanged];




    //矩形色相选择器
    self.rectColorPickerView = [[RSColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [self.view addSubview:self.rectColorPickerView];
    [self.rectColorPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colorPickerView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(8);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(150);
    }];

    self.rectColorPickerView.delegate = self;
    self.rectColorPickerView.cropToCircle = YES;    //裁剪成圆形


    //颜色指示器
    self.colorIndicator = [UIView new];
    [self.view addSubview:self.colorIndicator];
    [self.colorIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rectColorPickerView);
        make.left.equalTo(self.rectColorPickerView.mas_right).offset(20);
        make.width.height.mas_equalTo(100);
    }];
    self.colorIndicator.layer.cornerRadius = 10;
    self.colorIndicator.backgroundColor = [UIColor whiteColor];


}

#pragma mark - Action

- (void)whiteColorBtnAction:(UIButton *)btn {
    [self.whiteColorBtn setImage:[UIImage circleWithColor:[UIColor whiteColor] size:CGSizeMake(30, 30)] forState:UIControlStateNormal];

    self.colorIndicator.backgroundColor = [UIColor whiteColor];
}


- (void)brightnessSlideChanged:(RSBrightnessSlider *)slider{
    [self.rectColorPickerView setBrightness:slider.value];
    [self.colorPickerView setBrightness:slider.value];
}

- (void)opacitySliderChanged:(RSOpacitySlider *)slider {
    [self.rectColorPickerView setOpacity:slider.value];
    [self.colorPickerView setOpacity:slider.value];
}




#pragma mark - RSColorPickerViewDelegate

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)colorPicker {
    UIColor *selectedColor = [colorPicker selectionColor];
//    CGFloat alpha = CGColorGetAlpha(self.selectedColor.CGColor);
    CGFloat hue = 0, saturation = 0, brightness = 0,alpha = 0;
    [selectedColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if(alpha > 0.1){
        UIImage *colorImage = [UIImage circleWithColor:selectedColor size:CGSizeMake(30, 30)];
        [self.whiteColorBtn setImage:colorImage forState:UIControlStateNormal];
    }

    self.colorIndicator.backgroundColor = selectedColor;

    self.opacitySlider.value = alpha;
    self.brightnessSlider.value = brightness;
}

- (void)colorPicker:(RSColorPickerView *)colorPicker touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)colorPicker:(RSColorPickerView *)colorPicker touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}


@end
