# LWColorPicker Swift/SwiftUI Integration Guide

This guide helps you integrate the Swift/SwiftUI version of LWColorPicker into your iOS project.

## Quick Start

### 1. Add Files to Your Project

Copy all Swift files from the `Swift/` directory to your Xcode project:

```
Swift/
├── LWColorPicker.swift
├── ColorPickerView.swift
├── ColorPickerState.swift
├── BrightnessSlider.swift
├── OpacitySlider.swift
├── ColorFunctions.swift
└── ExampleView.swift (optional - for reference)
```

### 2. Import in Your SwiftUI Views

```swift
import SwiftUI

struct MyView: View {
    @State private var selectedColor: Color = .blue

    var body: some View {
        VStack {
            LWColorPicker(selectedColor: $selectedColor)
                .frame(width: 300)
                .padding()

            Text("You selected: \(colorHex)")
        }
    }

    var colorHex: String {
        let uiColor = UIColor(selectedColor)
        let components = getComponentsForColor(uiColor)
        return String(format: "#%02X%02X%02X",
            Int(components.r * 255),
            Int(components.g * 255),
            Int(components.b * 255)
        )
    }
}
```

### 3. Use in UIKit Projects

```swift
import UIKit

class ColorPickerViewController: UIViewController {
    private let colorPickerView = LWColorPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupColorPicker()
    }

    private func setupColorPicker() {
        view.addSubview(colorPickerView)
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            colorPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            colorPickerView.widthAnchor.constraint(equalToConstant: 300),
            colorPickerView.heightAnchor.constraint(equalToConstant: 400)
        ])

        colorPickerView.cropToCircle = true
        colorPickerView.selectedColor = .systemRed
    }
}
```

## Common Use Cases

### 1. Full-Featured Color Picker

```swift
struct FullColorPicker: View {
    @State private var color: Color = .red

    var body: some View {
        LWColorPicker(
            selectedColor: $color,
            cropToCircle: true,
            showBrightnessSlider: true,
            showOpacitySlider: true,
            showLoupe: true
        )
    }
}
```

### 2. Simple Color Wheel Only

```swift
struct SimpleColorWheel: View {
    @State private var color: Color = .blue
    @State private var brightness: CGFloat = 1.0
    @State private var opacity: CGFloat = 1.0

    var body: some View {
        ColorPickerView(
            selectedColor: $color,
            brightness: $brightness,
            opacity: $opacity,
            cropToCircle: true
        )
        .frame(width: 300, height: 300)
    }
}
```

### 3. With Custom Controls

```swift
struct CustomControlsPicker: View {
    @State private var color: Color = .green
    @State private var brightness: CGFloat = 1.0
    @State private var opacity: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 20) {
            // Color wheel
            ColorPickerView(
                selectedColor: $color,
                brightness: $brightness,
                opacity: $opacity,
                cropToCircle: true
            )
            .frame(width: 280, height: 280)

            // Custom brightness control
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "sun.min")
                    BrightnessSlider(brightness: $brightness)
                    Image(systemName: "sun.max")
                }

                HStack {
                    Image(systemName: "circle.slash")
                    OpacitySlider(opacity: $opacity)
                    Image(systemName: "circle.fill")
                }
            }
            .padding(.horizontal)
        }
    }
}
```

### 4. With Color Information Display

```swift
struct ColorPickerWithInfo: View {
    @State private var color: Color = .purple

    var body: some View {
        VStack(spacing: 20) {
            LWColorPicker(selectedColor: $color)
                .frame(maxWidth: 350)

            // Color info
            VStack(alignment: .leading, spacing: 10) {
                InfoRow(label: "Hex", value: hexString)
                InfoRow(label: "RGB", value: rgbString)
                InfoRow(label: "HSB", value: hsbString)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding()
    }

    private var hexString: String {
        let uiColor = UIColor(color)
        let c = getComponentsForColor(uiColor)
        return String(format: "#%02X%02X%02X",
            Int(c.r * 255), Int(c.g * 255), Int(c.b * 255))
    }

    private var rgbString: String {
        let uiColor = UIColor(color)
        let c = getComponentsForColor(uiColor)
        return String(format: "R:%d G:%d B:%d",
            Int(c.r * 255), Int(c.g * 255), Int(c.b * 255))
    }

    private var hsbString: String {
        let uiColor = UIColor(color)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        return String(format: "H:%d° S:%d%% B:%d%%",
            Int(h * 360), Int(s * 100), Int(b * 100))
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.medium)
            Text(value)
                .font(.system(.body, design: .monospaced))
            Spacer()
        }
    }
}
```

