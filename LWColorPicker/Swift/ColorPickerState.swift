//
//  ColorPickerState.swift
//  LWColorPicker
//
//  Swift/SwiftUI version of RSColorPickerState
//

import SwiftUI
import UIKit

/// Represents the state of a color picker.
/// This includes the position on the color picker (for a square picker)
/// that is selected, along with brightness and alpha values.
class ColorPickerState: ObservableObject {
    // MARK: - Properties

    @Published var hue: CGFloat
    @Published var saturation: CGFloat
    @Published var brightness: CGFloat
    @Published var alpha: CGFloat

    private var wheelSize: CGSize
    private var scaledRelativePoint: CGPoint

    // MARK: - Computed Properties

    var color: UIColor {
        UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    // MARK: - Initialization

    /// Creates a state for a given point on a color picker
    static func state(for point: CGPoint, size: CGSize, padding: CGFloat) -> ColorPickerState {
        let isRectangle = size.width != size.height
        let isHorizontal = size.width > size.height

        let scaledPoint: CGPoint
        if isRectangle {
            if isHorizontal {
                scaledPoint = CGPoint(x: point.x, y: size.height / 2)
            } else {
                scaledPoint = CGPoint(x: size.width / 2, y: point.y)
            }
        } else {
            let relativePoint = CGPoint(
                x: point.x - (size.width / 2.0),
                y: (size.width / 2.0) - point.y
            )
            scaledPoint = CGPoint(
                x: relativePoint.x / ((size.width / 2.0) - padding),
                y: relativePoint.y / ((size.width / 2.0) - padding)
            )
        }

        return ColorPickerState(
            scaledRelativePoint: scaledPoint,
            brightness: 1.0,
            alpha: 1.0,
            size: size
        )
    }

    /// Initialize with a color
    init(color: UIColor, size: CGSize) {
        self.wheelSize = size

        let components = getComponentsForColor(color)
        let uiColor = UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)

        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        self.hue = h
        self.saturation = s
        self.brightness = b
        self.alpha = a
        self.scaledRelativePoint = ColorPickerState.calculatePoint(hue: h, saturation: s, wheelSize: size)
    }

    /// Initialize with scaled relative point
    init(scaledRelativePoint: CGPoint, brightness: CGFloat, alpha: CGFloat, size: CGSize) {
        self.scaledRelativePoint = scaledRelativePoint
        self.brightness = brightness
        self.alpha = alpha
        self.wheelSize = size

        let (h, s) = ColorPickerState.calculateHueSaturation(
            from: scaledRelativePoint,
            wheelSize: size
        )
        self.hue = h
        self.saturation = s
    }

    // MARK: - Selection Location

    /// Returns the position of this state on a color picker
    func selectionLocation(size: CGSize, padding: CGFloat) -> CGPoint {
        let isRectangle = size.width != size.height

        if isRectangle {
            return scaledRelativePoint
        } else {
            var unscaled = scaledRelativePoint
            unscaled.x *= (size.width / 2.0) - padding
            unscaled.y *= (size.height / 2.0) - padding
            return CGPoint(
                x: unscaled.x + (size.width / 2.0),
                y: (size.height / 2.0) - unscaled.y
            )
        }
    }

    // MARK: - State Modification

    func settingBrightness(_ newBrightness: CGFloat) -> ColorPickerState {
        self.brightness = newBrightness
        return self
    }

    func settingAlpha(_ newAlpha: CGFloat) -> ColorPickerState {
        self.alpha = newAlpha
        return self
    }

    func settingHue(_ newHue: CGFloat) -> ColorPickerState {
        let newPoint = ColorPickerState.calculatePoint(
            hue: newHue,
            saturation: saturation,
            wheelSize: wheelSize
        )
        self.hue = newHue
        self.scaledRelativePoint = newPoint
        return self
    }

    func settingSaturation(_ newSaturation: CGFloat) -> ColorPickerState {
        let newPoint = ColorPickerState.calculatePoint(
            hue: hue,
            saturation: newSaturation,
            wheelSize: wheelSize
        )
        self.saturation = newSaturation
        self.scaledRelativePoint = newPoint
        return self
    }

    // MARK: - Helper Functions

    private static func calculateHueSaturation(
        from point: CGPoint,
        wheelSize: CGSize
    ) -> (hue: CGFloat, saturation: CGFloat) {
        let isRectangle = wheelSize.width != wheelSize.height
        let isHorizontal = wheelSize.width > wheelSize.height

        let hue: CGFloat
        let saturation: CGFloat

        if isRectangle {
            let len = max(wheelSize.width, wheelSize.height)
            if isHorizontal {
                hue = abs(point.x) / len
            } else {
                hue = abs(point.y) / len
            }
            saturation = 1.0
        } else {
            var angle = atan2(point.y, point.x)
            if angle < 0 {
                angle += .pi * 2
            }
            hue = angle / (.pi * 2)

            var radius = sqrt(pow(point.x, 2) + pow(point.y, 2))
            if radius > 1 {
                radius = 1
            }
            saturation = radius
        }

        return (hue, saturation)
    }

    private static func calculatePoint(
        hue: CGFloat,
        saturation: CGFloat,
        wheelSize: CGSize
    ) -> CGPoint {
        let isRectangle = wheelSize.width != wheelSize.height
        let isHorizontal = wheelSize.width > wheelSize.height

        if isRectangle {
            let len = max(wheelSize.width, wheelSize.height)
            let angle = hue * (2.0 * .pi)

            if isHorizontal {
                let pointX = angle * len
                return CGPoint(x: pointX, y: wheelSize.height / 2)
            } else {
                let pointY = angle * len
                return CGPoint(x: wheelSize.width / 2, y: pointY)
            }
        } else {
            // Color wheel - convert to HSV
            let angle = hue * (2.0 * .pi)
            let pointX = cos(angle) * saturation
            let pointY = sin(angle) * saturation
            return CGPoint(x: pointX, y: pointY)
        }
    }
}
