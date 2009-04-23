//
//  PieMenuItem.m
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 27/11/08.
//  Copyright 2008 Taps and Swipes. All rights reserved.
//

#import "PieMenuItem.h"


@implementation PieMenuItem

@synthesize title;
@synthesize label;
@synthesize target;
@synthesize action;
@synthesize userInfo;
@synthesize icon;
@synthesize subItems;
@synthesize parentItem;
@synthesize type;

- (id) initWithTitle:(NSString *)theTitle
			   label:(NSString *)theLabel
			  target:(id)theTarget
            selector:(SEL)theSelector
			userInfo:(id)theInfo
				icon:(UIImage *)theIcon {
	if (self = [self init]) {
		self.title = theTitle;
		self.label = theLabel;
		self.target = theTarget;
		self.action = theSelector;
		self.userInfo = theInfo;
		self.icon = theIcon;
	}
	return self;
}


- (id) init {
	if (self = [super init]) {
		self.type = PieMenuItemTypeNormal;
		self.subItems = [[[NSArray alloc] init] autorelease];
	}
	return self;
}

- (void) performAction {
	if (target != nil && action && [target respondsToSelector:action]) {
		[target performSelector:action withObject:self];
	}
}

- (void) addSubItem:(PieMenuItem *)theSubItem {
	if (theSubItem == nil) {
		NSException *exception = [NSException exceptionWithName:@"NSInvalidArgumentException"
														 reason:@"the item suplied is nil"  userInfo:nil];
		@throw exception;
	}
	if ([subItems count] >= kMaxNumberOfSubitems) {
		NSException *exception = [NSException exceptionWithName:@"RangeException"
														 reason:@"maximus number of subitems reached"  userInfo:nil];
		@throw exception;
	}
	if ([subItems indexOfObject:theSubItem] != NSNotFound) {
		NSException *exception = [NSException exceptionWithName:@"DuplicatedItemException"
														 reason:@"the item is allready a subitem"  userInfo:nil];
		@throw exception;
	}
	if (theSubItem.parentItem != nil && theSubItem.parentItem != self) {
		NSException *exception = [NSException exceptionWithName:@"ItemParentException"
														 reason:@"the item is a subitem of another item"  userInfo:nil];
		@throw exception;
	}
	if (theSubItem == self) {
		NSException *exception = [NSException exceptionWithName:@"ItemCicleException"
														 reason:@"the item is the same as teh parent"  userInfo:nil];
		@throw exception;
	}

	theSubItem.parentItem = self;
	self.subItems = [subItems arrayByAddingObject:theSubItem];
	self.type = PieMenuItemTypeParent;
}

- (BOOL) hasSubitems {
	return [subItems count] > 0;
}

- (NSUInteger) numberOfSubitems {
	return [subItems count];
}

- (PieMenuItem *) subitemAtIndex:(NSInteger)theIndex {
	if (theIndex >= 0 && theIndex < [subItems count]) {
		return [subItems objectAtIndex:theIndex];
	}
	return nil;
}

- (NSInteger) indexInParent {
	if (parentItem != nil) {
		return [parentItem.subItems indexOfObject:self];
	}
	return NSNotFound;
}


- (void) dealloc {
	[title release];
	[label release];
	[target release];
	[userInfo release];
	[icon release];
	[subItems release];
	[super dealloc];
}
@end
