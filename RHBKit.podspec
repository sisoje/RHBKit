#
# Be sure to run `pod lib lint RHBKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

$platforms = { :ios => "10.0", :watchos => "3.0", :tvos => "10.0", :osx => "10.12" }

Pod::Spec.new do |s|
  s.name             = 'RHBKit'
  s.version          = '1.0.959'
  s.summary          = 'Orientation tracker. Data stack. Table background data source. Predicate operators. Objective-C defer, casting & singleton.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Mutable protocol. Predicate operators. Cancellable and core data operations. Casting, singletons and defer for Objective-C and more... Goal was to reduce overabstractions and keep it low level.
                       DESC

  s.homepage         = 'https://github.com/sisoje/RHBKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lazar Otasevic' => 'redhotbits@gmail.com' }
  s.source           = { :git => 'https://github.com/sisoje/RHBKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/redhotbits'
  s.documentation_url = 'https://raw.githubusercontent.com/sisoje/RHBKit/master/README.md'

  s.swift_version = '4.0'

  s.platforms = $platforms

  s.subspec 'All' do |all|

    all.subspec 'Core' do |ss|
        ss.source_files = 'Sources/Core/**/*'
    end

    all.subspec 'OrientationTracker' do |ss|
        ss.platforms = $platforms.except(:osx, :tvos)
        ss.source_files = 'Sources/OrientationTracker/**/*'
        ss.dependency 'RHBKit/All/Core'
    end

    all.subspec 'UIKit' do |uikit|
        uikit.subspec 'Core' do |ss|
            ss.platforms = $platforms.except(:osx)
            ss.source_files = 'Sources/UIKit/Core/**/*'
        end
        uikit.subspec 'Extras' do |ss|
            ss.platforms = $platforms.except(:osx, :watchos)
            ss.source_files = 'Sources/UIKit/Extras/**/*'
            ss.dependency 'RHBKit/All/Core'
        end
    end

=begin
      all.subspec 'Contacts' do |ss|
            ss.platforms = $platforms.except(:tvos)
            ss.source_files = 'Sources/Contacts/Classes/**/*'
            ss.resources = 'Sources/Contacts/Assets/**/*'
            ss.dependency 'RHBKit/All/Foundation'
      end
=end

  end

    s.subspec 'ObjC' do |ss|
        ss.source_files = 'ObjC/**/*'
        ss.dependency 'RHBKit/All/Core'
    end

s.default_subspec = 'All/Core'

end
