# LWColorPicker Swift Version

This document describes how to use the Swift/SwiftUI version of LWColorPicker.

## Overview

LWColorPicker_swift is a modern Swift/SwiftUI implementation of the LWColorPicker library. It provides a beautiful, customizable color picker with full support for SwiftUI, Combine framework, and modern Swift patterns.

## Requirements

- iOS 14.0+
- Swift 5.0+
- Xcode 12.0+

## Installation

### CocoaPods

Add the following line to your Podfile:

```ruby
pod 'LWColorPicker_swift'
```

Then run:
```bash
pod install
```

## Key Features

- **SwiftUI Native** - Built from the ground up for SwiftUI
- **HSB Color Model** - Hue, Saturation, Brightness color selection
- **Multiple Layouts** - Circular and rectangular color wheel options
- **Real-time Preview** - Live color preview as you select
- **Opacity Control** - Built-in alpha channel slider
- **Hex Support** - Input and output colors as hex strings
- **Type Safe** - Full Swift type safety with Color and UIColor
- **Combine Integration** - Reactive color updates with publishers

## Quick Start

### Basic Color Picker

```swift
import SwiftUI
import LWColorPicker_swift

struct ContentView: View {
    @State private var selectedColor: Color = .blue

    var body: some View {
        VStack {
            ColorPickerView(selectedColor: $selectedColor)
                .frame(height: 300)

            Text("Selected Color")
                .foregroundColor(selectedColor)
                .font(.headline)
        }
    }
}
```

### With Brightness and Opacity Sliders

```swift
struct AdvancedColorPickerView: View {
    @State private var selectedColor: Color = .red
    @State private var brightness: Double = 1.0
    @State private var opacity: Double = 1.0

    var body: some View {
        VStack(spacing: 20) {
            ColorPickerView(selectedColor: $selectedColor)
                .frame(height: 250)

            BrightnessSlider(value: $brightness, color: selectedColor)
                .frame(height: 40)

            OpacitySlider(value: $opacity, color: selectedColor)
                .frame(height: 40)

            // Final color with brightness and opacity
            Rectangle()
                .fill(selectedColor.opacity(opacity))
                .brightness(brightness - 1.0)
                .frame(height: 60)
                .cornerRadius(8)
        }
        .padding()
    }
}
```

### Circular Color Wheel

```swift
struct CircularPickerView: View {
    @State private var selectedColor: Color = .green

    var body: some View {
        ColorPickerView(
            selectedColor: $selectedColor,
            style: .circular
        )
        .frame(width: 300, height: 300)
    }
}
```

## Advanced Usage

### Color Picker State Management

```swift
import LWColorPicker_swift

class ColorPickerViewModel: ObservableObject {
    @Published var colorState = ColorPickerState()

    var currentColor: Color {
        colorState.selectedColor
    }

    var hexString: String {
        colorState.hexString
    }

    func setColor(from hex: String) {
        colorState.setColor(fromHex: hex)
    }
}

// Usage in view
struct MyView: View {
    @StateObject private var viewModel = ColorPickerViewModel()

    var body: some View {
        VStack {
            ColorPickerView(selectedColor: $viewModel.colorState.selectedColor)

            Text("Hex: \(viewModel.hexString)")
                .monospaced()
        }
    }
}
```

### Custom Color Functions

```swift
import LWColorPicker_swift

// Convert between color spaces
let hsbColor = ColorFunctions.colorToHSB(.blue)
print("Hue: \(hsbColor.hue), Saturation: \(hsbColor.saturation)")

// Create color from HSB
let customColor = ColorFunctions.colorFromHSB(
    hue: 0.5,
    saturation: 0.8,
    brightness: 0.9
)

// Get hex string
let hexString = ColorFunctions.hexString(from: .red)
print(hexString) // "#FF0000"

// Create color from hex
if let color = ColorFunctions.color(fromHex: "#00FF00") {
    print("Created green color")
}
```

### Rectangular Color Picker

```swift
struct RectangularPickerView: View {
    @State private var selectedColor: Color = .purple

    var body: some View {
        VStack {
            ColorPickerView(
                selectedColor: $selectedColor,
                style: .rectangular
            )
            .frame(height: 300)

            HStack {
                Rectangle()
                    .fill(selectedColor)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)

                Text(ColorFunctions.hexString(from: selectedColor))
                    .font(.system(.body, design: .monospaced))
            }
        }
    }
}
```

### Combining with Combine Publishers

```swift
import Combine
import LWColorPicker_swift

class ColorViewModel: ObservableObject {
    @Published var selectedColor: Color = .blue
    @Published var displayHex: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        $selectedColor
            .map { ColorFunctions.hexString(from: $0) }
            .assign(to: &$displayHex)

        $selectedColor
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { color in
                self.saveColorPreference(color)
            }
            .store(in: &cancellables)
    }

    func saveColorPreference(_ color: Color) {
        // Save to UserDefaults or other persistence
    }
}
```

## SwiftUI-Specific Features

### Custom Picker Styles

```swift
extension ColorPickerView {
    enum PickerStyle {
        case circular
        case rectangular
        case wheel
    }
}

// Usage
ColorPickerView(
    selectedColor: $color,
    style: .wheel,
    showsSliders: true
)
```

### Accessibility Support

