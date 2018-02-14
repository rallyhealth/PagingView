Pod::Spec.new do |s|
    s.name         = "PagingView"
    s.version      = "1.0"
    s.summary      = "PagingView is a UI control using a swiping gesture to control the display of paged information."
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.homepage     = "https://github.com/rallyhealth/PagingView"
    s.author       = { "Rally Health" }
    s.source       = { :git => "https://github.com/rallyhealth/PagingView.git", :tag => "#{s.version}" }
    s.platform     = :ios, "9.0"
    s.requires_arc = true
    s.source_files = 'PagingView/PagingView.swift'
    s.swift_version = "4.0"
end
