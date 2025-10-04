# LWColorPicker - Swift/SwiftUI Version

A modern, native Swift/SwiftUI implementation of the LWColorPicker library, providing an elegant color picker interface for iOS applications.

## Overview

This is a complete Swift/SwiftUI rewrite of the original Objective-C LWColorPicker library. It maintains the same functionality while leveraging modern Swift features and SwiftUI's declarative syntax.

## Features

- **SwiftUI Native**: Built entirely with SwiftUI for modern iOS development
- **Color Wheel/Gradient**: Interactive color selection with circular or rectangular gradients
- **Brightness Control**: Adjustable brightness slider with gradient visualization
- **Opacity Control**: Alpha channel support with checkered background
- **Live Preview**: Real-time color preview with hex and RGB/HSB values
- **Magnifier Loupe**: Optional magnifying glass during color selection
- **UIKit Compatibility**: Wrapper classes for UIKit integration
- **Customizable**: Various display options and configurations

## Components

### Main Components

1. **LWColorPicker**: Complete color picker with all controls
2. **ColorPickerView**: Core color wheel/gradient picker
3. **BrightnessSlider**: Brightness adjustment slider
4. **OpacitySlider**: Alpha/opacity adjustment slider
5. **ColorPickerState**: State management for color values
6. **ColorFunctions**: Utility functions for color conversions

## Usage

### SwiftUI Usage

```swift
import SwiftUI

struct ContentView: View {
    @State private var selectedColor: Color = .red

    var body: some View {
        LWColorPicker(
            selectedColor: $selectedColor,
            cropToCircle: true,
            showBrightnessSlider: true,
            showOpacitySlider: true,
            showLoupe: true
        )
        .padding()
    }
}
```

### Individual Components

```swift
// Just the color picker wheel
ColorPickerView(
    selectedColor: $color,
    brightness: $brightness,
    opacity: $opacity,
    cropToCircle: true,
    showLoupe: true
)

// Brightness slider only
BrightnessSlider(brightness: $brightness)

// Opacity slider only
OpacitySlider(opacity: $opacity)
```

### UIKit Integration

```swift
import UIKit

class ViewController: UIViewController {
    let colorPicker = LWColorPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        colorPicker.cropToCircle = true
        colorPicker.showBrightnessSlider = true
        colorPicker.showOpacitySlider = true

        view.addSubview(colorPicker)
        // Set up constraints...
    }
}
```

## API Reference

### LWColorPicker

| Property | Type | Description |
|----------|------|-------------|
| `selectedColor` | `Binding<Color>` | The currently selected color |
| `cropToCircle` | `Bool` | Display as circle (true) or square (false) |
| `showBrightnessSlider` | `Bool` | Show/hide brightness control |
| `showOpacitySlider` | `Bool` | Show/hide opacity control |
| `showLoupe` | `Bool` | Show/hide magnifying loupe |

### ColorPickerView

| Property | Type | Description |
|----------|------|-------------|
| `selectedColor` | `Binding<Color>` | Selected color binding |
| `brightness` | `Binding<CGFloat>` | Brightness value (0.0 - 1.0) |
| `opacity` | `Binding<CGFloat>` | Opacity value (0.0 - 1.0) |
| `cropToCircle` | `Bool` | Circle or square shape |
| `showLoupe` | `Bool` | Display magnifying loupe |
| `delegate` | `ColorPickerViewDelegate?` | Delegate for color changes |

### ColorPickerViewDelegate

```swift
protocol ColorPickerViewDelegate: AnyObject {
    func colorPickerDidChangeSelection(_ colorPicker: ColorPickerView)
    func colorPickerTouchesBegan(_ colorPicker: ColorPickerView)
    func colorPickerTouchesEnded(_ colorPicker: ColorPickerView)
}
```

### BrightnessSlider / OpacitySlider

| Property | Type | Description |
|----------|------|-------------|
| `brightness/opacity` | `Binding<CGFloat>` | Value binding (0.0 - 1.0) |
| `delegate` | `BrightnessSliderDelegate?` / `OpacitySliderDelegate?` | Delegate for value changes |

## Customization

### Appearance Options

```swift
LWColorPicker(selectedColor: $color)
    .cropToCircle(true)           // Circle or rectangle
    .showBrightnessSlider(true)   // Show brightness control
    .showOpacitySlider(true)      // Show opacity control
    .showLoupe(false)             // Hide magnifying glass
```

### Color Information

Get color information from the selected color:

```swift
let uiColor = UIColor(selectedColor)
let components = getComponentsForColor(uiColor)

// RGB values (0.0 - 1.0)
let red = components.r
let green = components.g
let blue = components.b
let alpha = components.a

// HSB values
var hue: CGFloat = 0
var saturation: CGFloat = 0
var brightness: CGFloat = 0
uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
```

## File Structure

```
Swift/
├── LWColorPicker.swift          # Main complete picker component
├── ColorPickerView.swift        # Core color wheel/gradient view
├── ColorPickerState.swift       # State management
├── BrightnessSlider.swift       # Brightness slider component
├── OpacitySlider.swift          # Opacity slider component
├── ColorFunctions.swift         # Utility functions
├── ExampleView.swift            # Example usage and demos
└── README.md                    # This file
```

## Requirements

- iOS 14.0+
- Swift 5.5+
- SwiftUI
- Xcode 13.0+

## Migration from Objective-C Version

### Class Name Mappings

| Objective-C | Swift/SwiftUI |
|-------------|---------------|
| `RSColorPickerView` | `ColorPickerView` |
| `RSColorPickerState` | `ColorPickerState` |
| `RSBrightnessSlider` | `BrightnessSlider` |
| `RSOpacitySlider` | `OpacitySlider` |
| `RSColorFunctions` | `ColorFunctions` |

### Key Differences

1. **SwiftUI First**: Primary implementation uses SwiftUI
2. **Property Wrappers**: Uses `@State`, `@Binding`, `@StateObject`
3. **Reactive**: Automatic UI updates through bindings
4. **Type Safety**: Strong Swift typing instead of Objective-C conventions
5. **Modern APIs**: Uses Swift-native color and graphics APIs

### Delegate Pattern

The Swift version maintains delegate compatibility but also supports SwiftUI bindings:

```swift
// Objective-C style with delegate
class MyView: ColorPickerViewDelegate {
    func colorPickerDidChangeSelection(_ colorPicker: ColorPickerView) {
        // Handle color change
    }
}

// SwiftUI style with binding
@State var color: Color = .red
LWColorPicker(selectedColor: $color)
    .onChange(of: color) { newColor in
        // Handle color change
    }
```

## Examples

See `ExampleView.swift` for comprehensive examples including:

- Complete color picker with all controls
- Individual component usage
- Color information display
- RGB and HSB value extraction
- Custom styling and layouts

## License

Same license as the original LWColorPicker library.

## Author

Swift/SwiftUI version adapted from the original Objective-C implementation by Luo Wei.
