//
//  PieView.m
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 19/11/08.
//  Copyright 2008 Taps and Swipes. All rights reserved.
//

#import "PieView.h"


#define kStartAngle				8.0
#define kEndAngle				100.0
#define kTotalAngle				(360.0 - endAngle + initAngle)
#define kInnerCircleRadius		(38.0 + 10.0 * fingerSize)
#define kOuterCircleRadius		(kInnerCircleRadius + 50.0)
#define kBackItemRadius         (kOuterCircleRadius - 5.0)
#define kParentItemRadius       (kOuterCircleRadius + 5.0)
#define kCornerRadius           5.0
#define kRoundedRectRadius      10.0

#define kAlphaValue             1.0

#define kNoItemSelected         -1

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define RADIANS_TO_DEGREE(__ANGLE__) ((__ANGLE__) / M_PI * 180.0)

@interface PieView ()

@property (nonatomic) NSInteger selectedItem;
@property (nonatomic, retain) NSTimer *timer;

@end


@interface PieView (PrivateMethods)
- (void) initData;
- (void) initGradients;
- (void) itemSelected:(NSInteger)index;
- (CGMutablePathRef) newPathForRect:(CGRect)rect;
- (void) testForPoint:(CGPoint)point;
- (void) subitemsTimerFired:(NSTimer *)theTimer;
- (void) parentTimerFired:(NSTimer *)theTimer;
@end


@implementation PieView

@synthesize selectedItem;
@synthesize leftHanded;
@synthesize fingerSize;
@synthesize menu;
@synthesize timer;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self initData];
    }
    return self;
}

- (void) awakeFromNib {
	[self initData];
}

- (void) initData {
	[self initGradients];
	selectedItem = kNoItemSelected;
	self.backgroundColor = [UIColor clearColor];
	[self setLeftHanded:self.leftHanded];
}

- (void) setLeftHanded:(BOOL)isLeftHanded {
	leftHanded = isLeftHanded;
	if (leftHanded) {
		initAngle = kStartAngle + 72.0;
		endAngle = kEndAngle + 72.0;
	} else {
		initAngle = kStartAngle;
		endAngle = kEndAngle;
	}
	
}

- (CGFloat) minimumSize {
	return (kParentItemRadius + 5.0 ) * 2.0;
}

- (void) initGradients {

	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	
	CGFloat col1[] =
	{
		//209.0/255.0, 210.0/255.0, 212.0/255.0, kAlphaValue,
		184.0/255.0, 185.0/255.0, 186.0/255.0, kAlphaValue,
		203.0/255.0, 204.0/255.0, 206.0/255.0, kAlphaValue,
		243.0/255.0, 243.0/255.0, 243.0/255.0, kAlphaValue,
	};
	bggradient = CGGradientCreateWithColorComponents(rgb, col1, NULL, sizeof(col1)/(sizeof(col1[0])*4));
	
	CGFloat col2[] =
	{
		39.0/255.0, 119.0/255.0, 252.0/255.0, kAlphaValue,
		114.0/255.0, 173.0/255.0, 255.0/255.0, kAlphaValue,
	};
	selgradient = CGGradientCreateWithColorComponents(rgb, col2, NULL, sizeof(col2)/(sizeof(col2[0])*4));

	CGColorSpaceRelease(rgb);
	

}

