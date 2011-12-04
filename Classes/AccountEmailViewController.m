//
//  AccountEmailViewController.m
//  ScanTest
//
//  Created by Max Loukianov on 11/5/11.
//  Copyright (c) 2011 Freelink Wireless Services. All rights reserved.
//

#import "AccountEmailViewController.h"

@implementation AccountEmailViewController

@synthesize existingPassword;
@synthesize typePassword;
@synthesize retypePassword;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up navigation bar right button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(performSave)];
    
    [[self navigationItem] setRightBarButtonItem:rightButton];
    
    [rightButton release];
    
    // set up labels for text fields
    
    UILabel *label1 = [[UILabel alloc] init];
    [label1 setText:@"Old Password:"];
    
    [existingPassword setLeftView:label1];
    [existingPassword setLeftViewMode:UITextFieldViewModeAlways];
    
    [label1 release];
    
    UILabel *label2 = [[UILabel alloc] init];
    [label2 setText:@"New Password:"];
    
    [typePassword setLeftView:label2];
    [typePassword setLeftViewMode:UITextFieldViewModeAlways];
    
    [label2 release];
    
    UILabel *label3 = [[UILabel alloc] init];
    [label3 setText:@"Re-type Password:"];
    
    [retypePassword setLeftView:label3];
    [retypePassword setLeftViewMode:UITextFieldViewModeAlways];
    
    [label3 release];
    
}

- (void) performSave 
{
    NSLog(@"performSave called in AccountEmailViewController");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[self navigationItem] setRightBarButtonItem:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
