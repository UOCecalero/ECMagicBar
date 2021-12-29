#
# Be sure to run `pod lib lint ECMagicBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ECMagicBar'
  s.version          = '0.1.0'
  s.summary          = 'A chat textbar for iOS inspired in whatssap app.'

  s.description      = <<-DESC
A customizable chat textbar inspired in whatssap iOS app. You can implement your chat screen in a few minutes just placing it as inputAccessoryView.
                       DESC

  s.homepage         = 'https://github.com/UOCecalero/ECMagicBar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'LGPLv2.1', :file => 'LICENSE' }
  s.author           = { 'Eduard Calero' => 'educalero@icloud.com' }
  s.source           = { :git => 'https://github.com/UOCecalero/ECMagicBar.git', :tag => 'v0.1.0' }
  s.social_media_url = 'https://twitter.com/CaleroEduard'
  s.swift_version = '5.0'

  s.ios.deployment_target = '13.0'

  s.source_files = 'ECMagicBar/Classes/**/*'
  
#  s.resources = "ECMagicBar/Assets/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
   s.resource_bundles = {
     'ECMagicBar' => ['ECMagicBar/**/*.xib']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MobileCoreServices'
  # s.dependency 'AFNetworking', '~> 2.3'
end
