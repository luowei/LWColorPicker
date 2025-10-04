# LWColorPicker

[![CI Status](https://img.shields.io/travis/luowei/LWColorPicker.svg?style=flat)](https://travis-ci.org/luowei/LWColorPicker)
[![Version](https://img.shields.io/cocoapods/v/LWColorPicker.svg?style=flat)](https://cocoapods.org/pods/LWColorPicker)
[![License](https://img.shields.io/cocoapods/l/LWColorPicker.svg?style=flat)](https://cocoapods.org/pods/LWColorPicker)
[![Platform](https://img.shields.io/cocoapods/p/LWColorPicker.svg?style=flat)](https://cocoapods.org/pods/LWColorPicker)

**Language**: [English](./README.md) | [中文版](./README_ZH.md) | [Swift Version](./README_SWIFT_VERSION.md)

---

## Overview

LWColorPicker is a powerful and highly customizable color picker component designed specifically for iOS applications. It provides users with an intuitive and visually appealing interface to select colors by adjusting hue, saturation, brightness, and opacity values using the HSB (Hue-Saturation-Brightness) color model.

The library offers flexible display options with support for both circular and rectangular color picker layouts, complete with real-time color selection feedback and optional magnifying loupe for precise color picking. Built with performance in mind, LWColorPicker includes asynchronous preparation methods to ensure a smooth user experience even with complex color selection interfaces.

## Key Features

- **HSB Color Model** - Intuitive hue, saturation, and brightness-based color selection system
- **Flexible Display Modes** - Support for both circular and rectangular color picker layouts to match your design needs
- **Independent Brightness Control** - Dedicated brightness slider for precise color adjustments
- **Opacity/Alpha Support** - Built-in opacity control for transparent colors with visual feedback
- **Real-time Color Feedback** - Instant color preview and selection updates as users interact
- **Magnifying Loupe** - Optional magnifying glass for pixel-perfect color selection accuracy
- **Delegate Pattern** - Clean, flexible delegate callbacks for handling color selection events
- **Touch Event Handling** - Full support for touch began and touch ended delegate callbacks
- **Performance Optimized** - Asynchronous preparation methods for smooth, responsive UI
- **Easy Integration** - Simple API with Interface Builder support and programmatic configuration

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Requirements](#requirements)
- [Installation](#installation)
  - [CocoaPods](#cocoapods)
  - [Carthage](#carthage)
- [Usage](#usage)
  - [Quick Start](#quick-start)
  - [Interface Builder Setup](#interface-builder-setup)
  - [Programmatic Setup](#programmatic-setup)
  - [Delegate Implementation](#delegate-implementation)
  - [Color Selection](#color-selection)
  - [Performance Optimization](#performance-optimization)
- [API Reference](#api-reference)
- [Example Project](#example-project)
- [Author](#author)
- [License](#license)

## Requirements

- **iOS**: 8.0 or later
- **Xcode**: 8.0 or later
- **Language**: Objective-C
- **Frameworks**: UIKit, CoreGraphics

## Installation

LWColorPicker supports multiple installation methods to fit your project's dependency management needs.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate LWColorPicker into your Xcode project using CocoaPods, add it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'YourApp' do
  pod 'LWColorPicker'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate LWColorPicker into your Xcode project using Carthage, specify it in your `Cartfile`:

```ruby
github "luowei/LWColorPicker"
```

Run `carthage update` to build the framework and drag the built `LWColorPicker.framework` into your Xcode project:

```bash
$ carthage update --platform iOS
```

## Usage

### Quick Start

First, import the LWColorPicker headers in your view controller:

```objective-c
#import <LWColorPicker/RSColorPickerView.h>
#import <LWColorPicker/RSBrightnessSlider.h>
#import <LWColorPicker/RSOpacitySlider.h>
```

### Interface Builder Setup

You can easily integrate LWColorPicker using Interface Builder:

1. Add `UIView` objects to your storyboard or XIB
2. Set the custom class to `RSColorPickerView`, `RSBrightnessSlider`, and `RSOpacitySlider`
3. Connect IBOutlets to your view controller
4. Configure in your view controller:

```objective-c
@interface YourViewController () <RSColorPickerViewDelegate, RSBrightnessSliderDelegate, RSOpacitySliderDelegate>

@property (nonatomic) IBOutlet RSColorPickerView *colorPicker;
@property (nonatomic) IBOutlet RSBrightnessSlider *brightnessSlider;
@property (nonatomic) IBOutlet RSOpacitySlider *opacitySlider;

@end

@implementation YourViewController

- (void)awakeFromNib {
    [super awakeFromNib];

    // Set delegates
    _colorPicker.delegate = self;
    _brightnessSlider.delegate = self;
    _opacitySlider.delegate = self;

    // Configure appearance
    _colorPicker.cropToCircle = YES;  // Use circular picker layout
    _colorPicker.showLoupe = YES;     // Enable magnifying loupe
    _colorPicker.brightness = 1.0;    // Set initial brightness
}

@end
```

### Programmatic Setup

Alternatively, you can create and configure the color picker programmatically:

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];

    // Create color picker
    RSColorPickerView *colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(20, 100, 300, 300)];
    colorPicker.delegate = self;
    colorPicker.cropToCircle = YES;
    colorPicker.brightness = 1.0;
    colorPicker.showLoupe = YES;
    [self.view addSubview:colorPicker];

    // Create brightness slider
    RSBrightnessSlider *brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(20, 420, 300, 30)];
    brightnessSlider.delegate = self;
    [self.view addSubview:brightnessSlider];

    // Create opacity slider
    RSOpacitySlider *opacitySlider = [[RSOpacitySlider alloc] initWithFrame:CGRectMake(20, 470, 300, 30)];
    opacitySlider.delegate = self;
    [self.view addSubview:opacitySlider];

    self.colorPicker = colorPicker;
    self.brightnessSlider = brightnessSlider;
    self.opacitySlider = opacitySlider;
}
```

### Delegate Implementation

Implement the delegate methods to respond to color selection changes:

```objective-c
#pragma mark - RSColorPickerViewDelegate

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)colorPicker {
    // Required: Called whenever the color selection changes
    UIColor *selectedColor = [colorPicker selectionColor];

    // Update your UI with the selected color
    self.colorPreviewView.backgroundColor = selectedColor;

    // You can also extract RGB components if needed
    CGFloat red, green, blue, alpha;
    [selectedColor getRed:&red green:&green blue:&blue alpha:&alpha];
    NSLog(@"Selected color - R:%.2f G:%.2f B:%.2f A:%.2f", red, green, blue, alpha);
}

- (void)colorPicker:(RSColorPickerView *)colorPicker
       touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event {
    // Optional: Called when user starts touching the color picker
    NSLog(@"User started color selection");
}

- (void)colorPicker:(RSColorPickerView *)colorPicker
       touchesEnded:(NSSet *)touches
          withEvent:(UIEvent *)event {
    // Optional: Called when user stops touching the color picker
    NSLog(@"User finished color selection");
}

#pragma mark - RSBrightnessSliderDelegate

- (void)brightnessSlide:(RSBrightnessSlider *)brightnessSlider valueChanged:(float)value {
    // Update the color picker's brightness
    [self.colorPicker setBrightness:value];
}

#pragma mark - RSOpacitySliderDelegate

- (void)opacitySlider:(RSOpacitySlider *)opacitySlider opacityChanged:(float)value {
    // Update the color picker's opacity/alpha
    [self.colorPicker setOpacity:value];
}
```

### Color Selection

Working with colors is straightforward:

```objective-c
// Set a predefined color
self.colorPicker.selectionColor = [UIColor redColor];

// Set a custom color with RGB values
self.colorPicker.selectionColor = [UIColor colorWithRed:0.5 green:0.3 blue:0.8 alpha:1.0];

// Get the currently selected color
UIColor *currentColor = self.colorPicker.selectionColor;

// Get the color at a specific point in the picker
UIColor *colorAtPoint = [self.colorPicker colorAtPoint:CGPointMake(100, 100)];

// Programmatically set the selection point
self.colorPicker.selection = CGPointMake(150, 150);

// Adjust brightness and opacity programmatically
self.colorPicker.brightness = 0.8;  // Range: 0.0 to 1.0
self.colorPicker.opacity = 0.9;     // Range: 0.0 to 1.0
```

### Performance Optimization

For optimal performance, especially when displaying the color picker for the first time, you can pre-generate the color picker bitmap in the background. This prevents any UI lag when the picker appears:

```objective-c
// Simple preparation - uses default scale and padding
[RSColorPickerView prepareForSize:CGSizeMake(300, 300)];

// Prepare with custom padding (useful for circular pickers)
[RSColorPickerView prepareForSize:CGSizeMake(300, 300) padding:20];

// Full control with custom scale, padding, and background processing
[RSColorPickerView prepareForSize:CGSizeMake(300, 300)
                            scale:[UIScreen mainScreen].scale
                          padding:20
                     inBackground:YES];
```

**Best Practice**: Call the preparation method early in your app lifecycle (e.g., in `application:didFinishLaunchingWithOptions:` or during view controller initialization) to ensure the color picker is ready when needed.

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];

    // Pre-generate color picker bitmap for smooth appearance
    [RSColorPickerView prepareForSize:self.colorPicker.bounds.size
                                scale:[UIScreen mainScreen].scale
                              padding:self.colorPicker.paddingDistance
                         inBackground:YES];
}
```

## API Reference

### RSColorPickerView

The main color picker view component that displays the HSB color spectrum.

#### Properties

```objective-c
@property (nonatomic) BOOL cropToCircle;
```
Determines the picker's shape. Set to `YES` for circular layout, `NO` for rectangular layout. Default is `NO`.

```objective-c
@property (nonatomic) BOOL showLoupe;
```
Controls the visibility of the magnifying loupe during color selection. Set to `YES` to show the loupe for precise color picking. Default is `NO`.

```objective-c
@property (nonatomic) CGFloat brightness;
```
The brightness level of the color picker. Valid range is `0.0` (black) to `1.0` (full brightness). Default is `1.0`.

```objective-c
@property (nonatomic) CGFloat opacity;
```
The opacity/alpha level of the selected color. Valid range is `0.0` (transparent) to `1.0` (opaque). Default is `1.0`.

```objective-c
@property (nonatomic) UIColor *selectionColor;
```
Gets or sets the currently selected color in the picker. Setting this property will update the picker's selection point automatically.

```objective-c
@property (readwrite) CGPoint selection;
```
Gets or sets the current selection point in the picker's coordinate system.

```objective-c
@property (readonly) CGFloat paddingDistance;
```
Returns the padding distance from the edge of the view (useful for circular pickers).

```objective-c
@property (nonatomic, weak) IBOutlet id<RSColorPickerViewDelegate> delegate;
```
The delegate object that receives color picker events.

#### Instance Methods

```objective-c
- (UIColor *)colorAtPoint:(CGPoint)point;
```
Returns the color at the specified point in the picker's coordinate system.

**Parameters:**
- `point`: A point in the picker's coordinate space

**Returns:** The `UIColor` at the specified point

#### Class Methods

```objective-c
+ (void)prepareForSize:(CGSize)size;
```
Pre-generates the color picker bitmap for the specified size using default scale and padding.

```objective-c
+ (void)prepareForSize:(CGSize)size padding:(CGFloat)padding;
```
Pre-generates the color picker bitmap with custom padding.

```objective-c
+ (void)prepareForSize:(CGSize)size
                 scale:(CGFloat)scale
               padding:(CGFloat)padding
          inBackground:(BOOL)bg;
```
Full control preparation method with all parameters.

**Parameters:**
- `size`: The size of the color picker
- `scale`: The scale factor (typically `[UIScreen mainScreen].scale`)
- `padding`: The padding distance from edges
- `bg`: Whether to perform generation in background thread

### RSColorPickerViewDelegate

Protocol for receiving color picker events.

#### Required Methods

```objective-c
- (void)colorPickerDidChangeSelection:(RSColorPickerView *)colorPicker;
```
Called whenever the user changes the color selection in the picker. This is where you should update your UI with the newly selected color.

**Parameters:**
- `colorPicker`: The color picker view that triggered the event

#### Optional Methods

```objective-c
- (void)colorPicker:(RSColorPickerView *)colorPicker
       touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event;
```
Called when the user begins touching the color picker.

```objective-c
- (void)colorPicker:(RSColorPickerView *)colorPicker
       touchesEnded:(NSSet *)touches
          withEvent:(UIEvent *)event;
```
Called when the user stops touching the color picker.

---

### RSBrightnessSlider

A slider control for adjusting the brightness component of the color picker.

#### Properties

```objective-c
@property (nonatomic, weak) id<RSBrightnessSliderDelegate> delegate;
```
The delegate object that receives brightness change events.

### RSBrightnessSliderDelegate

Protocol for receiving brightness slider events.

```objective-c
- (void)brightnessSlide:(RSBrightnessSlider *)brightnessSlider
           valueChanged:(float)value;
```
Called when the brightness slider value changes.

**Parameters:**
- `brightnessSlider`: The slider that triggered the event
- `value`: The new brightness value (range: 0.0 to 1.0)

---

### RSOpacitySlider

A slider control for adjusting the opacity/alpha component of the selected color.

#### Properties

```objective-c
@property (nonatomic, weak) id<RSOpacitySliderDelegate> delegate;
```
The delegate object that receives opacity change events.

### RSOpacitySliderDelegate

Protocol for receiving opacity slider events.

```objective-c
- (void)opacitySlider:(RSOpacitySlider *)opacitySlider
       opacityChanged:(float)value;
```
Called when the opacity slider value changes.

**Parameters:**
- `opacitySlider`: The slider that triggered the event
- `value`: The new opacity value (range: 0.0 to 1.0)

## Example Project

The repository includes a comprehensive example project demonstrating all features of LWColorPicker.

To run the example project:

```bash
# Clone the repository
$ git clone https://github.com/luowei/LWColorPicker.git

# Navigate to the Example directory
$ cd LWColorPicker/Example

# Install dependencies
$ pod install

# Open the workspace
$ open LWColorPicker.xcworkspace
```

The example project demonstrates:
- Circular and rectangular color picker layouts
- Integration with brightness and opacity sliders
- Real-time color preview
- Magnifying loupe functionality
- Programmatic and Interface Builder setup

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue on GitHub. Pull requests are also appreciated.

## Author

**luowei**
Email: luowei@wodedata.com

## License

LWColorPicker is released under the **MIT License**. See the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) [year] luowei

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

**Made with love for the iOS development community.**
