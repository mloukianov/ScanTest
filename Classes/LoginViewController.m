//
//  LoginViewController.m
//  ScanTest
//
//  Created by Max Loukianov on 10/20/11.
//  Copyright (c) 2011 Freelink Wireless Services. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"
#import "SBJson.h"

#import "ScanTestAppDelegate.h"


@implementation LoginViewController

@synthesize emailField;
@synthesize passwordField;
@synthesize signupLabel;

@synthesize urlConnection;

@synthesize receivedData;

- (IBAction)doSignupButton:(id)sender {
    
    NSLog(@"Trying to signup");
    
    ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    SignupViewController *signupViewController = [[SignupViewController alloc] init];
    
    [[appDelegate navigationController] pushViewController:signupViewController animated:YES];
    
    [signupViewController release];
}

#pragma mark - NSURLConnectionDelegate methods

// this class is a delegate for the connection methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [urlConnection release];
    [receivedData release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere

    NSString* returnedString = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"Received data %@", returnedString);
    
    SBJsonParser* jsonparser = [[SBJsonParser alloc] init ];
    
    NSError* error = nil;
    id jsonobject = [jsonparser objectWithString:returnedString error:&error];
    
    if ([jsonobject isKindOfClass:[NSArray class]]) {
        // process it as an array
        assert("JSON object should not be of type NSArray");
        
    } else if ([jsonobject isKindOfClass:[NSDictionary class]]) {
        // process it as a dictionary
        NSLog(@"JSON object is NSDictionary");
        
        NSDictionary* jsondict = jsonobject;
        
        if ( [jsondict objectForKey:@"error"] ) {
            
            NSLog(@"Error content");
            
            UIAlertView* loginFailedAlert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:@"Email/password is incorrect" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            
            [loginFailedAlert show];
            [loginFailedAlert release];
            
        } else {
            
            NSString* profileEmail = [jsondict objectForKey:@"email"];
            NSString* profilePhone = [jsondict objectForKey:@"phone"];
            
            ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            appDelegate.profileEmail = profileEmail;
            appDelegate.profilePhone = profilePhone;
            
            // now we remove call the method on appDelegate to replace this with the tab control
            
            [appDelegate createMainTabControl];
            
        }
    }
    
    NSLog(@"JSON object is %@", jsonobject);
    
    [jsonparser release];
    [receivedData release];
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [theTextField resignFirstResponder];
    
    NSString* urlString = [NSString stringWithString:@"http://173.246.103.0/mobile/app/login"];
    // NSString* urlString = [NSString stringWithString:@"http://127.0.0.1:9000/mobile/app/login"];
    
    NSMutableString* mutableContentString = [NSMutableString stringWithString:@"email="];
    [mutableContentString appendString:[emailField text]];
    [mutableContentString appendString:@"&password="];
    [mutableContentString appendString:[passwordField text]];
    
    NSData* content = [NSData dataWithBytes:[mutableContentString UTF8String] length:[mutableContentString length]];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:content];
    [urlRequest setHTTPShouldHandleCookies:TRUE];
    [urlRequest setCachePolicy:NSURLCacheStorageNotAllowed];
    [urlRequest setTimeoutInterval:60.0];
    
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // we have created NSURLRequest (in the form of NSMutableURLRequest)
    
    NSLog(@"About to start calling the URL");
    
    urlConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    
    if (urlConnection) {

        receivedData = [[NSMutableData data] retain];
    }
    
    return NO;
}


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
    
    [[signupLabel layer] setCornerRadius:0.0f];
    [[signupLabel layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[signupLabel layer] setBorderWidth:1.0f];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)dismissKeyboard {
    if (emailField.editing) {
        [emailField resignFirstResponder];
    } else if (passwordField.editing) {
        [passwordField resignFirstResponder];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
