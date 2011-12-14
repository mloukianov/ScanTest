//
//  DailyDealDetailViewController.m
//  ScanTest
//
//  Created by Max Loukianov on 12/7/11.
//  Copyright (c) 2011 Freelink Wireless Services. All rights reserved.
//

#import "DailyDealDetailViewController.h"
#import "ScanTestAppDelegate.h"

@implementation DailyDealDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[appDelegate dealNavController] setNavigationBarHidden:NO animated:animated];
    [[[[appDelegate dealNavController] navigationBar] topItem] setTitle:@"Deal Info"];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[appDelegate dealNavController] setNavigationBarHidden:YES animated:animated];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
