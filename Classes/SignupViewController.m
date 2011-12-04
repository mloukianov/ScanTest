//
//  SignupViewController.m
//  ScanTest
//
//  Created by Max Loukianov on 11/6/11.
//  Copyright (c) 2011 Freelink Wireless Services. All rights reserved.
//

#import "SignupViewController.h"
#import "ScanTestAppDelegate.h"

#import "SBJson.h"


@implementation SignupViewController

@synthesize credentialsView;

@synthesize signupButton;

@synthesize phoneField;
@synthesize emailField;
@synthesize passwordField;
@synthesize confirmField;

@synthesize phone;
@synthesize email;
@synthesize password;
@synthesize confirm;

@synthesize receivedData;


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


- (void)dealloc {
    
    [super dealloc];
    [phoneField release];
    [emailField release];
    [passwordField release];
    [confirmField release];
    
    [phone release];
    [email release];
    [password release];
    [confirm release];
}

#pragma mark -

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSLog(@"text field content: %@", textField.text);
    NSLog(@"textfield tag %i", textField.tag);

    [textField resignFirstResponder];
    
    switch(textField.tag) {
        case 1:
            self.phone = textField.text;
            [self.emailField becomeFirstResponder];
            break;
        case 2:
            self.email = textField.text;
            [self.passwordField becomeFirstResponder];
            break;
        case 3:
            self.password = textField.text;
            [self.confirmField becomeFirstResponder];
            break;
        case 4:
            self.confirm = textField.text;
            break;
    }
    return NO;
}

#pragma mark -


- (IBAction)signupButtonPressed:(id)sender {
    
    NSLog(@"Trying to sign up for gimme");
    
    if ([self.phone length] < 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid phone number" message:@"Please make sure phone number you've entered is valid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (![emailTest evaluateWithObject:self.email]) {
        NSLog(@"Invalid e-mail address: %@", self.email);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid e-mail address" message:@"Please make sure e-mail address you've entered is valid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }

    if (![self.password isEqualToString:self.confirm]) {
        NSLog(@"Mismatched passwords: %@ and %@", self.password, self.confirm);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords does not match" message:@"Please make sure your password match with Confirm field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }

    NSString* urlString = [NSString stringWithString:@"http://173.246.103.0/mobile/app/signup"];
    
    NSMutableString* mutableContentString = [NSMutableString stringWithString:@"email="];
    [mutableContentString appendString:email];
    [mutableContentString appendString:@"&password="];
    [mutableContentString appendString:password];
    [mutableContentString appendString:@"&phone="];
    [mutableContentString appendString:phone];
    
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
    
    NSURLConnection* theConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    
    if (theConnection) {
        
        receivedData = [[NSMutableData data] retain];
    }

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
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
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
        NSLog(@"JSON object is NSArray - it should not be an array here");
        
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

#pragma mark -

#pragma mark TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier 
// and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"signupCell";
    
    UITableViewCell *cell = [credentialsView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Phone";
            self.phoneField.text = @"";
            [cell setAccessoryView:self.phoneField];
        }
            break;
            
        case 1:
        {
            cell.textLabel.text = @"Email";
            self.emailField.text = @"";
            [cell setAccessoryView:self.emailField];
        }
            break;
            
        case 2:
        {
            cell.textLabel.text = @"Password";
            self.passwordField.text = @"";
            [cell setAccessoryView:self.passwordField];
        }
            break;
            
        case 3:
        {
            cell.textLabel.text = @"Confirm";
            self.confirmField.text = @"";
            [cell setAccessoryView:self.confirmField];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.phoneField = [[UITextField alloc] initWithFrame:CGRectMake(155.0, 15.0, 165.0, 25.0)];
    
    self.phoneField.adjustsFontSizeToFitWidth = YES;
    self.phoneField.textColor = [UIColor blackColor];
    self.phoneField.placeholder = @"XXX.XXX.XXXX";
    self.phoneField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.phoneField.returnKeyType = UIReturnKeyNext;
    self.phoneField.backgroundColor = [UIColor whiteColor];
    self.phoneField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.phoneField.textAlignment = UITextAlignmentLeft;
    self.phoneField.clearButtonMode = UITextFieldViewModeNever;
    
    self.phoneField.tag = 1;
    
    self.phoneField.delegate = self;
    
    [[self phoneField] setEnabled:YES];
    
    
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(155.0, 15.0, 165.0, 25.0)];
    
    self.emailField.adjustsFontSizeToFitWidth = YES;
    self.emailField.textColor = [UIColor blackColor];
    self.emailField.placeholder = @"example@me.com";
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.returnKeyType = UIReturnKeyNext;
    self.emailField.backgroundColor = [UIColor whiteColor];
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.textAlignment = UITextAlignmentLeft;
    self.emailField.clearButtonMode = UITextFieldViewModeNever;
    
    self.emailField.tag = 2;
    
    self.emailField.delegate = self;
    
    [[self emailField] setEnabled:YES];


    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(155.0, 15.0, 165.0, 25.0)];
    
    self.passwordField.adjustsFontSizeToFitWidth = YES;
    self.passwordField.textColor = [UIColor blackColor];
    self.passwordField.placeholder = @"********";
    self.passwordField.keyboardType = UIKeyboardTypeDefault;
    self.passwordField.returnKeyType = UIReturnKeyNext;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.textAlignment = UITextAlignmentLeft;
    self.passwordField.clearButtonMode = UITextFieldViewModeNever;
    self.passwordField.secureTextEntry = YES;
    
    self.passwordField.tag = 3;
    
    self.passwordField.delegate = self;
    
    [[self passwordField] setEnabled:YES];

    
    self.confirmField = [[UITextField alloc] initWithFrame:CGRectMake(155.0, 15.0, 165.0, 25.0)];
    
    self.confirmField.adjustsFontSizeToFitWidth = YES;
    self.confirmField.textColor = [UIColor blackColor];
    self.confirmField.placeholder = @"********";
    self.confirmField.keyboardType = UIKeyboardTypeDefault;
    self.confirmField.returnKeyType = UIReturnKeyNext;
    self.confirmField.backgroundColor = [UIColor whiteColor];
    self.confirmField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.confirmField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.confirmField.textAlignment = UITextAlignmentLeft;
    self.confirmField.clearButtonMode = UITextFieldViewModeNever;
    self.confirmField.secureTextEntry = YES;
    
    self.confirmField.tag = 4;
    
    self.confirmField.delegate = self;
    
    [[self confirmField] setEnabled:YES];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.phoneField = nil;
    self.emailField = nil;
    self.passwordField = nil;
    self.confirmField = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[appDelegate navigationController] setNavigationBarHidden:NO animated:animated];
    [[[[appDelegate navigationController] navigationBar] topItem] setTitle:@"Sign up"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[appDelegate navigationController] setNavigationBarHidden:YES animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
