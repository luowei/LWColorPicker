//
//  ColorPickerView.swift
//  LWColorPicker
//
//  Swift/SwiftUI version of RSColorPickerView
//

import SwiftUI

// MARK: - Color Picker Delegate Protocol

/// Protocol for color picker view delegate
public protocol ColorPickerViewDelegate: AnyObject {
    /// Called every time the color picker's selection/color is changed
    func colorPickerDidChangeSelection(_ colorPicker: ColorPickerView)

    /// Optional: Called when touches begin
    func colorPickerTouchesBegan(_ colorPicker: ColorPickerView)

    /// Optional: Called when touches end
    func colorPickerTouchesEnded(_ colorPicker: ColorPickerView)
}

extension ColorPickerViewDelegate {
    func colorPickerTouchesBegan(_ colorPicker: ColorPickerView) {}
    func colorPickerTouchesEnded(_ colorPicker: ColorPickerView) {}
}

// MARK: - SwiftUI Color Picker View

/// A SwiftUI color picker view that displays a color wheel or gradient
public struct ColorPickerView: View {
    // MARK: - Properties

    @StateObject private var pickerState: ColorPickerState
    @State private var selectionPosition: CGPoint = .zero
    @State private var showLoupe: Bool = true
    @State private var isDragging: Bool = false

    public var cropToCircle: Bool = false
    public weak var delegate: ColorPickerViewDelegate?

    private let paddingDistance: CGFloat = 11.0  // kSelectionViewSize / 2

    // MARK: - Bindings

    @Binding public var brightness: CGFloat
    @Binding public var opacity: CGFloat
    @Binding public var selectedColor: Color

    // MARK: - Initialization

