//
//  AccountPrefsViewController.m
//  ScanTest
//
//  Created by Max Loukianov on 11/5/11.
//  Copyright (c) 2011 Freelink Wireless Services. All rights reserved.
//

#import "AccountPrefsViewController.h"
#import "AccountEmailViewController.h"
#import "AccountPasswordViewController.h"
#import "AccountPhoneViewController.h"
#import "ScanTestAppDelegate.h"

@implementation AccountPrefsViewController

@synthesize accountPrefsTable;
@synthesize accountBalanceLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    // get the tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"My Account"];
    UIImage *image = [UIImage imageNamed:@"19-gear.png"];
    [tbi setImage:image];
    
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
    // Do any additional setup after loading the view from its nib.
    
    [[self accountBalanceLabel] setText:@"$0.00"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch(section) {
        case 0:
            return 3;
        case 1:
            return 3;
        default:
            NSAssert(NO, @"Unhandled value in indexPath.section");
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                // change e-mail
            {
                AccountPasswordViewController *accountPasswordViewController = [[[AccountPasswordViewController alloc] init] autorelease];
                
                [[self navigationController] pushViewController:accountPasswordViewController animated:YES];
                
            }
                break;
                
            case 1:
                // change phone
            {
                AccountPhoneViewController *accountPhoneViewController = [[[AccountPhoneViewController alloc] init] autorelease];
                
                [[self navigationController] pushViewController:accountPhoneViewController animated:YES];
            }
                break;
                
            case 2:
                // change password
            {
                
                NSLog(@"Tapped on change password chevron");
                
                AccountEmailViewController *accountEmailViewController = [[[AccountEmailViewController alloc] init] autorelease];
                
                [[self navigationController] pushViewController:accountEmailViewController animated:YES];
            }
                break;
                
            default:
                NSAssert(NO, @"Unhandled value in indexPath.row in section 0");
        }
        
    } else if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
                // transfer funds
                break;
                
            case 1:
                // social networks
                break;
                
            case 2:
                // change favorites
                break;
                
            default:
                NSAssert(NO, @"Unhandled value in indexPath.row in section 1");
        }
        
    } else {
        NSAssert(NO, @"Unhandled section value in indexPath.section in didSelectRowInIndexPath");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
        // account info section
        switch(indexPath.row) {
            case 0:
            {
                UIImage* emailImage = [UIImage imageNamed:@"email_icon.jpg"];
                [[cell imageView] setImage:emailImage];
                
                ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];
                
                [[cell textLabel] setText:[appDelegate profileEmail]];
            }
                break;
                
            case 1:
            {
                UIImage* phoneImage = [UIImage imageNamed:@"phone_icon.jpg"];
                [[cell imageView] setImage:phoneImage];
                
                ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];
                
                [[cell textLabel] setText:[appDelegate profilePhone]];
            }
                break;
            case 2:
            {
                UIImage* passwordImage = [UIImage imageNamed:@"password_icon.jpg"];
                [[cell imageView] setImage:passwordImage];
                [[cell textLabel] setText:@"*********"];
            }
                break;
            default:
                NSAssert(NO, @"Unhandled value in indexPath.row in section 0");
        }
    } else if (indexPath.section == 1) {
        // social prefs and such
        switch(indexPath.row) {
            case 0:
                [[cell textLabel] setText:@"TransferFunds"];
                break;
            case 1:
                [[cell textLabel] setText:@"SocialPreferences"];
                break;
            case 2:
                [[cell textLabel] setText:@"EditFavorites"];
                break;
            default:
                NSAssert(NO, @"Unhandled value in indexPath.row in section 1");
        }
    }
    
    // Configure the cell...
    
    [cell setAccessoryType: UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
}

@end
