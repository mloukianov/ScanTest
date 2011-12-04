//
//  SignupViewController.h
//  ScanTest
//
//  Created by Max Loukianov on 11/6/11.
//  Copyright (c) 2011 Freelink Wireless Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    UITableView *credentialsView;
    
    UIButton *signupButton;
    
    UITextField *phoneField;
    UITextField *emailField;
    UITextField *passwordField;
    UITextField *confirmField;
    
    NSString *phone;
    NSString *email;
    NSString *password;
    NSString *confirm;
    
    NSMutableData* receivedData;
}

@property (nonatomic, retain) IBOutlet UITableView *credentialsView;

@property (nonatomic, retain) IBOutlet UIButton *signupButton;

@property (nonatomic, retain) UITextField* phoneField;
@property (nonatomic, retain) UITextField* emailField;
@property (nonatomic, retain) UITextField* passwordField;
@property (nonatomic, retain) UITextField* confirmField;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *confirm;

@property (nonatomic, retain) NSMutableData* receivedData;

- (IBAction)signupButtonPressed:(id)sender;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;



@end
