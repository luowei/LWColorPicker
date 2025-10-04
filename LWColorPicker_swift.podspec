#
# LWColorPicker_swift.podspec
# Swift version of LWColorPicker
#

Pod::Spec.new do |s|
  s.name             = 'LWColorPicker_swift'
  s.version          = '1.0.0'
  s.summary          = 'Swift version of LWColorPicker - A modern color picker for iOS'

  s.description      = <<-DESC
LWColorPicker_swift is a modern Swift/SwiftUI implementation of the LWColorPicker library.
A beautiful and customizable color picker supporting:
- HSB (Hue, Saturation, Brightness) color model
- Circular and rectangular color wheel layouts
- Brightness and opacity sliders
- Real-time color preview
- SwiftUI and UIKit integration
- Hex color input/output
- Color palette management
- Accessibility support
                       DESC

  s.homepage         = 'https://github.com/luowei/LWColorPicker.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luowei' => 'luowei@wodedata.com' }
  s.source           = { :git => 'https://github.com/luowei/LWColorPicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'

  s.source_files = 'LWColorPicker_swift/Swift/**/*'

  s.frameworks = 'UIKit', 'SwiftUI', 'Combine'
end
