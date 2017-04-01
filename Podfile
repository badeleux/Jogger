platform :ios, '9.0'

use_frameworks!

target 'Jogger' do
    pod 'StatefulViewController', '~> 3.0'
    pod 'EasyPeasy'
    pod 'SwiftyFORM'
    pod 'Swinject', '~> 2.0.0'
    pod 'SwinjectStoryboard', '~> 1.0.0'
    pod 'Himotoki', '~> 3.0'
    pod 'ReactiveSwift'
    pod 'ReactiveCocoa'
    pod 'SwiftDate'
    pod 'SwiftMessages'
    pod 'MGSwipeTableCell'

    pod 'Firebase/Database'
    pod 'Firebase/Auth'


    target 'JoggerTests' do
        inherit! :search_paths
        pod 'Firebase/Database'
        pod 'Firebase/Auth'
        pod 'Quick'
        pod 'Nimble'
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
