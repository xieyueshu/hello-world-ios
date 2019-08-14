platform :ios, '10.0'
use_frameworks!
target 'HelloWorld' do
pod 'Alamofire'
pod 'BigInt', '~> 4.0'
pod 'APIKit', '~> 3.2.1'
pod 'Moya', '~> 10.0'
pod 'R.swift'
pod 'CryptoSwift', '~> 0.15.0'
pod 'JSONRPCKit', :git=> 'https://github.com/bricklife/JSONRPCKit.git'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['JSONRPCKit'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
    if ['APIKit'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end
end
