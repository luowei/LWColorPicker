//
//  LWColorPicker.swift
//  LWColorPicker
//
//  Main SwiftUI color picker component that combines all sub-components
//

import SwiftUI

// MARK: - Complete Color Picker Component

/// A complete color picker component with color wheel, brightness, and opacity controls
public struct LWColorPicker: View {
    // MARK: - Properties

    @Binding public var selectedColor: Color
    @State private var brightness: CGFloat = 1.0
    @State private var opacity: CGFloat = 1.0

    public var cropToCircle: Bool = true
    public var showBrightnessSlider: Bool = true
    public var showOpacitySlider: Bool = true
    public var showLoupe: Bool = true

    // MARK: - Initialization

    public init(
        selectedColor: Binding<Color>,
        cropToCircle: Bool = true,
        showBrightnessSlider: Bool = true,
        showOpacitySlider: Bool = true,
        showLoupe: Bool = true
    ) {
        self._selectedColor = selectedColor
        self.cropToCircle = cropToCircle
        self.showBrightnessSlider = showBrightnessSlider
        self.showOpacitySlider = showOpacitySlider
        self.showLoupe = showLoupe
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 20) {
            // Color Picker Wheel/Gradient
            ColorPickerView(
                selectedColor: $selectedColor,
                brightness: $brightness,
                opacity: $opacity,
                cropToCircle: cropToCircle,
                showLoupe: showLoupe
            )
            .aspectRatio(1, contentMode: .fit)

            // Brightness Slider
            if showBrightnessSlider {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Brightness")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    BrightnessSlider(brightness: $brightness)
                        .frame(height: 30)
                }
            }

            // Opacity Slider
            if showOpacitySlider {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Opacity")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    OpacitySlider(opacity: $opacity)
                        .frame(height: 30)
                }
            }

            // Selected Color Preview
            HStack(spacing: 15) {
                Text("Selected Color:")
                    .font(.subheadline)

                ZStack {
                    // Checkered background
                    checkeredBackground
                        .frame(width: 60, height: 40)
                        .cornerRadius(8)

                    // Selected color
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedColor)
                        .frame(width: 60, height: 40)
                }

                // Color hex value
                Text(colorHexString)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
            }
        }
        .onChange(of: brightness) { _ in
            updateColorWithBrightness()
        }
        .onChange(of: opacity) { _ in
            updateColorWithOpacity()
        }
    }

    // MARK: - Helper Views

    private var checkeredBackground: some View {
        Image(uiImage: createCheckeredImage())
            .resizable(resizingMode: .tile)
    }

    private func createCheckeredImage() -> UIImage {
        createOpacityBackgroundImage(
            length: 10,
            scale: 2.0,
            color: UIColor(white: 0.8, alpha: 1.0)
        ) ?? UIImage()
    }

    // MARK: - Helper Methods

    private var colorHexString: String {
        let uiColor = UIColor(selectedColor)
        let components = getComponentsForColor(uiColor)
        let r = Int(components.r * 255)
        let g = Int(components.g * 255)
        let b = Int(components.b * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    private func updateColorWithBrightness() {
        let uiColor = UIColor(selectedColor)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        selectedColor = Color(
            UIColor(hue: h, saturation: s, brightness: brightness, alpha: a)
        )
    }

    private func updateColorWithOpacity() {
        let uiColor = UIColor(selectedColor)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        selectedColor = Color(
            UIColor(hue: h, saturation: s, brightness: b, alpha: opacity)
        )
    }
}

// MARK: - UIKit Wrapper

/// UIKit wrapper for LWColorPicker to maintain API compatibility
public class LWColorPickerView: UIView {
    // MARK: - Properties

    private var hostingController: UIHostingController<LWColorPicker>?
    private var colorBinding: Binding<Color>
    private var currentColor: Color = .white

    public var selectedColor: UIColor {
        get { UIColor(currentColor) }
        set {
            currentColor = Color(newValue)
            updatePicker()
        }
    }

    public var cropToCircle: Bool = true {
        didSet { updatePicker() }
    }

    public var showBrightnessSlider: Bool = true {
        didSet { updatePicker() }
    }

    public var showOpacitySlider: Bool = true {
        didSet { updatePicker() }
    }

    public var showLoupe: Bool = true {
        didSet { updatePicker() }
    }

    // MARK: - Initialization

    public override init(frame: CGRect) {
        colorBinding = Binding(
            get: { .white },
            set: { _ in }
        )
        super.init(frame: frame)
        setupPicker()
    }

    public required init?(coder: NSCoder) {
        colorBinding = Binding(
            get: { .white },
            set: { _ in }
        )
        super.init(coder: coder)
        setupPicker()
    }

    // MARK: - Setup

    private func setupPicker() {
        colorBinding = Binding(
            get: { [weak self] in
                self?.currentColor ?? .white
            },
            set: { [weak self] newValue in
                self?.currentColor = newValue
            }
        )

        let picker = LWColorPicker(
            selectedColor: colorBinding,
            cropToCircle: cropToCircle,
            showBrightnessSlider: showBrightnessSlider,
            showOpacitySlider: showOpacitySlider,
            showLoupe: showLoupe
        )

        let hosting = UIHostingController(rootView: picker)
        hostingController = hosting

        addSubview(hosting.view)
        hosting.view.backgroundColor = .clear
        hosting.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: topAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func updatePicker() {
        let picker = LWColorPicker(
            selectedColor: colorBinding,
            cropToCircle: cropToCircle,
            showBrightnessSlider: showBrightnessSlider,
            showOpacitySlider: showOpacitySlider,
            showLoupe: showLoupe
        )
        hostingController?.rootView = picker
    }
}

// MARK: - Preview

struct LWColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        LWColorPicker(
            selectedColor: .constant(.red),
            cropToCircle: true,
            showBrightnessSlider: true,
            showOpacitySlider: true,
            showLoupe: true
        )
        .padding()
    }
}
