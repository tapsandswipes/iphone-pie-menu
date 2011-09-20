//
//  TouchPieViewController.m
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 19/11/08.
//  Copyright Taps and Swipes 2008. All rights reserved.
//

#import "TouchPieViewController.h"
#import "PieMenu.h"

@interface TouchPieViewController (PrivateMethods)

- (void) itemSelected:(PieMenuItem *)item;

@end

@implementation TouchPieViewController

@synthesize pieMenu;
@synthesize label;

// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		
		
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.pieMenu = [[PieMenu alloc] init];
	PieMenuItem *itemA = [[PieMenuItem alloc] initWithTitle:@"ItemA" 
													  label:nil 
													 target:self 
												   selector:@selector(itemSelected:) 
												   userInfo:nil 
													   icon:[UIImage imageNamed:@"icon1.png"]];

	PieMenuItem *itemB = [[PieMenuItem alloc] initWithTitle:@"ItemB" 
													  label:nil 
													 target:self 
												   selector:@selector(itemSelected:) 
												   userInfo:nil 
													   icon:[UIImage imageNamed:@"icon1.png"]];
	
	PieMenuItem *itemC = [[PieMenuItem alloc] initWithTitle:@"ItemC" 
													  label:nil 
													 target:self 
												   selector:@selector(itemSelected:) 
												   userInfo:nil 
													   icon:[UIImage imageNamed:@"icon2.png"]];
	
	PieMenuItem *itemD = [[PieMenuItem alloc] initWithTitle:@"ItemD" 
													  label:nil 
													 target:self 
												   selector:@selector(itemSelected:) 
												   userInfo:nil 
													   icon:[UIImage imageNamed:@"icon3.png"]];
	
	
	PieMenuItem *itemE = [[PieMenuItem alloc] initWithTitle:@"ItemE" 
													  label:nil 
													 target:self 
												   selector:@selector(itemSelected:) 
												   userInfo:nil 
													   icon:[UIImage imageNamed:@"icon4.png"]];
	
	PieMenuItem *itemF = [[PieMenuItem alloc] initWithTitle:@"ItemF" 
													  label:nil 
													 target:self 
												   selector:@selector(itemSelected:) 
												   userInfo:nil 
													   icon:[UIImage imageNamed:@"icon4.png"]];
	
	PieMenuItem *itemG = [[PieMenuItem alloc] initWithTitle:@"ItemG" 
													  label:nil 
													 target:self 
												   selector:@selector(itemSelected:) 
												   userInfo:nil 
													   icon:[UIImage imageNamed:@"icon4.png"]];
	
	
	[itemA addSubItem:itemE];
	[itemA addSubItem:itemB];
	[itemA addSubItem:itemD];
	
	//[pieMenu addItem:itemD]; 
	[pieMenu addItem:itemA];
	[pieMenu addItem:itemC];
	//[pieMenu addItem:itemE];
	//[pieMenu addItem:itemB];
	[pieMenu addItem:itemF];
	[pieMenu addItem:itemG];
	
	[itemA release];
	[itemB release];
	[itemC release];
	[itemD release];
	[itemE release];
	[itemF release];
	[itemG release];
	
}

- (void) itemSelected:(PieMenuItem *)item {
	NSLog(@"Item '%s' selected", [item.title UTF8String]);
	label.text = [NSString stringWithFormat:@"Item '%s' selected", [item.title UTF8String]];
}

- (IBAction) fingerSizeAction:(id)sender {
	UISegmentedControl* segCtl = sender;
	pieMenu.fingerSize = [segCtl selectedSegmentIndex];
}

- (IBAction) leftHandedAction:(id)sender {
	UISwitch *swit = (UISwitch *)sender;
	pieMenu.leftHanded = swit.on;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

- (UIResponder *)nextResponder {
	if (pieMenu.on) {
		return [pieMenu view];
	} else {
		return [super nextResponder];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self.view];
	[pieMenu showInView:self.view atPoint:p];
    [super touchesBegan:touches withEvent:event];
}


@end
