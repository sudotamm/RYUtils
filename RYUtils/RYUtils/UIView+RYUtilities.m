//
//  UIView+RYUtilities.m
//  RYUtils
//
//  Created by Ryan on 12-8-3.
//  Copyright (c) 2012年 Ryan. All rights reserved.
//

#import "UIView+RYUtilities.h"

@implementation UIView (RYUtilities)

- (void)addInnerShadow
{
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = 0.5f * CGRectGetHeight(bounds);
    
    
    // Create the "visible" path, which will be the shape that gets the inner shadow
    // In this case it's just a rounded rect, but could be as complex as your want
    CGMutablePathRef visiblePath = CGPathCreateMutable();
    CGRect innerRect = CGRectInset(bounds, radius, radius);
    CGPathMoveToPoint(visiblePath, NULL, innerRect.origin.x, bounds.origin.y);
    CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x + innerRect.size.width, bounds.origin.y);
    CGPathAddArcToPoint(visiblePath, NULL, bounds.origin.x + bounds.size.width, bounds.origin.y, bounds.origin.x + bounds.size.width, innerRect.origin.y, radius);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.origin.x + bounds.size.width, innerRect.origin.y + innerRect.size.height);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height, innerRect.origin.x + innerRect.size.width, bounds.origin.y + bounds.size.height, radius);
    CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x, bounds.origin.y + bounds.size.height);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x, bounds.origin.y + bounds.size.height, bounds.origin.x, innerRect.origin.y + innerRect.size.height, radius);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.origin.x, innerRect.origin.y);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x, bounds.origin.y, innerRect.origin.x, bounds.origin.y, radius);
    CGPathCloseSubpath(visiblePath);
    
    // Fill this path
    UIColor *aColor = [UIColor redColor];
    [aColor setFill];
    CGContextAddPath(context, visiblePath);
    CGContextFillPath(context);
    
    
    // Now create a larger rectangle, which we're going to subtract the visible path from
    // and apply a shadow
    CGMutablePathRef path = CGPathCreateMutable();
    //(when drawing the shadow for a path whichs bounding box is not known pass "CGPathGetPathBoundingBox(visiblePath)" instead of "bounds" in the following line:)
    //-42 cuould just be any offset > 0
    CGPathAddRect(path, NULL, CGRectInset(bounds, -42, -42));
    
    // Add the visible path (so that it gets subtracted for the shadow)
    CGPathAddPath(path, NULL, visiblePath);
    CGPathCloseSubpath(path);
    
    // Add the visible paths as the clipping path to the context
    CGContextAddPath(context, visiblePath);
    CGContextClip(context);
    
    
    // Now setup the shadow properties on the context
    aColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 3.0f, [aColor CGColor]);
    
    // Now fill the rectangle, so the shadow gets drawn
    [aColor setFill];   
    CGContextSaveGState(context);   
    CGContextAddPath(context, path);
    CGContextEOFillPath(context);
    
    // Release the paths
    CGPathRelease(path);    
    CGPathRelease(visiblePath);
}

-(void)addGrayGradientShadow{
	// 0.8 is a good feeling shadowOpacity
	self.layer.shadowOpacity = 1.f;
	
	// The Width and the Height of the shadow rect
	CGFloat rectWidth = 10.f;
	CGFloat rectHeight = self.frame.size.height;
	
	// Creat the path of the shadow
	CGMutablePathRef shadowPath = CGPathCreateMutable();
	// Move to the (0, 0) point
	CGPathMoveToPoint(shadowPath, NULL, 0.0, 0.0);
	// Add the Left and right rect
	CGPathAddRect(shadowPath, NULL, CGRectMake(0.0-rectWidth, 0.0, rectWidth, rectHeight));
	CGPathAddRect(shadowPath, NULL, CGRectMake(self.frame.size.width+rectWidth, 0.0, rectWidth, rectHeight));
	
	self.layer.shadowPath = shadowPath;
	CGPathRelease(shadowPath);
	// Since the default color of the shadow is black, we do not need to set it now
	self.layer.shadowColor = [UIColor redColor].CGColor;
	
	self.layer.shadowOffset = CGSizeMake(0, 0);
	// This is very important, the shadowRadius decides the feel of the shadow
	self.layer.shadowRadius = 0;
}

// add the shadow effect to the view
-(void)addShadow{
	self.layer.shadowOpacity = 0.4;
	self.layer.shadowRadius = 1.5;
	self.layer.shadowOffset = CGSizeMake(0, 0);
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	CGPoint p1 = CGPointMake(0.0, 0.0+self.frame.size.height);
	CGPoint p2 = CGPointMake(0.0+self.frame.size.width, p1.y);
	CGPoint c1 = CGPointMake((p1.x+p2.x)/4 , p1.y+6.0);
	CGPoint c2 = CGPointMake(c1.x*3, c1.y);
	
	[path moveToPoint:p1];
	[path addCurveToPoint:p2 controlPoint1:c1 controlPoint2:c2];
	
	self.layer.shadowPath = path.CGPath;
}

-(void)addMovingShadow{
	
	
	static float step = 0.0;
	if (step>20.0) {
		step = 0.0;
	}
	
	self.layer.shadowOpacity = 0.4;
	self.layer.shadowRadius = 1.5;
	self.layer.shadowOffset = CGSizeMake(0, 0);
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	CGPoint p1 = CGPointMake(0.0, 0.0+self.frame.size.height);
	CGPoint p2 = CGPointMake(0.0+self.frame.size.width, p1.y);
	CGPoint c1 = CGPointMake((p1.x+p2.x)/4 , p1.y+step);
	CGPoint c2 = CGPointMake(c1.x*3, c1.y);
	
	[path moveToPoint:p1];
	[path addCurveToPoint:p2 controlPoint1:c1 controlPoint2:c2];
	
	self.layer.shadowPath = path.CGPath;
	step += 0.1;
	[self performSelector:@selector(addMovingShadow) withObject:nil afterDelay:1.0/30.0];
}

- (void)addAnimationWithType:(NSString *)type subtype:(NSString *)subtype;
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5f;
    transtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transtion.type = type;
    transtion.subtype = subtype;
    [self.layer addAnimation:transtion forKey:nil];
}

@end