### 5. With Delegate Pattern

```swift
class ColorPickerCoordinator: ColorPickerViewDelegate {
    func colorPickerDidChangeSelection(_ colorPicker: ColorPickerView) {
        print("Color changed!")
    }

    func colorPickerTouchesBegan(_ colorPicker: ColorPickerView) {
        print("User started picking")
    }

    func colorPickerTouchesEnded(_ colorPicker: ColorPickerView) {
        print("User finished picking")
    }
}

// Usage
let coordinator = ColorPickerCoordinator()
ColorPickerView(selectedColor: $color)
    .delegate = coordinator
```

### 6. Rectangular Color Bar

```swift
struct RectangularColorPicker: View {
    @State private var color: Color = .orange

    var body: some View {
        LWColorPicker(
            selectedColor: $color,
            cropToCircle: false,  // Use rectangle
            showBrightnessSlider: true,
            showOpacitySlider: false
        )
        .frame(width: 300, height: 100)
    }
}
```

## Advanced Features

### Save and Load Colors

```swift
struct PersistentColorPicker: View {
    @AppStorage("savedColor") private var savedColorData: Data = Data()
    @State private var color: Color = .blue

    var body: some View {
        VStack {
            LWColorPicker(selectedColor: $color)
                .onChange(of: color) { newColor in
                    saveColor(newColor)
                }
                .onAppear {
                    loadColor()
                }

            Button("Reset to Default") {
                color = .blue
            }
        }
    }

    private func saveColor(_ color: Color) {
        if let encoded = try? JSONEncoder().encode(
            UIColor(color).cgColor.components
        ) {
            savedColorData = encoded
        }
    }

    private func loadColor() {
        if let components = try? JSONDecoder().decode(
            [CGFloat].self, from: savedColorData
        ), components.count >= 3 {
            color = Color(
                red: components[0],
                green: components[1],
                blue: components[2]
            )
        }
    }
}
```

### Multiple Color Pickers

```swift
struct MultipleColorPickers: View {
    @State private var primaryColor: Color = .red
    @State private var secondaryColor: Color = .blue

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack {
                    Text("Primary Color")
                        .font(.headline)
                    LWColorPicker(selectedColor: $primaryColor)
                }

                VStack {
                    Text("Secondary Color")
                        .font(.headline)
                    LWColorPicker(selectedColor: $secondaryColor)
                }

                // Preview both colors
                HStack(spacing: 20) {
                    Circle()
                        .fill(primaryColor)
                        .frame(width: 100, height: 100)

                    Circle()
                        .fill(secondaryColor)
                        .frame(width: 100, height: 100)
                }
            }
            .padding()
        }
    }
}
```

## Troubleshooting

### Issue: Color picker not showing

**Solution**: Ensure you've imported SwiftUI and the view has a defined frame:

```swift
LWColorPicker(selectedColor: $color)
    .frame(width: 300)  // Add explicit frame
```

### Issue: UIKit wrapper not updating

**Solution**: Make sure you're updating the `selectedColor` property correctly:

```swift
colorPickerView.selectedColor = UIColor.systemBlue
// Not: colorPickerView.selectedColor = .systemBlue
```

### Issue: Delegate methods not called

**Solution**: Keep a strong reference to your delegate:

```swift
class MyView {
    let coordinator = ColorPickerCoordinator()  // Strong reference

    func setup() {
        colorPicker.delegate = coordinator
    }
}
```

## Performance Tips

1. **Reuse Instances**: Create color picker instances once and reuse them
2. **Limit Updates**: Use `.onChange` with debouncing for expensive operations
3. **Background Processing**: Perform color conversions off the main thread if needed

```swift
LWColorPicker(selectedColor: $color)
    .onChange(of: color) { newColor in
        // Debounce or throttle expensive operations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Perform expensive operation
        }
    }
```

## Next Steps

- Check out `ExampleView.swift` for more comprehensive examples
- Read `README.md` for full API documentation
- Explore the source code to understand implementation details

## Support

For issues or questions specific to the Swift/SwiftUI version, please refer to the implementation files or the original Objective-C version for comparison.
