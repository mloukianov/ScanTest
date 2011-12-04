//
//  AccountPrefsViewController.h
//  ScanTest
//
//  Created by Max Loukianov on 11/5/11.
//  Copyright (c) 2011 Freelink Wireless Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountPrefsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* accountPrefsTable;
    
    IBOutlet UILabel* accountBalanceLabel;
}

@property (nonatomic, retain) UITableView* accountPrefsTable;
@property (nonatomic, retain) UILabel* accountBalanceLabel;

@end
