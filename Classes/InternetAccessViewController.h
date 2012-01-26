//
//  InternetAccessViewController.h
//  ScanTest
//
//  Created by Max Loukianov on 1/26/12.
//  Copyright (c) 2012 Gimme!Deals LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternetAccessViewController : UIViewController {
    
    IBOutlet UIWebView* webView; 
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;

@end
