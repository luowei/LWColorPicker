//
//  OpacitySlider.swift
//  LWColorPicker
//
//  Swift/SwiftUI version of RSOpacitySlider
//

import SwiftUI

// MARK: - Opacity Slider Delegate Protocol

/// Protocol for opacity slider delegate
public protocol OpacitySliderDelegate: AnyObject {
    func opacitySlider(_ slider: OpacitySlider, opacityChanged value: CGFloat)
}

// MARK: - SwiftUI Opacity Slider

/// A SwiftUI slider that displays an opacity gradient with checkered background
public struct OpacitySlider: View {
    // MARK: - Properties

    @Binding public var opacity: CGFloat
    public weak var delegate: OpacitySliderDelegate?

    // MARK: - Initialization

    public init(opacity: Binding<CGFloat>) {
        self._opacity = opacity
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Checkered background
                checkeredBackground
                    .cornerRadius(3)

                // Opacity gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0),
                        Color.white.opacity(1)
                    ]),
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
                        updateOpacity(from: value.location.x, width: geometry.size.width)
                    }
            )
        }
        .frame(height: 30)
    }

    // MARK: - Helper Views

    private var checkeredBackground: some View {
        Image(uiImage: createCheckeredImage())
            .resizable(resizingMode: .tile)
    }

    private func createCheckeredImage() -> UIImage {
        createOpacityBackgroundImage(
            length: 16,
            scale: 2.0,
            color: UIColor(white: 0.5, alpha: 1.0)
        ) ?? UIImage()
    }

    // MARK: - Helper Methods

    private func thumbPosition(for width: CGFloat) -> CGFloat {
        return opacity * width
    }

    private func updateOpacity(from position: CGFloat, width: CGFloat) {
        let newOpacity = max(0, min(1, position / width))
        opacity = newOpacity
        delegate?.opacitySlider(self, opacityChanged: newOpacity)
    }
}

// MARK: - UIKit Wrapper (for UIKit compatibility)

/// UIKit wrapper for OpacitySlider to maintain API compatibility
public class OpacitySliderView: UIView {
    // MARK: - Properties

    public weak var delegate: OpacitySliderDelegate?

    private var hostingController: UIHostingController<OpacitySlider>?
    private var opacityBinding: Binding<CGFloat>
    private var currentOpacity: CGFloat = 1.0 {
        didSet {
            if let delegate = self.delegate {
                delegate.opacitySlider(OpacitySlider(opacity: opacityBinding), opacityChanged: currentOpacity)
            }
        }
    }

    // MARK: - Public API

    public var opacity: CGFloat {
        get { currentOpacity }
        set {
            currentOpacity = newValue
            updateSlider()
        }
    }

    // MARK: - Initialization

    public override init(frame: CGRect) {
        opacityBinding = Binding(
            get: { 1.0 },
            set: { _ in }
        )
        super.init(frame: frame)
        setupSlider()
    }

    public required init?(coder: NSCoder) {
        opacityBinding = Binding(
            get: { 1.0 },
            set: { _ in }
        )
        super.init(coder: coder)
        setupSlider()
    }

    // MARK: - Setup

    private func setupSlider() {
        opacityBinding = Binding(
            get: { [weak self] in
                self?.currentOpacity ?? 1.0
            },
            set: { [weak self] newValue in
                self?.currentOpacity = newValue
            }
        )

        let slider = OpacitySlider(opacity: opacityBinding)
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
        hostingController?.rootView = OpacitySlider(opacity: opacityBinding)
    }
}

// MARK: - Preview

struct OpacitySlider_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            OpacitySlider(opacity: .constant(0.5))
                .frame(height: 30)
                .padding()

            OpacitySlider(opacity: .constant(1.0))
                .frame(height: 30)
                .padding()
        }
    }
}
