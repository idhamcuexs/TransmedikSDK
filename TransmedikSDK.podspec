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

  s.description      = "TransmedikSDK for we plus"

  s.homepage         = 'https://github.com/idhamcuexs/TransmedikSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'idham290593@gmail.com' => 'idham290593@gmail.com' }
  s.source           = { :git => 'https://github.com/idhamcuexs/TransmedikSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_versions = "4.2 "
  s.source_files = 'TransmedikSDK/Classes/*.swift'
  
   s.resource_bundles = {
      'TransmedikSDK' => ['TransmedikSDK/Assets/*.{storyboard,xcassets,nib}']
   }
   
   
   
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit','Alamofire'
   
    s.dependency 'Alamofire', '~> 5.4'
    s.dependency 'SwiftyJSON', '~> 5.0.0'
    s.dependency 'MessageKit', '~> 3.0.0'
    s.dependency 'Kingfisher', '~> 5.15.8'
    s.dependency 'FSPagerView', '~> 0.8.3'
    s.dependency 'IQKeyboardManagerSwift', '~> 6.5.6'
    s.dependency 'SwiftyCodeView', '~> 0.3.6'
    s.dependency 'DropDown', '~> 2.3.13'
    s.dependency 'MessageInputBar', '~> 0.4.0'
    s.dependency 'URLEmbeddedView', '~> 0.18.0'
    s.dependency 'SwipeCellKit', '~> 2.7.1'
    s.dependency 'Parse', '~> 1.19.1'
    s.dependency 'Lightbox', '~> 2.5.0'
    s.dependency 'CDAlertView','~> 0.10.0'
    s.dependency 'Starscream', '~> 3.1.0'
    s.dependency 'ParseLiveQuery', '~> 2.7.0 '
#    s.dependency 'GoogleMaps', '~> 3.10.0'
#    s.dependency 'GooglePlaces', '~> 3.10.0 '
    s.dependency 'ESTabBarController-swift', '~> 2.8.0 '
    s.dependency 'MSPeekCollectionViewDelegateImplementation', '~> 3.1.1 '
    s.dependency 'CRRefresh', '~> 1.1.3 '
    s.dependency 'BubbleShowCase', '~> 1.2.0 '
    s.dependency 'SVPinView', '~> 1.0'
    s.dependency 'ImagePickerWhatsApp', '~> 1.0.0'
    s.dependency 'DividerView', '~>3.0'
    s.dependency 'YPImagePicker', '~>4.4.0'
    s.dependency 'FloatRatingView', '~> 4'
    s.dependency 'NVActivityIndicatorView', '~> 5.1.1'
    s.dependency 'lottie-ios', '~> 2.5.0'
    s.dependency 'SkeletonView', '~> 1.11.0'

   
end
