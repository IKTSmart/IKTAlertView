#IKTRouter

Pod::Spec.new do |s|
  s.name             = 'IKTAlertView'
  s.version          = '0.0.2'
  s.summary          = 'iOS弹窗'

  s.description      = <<-DESC
  选择弹出框 for iOS
                       DESC

  s.homepage         = 'https://github.com/IKTSmart/IKTAlertView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { 'IKT' => 'E.T.Scorpion' }
  s.source           = { :git => 'https://github.com/IKTSmart/IKTAlertView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'IKTAlertView/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'Router' => ['IKTAlertView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
