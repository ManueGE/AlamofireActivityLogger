Pod::Spec.new do |spec|

  spec.name         = "AlamofireActivityLogger"
  spec.version      = "1.0.0"
  spec.summary      = "A response serializer for Alamofire which logs both request and response"
  spec.description  = <<-DESC
  A response serializer for Alamofire which prints both request and responses. It provides 4 log levels and a few options to configure your logs.
                   DESC
  spec.homepage     = "https://github.com/ManueGE/AlamofireActivityLogger/"
  spec.license      = "MIT"


  spec.author    = "Manuel García-Estañ"
  spec.social_media_url   = "http://twitter.com/ManueGE"

  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/ManueGE/AlamofireActivityLogger.git", :tag => "#{spec.version}" }

  spec.requires_arc = true
  spec.framework = "Foundation"
  spec.dependency "Alamofire", "~> 3.4"
  spec.source_files  = "alamofire_activity_logger/Request+ActivityLogger.swift"

end
