#
# Be sure to run `pod lib lint TransmedikSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TransmedikSDK'
  s.version          = '1.0.0'
  s.summary          = 'TransmedikSDK for library WE+'

  s.description      ="TransmedikSDK for we plus"

  s.homepage         = 'https://github.com/idhamcuexs/TransmedikSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'idham290593@gmail.com' => 'idham290593@gmail.com' }
  s.source           = { :git => 'https://github.com/idhamcuexs/TransmedikSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_versions = "4.0 "
  s.source_files = 'TransmedikSDK/Classes/**/*'
  
   s.resource_bundles = {
     'Resource' => ['TransmedikSDK/Assets/Assets.xcassets']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
#   s.dependency 'Alamofire'
   
   #s.dependency 'Alamofire'
   #s.dependency 'Kingfisher'
   #s.dependency 'FSPagerView'
   #s.dependency 'SwiftyJSON'
   #s.dependency 'IQKeyboardManagerSwift'
   #s.dependency 'SwiftyCodeView'
   #s.dependency 'DropDown'
   #s.dependency 'MessageKit'
   #s.dependency 'MessageInputBar'
   #s.dependency 'URLEmbeddedView'
   ##s.dependency 'SwipeCellKit'
   #s.dependency 'Parse'
   #s.dependency 'Lightbox'
   #s.dependency 'CDAlertView'
   #s.dependency 'Starscream', '~> 3.1.0'
   #s.dependency 'ParseLiveQuery', '~> 2.7.0 '
   #s.dependency 'GoogleMaps', '3.10.0'
   #s.dependency 'GooglePlaces', '3.10.0'
   #s.dependency "ESTabBarController-swift"
   #s.dependency 'MSPeekCollectionViewDelegateImplementation'
   #s.dependency 'CRRefresh'
   ##s.dependency 'BubbleShowCase'
   #s.dependency 'SVPinView', '~> 1.0'
   #s.dependency 'ImagePickerWhatsApp'
   #s.dependency 'DividerView', '3.0'
   #s.dependency 'YPImagePicker'
   #s.dependency 'FloatRatingView', '~> 4'
   #s.dependency 'NVActivityIndicatorView'
   #s.dependency 'lottie-ios', '2.5.0'
   #s.dependency 'SkeletonView'
   
end
