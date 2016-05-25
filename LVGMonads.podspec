Pod::Spec.new do |s|

  s.name         = "LVGMonads"
  s.version      = "0.0.1"
  s.summary      = "Haskell-like Monads implemented in Swift."
  s.homepage     = 'https://github.com/letvargo/LVGMonads'
  s.description  = <<-DESC
    Haskell-like Monads implemented in Swift.
                   DESC
  s.license      = 'MIT'
  s.author             = { "letvargo" => "letvargo@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.source       = { :git => "https://github.com/letvargo/LVGMonads.git", :tag => "0.0.1" }
  s.source_files  = "Source/**/*"
  s.requires_arc = true

  s.subspec 'IO' do |sp|
    sp.source_files = 'Source/IO.swift'
    sp.dependency 'LVGMonads/Operators'
  end

  s.subspec 'Operators' do |sp|
    sp.source_files = 'Source/Operators.swift'
  end

end