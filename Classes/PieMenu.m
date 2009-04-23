//
//  PieMenu.m
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 27/11/08.
//  Copyright 2008 Taps and Swipes. All rights reserved.
//

#import "PieMenu.h"
#import "PieView.h"

#define kImageSize          64

static int contrapositions[] = { 5, 6, 6, 0, 0, 0, 1 };

int getposition(int origPosition, int origNum, int destNum) {
	int oriGmapTo6 = origPosition * kMaxNumberOfItems / origNum;
	int contraPosIn6 = contrapositions[oriGmapTo6];
	return ceilf(1.0 * contraPosIn6 * destNum / kMaxNumberOfItems);
}

CGContextRef MyCreateBitmapContext (int pixelsWide, int pixelsHigh) {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
	
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease( colorSpace );
    if (context== NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        return NULL;
    }
	
    return context;
}



@interface PieMenu ()
@property (nonatomic, retain) PieView *pieView;
@property (nonatomic, assign) UIView *parentView;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSMutableArray *path;
@end

@interface PieMenu (ProivateMethods)

- (void) showMenuAtPoint:(CGPoint)thePoint;
- (void) hideMenu;

@end

@implementation PieMenu

@synthesize leftHanded;
@synthesize fingerSize;
@synthesize pieView;
@synthesize parentView;
@synthesize items;
@synthesize path;
@synthesize on;

- (id) init {
	if (self = [super init]) {
		self.items = [[NSArray alloc] init];
		self.path = [NSMutableArray arrayWithCapacity:2];
		self.fingerSize = PieMenuFingerSizeNormal;
	}
	return self;
}

- (void) showInView:(UIView *)theView atPoint:(CGPoint)thePoint {
	self.parentView = theView;
	if (pieView == nil) {
		self.pieView = [[PieView alloc] initWithFrame:CGRectZero];
		pieView.userInteractionEnabled = YES;
		for (PieMenuItem *item in items) {
			[pieView addItem:item];
		}
		pieView.leftHanded = self.leftHanded;
		pieView.menu = self;
		pieView.fingerSize = self.fingerSize;
	}
	pieView.frame = CGRectZero;
	pieView.center = thePoint;
	[self.parentView addSubview:pieView];
	[self showMenuAtPoint:thePoint];
	on = YES;
}

- (void) showMenuAtPoint:(CGPoint)thePoint {
	[UIView beginAnimations:nil	context:NULL];
	[UIView setAnimationDuration:0.15];
	pieView.frame = CGRectMake(thePoint.x - [pieView minimumSize] / 2.0, thePoint.y - [pieView minimumSize] / 2.0, [pieView minimumSize], [pieView minimumSize]);
	[UIView commitAnimations];
	on = YES;
}

- (void) hideMenu {
	[UIView beginAnimations:nil	context:NULL];
	[UIView setAnimationDuration:0.5];
	[self.pieView removeFromSuperview];
	[UIView commitAnimations];
	on = NO;
}

- (void) itemSelected:(PieMenuItem *)item {
	[self hideMenu];
	[pieView clearItems];
	for (PieMenuItem *myitem in items) {
		[pieView addItem:myitem];
	}
	if (item) {
		[item performAction];
	}
}

- (void) addItem:(PieMenuItem *)item {
	if (item == nil) {
		NSException *exception = [NSException exceptionWithName:@"NSInvalidArgumentException"
														 reason:@"the item suplied is nil"  userInfo:nil];
		@throw exception;
	}
	if ([items count] >= kMaxNumberOfItems) {
		NSException *exception = [NSException exceptionWithName:@"RangeException"
														 reason:@"maximus number of subitems reached"  userInfo:nil];
		@throw exception;
	}
	if ([items indexOfObject:item] != NSNotFound) {
		NSException *exception = [NSException exceptionWithName:@"DuplicatedItemException"
														 reason:@"the item is allready a subitem"  userInfo:nil];
		@throw exception;
	}
	self.items = [items arrayByAddingObject:item];
}

- (UIView *) view {
	return pieView;
}

- (void) setFingerSize:(PieMenuFingerSize)theFingerSize {
	fingerSize = theFingerSize;
	if (pieView != nil) {
		pieView.fingerSize = fingerSize;
	}
}

- (void) setLeftHanded:(BOOL)theLeftHanded {
	leftHanded = theLeftHanded;
	if (pieView != nil) {
		pieView.leftHanded = leftHanded;
	}
}

- (void) itemWithSubitemsSelected:(PieMenuItem *)theItem withIndex:(NSInteger)theIndex atPoint:(CGPoint)thePoint {

	CGContextRef myContext = MyCreateBitmapContext(kImageSize, kImageSize);
	CGContextScaleCTM(myContext, 1.0, -1.0);
	CGContextTranslateCTM(myContext, 0.0, -kImageSize);
	CGContextScaleCTM(myContext, kImageSize / [pieView minimumSize], kImageSize / [pieView minimumSize]);
	[pieView.layer renderInContext:myContext];
	CGImageRef myImage = CGBitmapContextCreateImage(myContext);
	CGContextRelease(myContext);
	UIImage *image = [UIImage imageWithCGImage:myImage];
	CGImageRelease(myImage);
	
	CGPoint point = [parentView convertPoint:thePoint fromView:pieView];
	[self hideMenu];
	[pieView clearItems];
	
	NSInteger pos;
	if (theItem.parentItem != nil) {
		pos = getposition([theItem indexInParent], [theItem.parentItem  numberOfSubitems], [theItem numberOfSubitems]);
	} else {
		pos = getposition([items indexOfObject:theItem], items.count, [theItem numberOfSubitems]);
	}
	
	NSLog(@"POS: %i", pos);

	for (NSUInteger i = 0; i < [theItem numberOfSubitems] + 1; i++) {
		if (i == pos) {
			PieMenuItem *parentItem = [[PieMenuItem alloc] init];
			parentItem.title = @"< back";
			parentItem.icon = image;
			parentItem.type = PieMenuItemTypeBack;
			parentItem.parentItem = theItem;
			[pieView addItem:parentItem];
			[path addObject:parentItem];
			[parentItem release];
		}
		if ([theItem subitemAtIndex:i])
			[pieView addItem:[theItem subitemAtIndex:i]];
	}
	[self showInView:parentView atPoint:point];
}


- (void) parentItemSelected:(PieMenuItem *)theItem withIndex:(NSInteger)theIndex atPoint:(CGPoint)thePoint {
	CGPoint point = [parentView convertPoint:thePoint fromView:pieView];
	[self hideMenu];
	[pieView clearItems];

	PieMenuItem *item = theItem.parentItem;
	PieMenuItem *parentItem = item.parentItem;
	NSArray *subitems = items;
	NSInteger pos = -1;
	if (parentItem != nil) {
		subitems = parentItem.subItems;
		if (parentItem.parentItem != nil) {
			pos = getposition([parentItem indexInParent], [parentItem.parentItem  numberOfSubitems], [parentItem numberOfSubitems]);
		} else {
			pos = getposition([items indexOfObject:parentItem], items.count, [parentItem numberOfSubitems]);
		}
	}
	
	NSLog(@"POS: %i", pos);	
	[path removeLastObject];

	for (NSUInteger i = 0; i < subitems.count + 1; i++) {
		if (i == pos) {
			[pieView addItem:[path lastObject]];
		}
		@try {
			[pieView addItem:[subitems objectAtIndex:i]];
		} 
		@catch (NSException *exception) {
		}
	}
	[self showInView:parentView atPoint:point];
}


- (void) dealloc {
	[pieView release];
	[items release];
	[path release];
	[super dealloc];
	
}


@end
