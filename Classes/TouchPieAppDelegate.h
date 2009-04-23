//
//  TouchPieAppDelegate.h
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 19/11/08.
//  Copyright Taps and Swipes 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchPieViewController;

@interface TouchPieAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TouchPieViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TouchPieViewController *viewController;

@end