- (void) itemSelected:(NSInteger)index {
	if (index >= 0 && index < kMaxNumberOfItems) {
		PieMenuItem *item = (PieMenuItem *)items[index];
		[menu itemSelected:item];
	} else {
		[menu itemSelected:nil];
	}
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGRect bounds = self.bounds;
	CGPoint center = CGPointMake(bounds.size.width / 2.0, bounds.size.height / 2.0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 153.0/255.0, 153.0/255.0, 153.0/255.0, 1.0);
	CGContextSetRGBFillColor(context, 100.0/255.0, 100.0/255.0, 100.0/255.0, kAlphaValue);
	CGContextSetLineWidth(context, 0.6);
	UIFont *font = [UIFont boldSystemFontOfSize:12.0];

	
	CGFloat startAngle = initAngle;
	CGFloat pieceAngle = kTotalAngle / n_items;
	float           myColorValues[] = {255.0/255.0, 255.0/255.0, 255.0/255.0, 1.0};
	CGColorRef      myColor;
	float           myColorValues2[] = {51.0/255.0, 51.0/255.0, 51.0/255.0, 1.0};
	CGColorRef      myColor2;
    CGColorSpaceRef myColorSpace;
	myColorSpace = CGColorSpaceCreateDeviceRGB ();
    myColor = CGColorCreate (myColorSpace, myColorValues);
	myColor2 = CGColorCreate (myColorSpace, myColorValues2);
	
	
	UIImage *previmage = nil;
	CGPoint imagePoint;

	for (int i = 0; i < n_items; i++) {
		PieMenuItem *item = items[i];
		
		CGFloat radius = (item.type == PieMenuItemTypeParent ? kParentItemRadius : (item.type == PieMenuItemTypeBack ? kBackItemRadius : kOuterCircleRadius));
		if (item.type == PieMenuItemTypeBack) {
			CGFloat pieceCenterAngle = startAngle - pieceAngle / 2.0;
			CGFloat pieceRadius = kInnerCircleRadius + (radius - kInnerCircleRadius) / 2.0;
			CGPoint pieceCenter = CGPointMake(center.x + pieceRadius * cosf(DEGREES_TO_RADIANS(pieceCenterAngle)), center.y + pieceRadius * sinf(DEGREES_TO_RADIANS(pieceCenterAngle)));
			UIImage *image = (UIImage *)item.icon;
			if (i == selectedItem) {
				imagePoint = CGPointMake(pieceCenter.x - image.size.width * 1.5 / 2.0, pieceCenter.y - image.size.height * 1.5 / 2.0);
				previmage = image;
			} else {
				imagePoint = CGPointMake(pieceCenter.x - image.size.width / 2.0, pieceCenter.y - image.size.height / 2.0);
				previmage = nil;
				[image drawAtPoint:imagePoint];
			}
		} else {
			CGFloat alpha = RADIANS_TO_DEGREE(atanf(kCornerRadius/radius));
			CGFloat cradius = cosf(DEGREES_TO_RADIANS(alpha)) * radius;
			CGFloat angle = startAngle - pieceAngle;
			//CGPoint a = CGPointMake(center.x + kInnerCircleRadius * cosf(DEGREES_TO_RADIANS(startAngle)), center.y + kInnerCircleRadius * sinf(DEGREES_TO_RADIANS(startAngle)));
			CGPoint b = CGPointMake(center.x + (radius - kCornerRadius) * cosf(DEGREES_TO_RADIANS(startAngle)), center.y + (radius - kCornerRadius) * sinf(DEGREES_TO_RADIANS(startAngle)));
			CGPoint c = CGPointMake(center.x + cradius * cosf(DEGREES_TO_RADIANS(startAngle)), center.y + cradius * sinf(DEGREES_TO_RADIANS(startAngle)));
			CGPoint d = CGPointMake( center.x + radius * cosf(DEGREES_TO_RADIANS(startAngle - alpha)), center.y + radius * sinf(DEGREES_TO_RADIANS(startAngle - alpha)));
			//CGPoint e = CGPointMake( center.x + radius * cosf(DEGREES_TO_RADIANS(angle + alpha)), center.y + radius * sinf(DEGREES_TO_RADIANS(angle + alpha)));
			CGPoint f = CGPointMake(center.x + cradius * cosf(DEGREES_TO_RADIANS(angle)), center.y + cradius * sinf(DEGREES_TO_RADIANS(angle)));
			CGPoint g = CGPointMake(center.x + (radius - kCornerRadius) * cosf(DEGREES_TO_RADIANS(angle)), center.y + (radius - kCornerRadius) * sinf(DEGREES_TO_RADIANS(angle)));
			//CGPoint h = CGPointMake(center.x + kInnerCircleRadius * cosf(DEGREES_TO_RADIANS(angle)), center.y + kInnerCircleRadius * sinf(DEGREES_TO_RADIANS(angle)));
			
			CGMutablePathRef path = CGPathCreateMutable();
			CGPathMoveToPoint(path, NULL, b.x, b.y);
			CGPathAddArcToPoint(path, NULL, c.x, c.y, d.x, d.y, kCornerRadius);
			CGPathAddArc(path, NULL, center.x, center.y, radius, DEGREES_TO_RADIANS(startAngle-alpha), DEGREES_TO_RADIANS(startAngle - pieceAngle + alpha), 1);
			CGPathAddArcToPoint(path, NULL, f.x, f.y, g.x, g.y, kCornerRadius);
			CGPathAddArc(path, NULL, center.x, center.y, kInnerCircleRadius, DEGREES_TO_RADIANS( startAngle - pieceAngle), DEGREES_TO_RADIANS(startAngle), 0);
			CGPathCloseSubpath(path);

			CGContextSaveGState(context);
			CGContextSetShadow(context, CGSizeMake(0, 0), 5.0);
			CGContextAddPath(context, path);
			CGContextDrawPath(context, kCGPathFill);
			CGContextRestoreGState(context);
			
			CGContextSaveGState(context);
			CGContextAddPath(context, path);
			CGContextClip(context);
			if (i == selectedItem) {
				CGContextDrawRadialGradient(context, selgradient, center, radius * 0.3, center, radius, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
			} else {
				CGContextDrawRadialGradient(context, bggradient, center, kInnerCircleRadius, center, radius - 2.0, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
			}
			CGContextRestoreGState(context);
			CGPathRelease(path);
			
			CGContextSaveGState(context);
			CGFloat pieceCenterAngle = startAngle - pieceAngle / 2.0;
			CGFloat pieceRadius = kInnerCircleRadius + (radius - kInnerCircleRadius) / 2.0;
			CGSize titleSize = [item.title sizeWithFont:font];
			CGPoint labelCenter = CGPointMake(center.x + pieceRadius * cosf(DEGREES_TO_RADIANS(pieceCenterAngle)), center.y + pieceRadius * sinf(DEGREES_TO_RADIANS(pieceCenterAngle)));
			if (item.icon != nil) {
				[item.icon drawAtPoint:CGPointMake(labelCenter.x - item.icon.size.width / 2.0, labelCenter.y - item.icon.size.height ) ];
				labelCenter.y += item.icon.size.height / 3.0;
			}
			NSString *txt = [NSString stringWithString:item.title];
			if (item.type == PieMenuItemTypeParent) {
				txt = [txt stringByAppendingString:@"..."];
			}
			if (i == selectedItem) {
				CGContextSetRGBFillColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1.0);
				CGContextSetShadowWithColor(context, CGSizeMake(0, -1.0), 0.0, myColor2);
			} else {
				CGContextSetRGBFillColor(context, 51.0/255.0, 51.0/255.0, 51.0/255.0, 1.0);
				CGContextSetShadowWithColor(context, CGSizeMake(0, -1.0), 0.0, myColor);
			}
			[txt drawAtPoint:CGPointMake(labelCenter.x - titleSize.width / 2.0, labelCenter.y - titleSize.height / 2.0) withFont:font];	
		
			CGContextRestoreGState(context);
		}
		startAngle -= pieceAngle;
	}
	CGColorRelease (myColor);
	CGColorRelease (myColor2);
    CGColorSpaceRelease (myColorSpace); 
	
	CGContextSaveGState(context);
	CGContextSetShadow(context, CGSizeMake(0, 0), 4.0);
	CGContextAddEllipseInRect(context, CGRectMake(center.x - kInnerCircleRadius, center.y - kInnerCircleRadius, kInnerCircleRadius * 2.0, kInnerCircleRadius * 2.0));
	CGContextDrawPath(context, kCGPathFill);
	CGContextRestoreGState(context);

	//Draw the inner circle
	CGContextSaveGState(context);
	CGContextAddEllipseInRect(context, CGRectMake(center.x - kInnerCircleRadius, center.y - kInnerCircleRadius, kInnerCircleRadius * 2.0, kInnerCircleRadius * 2.0));
	CGContextClip(context);
	CGContextDrawRadialGradient(context, bggradient, center, 0.0, center, kInnerCircleRadius+30, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
	
	//CGContextAddEllipseInRect(context, CGRectMake(center.x - kInnerCircleRadius, center.y - kInnerCircleRadius, kInnerCircleRadius * 2.0, kInnerCircleRadius * 2.0));
	//CGContextDrawPath(context, kCGPathStroke);
	
	// Draw the inner rounded rect
	CGContextSetRGBStrokeColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1.0);
	CGMutablePathRef path = [self newPathForRect:CGRectMake(center.x - kRoundedRectRadius, center.y - kRoundedRectRadius, kRoundedRectRadius * 2.0, kRoundedRectRadius * 2.0)];
	CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
	CGPathRelease(path);
	
	if (previmage != nil) {
		CGContextSaveGState(context);
		CGContextScaleCTM(context, 1.2, 1.2);
		[previmage drawAtPoint:imagePoint];
		CGContextRestoreGState(context);
	}	
}


- (CGMutablePathRef) newPathForRect:(CGRect)rect {
	CGFloat radius = 5.0;
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	CGPathMoveToPoint(path, NULL, minx, midy);
	CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, radius);
	CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, radius);
	CGPathAddArcToPoint(path, NULL, maxx, maxy, midx, maxy, radius);
	CGPathAddArcToPoint(path, NULL, minx, maxy, minx, midy, radius);
	CGPathCloseSubpath(path);
	
	return path;
}

