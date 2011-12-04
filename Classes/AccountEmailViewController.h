//
//  AccountEmailViewController.h
//  ScanTest
//
//  Created by Max Loukianov on 11/5/11.
//  Copyright (c) 2011 Freelink Wireless Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountEmailViewController : UIViewController {
    IBOutlet UITextField *existingPassword;
    IBOutlet UITextField *typePassword;
    IBOutlet UITextField *retypePassword;
    
}

@property (nonatomic, retain) UITextField *existingPassword;
@property (nonatomic, retain) UITextField *typePassword;
@property (nonatomic, retain) UITextField *retypePassword;

- (void) performSave;

@end
