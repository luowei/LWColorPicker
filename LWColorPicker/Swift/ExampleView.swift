//
//  ExampleView.swift
//  LWColorPicker
//
//  Example usage of LWColorPicker in SwiftUI
//

import SwiftUI

// MARK: - Example View

/// Example view demonstrating the usage of LWColorPicker
struct ColorPickerExampleView: View {
    @State private var selectedColor: Color = .red
    @State private var useCircle: Bool = true
    @State private var showBrightness: Bool = true
    @State private var showOpacity: Bool = true
    @State private var showLoupe: Bool = true

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Main Color Picker
                    LWColorPicker(
                        selectedColor: $selectedColor,
                        cropToCircle: useCircle,
                        showBrightnessSlider: showBrightness,
                        showOpacitySlider: showOpacity,
                        showLoupe: showLoupe
                    )
                    .padding()

                    // Options
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Options")
                            .font(.headline)
                            .padding(.horizontal)

                        Toggle("Circular Picker", isOn: $useCircle)
                            .padding(.horizontal)

                        Toggle("Show Brightness Slider", isOn: $showBrightness)
                            .padding(.horizontal)

                        Toggle("Show Opacity Slider", isOn: $showOpacity)
                            .padding(.horizontal)

                        Toggle("Show Loupe", isOn: $showLoupe)
                            .padding(.horizontal)
                    }

                    // Color Information
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Color Information")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack {
                            Text("RGB:")
                                .fontWeight(.medium)
                            Text(rgbString)
                                .font(.system(.body, design: .monospaced))
                        }
                        .padding(.horizontal)

                        HStack {
                            Text("HSB:")
                                .fontWeight(.medium)
                            Text(hsbString)
                                .font(.system(.body, design: .monospaced))
                        }
                        .padding(.horizontal)
                    }

                    // Color Preview Samples
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Color Preview")
                            .font(.headline)
                            .padding(.horizontal)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            ColorSampleCard(color: selectedColor, title: "Fill")
                            ColorSampleCard(color: selectedColor.opacity(0.5), title: "50% Opacity")
                            ColorSampleCard(color: selectedColor, title: "Border", isBorder: true)
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("LWColorPicker")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Helper Properties

    private var rgbString: String {
        let uiColor = UIColor(selectedColor)
        let components = getComponentsForColor(uiColor)
        let r = Int(components.r * 255)
        let g = Int(components.g * 255)
        let b = Int(components.b * 255)
        let a = Int(components.a * 100)
        return "R:\(r) G:\(g) B:\(b) A:\(a)%"
    }

    private var hsbString: String {
        let uiColor = UIColor(selectedColor)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        let hDeg = Int(h * 360)
        let sPct = Int(s * 100)
        let bPct = Int(b * 100)
        let aPct = Int(a * 100)
        return "H:\(hDeg)° S:\(sPct)% B:\(bPct)% A:\(aPct)%"
    }
}

// MARK: - Color Sample Card

struct ColorSampleCard: View {
    let color: Color
    let title: String
    var isBorder: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            if isBorder {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 4)
                    .frame(height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemBackground))
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .frame(height: 80)
            }

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Standalone Component Examples

struct BrightnessSliderExample: View {
    @State private var brightness: CGFloat = 0.8

    var body: some View {
        VStack(spacing: 20) {
            Text("Brightness: \(Int(brightness * 100))%")
                .font(.headline)

            BrightnessSlider(brightness: $brightness)
                .frame(height: 30)
                .padding(.horizontal)

            Rectangle()
                .fill(Color.white.opacity(brightness))
                .frame(height: 100)
                .cornerRadius(12)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct OpacitySliderExample: View {
    @State private var opacity: CGFloat = 0.8

    var body: some View {
        VStack(spacing: 20) {
            Text("Opacity: \(Int(opacity * 100))%")
                .font(.headline)

            OpacitySlider(opacity: $opacity)
                .frame(height: 30)
                .padding(.horizontal)

            ZStack {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .foregroundColor(.gray)

                Rectangle()
                    .fill(Color.blue.opacity(opacity))
                    .frame(height: 100)
            }
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .padding()
    }
}

struct ColorPickerViewExample: View {
    @State private var selectedColor: Color = .red
    @State private var brightness: CGFloat = 1.0
    @State private var opacity: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 20) {
            ColorPickerView(
                selectedColor: $selectedColor,
                brightness: $brightness,
                opacity: $opacity,
                cropToCircle: true,
                showLoupe: true
            )
            .frame(width: 300, height: 300)

            Text("Selected: \(colorDescription)")
                .font(.caption)
                .padding()
        }
    }

    private var colorDescription: String {
        let uiColor = UIColor(selectedColor)
        let components = getComponentsForColor(uiColor)
        let r = Int(components.r * 255)
        let g = Int(components.g * 255)
        let b = Int(components.b * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

// MARK: - Preview

struct ColorPickerExampleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ColorPickerExampleView()

            BrightnessSliderExample()
                .previewDisplayName("Brightness Slider")

            OpacitySliderExample()
                .previewDisplayName("Opacity Slider")

            ColorPickerViewExample()
                .previewDisplayName("Color Picker View")
        }
    }
}
