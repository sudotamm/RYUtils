//
//  RYReverseLocation.m
//  SuZhouWeather
//
//  Created by Ryan on 13-8-9.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "RYReverseLocation.h"

@interface RYReverseLocation()

@property (nonatomic, retain) CLLocationManager *locationManager;

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
        [locationManager setDelegate:self];
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
    [reverseErrorBlock release];
    [reverseCompletionBlock release];
    [completionBlock release];
    [errorBlock release];
    [address release];
    [curLocation release];
    locationManager.delegate = nil;
    [locationManager release];
    locationManager = nil;
    [super dealloc];
}

#pragma mark - Public methods
- (void)updateLocationOnCompletion:(CompletionBlock)completion error:(ErrorBlock)error
{
    self.completionBlock = completion;
    self.errorBlock = error;
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        [locationManager startUpdatingLocation];
    }
    else
    {
        self.errorBlock(@"未打开定位服务.");
    }
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
            self.reverseErrorBlock(error.description);
        }
        else
        {
            for(CLPlacemark *placemark in placemarks)
            {
                //            self.fileDes = [NSString stringWithFormat:@"City:%@ Country:%@ CountryCode:%@ FormattedAddressLines:%@  Name:%@ State:%@ Street:@ SubLocality:%@ Thoroughfare:%@",[placemark.addressDictionary objectForKey:@"City"],[placemark.addressDictionary objectForKey:@"Country"],[placemark.addressDictionary objectForKey:@"CountryCode"],[placemark.addressDictionary objectForKey:@"Name"],[placemark.addressDictionary objectForKey:@"State"],[placemark.addressDictionary objectForKey:@"Street"],[placemark.addressDictionary objectForKey:@"SubLocality"],[placemark.addressDictionary objectForKey:@"Thoroughfare"]];
                self.address = [NSString stringWithFormat:@"%@",[placemark.addressDictionary objectForKey:@"Name"]];
                self.reverseCompletionBlock(self.address);
            }
        }
    }];
    [geocoder release];
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	//Request for new annotations
    [manager stopUpdatingLocation];
    self.curLocation = newLocation;
    self.completionBlock(self.curLocation);
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    self.errorBlock(error.description);
}
@end