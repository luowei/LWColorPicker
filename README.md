# LWColorPicker

[![CI Status](https://img.shields.io/travis/luowei/LWColorPicker.svg?style=flat)](https://travis-ci.org/luowei/LWColorPicker)
[![Version](https://img.shields.io/cocoapods/v/LWColorPicker.svg?style=flat)](https://cocoapods.org/pods/LWColorPicker)
[![License](https://img.shields.io/cocoapods/l/LWColorPicker.svg?style=flat)](https://cocoapods.org/pods/LWColorPicker)
[![Platform](https://img.shields.io/cocoapods/p/LWColorPicker.svg?style=flat)](https://cocoapods.org/pods/LWColorPicker)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```Objective-C
@property (nonatomic) IBOutlet RSColorPickerView *colorPicker;

- (void)awakeFromNib {
    [super awakeFromNib];

    if(_colorPicker && _brightnessSlider && _opacitySlider){
        _colorPicker.delegate = self;
        _brightnessSlider.delegate = self;
        _opacitySlider.delegate = self;
    }
}

// Implement RSColorPickerViewDelegate
- (void)colorPickerDidChangeSelection:(RSColorPickerView *)colorPicker {

    UIColor *selectedColor = [colorPicker selectionColor];
    //todo: something ......
}


// Implement RSBrightnessSliderDelegate
- (void)brightnessSlide:(RSBrightnessSlider *)brightnessSlider valueChanged:(float)value {
    [_colorPicker setBrightness:value];
}

// Implement RSOpacitySliderDelegate
- (void)opacitySlider:(RSOpacitySlider *)opacitySlider opacityChanged:(float)value {
    [_colorPicker setOpacity:value];
}

```

## Requirements

## Installation

LWColorPicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LWColorPicker'
```

**Carthage**
```ruby
github "luowei/LWColorPicker"
```


## Author

luowei, luowei@wodedata.com

## License

LWColorPicker is available under the MIT license. See the LICENSE file for more info.
