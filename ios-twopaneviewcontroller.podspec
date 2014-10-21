Pod::Spec.new do |s|
  s.name         = "ios-twopaneviewcontroller"
  s.version      = "0.1.0"
  s.summary      = "Simple two pane split view controller for iPad"
  s.homepage     = "https://github.com/mruegenberg/ios-twopaneviewcontroller"

  s.license      = 'MIT'

  s.author       = { "Marcel Ruegenberg" => "github@dustlab.com" }

  s.source       = { :git => "https://github.com/mruegenberg/ios-twopaneviewcontroller", :tag => s.version }

  s.platform     = :ios, '6.0'
  
  s.requires_arc = true

  s.source_files = '*.{h,m}'

  s.public_header_files = 'TwoPaneViewController.h', 'TwoPaneViewController.h'

  s.frameworks  = 'CoreFoundation', 'UIKit'
end
