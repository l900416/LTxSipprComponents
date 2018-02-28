Pod::Spec.new do |s|
  s.name         = "LTxSippr"
  s.version      = "0.0.1"
  s.summary      = "Components For Sippr. "
  s.license      = "MIT"
  s.author             = { "liangtong" => "l900416@163.com" }

  s.homepage     = "https://github.com/l900416/LTxSipprComponents"
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/l900416/LTxSipprComponents.git", :tag => "#{s.version}" }

  s.dependency 'LTFileQuickPreview'
  s.dependency 'MJRefresh'
  s.dependency 'DZNEmptyDataSet'
  s.dependency 'AFNetworking'
  s.frameworks = "Foundation", "UIKit"

  s.default_subspecs = 'Core'

# 资源模块
  s.subspec 'Support' do |sp|
    sp.resources = 'LTxSipprComponents.bundle'
  end

# 核心模块
  s.subspec 'Core' do |sp|
    # 依赖
    sp.dependency 'LTxSippr/Support'

    # Utils
    sp.subspec 'Utils' do |ssp|
        ssp.source_files  =  "LTxSipprFoundation/Utils/*.{h,m}"
        ssp.public_header_files = "LTxSipprFoundation/Utils/**/*.h"
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



end
