//
//  RYMediaPicker.m
//  NOAHWM
//
//  Created by Ryan on 13-6-18.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "RYMediaPicker.h"
#import "AssetsLibrary/AssetsLibrary.h"

@interface RYMediaPicker()

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
#else
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
#endif

@end

@implementation RYMediaPicker

@synthesize fileType,fileName,fileData;
@synthesize fileLocation,fileDate,fileLocationName;
@synthesize parentController,delegate;
@synthesize showExtraInfo, mediaEditing;
@synthesize imagePickerController;

+ (RYMediaPicker *)sharedPicker
{
    static RYMediaPicker *picker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[RYMediaPicker alloc] init];
    });
    return picker;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    [imagePickerController release];
    [fileLocationName release];
    [fileDate release];
    [fileLocation release];
    [fileName release];
    [fileData release];
    [super dealloc];
}
#endif

- (UIImagePickerController *)imagePickerController
{
    if(nil == imagePickerController)
    {
        imagePickerController = [[UIImagePickerController alloc] init];
    }
    return imagePickerController;
}

- (void)clearCacheAfterCallBack
{
    self.fileName = nil;
    self.fileData = nil;
    self.fileLocation = nil;
    self.fileDate = nil;
    self.fileLocationName = nil;
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GetPictureFromDevice methods

- (void)takePhotoWithCamera
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
		if(self.fileType == kPhotoType)
			self.imagePickerController.mediaTypes = [NSArray arrayWithObject:@"public.image"];
		else if(self.fileType == kMovieType){
			self.imagePickerController.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
		}
        else
        {
            self.imagePickerController.mediaTypes = [NSArray arrayWithObjects:@"public.image",@"public.movie", nil];
        }
		self.imagePickerController.delegate = self;
		self.imagePickerController.allowsEditing = self.mediaEditing;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [(UIViewController *)self.parentController presentViewController:self.imagePickerController animated:YES completion:nil];
        }
        else {
            UIViewController *vc = (UIViewController *)self.parentController;
            UIViewController *modalVC = [vc presentedViewController];
            if(nil == modalVC)
            {
                [vc presentViewController:self.imagePickerController animated:YES completion:nil];
            }
            else {
                [modalVC presentViewController:self.imagePickerController animated:YES completion:nil];
            }
        }
	}
	else {
        [self.delegate didGetFileFailedWithMessage:@"设备不支持摄像头"];
	}
}

- (UIImagePickerController *)getPhotoFromLibrary
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
		if(self.fileType == kPhotoType)
			self.imagePickerController.mediaTypes = [NSArray arrayWithObject:@"public.image"];
		else if(self.fileType == kMovieType){
			self.imagePickerController.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
		}
        else
        {
            self.imagePickerController.mediaTypes = [NSArray arrayWithObjects:@"public.image",@"public.movie", nil];
        }
		self.imagePickerController.delegate = self;
		self.imagePickerController.allowsEditing = self.mediaEditing;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            return self.imagePickerController;
        }
        else {
            [(UIViewController *)self.parentController presentViewController:self.imagePickerController animated:YES completion:nil];
            self.imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
	}
	else {
        [self.delegate didGetFileFailedWithMessage:@"设备不支持摄像头"];
	}
    return nil;
}

#pragma mark UIImagePickerController delegate methods
//Get thumbnail image for movie the user choose to show in pre-view
//- (UIImage *)getThumbnailImageForMovie:(UIImagePickerController *)imagePicker
//{
//	//CFShow([[NSFileManager defaultManager] directoryContentsAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents"]]);
//	CGSize sixzevid=CGSizeMake(imagePicker.view.bounds.size.width,imagePicker.view.bounds.size.height-100);
//	UIGraphicsBeginImageContext(sixzevid);
//	[imagePicker.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	return viewImage;
//}

