//
//  TouchPieAppDelegate.m
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 19/11/08.
//  Copyright Taps and Swipes 2008. All rights reserved.
//

#import "TouchPieAppDelegate.h"
#import "TouchPieViewController.h"

@implementation TouchPieAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
