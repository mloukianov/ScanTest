//
//  ScanTestAppDelegate.h
//  ScanTest
//
//  Created by David Kavanagh on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanTestAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    
    UINavigationController *dealNavController;
    
    NSString* profileEmail;
    NSString* profilePhone;
    NSString* profilePassword;
    
    NSString* accountBalance;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *dealNavController;

@property (nonatomic, retain) NSString* profileEmail;
@property (nonatomic, retain) NSString* profilePhone;
@property (nonatomic, retain) NSString* profilePassword;

@property (nonatomic, retain) NSString* accountBalance;

- (void) createMainTabControl;

@end

