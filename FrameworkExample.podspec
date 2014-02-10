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

  #s.subspec 'XCTest' do |xctest|
  #    xctest.framework = 'XCTest'
  #    xctest.source_files = 'FrameworkExampleTests/**/*.{h,m}'
  #    xctest.requires_arc = true
  #    xctest.prefix_header_contents = <<-EOS
  #                                    #import <XCTest/XCTest.h>
  #                                    EOS
  #end

  s.prepare_foo = <<-SCRIPT
    require 'xcodeproj'

    project = Xcodeproj::Project.open('Poddy/Poddy.xcodeproj')
    main_target = project.targets.first

    # Create Prep phase
    phase_prep = main_target.new_shell_script_build_phase("prepare_framework")
    phase_prep.shell_script = <<-SH
    set -e
    mkdir -p "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/Versions/A/Headers"
    # Link the "Current" version to "A"
    /bin/ln -sfh A "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/Versions/Current"
    /bin/ln -sfh Versions/Current/Headers "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/Headers"
    /bin/ln -sfh "Versions/Current/${PRODUCT_NAME}" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/${PRODUCT_NAME}"
    # The -a ensures that the headers maintain the source modification date so that we don't constantly
    # cause propagating rebuilds of files that import these headers.
    /bin/cp -a "${TARGET_BUILD_DIR}/${PUBLIC_HEADERS_FOLDER_PATH}/" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/Versions/A/Headers"
    SH
    # Move it to the top of the phases
    phases = main_target.build_phases
    phases.insert(0, phases.delete_at(phases.find_index(phase_prep)))


    # Create Build Phase
    phase_build = main_target.new_shell_script_build_phase("build_framework")
    phase_build.shell_script = <<-SH
    set -e
    set +u
    # Avoid recursively calling this script.
    if [[ $SF_MASTER_SCRIPT_RUNNING ]]
    then
        exit 0
    fi
    set -u
    export SF_MASTER_SCRIPT_RUNNING=1

    SF_TARGET_NAME=${PROJECT_NAME}
    SF_EXECUTABLE_PATH="lib${SF_TARGET_NAME}.a"
    SF_WRAPPER_NAME="${SF_TARGET_NAME}.framework"

    # The following conditionals come from
    # https://github.com/kstenerud/iOS-Universal-Framework

    if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]
    then
        SF_SDK_PLATFORM=${BASH_REMATCH[1]}
    else
        echo "Could not find platform name from SDK_NAME: $SDK_NAME"
        exit 1
    fi

    if [[ "$SDK_NAME" =~ ([0-9]+.*$) ]]
    then
        SF_SDK_VERSION=${BASH_REMATCH[1]}
    else
        echo "Could not find sdk version from SDK_NAME: $SDK_NAME"
        exit 1
    fi

    if [[ "$SF_SDK_PLATFORM" = "iphoneos" ]]
    then
        SF_OTHER_PLATFORM=iphonesimulator
    else
        SF_OTHER_PLATFORM=iphoneos
    fi

    if [[ "$BUILT_PRODUCTS_DIR" =~ (.*)$SF_SDK_PLATFORM$ ]]
    then
        SF_OTHER_BUILT_PRODUCTS_DIR="${BASH_REMATCH[1]}${SF_OTHER_PLATFORM}"
    else
        echo "Could not find platform name from build products directory: $BUILT_PRODUCTS_DIR"
        exit 1
    fi

    # Build the other platform.
    xcrun xcodebuild -project "${PROJECT_FILE_PATH}" -target "${TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk ${SF_OTHER_PLATFORM}${SF_SDK_VERSION} BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" SYMROOT="${SYMROOT}" $ACTION

    # Smash the two static libraries into one fat binary and store it in the .framework
    xcrun lipo -create "${BUILT_PRODUCTS_DIR}/${SF_EXECUTABLE_PATH}" "${SF_OTHER_BUILT_PRODUCTS_DIR}/${SF_EXECUTABLE_PATH}" -output "${BUILT_PRODUCTS_DIR}/${SF_WRAPPER_NAME}/Versions/A/${SF_TARGET_NAME}"

    # Copy the binary to the other architecture folder to have a complete framework in both.
    cp -a "${BUILT_PRODUCTS_DIR}/${SF_WRAPPER_NAME}/Versions/A/${SF_TARGET_NAME}" "${SF_OTHER_BUILT_PRODUCTS_DIR}/${SF_WRAPPER_NAME}/Versions/A/${SF_TARGET_NAME}"
    SH

    project.save()

  SCRIPT

end
