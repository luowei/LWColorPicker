#
# Be sure to run `pod lib lint LWColorPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LWColorPicker'
  s.version          = '1.0.0'
  s.summary          = 'ALWColorPicker，颜色选择器，支持色相、饱和度、透明度的选取，支持圆形和矩形HSB颜色模式图。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
LWColorPicker，颜色选择器，支持色相、饱和度、透明度的选取，支持圆形和矩形HSB颜色模式图。
                       DESC

  s.homepage         = 'https://github.com/luowei/LWColorPicker.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luowei' => 'luowei@wodedata.com' }
  s.source           = { :git => 'https://github.com/luowei/LWColorPicker.git'}
  # s.source           = { :git => 'https://gitlab.com/ioslibraries1/libcolorpicker.git'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LWColorPicker/Classes/**/*'
  s.exclude_files = 'LWColorPicker/Swift/**/*.swift'
  
  # s.resource_bundles = {
  #   'LWColorPicker' => ['LWColorPicker/Assets/*.png']
  # }

  s.public_header_files = 'LWColorPicker/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
