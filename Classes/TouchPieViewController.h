//
//  TouchPieViewController.h
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 19/11/08.
//  Copyright Taps and Swipes 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PieMenu;

@interface TouchPieViewController : UIViewController {
	PieMenu *pieMenu;
	UILabel *label;
}

@property (nonatomic, retain) PieMenu *pieMenu;
@property (nonatomic, retain) IBOutlet UILabel *label;

- (IBAction) fingerSizeAction:(id)sender;
- (IBAction) leftHandedAction:(id)sender;

@end

