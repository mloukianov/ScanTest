//
//  SuperDealViewController.m
//  ScanTest
//
//  Created by Max Loukianov on 9/11/11.
//  Copyright 2011 Freelink Wireless Services. All rights reserved.
//

#import "SuperDealViewController.h"


@implementation SuperDealViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    // get the tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    
    // give it a name
    [tbi setTitle:@"Super Deal"];
    
    UIImage *image = [UIImage imageNamed:@"169-8ball.png"];
    
    [tbi setImage:image];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    NSLog(@"View did load on orange view");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"View will appear got called");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"View will disappear got called");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
