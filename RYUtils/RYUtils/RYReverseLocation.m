//
//  RYReverseLocation.m
//  SuZhouWeather
//
//  Created by Ryan on 13-8-9.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "RYReverseLocation.h"

@interface RYReverseLocation()

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) CLLocationManager *locationManager;
#else
@property (nonatomic, strong) CLLocationManager *locationManager;
#endif

@end

@implementation RYReverseLocation

@synthesize locationManager;
@synthesize curLocation;
@synthesize address;
@synthesize completionBlock,errorBlock;
@synthesize reverseCompletionBlock,reverseErrorBlock;

#pragma mark - Singleton methods

- (id)init
{
    if(self = [super init])
    {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //Set the filter to 200 meters
        locationManager.distanceFilter = 200.f;
    }
    return self;
}

+ (RYReverseLocation *)sharedLocation
{
    static RYReverseLocation *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[RYReverseLocation alloc] init];
    });
    return location;
}

- (void)dealloc
{
    locationManager.delegate = nil;
#if ! __has_feature(objc_arc)
    [reverseErrorBlock release];
    [reverseCompletionBlock release];
    [completionBlock release];
    [errorBlock release];
    [address release];
    [curLocation release];
    [locationManager release];
    locationManager = nil;
    [super dealloc];
#endif
}

#pragma mark - Public methods
- (void)updateLocationOnCompletion:(RYCompletionBlock)completion error:(RYErrorBlock)error
{
    self.completionBlock = completion;
    self.errorBlock = error;
    locationManager.delegate = self;
    //iOS定位提示
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            /*
             *      If the NSLocationWhenInUseUsageDescription key is not specified in your
             *      Info.plist, this method will do nothing, as your app will be assumed not
             *      to support WhenInUse authorization.
             */
            NSString *locateDescription = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSLocationWhenInUseUsageDescription"];
            if(locateDescription.length == 0)
            {
                NSString *errorDes = @"iOS8下使用定位请在app-info.plist里加入key:NSLocationWhenInUseUsageDescription.";
                NSError *locateError = [NSError errorWithDomain:errorDes code:400 userInfo:nil];
                [self locationManager:locationManager didFailWithError:locateError];
            }
            [locationManager requestWhenInUseAuthorization];
        }
    }
    [locationManager startUpdatingLocation];
}

- (void)reverseAddressFromLocation:(CLLocation *)location
                      onCompletion:(ReverseCompletionBlock)reverseCompletion
                           onError:(ReverseErrorBlock)reverseError
{
    self.reverseCompletionBlock = reverseCompletion;
    self.reverseErrorBlock = reverseError;
    
    CLGeocoder *geocoder = [[NSClassFromString(@"CLGeocoder") alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError*error){
        if(error)
        {
//            NSLog(@"地址解析错误.");
            self.reverseErrorBlock(@"地址解析错误.");
        }
        else
        {
//            NSLog(@"地址解析成功.");
            for(CLPlacemark *placemark in placemarks)
            {
                //            self.fileDes = [NSString stringWithFormat:@"City:%@ Country:%@ CountryCode:%@ FormattedAddressLines:%@  Name:%@ State:%@ Street:@ SubLocality:%@ Thoroughfare:%@",[placemark.addressDictionary objectForKey:@"City"],[placemark.addressDictionary objectForKey:@"Country"],[placemark.addressDictionary objectForKey:@"CountryCode"],[placemark.addressDictionary objectForKey:@"Name"],[placemark.addressDictionary objectForKey:@"State"],[placemark.addressDictionary objectForKey:@"Street"],[placemark.addressDictionary objectForKey:@"SubLocality"],[placemark.addressDictionary objectForKey:@"Thoroughfare"]];
                self.address = [NSString stringWithFormat:@"%@",[placemark.addressDictionary objectForKey:@"City"]];
                self.reverseCompletionBlock(self.address);
            }
        }
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
//    NSLog(@"定位成功.");
    //Request for new annotations
    locationManager.delegate = nil;     //解决定位在stop之前多次返回的问题
    [manager stopUpdatingLocation];     //停止根据距离移动多次轮询定位
    self.curLocation = newLocation;
    self.completionBlock(self.curLocation);
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
//    NSLog(@"定位错误.");
    locationManager.delegate = nil;     //解决定位在stop之前多次返回的问题
    [manager stopUpdatingLocation];     //停止根据距离移动多次轮询定位
    if(![CLLocationManager locationServicesEnabled] || ([CLLocationManager authorizationStatus] <= kCLAuthorizationStatusDenied))
    {
        self.errorBlock(@"未打开定位服务.");
    }
    else
        self.errorBlock(@"定位错误.");
}
@end
