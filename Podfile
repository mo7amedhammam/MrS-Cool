# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'MrS-Cool' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MrS-Cool
  pod 'Alamofire', '~> 5.8.1'                     # Updated for privacy manifest
  pod 'FSCalendar', '~> 2.8.4'                    # No update needed (not flagged)
  pod 'CalendarKit', '~> 1.1.9'                   # No update needed (not flagged)
  pod 'Kingfisher', '~> 7.10.0'                   # Updated for privacy manifest
  
  # Firebase pods - all updated to same version
  pod 'Firebase', '~> 10.22.0'                    # Core dependency
  pod 'Firebase/Core', '~> 10.22.0'               # Updated for privacy manifest
  pod 'Firebase/Messaging', '~> 10.22.0'          # Updated for privacy manifest
  pod 'Firebase/Analytics', '~> 10.22.0'          # Updated for privacy manifest
  pod 'Firebase/Crashlytics', '~> 10.22.0'        # Updated for privacy manifest

  # Optional pods (commented out)
  # pod 'IQKeyboardManagerSwift', '6.3.0'
  # pod 'ReadMoreTextView'
  # pod 'lottie-ios'
  # pod 'DropDown'
  # pod 'GoogleSignIn'
  # pod 'AssetsPickerViewController'
  # pod 'Player'
  # pod 'ReadMoreTextView'
  # pod 'KeychainSwift'

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
