//
//  RYCommonMethods.m
//  RYUtils
//
//  Created by Ryan on 13-11-6.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "RYCommonMethods.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RYCommonMethods

+ (UIImage *)qrImageForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    /**
     ，根據CIImage結果生成的UIImage對象已經可以顯示，但這裡直接顯示的話有一個問題，原始的二維碼是以每個塊一個像素的單位來產生的，結果將是一個非常小的二維碼圖片，用設備去識別講非常困難。但如果我們直接去縮放這個UIImage的話，結果將會變非常模糊。
     */
    CIImage *ciImage = [qrFilter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImage = [context createCGImage:ciImage
                          
                                       fromRect:[ciImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    /**
     所以我們在最後我們使用了CoreGraphic中CGContextSetInterpolationQuality的kCGInterpolationNone來進行無損的點整縮放，獲得最終放大15倍以後的清晰二維碼圖像并設置到界面中的UIImageView中。
     */
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * 15, image.size.height * 15));
    
    CGContextRef resizeContext = UIGraphicsGetCurrentContext();
    
    CGContextSetInterpolationQuality(resizeContext, kCGInterpolationNone);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width * 15, image.size.height * 15)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if ([textView respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
#if ! __has_feature(objc_arc)
        [paragraphStyle release];
#endif
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}

+ (CGFloat)measureHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    if (text.length > 0)
    {
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        return ceilf(frame.size.height);
    }
    else
        return 0;
}

+ (CGFloat)measureWidthForText:(NSString *)text havingHeight:(CGFloat)heightValue andFont:(UIFont *)font
{
    if (text.length > 0)
    {
        CGRect frame = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, heightValue)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        return ceilf(frame.size.width);
    }
    else
        return 0;
}

//唯一识别号
+ (NSString *)generateUniqueString
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

+ (NSString *) base64StringFromData:(NSData *)imgData length:(NSInteger)lineLength
{
	static const char *encodingTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	const unsigned char *bytes = [imgData bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:[imgData length]];
	unsigned long ixtext = 0;
	unsigned long lentext = [imgData length];
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	short i = 0;
	short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	while( YES ) {
		ctremaining = lentext - ixtext;
		if( ctremaining <= 0 ) break;
		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < lentext ) inbuf[i] = bytes[ix];
			else inbuf [i] = 0;
        }
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
		switch( ctremaining ) {
			case 1:
				ctcopy = 2;
				break;
			case 2:
				ctcopy = 3;
				break;
		}
		for( i = 0; i < ctcopy; i++ )
			[result appendFormat:@"%c", encodingTable[outbuf[i]]];
		for( i = ctcopy; i < 4; i++ )
			[result appendFormat:@"%c",'='];
		ixtext += 3;
        charsonline += 4;
		if( lineLength > 0 ) {
			if (charsonline >= lineLength) {
				charsonline = 0;
				[result appendString:@"n"];
			}
		}
	}
	return result;
}

+ (NSData *)dataFromBase64String:(NSString *)string;
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    if (string == nil) {
        return [NSData data];
    }
    ixtext = 0;
    tempcstring = (const unsigned char *)[string UTF8String];
    lentext = [string length];
    theData = [NSMutableData dataWithCapacity: lentext];
    ixinbuf = 0;
    while (true) {
        if (ixtext >= lentext) {
            break;
        }
        ch = tempcstring [ixtext++];
        flignore = false;
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        }
        else if (ch == '+') {
            ch = 62;
        }
        else if (ch == '=') {
            flendtext = true;
        }
        else if (ch == '/') {
            ch = 63;
        }
        else {
            flignore = true;
        }
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                }
                else {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            if (flbreak) {
                break;
            }
        }
    }
    return theData;
}

+ (NSString *)md5String:(NSString *)baseString
{
    
    if(self == nil || [baseString length] == 0)
        return nil;
    
    const char *value = [baseString UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)(strlen(value)), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
#if ! __has_feature(objc_arc)
    return [outputString autorelease];
#else
    return outputString;
#endif
}

+ (NSString *)appBundleDispalyName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)appBundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (void)customNaviBarItemWithFontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor
{
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], nil]
     setTitleTextAttributes:@{
                              NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                              NSForegroundColorAttributeName: fontColor
                              } forState:UIControlStateNormal];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    if(email.length == 0)
        return NO;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*
 130~139  145,147 15[012356789] 180~189
 */
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    if(mobile.length == 0)
        return NO;
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isValidateString:(NSString *)validString
{
    if(validString.length == 0)
        return NO;
    NSString *validRegex = @"\\w{0,8}";
    NSPredicate *validTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",validRegex];
    return [validTest evaluateWithObject:validString];
}
@end
