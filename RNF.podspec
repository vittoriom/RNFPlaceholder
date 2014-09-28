Pod::Spec.new do |s|
  s.name         = 'RNF'
  s.version      = '0.1'
  s.summary      = 'RuntimeNetworkFoundation'
  s.author       = {
    'Vittorio Monaco' => 'vittorio.monaco1@gmail.com'
  }
  s.source       = {
    :git => 'https://github.com/vittoriom/RNFPlaceholder.git',
    :tag => s.version.to_s
  }
  s.source_files = 'RuntimeNetworkFoundation/RuntimeNetworkFoundation/**/*.{h,m}'
  s.license      = 'BSD'
  s.requires_arc = true
  s.ios.deployment_target = "7.0"
end
