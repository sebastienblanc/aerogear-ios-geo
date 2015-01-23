Pod::Spec.new do |s|
  s.name         = "AeroGearGeo"
  s.version      = "0.1.0"
  s.summary      = "Lightweight geolocation lib."
  s.homepage     = "https://github.com/sebastienblanc/aerogear-ios-geo"
  s.license      = 'Apache License, Version 2.0'
  s.author       = "Red Hat, Inc."
  s.source       = { :git => 'https://github.com/corinnekrych/aerogear-ios-geo.git',  :branch => 'cocoapods.support'}
  s.platform     = :ios, 8.0
  s.source_files = 'UnifiedGeo/*.{swift}'
end