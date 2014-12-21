source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.1'

#pod 'PBJVision', '~> 0.1'
#pod 'GVMusicPlayerController', :git => 'https://github.com/nickbolton/GVMusicPlayerController.git', :branch => 'master'
#pod 'VideoPlayerKit', :git => 'https://github.com/nickbolton/VideoPlayerKit.git', :branch => 'master'
pod 'Bedrock/Core', :git => 'https://github.com/nickbolton/PBBedrock.git', :branch=>'master'
pod 'Bedrock/AutoLayout', :git => 'https://github.com/nickbolton/PBBedrock.git', :branch=>'master'
#comment -- update Reachabilty to fork 3.1 and apply patch for https://github.com/CocoaPods/Specs/issues/352

inhibit_all_warnings!

post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGN_IDENTITY'] = 'iPhone Developer'
    end
  end
end
