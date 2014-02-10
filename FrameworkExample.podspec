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
  s.source       = { :git => "https://github.com/chris-garrett/cocoapod-framework.git", 
                     :branch => 'new-framework',
                     #:commit => '575206edfb5656525eccf9bf98491993713cd645',
                     #:tag => "0.0.1" 
                   }

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

  s.subspec 'XCTest' do |xctest|
      xctest.framework = 'XCTest'
      xctest.source_files = 'FrameworkExampleTests/**/*.{h,m}'
      xctest.requires_arc = true
      xctest.prefix_header_contents = <<-EOS
                                      #import <XCTest/XCTest.h>
                                      EOS
  end

end
