platform :ios, '8.0'

# swift all the way
use_frameworks!
inhibit_all_warnings!

# open source pods
source 'https://github.com/CocoaPods/Specs.git'


# pod scripts
post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
      	if !config.to_s.include? 'Debug'
      		config.build_settings['CODE_SIGN_IDENTITY[sdk=iphoneos*]'] = 'iPhone Distribution'
      	end
      end
    end
	end
