//
//  ScanTestAppDelegate.m
//  ScanTest
//
//  Created by David Kavanagh on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ScanTestAppDelegate.h"

#import "RootViewController.h"
#import "DailyDealViewController.h"
#import "SuperDealViewController.h"
#import "AccountPrefsViewController.h"

#import "LoginViewController.h"


@implementation ScanTestAppDelegate

@synthesize window;
@synthesize navigationController;

@synthesize profileEmail;
@synthesize profilePhone;
@synthesize profilePassword;

@synthesize accountBalance;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch
    
    LoginViewController* loginViewController = [[LoginViewController alloc] init];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    [navigationController setNavigationBarHidden:YES];
    
    [window setRootViewController:navigationController];
    
    [loginViewController release];
    
    // show the window
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


#pragma mark -
#pragma mark 

- (void)createMainTabControl {
    
    // Create the tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    // create four view controllers
    UIViewController *rootViewController = [[RootViewController alloc] init];
    UIViewController *dailyDealViewController = [[DailyDealViewController alloc] init];
    UIViewController *superDealViewController = [[SuperDealViewController alloc] init];
    UIViewController *accountPrefsViewController = [[AccountPrefsViewController alloc] init];
    
    UINavigationController *prefsNavController = [[UINavigationController alloc] initWithRootViewController:accountPrefsViewController];
    
    // make an array containing four view controllers
    NSArray *viewControllers = [NSArray arrayWithObjects:rootViewController, dailyDealViewController, superDealViewController, prefsNavController, nil];
    
    // The viewcontrollers array retains controllers, so release them
    [rootViewController release];
    [dailyDealViewController release];
    [superDealViewController release];
    [accountPrefsViewController release];
    
    [prefsNavController release];
    
    // attach them to the tab bar controller
    [tabBarController setViewControllers:viewControllers];
    
    // set tab bar controller as a root controller for this window
    [window setRootViewController:tabBarController];
    
    // the window retains tab bar controller, so we can release
    [tabBarController release];
    
}

#pragma mark -


@end

