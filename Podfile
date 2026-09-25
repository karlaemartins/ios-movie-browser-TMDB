platform :ios, '18.1'

target 'NetworkLayer' do
  use_frameworks!

end

target 'MovieBrowserTMDBTests' do
  use_frameworks!
  inherit! :search_paths
  pod 'iOSSnapshotTestCase', '~> 8.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '18.1'
    end
  end
end