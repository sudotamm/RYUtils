Pod::Spec.new do |s|
  s.name             = "RYUtils"
  s.version          = "5.0.0"
  s.summary          = "Ryan Yuan's private library for Objective-C."
  s.description      = <<-DESC
                       It is Ryan Yuan's private library, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/sudotamm/RYUtils"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "sudotamm" => "sudotamm@hotmail.com" }
  s.source           = { :git => "https://github.com/sudotamm/RYUtils.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'

  s.platform     = :ios, '7.0'
  # s.ios.deployment_target = '7.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'RYUtils/RYUtils/*.{h,m}'
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'QuartzCore', 'AssetsLibrary', 'CoreLocation','Accelerate','CoreImage'

end
