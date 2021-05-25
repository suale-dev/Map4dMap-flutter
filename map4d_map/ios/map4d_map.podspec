Pod::Spec.new do |s|
  s.name             = 'map4d_map'
  s.version          = '0.0.1'
  s.summary          = 'Map4d Map SDK for Flutter'
  s.description      = <<-DESC
  A Flutter plugin that provides a Map4d Map widget.
                       DESC
  s.homepage         = 'https://map4d.vn'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'IOTLink' => 'admin@iotlink.com.vn' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Map4dMap'
  s.static_framework = true
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
