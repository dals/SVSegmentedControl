//
//  SVSegmentedThumb.m
//  SVSegmentedControl
//
//  Created by Sam Vermette on 25.05.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

#import "SVSegmentedThumb.h"
#import <QuartzCore/QuartzCore.h>

@implementation SVSegmentedThumb

@synthesize title, font, tintColor, textColor, shadowColor, shadowOffset;

- (void)dealloc {
	self.title = nil;
	self.tintColor = nil;
	self.textColor = nil;
	self.shadowColor = nil;
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
	
    if (self) {
		self.userInteractionEnabled = NO;
		self.backgroundColor = [UIColor clearColor];
		self.layer.shadowOffset = CGSizeMake(0, 0);
		self.layer.shadowRadius = 1;
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOpacity = 1;
		self.layer.shouldRasterize = YES;
		
		label = [[UILabel alloc] initWithFrame:self.bounds];
		label.textAlignment = UITextAlignmentCenter;
		label.font = self.font;
		label.backgroundColor = [UIColor clearColor];
		[self addSubview:label];
		[label release];
		
		self.textColor = [UIColor whiteColor];
		self.shadowColor = [UIColor blackColor];
		self.shadowOffset = CGSizeMake(0, -1);
		self.tintColor = [UIColor grayColor];
    }
	
    return self;
}

- (void)setFrame:(CGRect)newFrame {
	[super setFrame:newFrame];
	label.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	// STROKE GRADIENT
	
	CGPathRef strokeRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2].CGPath;
	CGContextAddPath(context, strokeRect);
	CGContextClip(context);
	
	CGContextSaveGState(context);
	
	CGFloat strokeComponents[4] = {    
		0.55, 1,
		0.40, 1
	};
	
	if(selected) {
		strokeComponents[0]-=0.1;
		strokeComponents[2]-=0.1;
	}
	
	CGGradientRef strokeGradient = CGGradientCreateWithColorComponents(colorSpace, strokeComponents, NULL, 2);	
	CGContextDrawLinearGradient(context, strokeGradient, CGPointMake(0,0), CGPointMake(0,CGRectGetHeight(rect)), 0);
	CGGradientRelease(strokeGradient);
	
	
	// FILL GRADIENT
	
	CGPathRef fillRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius:1].CGPath;
	CGContextAddPath(context, fillRect);
	CGContextClip(context);
	
	CGFloat fillComponents[4] = {    
		0.5, 1,
		0.35, 1
	};
	
	if(selected) {
		fillComponents[0]-=0.1;
		fillComponents[2]-=0.1;
	}
	
	CGGradientRef fillGradient = CGGradientCreateWithColorComponents(colorSpace, fillComponents, NULL, 2);	
	CGContextDrawLinearGradient(context, fillGradient, CGPointMake(0,0), CGPointMake(0,CGRectGetHeight(rect)), 0);
	CGGradientRelease(fillGradient);
	
	CGColorSpaceRelease(colorSpace);
	
	CGContextRestoreGState(context);
	[self.tintColor set];
	UIRectFillUsingBlendMode(rect, kCGBlendModeOverlay);
}


#pragma mark -
#pragma mark Setters

- (void)setTitle:(NSString *)newString {
	label.text = newString;
}

- (void)setFont:(UIFont *)newFont {
	font = newFont;
	label.font = newFont;
}

- (void)setTintColor:(UIColor *)newColor {
	
	if(tintColor)
		[tintColor release], tintColor = nil;
	
	if(newColor) {
		tintColor = [newColor retain];
		[self setNeedsDisplay];
	}
}

- (void)setTextColor:(UIColor *)newColor {
	textColor = newColor;
	label.textColor = newColor;
}

- (void)setShadowColor:(UIColor *)newColor {
	shadowColor = newColor;
	label.shadowColor = newColor;
}

- (void)setShadowOffset:(CGSize)newOffset {
	label.shadowOffset = newOffset;
}

#pragma mark -

- (void)setSelected:(BOOL)s {
	
	selected = s;
	
	if(selected)
		self.alpha = 0.8;
	else
		self.alpha = 1;
	
	[self setNeedsDisplay];
}

- (void)activate {
	[self setSelected:NO];
	label.alpha = 1;
}

- (void)deactivate {
	[self setSelected:YES];
	label.alpha = 0;
}


@end