    public init(
        selectedColor: Binding<Color> = .constant(.white),
        brightness: Binding<CGFloat> = .constant(1.0),
        opacity: Binding<CGFloat> = .constant(1.0),
        cropToCircle: Bool = false,
        showLoupe: Bool = true
    ) {
        self._selectedColor = selectedColor
        self._brightness = brightness
        self._opacity = opacity
        self.cropToCircle = cropToCircle
        self._showLoupe = State(initialValue: showLoupe)

        let uiColor = UIColor(selectedColor.wrappedValue)
        let size = CGSize(width: 300, height: 300)  // Default size
        self._pickerState = StateObject(wrappedValue: ColorPickerState(color: uiColor, size: size))
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient layer
                colorWheelGradient(size: geometry.size)
                    .clipShape(containerShape(size: geometry.size))

                // Brightness overlay
                Color.black
                    .opacity(1 - brightness)
                    .clipShape(containerShape(size: geometry.size))

                // Opacity background
                if opacity < 1.0 {
                    checkeredBackground
                        .opacity(1 - opacity)
                        .clipShape(containerShape(size: geometry.size))
                }

                // Selection indicator
                SelectionIndicator()
                    .position(selectionPosition)

                // Loupe (magnifier) when dragging
                if isDragging && showLoupe {
                    LoupeView(color: selectedColor)
                        .position(x: selectionPosition.x, y: selectionPosition.y - 60)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        handleDrag(at: value.location, in: geometry.size)
                        if !isDragging {
                            isDragging = true
                            delegate?.colorPickerTouchesBegan(self as! ColorPickerView)
                        }
                    }
                    .onEnded { value in
                        handleDrag(at: value.location, in: geometry.size)
                        isDragging = false
                        delegate?.colorPickerTouchesEnded(self as! ColorPickerView)
                    }
            )
            .onAppear {
                updateSelectionPosition(size: geometry.size)
            }
            .onChange(of: selectedColor) { _ in
                updateFromColor(size: geometry.size)
            }
        }
        .aspectRatio(cropToCircle ? 1 : nil, contentMode: .fit)
    }

    // MARK: - Helper Views

    @ViewBuilder
    private func containerShape(size: CGSize) -> some Shape {
        if cropToCircle {
            Circle()
        } else {
            Rectangle()
        }
    }

    private var checkeredBackground: some View {
        Image(uiImage: createCheckeredImage())
            .resizable(resizingMode: .tile)
    }

    private func createCheckeredImage() -> UIImage {
        createOpacityBackgroundImage(length: 20, scale: 2.0, color: UIColor(white: 0.5, alpha: 1.0)) ?? UIImage()
    }

    // MARK: - Color Wheel Gradient

    private func colorWheelGradient(size: CGSize) -> some View {
        GeometryReader { _ in
            if cropToCircle {
                RadialGradient(
                    gradient: Gradient(colors: createHueColors()),
                    center: .center,
                    startRadius: 0,
                    endRadius: min(size.width, size.height) / 2
                )
            } else {
                LinearGradient(
                    gradient: Gradient(colors: createHueColors()),
                    startPoint: size.width > size.height ? .leading : .top,
                    endPoint: size.width > size.height ? .trailing : .bottom
                )
            }
        }
    }

    private func createHueColors() -> [Color] {
        stride(from: 0.0, to: 1.0, by: 1.0 / 360.0).map { hue in
            Color(hue: hue, saturation: 1.0, brightness: 1.0)
        }
    }

    // MARK: - Touch Handling

    private func handleDrag(at point: CGPoint, in size: CGSize) {
        let validPoint = validPoint(for: point, in: size)
        updateState(for: validPoint, size: size)
        updateSelectionPosition(size: size)
        delegate?.colorPickerDidChangeSelection(self as! ColorPickerView)
    }

    private func validPoint(for point: CGPoint, in size: CGSize) -> CGPoint {
        if cropToCircle {
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let dx = point.x - center.x
            let dy = point.y - center.y
            let distance = sqrt(dx * dx + dy * dy)
            let maxRadius = (min(size.width, size.height) / 2) - paddingDistance

            if distance <= maxRadius {
                return point
            } else {
                let angle = atan2(dy, dx)
                return CGPoint(
                    x: center.x + maxRadius * cos(angle),
                    y: center.y + maxRadius * sin(angle)
                )
            }
        } else {
            let isRectangle = size.width != size.height
            var validPoint = point

            if isRectangle {
                validPoint.x = max(0, min(size.width, point.x))
                validPoint.y = max(0, min(size.height, point.y))
            } else {
                validPoint.x = max(paddingDistance, min(size.width - paddingDistance, point.x))
                validPoint.y = max(paddingDistance, min(size.height - paddingDistance, point.y))
            }

            return validPoint
        }
    }

    private func updateState(for point: CGPoint, size: CGSize) {
        let newState = ColorPickerState.state(for: point, size: size, padding: paddingDistance)
        _ = newState.settingBrightness(brightness).settingAlpha(opacity)

        selectedColor = Color(newState.color)
        pickerState.hue = newState.hue
        pickerState.saturation = newState.saturation
    }

    private func updateSelectionPosition(size: CGSize) {
        selectionPosition = pickerState.selectionLocation(size: size, padding: paddingDistance)
    }

    private func updateFromColor(size: CGSize) {
        let newState = ColorPickerState(color: UIColor(selectedColor), size: size)
        pickerState.hue = newState.hue
        pickerState.saturation = newState.saturation
        updateSelectionPosition(size: size)
    }

    // MARK: - Public Methods

    /// Get color at a specific point
    public func colorAt(point: CGPoint, size: CGSize) -> Color {
        let state = ColorPickerState.state(for: point, size: size, padding: paddingDistance)
        return Color(state.color)
    }
}

// MARK: - Selection Indicator

struct SelectionIndicator: View {
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.white.opacity(0.4), lineWidth: 3)
                .frame(width: 22, height: 22)

            Circle()
                .strokeBorder(Color.black, lineWidth: 2)
                .frame(width: 16, height: 16)
        }
    }
}

// MARK: - Loupe View

struct LoupeView: View {
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 60, height: 60)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)

            Circle()
                .strokeBorder(Color.white, lineWidth: 3)
                .frame(width: 60, height: 60)

            Circle()
                .strokeBorder(Color.black, lineWidth: 2)
                .frame(width: 54, height: 54)
        }
    }
}

// MARK: - Preview

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(
            selectedColor: .constant(.red),
            brightness: .constant(1.0),
            opacity: .constant(1.0),
            cropToCircle: true,
            showLoupe: true
        )
        .frame(width: 300, height: 300)
        .padding()
    }
}
