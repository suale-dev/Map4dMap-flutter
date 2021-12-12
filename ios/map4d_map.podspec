Pod::Spec.new do |s|
  s.name             = 'map4d_map'
  s.version          = '2.1.1'
  s.summary          = 'Map4dMap SDK for Flutter'
  s.description      = <<-DESC
  A Flutter plugin that provides a MFMapView widget.
                       DESC
  s.homepage         = 'https://map4d.vn'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'IOTLink' => 'admin@iotlink.com.vn' }
  s.source           = { :path => 'https://github.com/map4d/map4d-map-flutter' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Map4dMap', '~> 2.0.6'
  s.static_framework = true
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
