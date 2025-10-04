//
//  BrightnessSlider.swift
//  LWColorPicker
//
//  Swift/SwiftUI version of RSBrightnessSlider
//

import SwiftUI

// MARK: - Brightness Slider Delegate Protocol

/// Protocol for brightness slider delegate
public protocol BrightnessSliderDelegate: AnyObject {
    func brightnessSlider(_ slider: BrightnessSlider, valueChanged value: CGFloat)
}

// MARK: - SwiftUI Brightness Slider

/// A SwiftUI slider that displays a brightness gradient from black to white
public struct BrightnessSlider: View {
    // MARK: - Properties

    @Binding public var brightness: CGFloat
    public weak var delegate: BrightnessSliderDelegate?

    // MARK: - Initialization

    public init(brightness: Binding<CGFloat>) {
        self._brightness = brightness
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.black, .white]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .cornerRadius(3)

                // Thumb indicator
                Circle()
                    .fill(Color.white)
                    .frame(width: 16, height: 16)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    .offset(x: thumbPosition(for: geometry.size.width) - 8, y: 0)
            }
            .frame(height: 30)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        updateBrightness(from: value.location.x, width: geometry.size.width)
                    }
            )
        }
        .frame(height: 30)
    }

    // MARK: - Helper Methods

    private func thumbPosition(for width: CGFloat) -> CGFloat {
        return brightness * width
    }

    private func updateBrightness(from position: CGFloat, width: CGFloat) {
        let newBrightness = max(0, min(1, position / width))
        brightness = newBrightness
        delegate?.brightnessSlider(self, valueChanged: newBrightness)
    }
}

// MARK: - UIKit Wrapper (for UIKit compatibility)

/// UIKit wrapper for BrightnessSlider to maintain API compatibility
public class BrightnessSliderView: UIView {
    // MARK: - Properties

    public weak var delegate: BrightnessSliderDelegate?

    private var hostingController: UIHostingController<BrightnessSlider>?
    private var brightnessBinding: Binding<CGFloat>
    private var currentBrightness: CGFloat = 1.0 {
        didSet {
            if let delegate = self.delegate {
                delegate.brightnessSlider(BrightnessSlider(brightness: brightnessBinding), valueChanged: currentBrightness)
            }
        }
    }

    // MARK: - Public API

    public var brightness: CGFloat {
        get { currentBrightness }
        set {
            currentBrightness = newValue
            updateSlider()
        }
    }

    // MARK: - Initialization

    public override init(frame: CGRect) {
        brightnessBinding = Binding(
            get: { 1.0 },
            set: { _ in }
        )
        super.init(frame: frame)
        setupSlider()
    }

    public required init?(coder: NSCoder) {
        brightnessBinding = Binding(
            get: { 1.0 },
            set: { _ in }
        )
        super.init(coder: coder)
        setupSlider()
    }

    // MARK: - Setup

    private func setupSlider() {
        brightnessBinding = Binding(
            get: { [weak self] in
                self?.currentBrightness ?? 1.0
            },
            set: { [weak self] newValue in
                self?.currentBrightness = newValue
            }
        )

        let slider = BrightnessSlider(brightness: brightnessBinding)
        let hosting = UIHostingController(rootView: slider)
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

    private func updateSlider() {
        hostingController?.rootView = BrightnessSlider(brightness: brightnessBinding)
    }
}

// MARK: - Preview

struct BrightnessSlider_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            BrightnessSlider(brightness: .constant(0.5))
                .frame(height: 30)
                .padding()

            BrightnessSlider(brightness: .constant(1.0))
                .frame(height: 30)
                .padding()
        }
    }
}