//唯一识别号
- (NSString *)generateUniqueFileName
{
	CFUUIDRef uuid;
	CFStringRef uuidStr;
	NSString *result;
    
	uuid = CFUUIDCreate(NULL);
	assert(uuid != NULL);
    
	uuidStr = CFUUIDCreateString(NULL, uuid);
	assert(uuidStr != NULL);
    
	result = [NSString stringWithFormat:@"%@", uuidStr];
    
	CFRelease(uuidStr);
	CFRelease(uuid);
    
	return result;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSString *fullName = nil;
	NSData *uploadData = nil;
	if(self.fileType == kPhotoType){
		UIImage *image = nil;
        if(self.mediaEditing)
        {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        else
        {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        NSString *str = [self generateUniqueFileName];
        fullName = [NSString stringWithFormat:@"%@.jpg",str];
        uploadData = UIImageJPEGRepresentation(image, 1);
	}
	else if(self.fileType == kMovieType){
		NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
		uploadData = [NSData dataWithContentsOfURL:videoURL];
        NSString *str = [self generateUniqueFileName];
        fullName = [NSString stringWithFormat:@"%@.mov",str];
	}
	//保存文件基本信息，文件名(fileName)和文件内容(fileData) - 文件名生成的唯一识别号
	self.fileName = fullName;
	self.fileData = uploadData;
    
    if(self.showExtraInfo)
    {
        //获取文件的具体信息，文件地址(fileDes)，文件日期(fileDate)，文件经纬度(fileLocation)
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSURL *referenceUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
        if(referenceUrl)
        {
            //如果文件本身保存了相关信息，从程序集获取，否则重新获取日期，定位信息
            [library assetForURL:referenceUrl resultBlock:^(ALAsset *asset) {
                // code to handle the asset here
                self.fileLocation = [asset valueForProperty:ALAssetPropertyLocation];
                self.fileDate = [asset valueForProperty:ALAssetPropertyDate];
                [self analysisLocationToAddressWithLocation:self.fileLocation];
            } failureBlock:^(NSError *error) {
                // error handling
                [self.delegate didGetFileWithData:self];
                [self clearCacheAfterCallBack];
            }];
        }
        else {
            self.fileDate = [NSDate date];
            //get the current location from gps
            CLLocationManager *locManager = [[CLLocationManager alloc] init];
            [locManager setDelegate:self];
            [locManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //Set the filter to 200 meters
            locManager.distanceFilter = 200.f;
            [locManager startUpdatingLocation];
        }
#if ! __has_feature(objc_arc)
        [library release];
#endif
    }
    else
    {
        [self.delegate didGetFileWithData:self];
        [self clearCacheAfterCallBack];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CLLocationManagerDelegate methods

- (void)analysisLocationToAddressWithLocation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[NSClassFromString(@"CLGeocoder") alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError*error){
        for(CLPlacemark *placemark in placemarks)
        {
            //            self.fileDes = [NSString stringWithFormat:@"City:%@ Country:%@ CountryCode:%@ FormattedAddressLines:%@  Name:%@ State:%@ Street:@ SubLocality:%@ Thoroughfare:%@",[placemark.addressDictionary objectForKey:@"City"],[placemark.addressDictionary objectForKey:@"Country"],[placemark.addressDictionary objectForKey:@"CountryCode"],[placemark.addressDictionary objectForKey:@"Name"],[placemark.addressDictionary objectForKey:@"State"],[placemark.addressDictionary objectForKey:@"Street"],[placemark.addressDictionary objectForKey:@"SubLocality"],[placemark.addressDictionary objectForKey:@"Thoroughfare"]];
            self.fileLocationName = [NSString stringWithFormat:@"%@",[placemark.addressDictionary objectForKey:@"Name"]];
        }
        [self.delegate didGetFileWithData:self];
        [self clearCacheAfterCallBack];
    }];
#if ! __has_feature(objc_arc)
    [geocoder release];
#endif
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	//Request for new annotations
    [manager stopUpdatingLocation];
    manager.delegate = nil;
#if ! __has_feature(objc_arc)
    [manager release];
#endif
    manager = nil;
    
    self.fileLocation = newLocation;
    [self analysisLocationToAddressWithLocation:self.fileLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    manager.delegate = nil;
#if ! __has_feature(objc_arc)
    [manager release];
#endif
    manager = nil;

    [self.delegate didGetFileWithData:self];
    [self clearCacheAfterCallBack];
}
@end
