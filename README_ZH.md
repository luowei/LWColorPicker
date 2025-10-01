# LWColorPicker

[![CI Status](https://img.shields.io/travis/luowei/LWColorPicker.svg?style=flat)](https://travis-ci.org/luowei/LWColorPicker)
[![Version](https://img.shields.io/cocoapods/v/LWColorPicker.svg?style=flat)](https://cocoapods.org/pods/LWColorPicker)
[![License](https://img.shields.io/cocoapods/l/LWColorPicker.svg?style=flat)](https://cocoapods.org/pods/LWColorPicker)
[![Platform](https://img.shields.io/cocoapods/p/LWColorPicker.svg?style=flat)](https://cocoapods.org/pods/LWColorPicker)

[English Documentation](README.md)

## 项目描述

LWColorPicker 是一个功能强大且可自定义的 iOS 颜色选择器组件。它为用户提供了通过调整色相、饱和度、亮度和不透明度来选择颜色的直观界面。该库支持圆形和矩形 HSB（色相-饱和度-亮度）颜色模式显示，并提供实时颜色选择反馈。

## 功能特性

- **HSB 颜色模型**: 直观的色相、饱和度和亮度颜色选择
- **灵活的显示**: 支持圆形和矩形颜色选择器布局
- **亮度控制**: 独立的亮度滑块，用于精细调整颜色
- **不透明度支持**: 内置透明颜色的 alpha/不透明度控制
- **实时反馈**: 实时颜色预览和选择更新
- **放大镜**: 可选的放大镜，用于精确选择颜色
- **委托模式**: 灵活的委托回调用于颜色选择事件
- **触摸事件**: 支持触摸开始和结束的委托回调
- **性能优化**: 异步准备方法以实现流畅的用户体验

## 系统要求

- iOS 8.0+
- Xcode 8.0+
- Objective-C

## 安装方法

### CocoaPods

LWColorPicker 可通过 [CocoaPods](https://cocoapods.org) 安装。只需在 Podfile 中添加以下行：

```ruby
pod 'LWColorPicker'
```

然后运行：
```bash
pod install
```

### Carthage

在 Cartfile 中添加以下行：

```ruby
github "luowei/LWColorPicker"
```

然后运行：
```bash
carthage update --platform iOS
```

## 使用方法

### 基本设置

导入头文件：

```objective-c
#import <LWColorPicker/RSColorPickerView.h>
#import <LWColorPicker/RSBrightnessSlider.h>
#import <LWColorPicker/RSOpacitySlider.h>
```

### 创建颜色选择器

```objective-c
@property (nonatomic) IBOutlet RSColorPickerView *colorPicker;
@property (nonatomic) IBOutlet RSBrightnessSlider *brightnessSlider;
@property (nonatomic) IBOutlet RSOpacitySlider *opacitySlider;

- (void)awakeFromNib {
    [super awakeFromNib];

    if (_colorPicker && _brightnessSlider && _opacitySlider) {
        _colorPicker.delegate = self;
        _brightnessSlider.delegate = self;
        _opacitySlider.delegate = self;

        // 配置颜色选择器
        _colorPicker.cropToCircle = YES; // 使用圆形选择器
        _colorPicker.showLoupe = YES;    // 显示放大镜
    }
}
```

### 编程方式设置

```objective-c
RSColorPickerView *colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(20, 100, 300, 300)];
colorPicker.delegate = self;
colorPicker.cropToCircle = YES;
colorPicker.brightness = 1.0;
[self.view addSubview:colorPicker];
```

### 实现委托

```objective-c
#pragma mark - RSColorPickerViewDelegate

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)colorPicker {
    UIColor *selectedColor = [colorPicker selectionColor];
    // 使用选中的颜色更新 UI
    self.previewView.backgroundColor = selectedColor;
}

- (void)colorPicker:(RSColorPickerView *)colorPicker
       touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event {
    // 处理触摸开始
}

- (void)colorPicker:(RSColorPickerView *)colorPicker
       touchesEnded:(NSSet *)touches
          withEvent:(UIEvent *)event {
    // 处理触摸结束
}

#pragma mark - RSBrightnessSliderDelegate

- (void)brightnessSlide:(RSBrightnessSlider *)brightnessSlider valueChanged:(float)value {
    [_colorPicker setBrightness:value];
}

#pragma mark - RSOpacitySliderDelegate

- (void)opacitySlider:(RSOpacitySlider *)opacitySlider opacityChanged:(float)value {
    [_colorPicker setOpacity:value];
}
```

### 颜色选择

```objective-c
// 设置特定颜色
colorPicker.selectionColor = [UIColor redColor];

// 获取当前选中的颜色
UIColor *currentColor = colorPicker.selectionColor;

// 获取特定点的颜色
UIColor *colorAtPoint = [colorPicker colorAtPoint:CGPointMake(100, 100)];
```

### 性能优化

预先准备颜色选择器数据以获得更好的用户体验：

```objective-c
// 在后台为特定尺寸准备
[RSColorPickerView prepareForSize:CGSizeMake(300, 300)];

// 使用自定义边距准备
[RSColorPickerView prepareForSize:CGSizeMake(300, 300) padding:20];

// 在后台使用自定义缩放和边距准备
[RSColorPickerView prepareForSize:CGSizeMake(300, 300)
                            scale:[UIScreen mainScreen].scale
                          padding:20
                     inBackground:YES];
```

## API 文档

### RSColorPickerView

主颜色选择器视图：

```objective-c
@interface RSColorPickerView : UIView

@property (nonatomic) BOOL cropToCircle;         // 圆形或方形选择器
@property (nonatomic) BOOL showLoupe;            // 显示放大镜
@property (nonatomic) CGFloat brightness;        // 0.0 到 1.0
@property (nonatomic) CGFloat opacity;           // 0.0 到 1.0
@property (nonatomic) UIColor *selectionColor;   // 当前选中的颜色
@property (readwrite) CGPoint selection;         // 选择点
@property (readonly) CGFloat paddingDistance;    // 边缘填充
@property (nonatomic, weak) IBOutlet id<RSColorPickerViewDelegate> delegate;

- (UIColor *)colorAtPoint:(CGPoint)point;

+ (void)prepareForSize:(CGSize)size;
+ (void)prepareForSize:(CGSize)size padding:(CGFloat)padding;
+ (void)prepareForSize:(CGSize)size scale:(CGFloat)scale padding:(CGFloat)padding inBackground:(BOOL)bg;

@end
```

### RSColorPickerViewDelegate

```objective-c
@protocol RSColorPickerViewDelegate <NSObject>

@required
- (void)colorPickerDidChangeSelection:(RSColorPickerView *)colorPicker;

@optional
- (void)colorPicker:(RSColorPickerView *)colorPicker touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)colorPicker:(RSColorPickerView *)colorPicker touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
```

### RSBrightnessSlider

```objective-c
@interface RSBrightnessSlider : UIControl

@property (nonatomic, weak) id<RSBrightnessSliderDelegate> delegate;

@end

@protocol RSBrightnessSliderDelegate <NSObject>
- (void)brightnessSlide:(RSBrightnessSlider *)brightnessSlider valueChanged:(float)value;
@end
```

### RSOpacitySlider

```objective-c
@interface RSOpacitySlider : UIControl

@property (nonatomic, weak) id<RSOpacitySliderDelegate> delegate;

@end

@protocol RSOpacitySliderDelegate <NSObject>
- (void)opacitySlider:(RSOpacitySlider *)opacitySlider opacityChanged:(float)value;
@end
```

## 示例项目

要运行示例项目，请克隆仓库并首先从 Example 目录运行 `pod install`：

```bash
git clone https://github.com/luowei/LWColorPicker.git
cd LWColorPicker/Example
pod install
open LWColorPicker.xcworkspace
```

## 作者

luowei, luowei@wodedata.com

## 许可证

LWColorPicker 基于 MIT 许可证开源。详见 LICENSE 文件。
