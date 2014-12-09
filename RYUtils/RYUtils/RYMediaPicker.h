//
//  RYMediaPicker.h
//  NOAHWM
//
//  Created by Ryan on 13-6-18.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

/**
 该类用于管理设备的照片选择（拍照或照片库选择）
 可获取文件基本信息和详细信息（获取文件信息）
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kAllType = 0,
    kPhotoType,
    kMovieType
}FileType;

@protocol RYMediaPickerDelegate;

@interface RYMediaPicker : NSObject
<UINavigationControllerDelegate, UIImagePickerControllerDelegate,
CLLocationManagerDelegate>

@property (nonatomic, assign) BOOL showExtraInfo;       //是否获取media文件的详细信息，默认no
@property (nonatomic, assign) BOOL mediaEditing;        //media文件是否能编辑，默认no
@property (nonatomic, assign) FileType fileType;        //media文件的类型

#if ! __has_feature(objc_arc)
@property (nonatomic, assign) id<RYMediaPickerDelegate> delegate;
@property (nonatomic, assign) id parentController;      //基于parentController present picker
#else
@property (nonatomic, weak) id<RYMediaPickerDelegate> delegate;
@property (nonatomic, weak) id parentController;      //基于parentController present picker
#endif

//基本信息
@property (nonatomic, copy) NSString *fileName;       //media文件的文件名 - 唯一识别名称
#if ! __has_feature(objc_arc)
@property (nonatomic, retain) NSData *fileData;         //media文件的二进制流数据
#else
@property (nonatomic, strong) NSData *fileData;         //media文件的二进制流数据
#endif

//详细信息
@property (nonatomic, copy) NSString *fileLocationName; //media文件的地址名称
#if ! __has_feature(objc_arc)
@property (nonatomic, retain) CLLocation *fileLocation; //media文件的经纬度
@property (nonatomic, retain) NSDate *fileDate;         //media文件的日期
#else
@property (nonatomic, strong) CLLocation *fileLocation; //media文件的经纬度
@property (nonatomic, strong) NSDate *fileDate;         //media文件的日期
#endif

+ (RYMediaPicker *)sharedPicker;

/**
	打开摄像头拍照
 */
- (void)takePhotoWithCamera;


/**
	获取本地照片库文件
	@returns 如果是iphone设备直接显示照片库，如果是ipad设备，返回UIImagePickerController句柄，ipad照片库选择需要用popover展示
 */
- (UIImagePickerController *)getPhotoFromLibrary;

@end

@protocol RYMediaPickerDelegate <NSObject>

- (void)didGetFileWithData:(RYMediaPicker *)mediaPicker;
- (void)didGetFileFailedWithMessage:(NSString *)mes;
@end
