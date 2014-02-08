Pod::Spec.new do |s|
  s.name         = "FrameworkExample"
  s.version      = "0.0.1"
  s.summary      = "CocoaPod Framework example"
  s.description  = <<-DESC
                   CocoaPod Framework example based on instructions from: 

                   https://github.com/jverkoey/iOS-Framework
                   DESC
  s.homepage     = "https://github.com/chris-garrett/cocoapod-framework"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Chris Garrett" => "chris@nesteggs.ca" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/chris-garrett/cocoapod-framework.git", :commit => '6a79bf9f6541b60d8ac6bfe3cb0a2ac2bf58d516'}
#, :tag => "0.0.1" }

  s.source_files  = 'FrameworkExample/**/*.{h,m}'
  s.exclude_files = 'FrameworkExample/Exclude'

  # s.public_header_files = 'Classes/**/*.h'
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.libraries = 'iconv', 'xml2'
  s.requires_arc = true
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  # s.dependency 'JSONKit', '~> 1.4'

end