- (void)dealloc {
	CGGradientRelease(bggradient);
	CGGradientRelease(selgradient);
	for (int i = 0; i < n_items; i++) {
		[items[i] release];
	}
	[timer release];
    [super dealloc];
}


- (void) addItem:(PieMenuItem *)item {
	if (n_items < kMaxNumberOfItems) {
		items[n_items++] = [item retain];
		[self setNeedsDisplay];
	}
}

- (void) clearItems {
	for (int i = 0; i < n_items; i++) {
		[items[i] release];
		items[i] = NULL;
	}
	n_items = 0;
	selectedItem = kNoItemSelected;
}

- (void) testForPoint:(CGPoint)point {
	CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
	selectedItem = kNoItemSelected;
	CGPoint rp = CGPointMake(point.x - center.x, point.y - center.y);
	CGFloat radius = sqrtf(rp.x*rp.x + rp.y*rp.y);
	CGFloat angle = RADIANS_TO_DEGREE(acosf(rp.x / radius));
	if (rp.x < 0.0 && rp.y > 0.0) {
		angle = angle - 360.0;
	} else if (rp.y < 0.0 || rp.x < 0.0) {
		angle = -angle;
	}
	
	CGFloat startAngle = initAngle;
	CGFloat pieceAngle = kTotalAngle / n_items;
	for (int i = 0; i < n_items; i++) {
		if (angle < startAngle && angle > (startAngle - pieceAngle) && radius > 7.0) {
			selectedItem = i;
			break;
		}
		startAngle -= pieceAngle;
	}
	[self setNeedsDisplay];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	[self testForPoint:p];
	if ([timer isValid]) {
		[timer invalidate];
	}
	if (selectedItem != kNoItemSelected) {
		if (items[selectedItem].type == PieMenuItemTypeParent) {
			NSValue *miValue = [NSValue value:&p withObjCType:@encode(CGPoint)];
			self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(subitemsTimerFired:) userInfo:miValue repeats:NO];
		} else if (items[selectedItem].type == PieMenuItemTypeBack) {
			NSValue *miValue = [NSValue value:&p withObjCType:@encode(CGPoint)];
			self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(parentTimerFired:) userInfo:miValue repeats:NO];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([timer isValid]) {
		[timer invalidate];
	}
	if (selectedItem != kNoItemSelected) {
		[self itemSelected:selectedItem];
		selectedItem = kNoItemSelected;
	} else {
		[self itemSelected:kNoItemSelected];
	}
	[self setNeedsDisplay];
}


- (void) subitemsTimerFired:(NSTimer *)theTimer {
	if (selectedItem != kNoItemSelected) {
		[menu itemWithSubitemsSelected:items[selectedItem] withIndex:selectedItem atPoint:[[theTimer userInfo] CGPointValue]];
	}
}

- (void) parentTimerFired:(NSTimer *)theTimer {
	if (selectedItem != kNoItemSelected) {
		[menu parentItemSelected:items[selectedItem] withIndex:selectedItem atPoint:[[theTimer userInfo] CGPointValue]];
	}
}	
@end
