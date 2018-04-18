Pod::Spec.new do |s|
  s.name         = "LTxSippr"
  s.version      = "0.0.5"
  s.summary      = "Components For Sippr. "
  s.license      = "MIT"
  s.author             = { "liangtong" => "l900416@163.com" }

  s.homepage     = "https://github.com/l900416/LTxSipprComponents"
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/l900416/LTxSipprComponents.git", :tag => "#{s.version}" }

  s.dependency 'LTFileQuickPreview'
  s.dependency 'MJRefresh', '~> 3.1.15.3'
  s.dependency 'DZNEmptyDataSet', '~> 1.8.1'
  s.dependency 'AFNetworking', '~> 3.2.0'
  s.dependency 'Toast', '~> 4.0.0'
  s.frameworks = "Foundation", "UIKit"

  s.default_subspecs = 'Core'


  # 核心模块
  s.subspec 'Core' do |sp|
    # Model
    sp.subspec 'Model' do |ssp|
        ssp.source_files  =  "LTxSipprFoundation/Model/*.{h,m}"
        ssp.public_header_files = "LTxSipprFoundation/Model/**/*.h"
    end

    # Utils
    sp.subspec 'Utils' do |ssp|
        ssp.source_files  =  "LTxSipprFoundation/Utils/*.{h,m}"
        ssp.public_header_files = "LTxSipprFoundation/Utils/**/*.h"
        ssp.dependency 'LTxSippr/Core/Model'
    end

    # Views
        sp.subspec 'Views' do |ssp|
        ssp.source_files  =  "LTxSipprFoundation/Views/*.{h,m}"
        ssp.public_header_files = "LTxSipprFoundation/Views/**/*.h"
        ssp.dependency 'LTxSippr/Core/Utils'
    end

    # Controllers
    sp.subspec 'Controllers' do |ssp|
        ssp.source_files  =  "LTxSipprFoundation/Controllers/*.{h,m}"
        ssp.public_header_files = "LTxSipprFoundation/Controllers/**/*.h"
        ssp.dependency 'LTxSippr/Core/Views'
    end

  end


  # 消息模块
  s.subspec 'Message' do |sp|
    sp.dependency 'LTxSippr/Core'

    # Model
        sp.subspec 'Model' do |ssp|
        ssp.source_files  =  "LTxSipprMsg/Model/*.{h,m}"
        ssp.public_header_files = "LTxSipprMsg/Model/*.h"
    end

    # ViewModel
        sp.subspec 'ViewModel' do |ssp|
        ssp.source_files  =  "LTxSipprMsg/ViewModel/*.{h,m}"
        ssp.public_header_files = "LTxSipprMsg/ViewModel/*.h"
    end

    # Views
        sp.subspec 'Views' do |ssp|
        ssp.source_files  =  "LTxSipprMsg/Views/*.{h,m,xib}"
        ssp.public_header_files = "LTxSipprMsg/Views/*.h"
        ssp.dependency 'LTxSippr/Message/Model'
    end

    # Controllers
        sp.subspec 'Controllers' do |ssp|
        ssp.source_files  =  "LTxSipprMsg/Controllers/*.{h,m}"
        ssp.public_header_files = "LTxSipprMsg/Controllers/*.h"
        ssp.dependency 'LTxSippr/Message/Views'
        ssp.dependency 'LTxSippr/Message/ViewModel'
    end

  end

  # 设置模块
  s.subspec 'Setting' do |sp|
    sp.dependency 'LTxSippr/Core'

    # Model
        sp.subspec 'Model' do |ssp|
        ssp.source_files  =  "LTxSipprSetting/Model/*.{h,m}"
        ssp.public_header_files = "LTxSipprSetting/Model/*.h"
    end

    # ViewModel
    sp.subspec 'ViewModel' do |ssp|
        ssp.source_files  =  "LTxSipprSetting/ViewModel/*.{h,m}"
        ssp.public_header_files = "LTxSipprSetting/ViewModel/*.h"
    end

    # Views
    sp.subspec 'Views' do |ssp|
        ssp.source_files  =  "LTxSipprSetting/Views/*.{h,m,xib}"
        ssp.public_header_files = "LTxSipprSetting/Views/*.h"
        ssp.dependency 'LTxSippr/Setting/Model'
    end

    # Controllers
    sp.subspec 'Controllers' do |ssp|
        ssp.source_files  =  "LTxSipprSetting/Controllers/*.{h,m}"
        ssp.public_header_files = "LTxSipprSetting/Controllers/*.h"
        ssp.dependency 'LTxSippr/Setting/Views'
        ssp.dependency 'LTxSippr/Setting/ViewModel'
        ssp.dependency 'LTxSippr/Camera/QRCode'
    end

  end

  # Camera模块
  s.subspec 'Camera' do |sp|
    sp.dependency 'LTxSippr/Core'
    sp.dependency 'SGQRCode', '~> 2.2.0'
    # Common
    sp.subspec 'Common' do |ssp|
        ssp.source_files  =  "LTxSipprCamera/Common/*.{h,m}"
        ssp.public_header_files = "LTxSipprCamera/Common/*.h"
    end

    # QRCode
    sp.subspec 'QRCode' do |ssp|
        ssp.source_files  =  "LTxSipprCamera/QRCode/*.{h,m}"
        ssp.public_header_files = "LTxSipprCamera/QRCode/*.h"
        ssp.dependency 'LTxSippr/Camera/Common'
    end

    # Photo
    sp.subspec 'Photo' do |ssp|
        ssp.source_files  =  "LTxSipprCamera/Photo/*.{h,m}"
        ssp.public_header_files = "LTxSipprCamera/Photo/*.h"
        ssp.dependency 'LTxSippr/Camera/Common'
    end

  end

end
