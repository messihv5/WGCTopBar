Pod::Spec.new do |s|

s.name         = "WGCTopBar"
s.version      = "0.0.1"
s.summary      = "A simple top bar."
s.description  = <<-DESC
A topbar that can set bar items and a indicator to indicate the selected bar item.
DESC
s.homepage     = "https://github.com/messihv5/WGCTopBar"
s.license      = "MIT"
s.author             = { "messihv5" => "724009249@qq.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/messihv5/WGCTopBar.git", :tag => "0.0.1" }
s.source_files  = "WGCTopBar/**/*"
s.framework  = "UIKit"
s.requires_arc = true
s.dependency "YYKit"

end
