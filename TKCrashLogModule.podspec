#
# Be sure to run `pod lib lint TKCrashLogModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TKCrashLogModule'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TKCrashLogModule.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhuamaodeyu/TKCrashLogModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhuamaodeyu' => '1021491936@qq.com' }
  s.source           = { :git => 'https://github.com/zhuamaodeyu/TKCrashLogModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

#  s.source_files = 'TKCrashLogModule/Classes/**/*'

  # s.resource_bundles = {
  #   'TKCrashLogModule' => ['TKCrashLogModule/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.default_subspec = 'Module'

  s.subspec 'Core' do |ss|
        ss.source_files = 'TKCrashLogModule/Classes/Core/**/*'
  end

  s.subspec 'Module' do |ss|
      ss.source_files = 'TKCrashLogModule/Classes/**/*'
  end


    s.dependency 'skpsmtpmessage'
    s.dependency 'ZipArchive'
end
