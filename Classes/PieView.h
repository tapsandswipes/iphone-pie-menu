//
//  PieView.h
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 19/11/08.
//  Copyright 2008 Taps and Swipes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieMenu.h"

@interface PieView : UIView {
  @private	
	BOOL leftHanded;
	PieMenu *menu;
	PieMenuItem *items[kMaxNumberOfItems];
	NSInteger selectedItem;
	NSInteger n_items;
	CGGradientRef bggradient;
	CGGradientRef selgradient;
	CGFloat initAngle;
	CGFloat endAngle;
	PieMenuFingerSize fingerSize;
	NSTimer *timer;
}

@property (nonatomic) BOOL leftHanded;
@property (nonatomic) PieMenuFingerSize fingerSize;
@property (nonatomic, assign) PieMenu *menu;

- (void) addItem:(PieMenuItem *)item;
- (void) clearItems;
- (CGFloat) minimumSize;

@end
