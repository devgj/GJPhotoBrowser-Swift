Pod::Spec.new do |s|
  s.name = 'GJPhotoBrowser-Swift'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'PhotoBrowser in Swift'
  s.homepage = 'https://github.com/devgj/GJPhotoBrowser-Swift'
  s.authors = { 'GJ' => 'devwgj@gmail.com' }
  s.source = { :git => 'https://github.com/devgj/GJPhotoBrowser-Swift.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.dependency 'SDWebImage'
  s.source_files = 'Source/*.swift'

  s.requires_arc = true
end
