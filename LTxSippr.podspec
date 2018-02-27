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


  s.default_subspecs = 'Foundation'

# 消息模块
  s.subspec 'Message' do |sp|
    sp.source_files  =  "LTxSipprMsg/**/*.{h,m,xib}", "LTxSipprFoundation/**/*.{h,m}"
    sp.public_header_files = "LTxSipprMsg/**/**/*.h", "LTxSipprFoundation/**/**/*.h"
  end

# 核心模块
  s.subspec 'Foundation' do |sp|
    sp.source_files  =  "LTxSipprFoundation/**/*.{h,m}"
    sp.public_header_files = "LTxSipprFoundation/**/**/*.h"
    sp.resources = 'LTxSipprComponents.bundle/Images/*.*'
  end



  s.dependency 'LTFileQuickPreview'
  s.dependency 'MJRefresh'
  s.dependency 'DZNEmptyDataSet'
  s.dependency 'AFNetworking'
  s.frameworks = "Foundation", "UIKit"

end
