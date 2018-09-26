Pod::Spec.new do |spec|

  spec.name         = "AlamofireActivityLogger"
  spec.version      = "2.5.0"
  spec.summary      = "A response serializer for Alamofire which logs both request and response"
  spec.description  = <<-DESC
  A response serializer for Alamofire which prints both request and responses. It provides 4 log levels and a few options to configure your logs.
                   DESC
  spec.homepage     = "https://github.com/ManueGE/AlamofireActivityLogger/"
  spec.license      = "MIT"


  spec.author    = "Manuel García-Estañ"
  spec.social_media_url   = "http://twitter.com/ManueGE"

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
  spec.watchos.deployment_target = '2.0'
  spec.tvos.deployment_target = '9.0'

  spec.source       = { :git => "https://github.com/ManueGE/AlamofireActivityLogger.git", :tag => "#{spec.version}" }

  spec.requires_arc = true
  spec.framework = "Foundation"
  spec.dependency "Alamofire", "~> 4.7"
  spec.source_files  = "alamofire_activity_logger/ActivityLogger/*.{swift}"

  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }

end
