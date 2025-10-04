//
//  ColorFunctions.swift
//  LWColorPicker
//
//  Swift/SwiftUI version of RSColorFunctions
//

import SwiftUI
import UIKit

// MARK: - Color Conversion Functions

/// Converts HSV values to RGB pixel
func pixelFromHSV(h: CGFloat, s: CGFloat, v: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
    if s == 0 {
        return (v, v, v)
    }

    var hue = h
    if hue == 1 {
        hue = 0
    }

    let varH = hue * 6.0
    let varI = Int(varH)
    let var1 = v * (1.0 - s)

    switch varI {
    case 0:
        let var3 = v * (1.0 - s * (1.0 - (varH - CGFloat(varI))))
        return (v, var3, var1)
    case 1:
        let var2 = v * (1.0 - s * (varH - CGFloat(varI)))
        return (var2, v, var1)
    case 2:
        let var3 = v * (1.0 - s * (1.0 - (varH - CGFloat(varI))))
        return (var1, v, var3)
    case 3:
        let var2 = v * (1.0 - s * (varH - CGFloat(varI)))
        return (var1, var2, v)
    case 4:
        let var3 = v * (1.0 - s * (1.0 - (varH - CGFloat(varI))))
        return (var3, var1, v)
    default:
        let var2 = v * (1.0 - s * (varH - CGFloat(varI)))
        return (v, var1, var2)
    }
}

/// Extracts RGBA components from UIColor
func getComponentsForColor(_ color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0

    if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
        return (r, g, b, a)
    } else if color.getWhite(&r, alpha: &a) {
        return (r, r, r, a)
    }

    // Fallback using Core Graphics context
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    var pixel: [UInt8] = [0, 0, 0, 0]
    let context = CGContext(
        data: &pixel,
        width: 1,
        height: 1,
        bitsPerComponent: 8,
        bytesPerRow: 4,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )

    context?.setFillColor(color.cgColor)
    context?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))

    r = CGFloat(pixel[0]) / 255.0
    g = CGFloat(pixel[1]) / 255.0
    b = CGFloat(pixel[2]) / 255.0
    a = CGFloat(pixel[3]) / 255.0

    if a > 0 {
        r /= a
        g /= a
        b /= a
    }

    return (r, g, b, a)
}

// MARK: - Image Generation Functions

/// Creates a checkered opacity background image
func createOpacityBackgroundImage(length: CGFloat, scale: CGFloat, color: UIColor) -> UIImage? {
    let halfLength = length * 0.5

    let renderer = UIGraphicsImageRenderer(size: CGSize(width: length, height: length))
    let image = renderer.image { ctx in
        let context = ctx.cgContext

        // Draw colored squares
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: halfLength, height: halfLength))
        context.fill(CGRect(x: halfLength, y: halfLength, width: halfLength, height: halfLength))

        // Draw white squares
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(x: 0, y: halfLength, width: halfLength, height: halfLength))
        context.fill(CGRect(x: halfLength, y: 0, width: halfLength, height: halfLength))
    }

    return UIImage(cgImage: image.cgImage!, scale: scale, orientation: .up)
}

/// Generates a random color
func randomColor(opaque: Bool = true) -> UIColor {
    let hue = CGFloat(arc4random_uniform(256)) / 256.0
    let saturation = (CGFloat(arc4random_uniform(128)) / 256.0) + 0.5  // 0.5 to 1.0
    let brightness = (CGFloat(arc4random_uniform(128)) / 256.0) + 0.5  // 0.5 to 1.0
    let alpha: CGFloat = opaque ? 1.0 : (CGFloat(arc4random_uniform(128)) / 256.0) + 0.5

    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
}

// MARK: - UIImage Extension

extension UIImage {
    /// Creates a circular image with the specified color
    static func circleWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let context = ctx.cgContext
            context.saveGState()

            let rect = CGRect(origin: .zero, size: size)
            context.setFillColor(color.cgColor)
            context.fillEllipse(in: rect)

            context.restoreGState()
        }
    }
}
