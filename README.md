# RYUtils
Ryan Yuan 的私有库， 自定义了图片异步下载及缓存，Model映射，全局Hud，Media资源获取，全局Popover，定位及解析等常用框架。

所有源码以Objective-C, 基于Sigleton、Category、Runtime、Block等封装实现，后续会逐步迁移之Swift

# Source code

- NSArray+RYLocationTransform.h - 提供火星坐标系，百度坐标系和国际通用坐标系之间的经纬度转换

- NSDate+RYAdditions.h - 提供根据标准日期格式之间日期和字符串类型的互转

- NSObject+RYPropertyList.h - 利用runtime获取对象运行期间的property, methods or variables.

- RYBaseModel.h - 对象字典映射，将object转为dict或dict转为object

- RYAppBackgroundConfiger.h - 后台处理清楚缓存及禁止icloud文件备份

- RYAsynImageView.h - 基于UIImageView异步加载图片

- RYDownloaderManager.h - 基于NSURLConnection封装的网络请求管理类

- RYHUDManager.h - 全局HUD管理类

- RYMediaPicker.h - 相册media资源加载

- RYReverseLocation.h - 封装了GPS定位及经纬度地理位置解析功能

- RYXMLReader.h - Xml文件映射为字典

- UIImage+RYAssetLaunchImage.h - 获取启动图及App名称，版本号等基本信息

- UIImage+RYScreenShot.h - 截图处理

- UIImage+RYUtilities.h - 图片处理常用方法，aspect到指定size，调整图片分辨率，区域截图，图片加水印等

- UIView+RYUtilities.h - 基于UIView之间切换的过渡效果， push/movein/reveal/fade/rotate/flip等

- RYCycleScrollView.h - 首位相连的scrollview

- RYCommonMethods.h - 开发过程中常用的方法，base64编码、md5编码、qrcode生成、正则验证、计算textview content高度等

# Cocoapods集成方式：

pod 'RYUtils'

#License

These specifications and CocoaPods are available under the <a href='https://opensource.org/licenses/mit-license.php'>MIT license</a>.
