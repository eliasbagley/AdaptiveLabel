#
# Be sure to run `pod lib lint AdaptiveLabel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AdaptiveLabel'
  s.version          = '0.1.0'
  s.summary          = 'A UILabel subclass which adapts its font size and characer spacing to fit within constrained dimensions'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  AdaptiveLabel is a UILabel subclass which allows the font size and text spacing to grow to fit within constrained dimensions. It's usage is to create labels which have the same relative sizing across all iPhone screen sizes, by using AutoLayout constraints to constrain the label rather than setting the font directly. The options are FixedWidth, where the font size will grow until the fixed width is completely filled, allowing the height to grow freely; FixedHeight, where the font size will grow until the height is completely filled, allowing the width of the label to grow greely, or FidedWidthAndHeight, which increases the font size until the desired height is reached, and then increases the character spacing until the desired width is reached.
                       DESC

  s.homepage         = 'https://github.com/eliasbagley/AdaptiveLabel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Elias Bagley' => 'elias.bagley@gmail.com' }
  s.source           = { :git => 'https://github.com/eliasbagley/AdaptiveLabel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AdaptiveLabel/Classes/**/*'

  # s.resource_bundles = {
  #   'AdaptiveLabel' => ['AdaptiveLabel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
