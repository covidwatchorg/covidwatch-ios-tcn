# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'COVIDWatch iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for COVIDWatch
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'

  # Dev Tooling
  pod 'SwiftLint'

  target 'COVIDWatch iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'COVIDWatch iOSUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['FirebaseFirestoreSwift'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
  end
end
