//
//  PreferencesController.m
//  ScanTest
//
//  Created by Max Loukianov on 9/11/11.
//  Copyright 2011 Freelink Wireless Services. All rights reserved.
//

#import "PreferencesController.h"

#import "ScanTestAppDelegate.h"


@implementation PreferencesController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    // get the tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    
    // give it a name
    [tbi setTitle:@"My Account"];
    
    UIImage *image = [UIImage imageNamed:@"19-gear.png"];
    
    [tbi setImage:image];

    if (self) {
        
		// NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];		
        
        // appSettings = myDefaults;

		// settingsList = [NSArray arrayWithObjects:<#(id), ...#>, nil]
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
            return 3;
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
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
