//
//  LoginViewController.h
//  ScanTest
//
//  Created by Max Loukianov on 10/20/11.
//  Copyright (c) 2011 Freelink Wireless Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    
    UITextField* emailField;
    UITextField* passwordField;
    
    NSURLConnection *urlConnection;
    
    NSMutableData* receivedData;
    
    UIButton *signupLabel;
}

@property (nonatomic, retain) IBOutlet UITextField* emailField;
@property (nonatomic, retain) IBOutlet UITextField* passwordField;

@property (nonatomic, retain) IBOutlet UIButton *signupLabel;

@property (nonatomic, retain) NSURLConnection *urlConnection;

@property (nonatomic, retain) NSMutableData* receivedData;

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (IBAction)doSignupButton:(id)sender;

@end
