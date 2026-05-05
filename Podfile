platform :ios, '14.0'

target 'ImageViewer' do
  use_frameworks!

  pod 'IQKeyboardManagerSwift', '6.5.6'
  pod 'SwiftyJSON'
  pod 'SimpleImageViewer'
  pod 'Siren'
  pod 'QorumLogs'
  pod 'Moya'
  pod 'SDWebImage'
  pod 'lottie-ios', '~> 3.5'
  pod 'AWSS3'
  pod 'AWSCore'
  pod 'FirebaseAuth' 
  pod 'Firebase/Core'
  pod 'GoogleSignIn'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
        config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      end
    end
  end
end
