Pod::Spec.new do |s|
    s.name = "AsyncViewController"
    s.version = "2.1.1"
    s.summary = "AsyncViewController provides bridges the gap between loading data and presenting the respective view controller."
    s.author = "Lukas Würzburger"
    s.license = { :type => "MIT" }
    s.homepage = "https://github.com/lukaswuerzburger/AsyncViewController"
    s.platform = :ios
    s.source = { :git => "https://github.com/lukaswuerzburger/AsyncViewController.git", :tag => "2.1.1" }
    s.source_files = "AsyncViewController/Sources/*.swift"
    s.ios.deployment_target = "9.0"
    s.ios.frameworks = 'Foundation', 'UIKit'
    s.requires_arc = true
    s.swift_version = "5.0"
end
