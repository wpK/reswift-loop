Pod::Spec.new do |s|
  s.name             = "ReSwiftLoop"
  s.version          = "0.0.1"
  s.summary          = "A port of redux-loop middleware for ReSwift."
  s.description      = <<-DESC
                          A port of redux-loop middleware for ReSwift.
                        DESC
  s.homepage         = "https://github.com/wpK/ReSwift-Loop"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = { "William Key" => "williamkey@@gmail.com" }
  s.social_media_url = "http://twitter.com/williamkey"
  s.source           = { :git => "https://github.com/wpK/ReSwift-Loop.git", :tag => s.version.to_s }
  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = true
  s.source_files     = 'ReSwiftLoop/**/*.swift'
  s.dependency 'ReSwift', '~>1.0'
end
