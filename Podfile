# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MrS-Cool' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MrS-Cool
    pod 'Alamofire', '5.6.4'
#    pod 'Kingfisher','7.6.1'
#    pod 'IQKeyboardManagerSwift', '6.3.0'
#    pod 'Firebase'
#    pod 'Firebase/Analytics'
#    pod 'Firebase/Messaging'
#    pod 'ReadMoreTextView'
#    pod 'lottie-ios'
#    pod 'DropDown'
#    pod 'Firebase/Crashlytics'
#    pod 'GoogleSignIn'
#    pod 'AssetsPickerViewController'
#    pod 'Player'
#    pod 'ReadMoreTextView'
#    pod 'KeychainSwift'

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
 end
