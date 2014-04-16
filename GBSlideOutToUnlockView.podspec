Pod::Spec.new do |s|
  s.name             = "GBSlideOutToUnlockView"
  s.version          = "0.1.0"
  s.summary          = "A short description of GBSlideOutToUnlockView."
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = "Gustavo Barbosa"
  s.source           = { :git => "http://github.com/barbosa/GBSlideOutToUnlockView.git", :tag => s.version.to_s }

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets/*.png'

  # s.frameworks = 'SomeFramework', 'AnotherFramework'
end