```swift
ColorPickerView(selectedColor: $selectedColor)
    .accessibilityLabel("Color Picker")
    .accessibilityHint("Drag to select a color")
    .accessibilityValue(ColorFunctions.hexString(from: selectedColor))
```

### Custom Slider Appearance

```swift
BrightnessSlider(value: $brightness, color: selectedColor)
    .accentColor(.white)
    .frame(height: 50)
    .background(
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
    )
```

## Color Palette Management

### Saving Color Palettes

```swift
struct ColorPaletteView: View {
    @State private var selectedColor: Color = .blue
    @State private var savedColors: [Color] = []

    var body: some View {
        VStack {
            ColorPickerView(selectedColor: $selectedColor)
                .frame(height: 300)

            Button("Save Color") {
                savedColors.append(selectedColor)
            }

            ScrollView(.horizontal) {
                HStack {
                    ForEach(savedColors.indices, id: \.self) { index in
                        Rectangle()
                            .fill(savedColors[index])
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedColor = savedColors[index]
                            }
                    }
                }
            }
        }
    }
}
```

### Preset Color Swatches

```swift
struct ColorSwatchPicker: View {
    @Binding var selectedColor: Color

    let presetColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple,
        .pink, .brown, .gray, .black, .white
    ]

    var body: some View {
        VStack(spacing: 20) {
            ColorPickerView(selectedColor: $selectedColor)

            Text("Presets")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                ForEach(presetColors.indices, id: \.self) { index in
                    Rectangle()
                        .fill(presetColors[index])
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: selectedColor == presetColors[index] ? 3 : 0)
                        )
                        .onTapGesture {
                            selectedColor = presetColors[index]
                        }
                }
            }
        }
    }
}
```

## API Reference

### ColorPickerView

```swift
struct ColorPickerView: View {
    @Binding var selectedColor: Color
    var style: PickerStyle = .circular
    var showsSliders: Bool = false

    init(
        selectedColor: Binding<Color>,
        style: PickerStyle = .circular,
        showsSliders: Bool = false
    )
}
```

### ColorPickerState

```swift
class ColorPickerState: ObservableObject {
    @Published var selectedColor: Color
    @Published var hue: Double
    @Published var saturation: Double
    @Published var brightness: Double

    var hexString: String { get }

    func setColor(fromHex hex: String)
    func setColor(hue: Double, saturation: Double, brightness: Double)
}
```

### BrightnessSlider

```swift
struct BrightnessSlider: View {
    @Binding var value: Double
    var color: Color

    init(value: Binding<Double>, color: Color)
}
```

### OpacitySlider

```swift
struct OpacitySlider: View {
    @Binding var value: Double
    var color: Color

    init(value: Binding<Double>, color: Color)
}
```

### ColorFunctions

```swift
enum ColorFunctions {
    static func colorToHSB(_ color: Color) -> (hue: Double, saturation: Double, brightness: Double)
    static func colorFromHSB(hue: Double, saturation: Double, brightness: Double) -> Color
    static func hexString(from color: Color) -> String
    static func color(fromHex hex: String) -> Color?
    static func uiColor(from color: Color) -> UIColor
}
```

## Best Practices

### 1. Use State Management

```swift
// Good - Centralized state
@StateObject private var colorState = ColorPickerState()

// Avoid - Multiple scattered states
@State private var hue: Double = 0
@State private var saturation: Double = 0
@State private var brightness: Double = 0
```

### 2. Debounce Color Changes

```swift
// Prevent excessive updates
$selectedColor
    .debounce(for: 0.3, scheduler: RunLoop.main)
    .sink { color in
        updateUI(with: color)
    }
```

### 3. Handle Color Conversions Efficiently

```swift
// Cache hex conversions
private var hexCache: [Color: String] = [:]

func getHex(for color: Color) -> String {
    if let cached = hexCache[color] {
        return cached
    }
    let hex = ColorFunctions.hexString(from: color)
    hexCache[color] = hex
    return hex
}
```

## Migration from Objective-C Version

### Before (Objective-C)
```objective-c
LWColorPickerView *picker = [[LWColorPickerView alloc] init];
picker.selectedColor = [UIColor blueColor];
[picker setColorChangedBlock:^(UIColor *color) {
    // Handle color change
}];
```

### After (Swift)
```swift
@State private var selectedColor: Color = .blue

ColorPickerView(selectedColor: $selectedColor)
    .onChange(of: selectedColor) { newColor in
        // Handle color change
    }
```

## Troubleshooting

**Q: Colors look different than expected**
- Ensure you're using the correct color space (RGB vs HSB)
- Check if opacity/alpha channel is being applied

**Q: Picker not updating in real-time**
- Verify you're using `@Binding` for the selected color
- Check that the parent view is updating properly

**Q: Performance issues with large color palettes**
- Use `LazyVGrid` or `LazyHGrid` for large collections
- Consider implementing pagination for very large palettes

**Q: Hex input not working**
- Ensure hex strings include the '#' prefix
- Validate hex format (6 or 8 characters after #)

## Examples

Check the `LWColorPicker/Swift/ExampleView.swift` for complete working examples including:

- Basic color picker usage
- Custom picker styles
- Color palette management
- Hex input/output
- Integration with forms

## License

LWColorPicker_swift is available under the MIT license. See the LICENSE file for more information.

## Author

**luowei**
- Email: luowei@wodedata.com
- GitHub: [@luowei](https://github.com/luowei)
