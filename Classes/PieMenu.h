//
//  PieMenu.h
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 27/11/08.
//  Copyright 2008 Taps and Swipes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "PieMenuItem.h"

#define kMaxNumberOfItems   7

@class PieView;

typedef enum {
	PieMenuFingerSizeTiny,
	PieMenuFingerSizeNormal,
	PieMenuFingerSizeBig,
} PieMenuFingerSize;

@interface PieMenu : NSObject {
  @private
	BOOL leftHanded;
	PieMenuFingerSize fingerSize;
	PieView *pieView;
	UIView *parentView;
	NSArray *items;
	NSMutableArray *path;
	BOOL on;
}

@property (nonatomic) BOOL leftHanded;
@property (nonatomic) PieMenuFingerSize fingerSize;
@property (nonatomic) BOOL on;

- (void) showInView:(UIView *)theView atPoint:(CGPoint)thePoint;
- (void) itemSelected:(PieMenuItem *)item;
- (void) addItem:(PieMenuItem *)item;
- (UIView *) view;
- (void) itemWithSubitemsSelected:(PieMenuItem *)theItem withIndex:(NSInteger)theIndex atPoint:(CGPoint)thePoint;
- (void) parentItemSelected:(PieMenuItem *)theItem withIndex:(NSInteger)theIndex atPoint:(CGPoint)thePoint;

@end
