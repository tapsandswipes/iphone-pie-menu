//
//  PieMenuItem.h
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 27/11/08.
//  Copyright 2008 Taps and Swipes. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMaxNumberOfSubitems   5

typedef enum {
	PieMenuItemTypeNormal,
	PieMenuItemTypeBack,
	PieMenuItemTypeParent,
} PieMenuItemType;

@interface PieMenuItem : NSObject {
	NSString *title;
	NSString *label;
	id target;
	SEL action;
	id userInfo;
	UIImage *icon;
	NSArray *subItems;
	PieMenuItem *parentItem;
	PieMenuItemType type;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) id userInfo;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSArray *subItems;
@property (nonatomic, assign) PieMenuItem *parentItem;
@property (nonatomic) PieMenuItemType type;

- (id) initWithTitle:(NSString *)theTitle
			   label:(NSString *)theLabel
			  target:(id)theTarget
            selector:(SEL)theSelector
			userInfo:(id)theInfo
				icon:(UIImage *)theIcon;
- (void) addSubItem:(PieMenuItem *)theSubItem;
- (BOOL) hasSubitems;
- (NSUInteger) numberOfSubitems;
- (PieMenuItem *) subitemAtIndex:(NSInteger)theIndex;
- (void) performAction;
- (NSInteger) indexInParent; 

@end
