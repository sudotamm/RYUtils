//
//  RYAsynImageView.m
//  RYUtils
//
//  Created by Ryan Yuan on 4/18/12.
//  Copyright (c) 2012 Ryan. All rights reserved.
//

#import "RYAsynImageView.h"
#import "UIView+RYUtilities.h"
#import "RYImageDownloader.h"

@interface RYAsynImageView()<RYImageDownloaderDelegate>

- (NSString *)getImagesDirectory;
- (BOOL)isImageExistWithName:(NSString *)imageName;

@end

@implementation RYAsynImageView

@synthesize shouldResize;
@synthesize aysnLoader;
@synthesize placeholderName,cacheDir;
@synthesize forYulong;
@synthesize originalFrame;
@synthesize ignoreCache;

#pragma mark - UIView methods
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.originalFrame = frame;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.originalFrame = self.frame;
}


- (void)dealloc
{
    [aysnLoader cancelDownload];
    aysnLoader.delegate = nil;
#if ! __has_feature(objc_arc)
    [cacheDir release];
    [placeholderName release];
    [aysnLoader release];
    aysnLoader = nil;
    [super dealloc];
#endif
}

#pragma mark - Private methods

- (BOOL)isImageExistWithName:(NSString *)imageName
{
    if(nil != [UIImage imageNamed:imageName])
        return YES;
    return NO;
}

- (NSString *)getImagesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths lastObject];
    return [documentDirectory stringByAppendingPathComponent:self.cacheDir];
}

- (void)resizeSelfWithImage:(UIImage *)img
{
    if(CGRectEqualToRect(self.originalFrame, CGRectZero))
    {
        NSAssert(0, @"设置resize的RYAsynImageView的frame不可以为zero");
    }
	// the downloaded local cached article image.
	UIImage *tmpImage = img;
	
	// Adjust the image frame
	CGFloat picWidth = self.originalFrame.size.width;
	CGFloat picHeight = self.originalFrame.size.height;
    
    CGFloat actWidth = tmpImage.size.width;
    CGFloat actHeight = tmpImage.size.height;
	
	if(tmpImage.size.width <= picWidth && tmpImage.size.height <= picHeight)
	{
        actWidth = tmpImage.size.width;
        actHeight = tmpImage.size.height;
	}
	else if(tmpImage.size.width > picWidth && tmpImage.size.height <= picHeight)
	{
        actHeight = actHeight*picWidth/actWidth;
        actWidth = picWidth;
	}
	else if(tmpImage.size.width <= picWidth && tmpImage.size.height > picHeight)
	{
        actWidth = actWidth*picHeight/actHeight;
        actHeight = picHeight;
	}
	else if(tmpImage.size.width > picWidth && tmpImage.size.height > picHeight) 
	{
		if((tmpImage.size.width/picWidth) >= (tmpImage.size.height/picHeight))
		{
            actHeight = picWidth/actWidth*actHeight;
            actWidth = picWidth;
		}
		else 
		{
            actWidth = picHeight/actHeight*actWidth;
            actHeight = picHeight;
		}
	}
    CGRect rect = self.originalFrame;
    rect.origin.x = rect.origin.x+(picWidth-actWidth)/2;
    rect.origin.y = rect.origin.y+(picHeight-actHeight)/2;
    rect.size.height = actHeight;
    rect.size.width = actWidth;
    self.frame = rect;
}

#pragma mark - Public methods

- (void)aysnLoadImageWithUrl:(NSString *)url placeHolder:(NSString *)placeHolder
{
    if(nil != aysnLoader)
    {
        [aysnLoader cancelDownload];
        aysnLoader.delegate = nil;
        aysnLoader = nil;
    }
    self.placeholderName = placeHolder;
    if(nil == url || [url isEqualToString:@""])
    {
        if([self isImageExistWithName:placeHolder])
        {
            UIImage *img = [UIImage imageNamed:placeHolder];
            if(self.shouldResize)
                [self resizeSelfWithImage:img];
            self.image = img;
        }
        else
            NSAssert(0, @"%@ not existed.",placeHolder);
        return;
    }
    NSFileManager *manager =[NSFileManager defaultManager];
    NSArray *array = [url componentsSeparatedByString:@"/"];
    NSString *imageName = [array lastObject];

    NSString *imagePath = [[self getImagesDirectory] stringByAppendingPathComponent:imageName];

    BOOL isDirectory,valid;
    valid = [manager fileExistsAtPath:imagePath isDirectory:&isDirectory];
    if(valid && !isDirectory)
    {
        
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        if(self.shouldResize)
            [self resizeSelfWithImage:img];
        self.image = img;
        if(self.ignoreCache)
        {
            RYImageDownloader *d = [[RYImageDownloader alloc] init];
            d.purpose = imagePath;
            d.delegate = self;
            self.aysnLoader = d;
            
            NSString *realUrl = url;
//            if(forYulong)
//                realUrl = [[ylAppManager sharedAppManager] getURL:url];
            [self.aysnLoader startDownloadWithURL:realUrl];
#if ! __has_feature(objc_arc)
            [d release];
#endif
        }
    }
    else
    {
        if([self isImageExistWithName:placeHolder])
        {
            UIImage *img = [UIImage imageNamed:placeHolder];
            if(self.shouldResize)
                [self resizeSelfWithImage:img];
            self.image = img;
        }
        else
            NSAssert(0, @"%@ not existed.", placeHolder);
        RYImageDownloader *d = [[RYImageDownloader alloc] init];
        d.purpose = imagePath;
        d.delegate = self;
        self.aysnLoader = d;
        
        NSString *realUrl = url;
//        if(forYulong)
//            realUrl = [[ylAppManager sharedAppManager] getURL:url];
        [self.aysnLoader startDownloadWithURL:realUrl];
#if ! __has_feature(objc_arc)
        [d release];
#endif
    }
}

#pragma mark - RYImageDownloaderDelegate methods
- (void)downloader:(RYImageDownloader*)downloader completeWithNSData:(NSData*)data
{
    UIImage *img = [UIImage imageWithData:data];
    if(nil == img)
    {
        [self downloader:downloader didFinishWithError:nil];
        return;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:[self getImagesDirectory]])
        [manager createDirectoryAtPath:[self getImagesDirectory] withIntermediateDirectories:NO attributes:nil error:nil];
    if([data writeToFile:downloader.purpose atomically:NO])
    {
        [self addAnimationWithType:kCATransitionFade subtype:nil];
        if(self.shouldResize)
            [self resizeSelfWithImage:img];
        self.image = img;
    }
}
- (void)downloader:(RYImageDownloader*)downloader didFinishWithError:(NSString*)message
{
    if([self isImageExistWithName:self.placeholderName])
    {
        UIImage *img = [UIImage imageNamed:self.placeholderName];
        if(self.shouldResize)
            [self resizeSelfWithImage:img];
        self.image = img;
    }
    else
        NSAssert(0, @"%@ not existed.", self.placeholderName);
}
@end
