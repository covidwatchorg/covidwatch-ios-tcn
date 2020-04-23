# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'CovidWatch iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CovidWatch
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'

  # Dev Tooling
  pod 'SwiftLint'

  target 'CovidWatch iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CovidWatch iOSUITests' do
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
