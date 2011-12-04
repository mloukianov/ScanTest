//
//  RootViewController.m
//  ScanTest
//
//  Created by David Kavanagh on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "ScanTestAppDelegate.h"
#import "QRCodeReader.h"

#import "SBJson.h"


#import <objc/runtime.h>


@interface RootViewController()

@end


@implementation RootViewController

@synthesize resultsView;
@synthesize resultsToDisplay;

@synthesize locationManager;

@synthesize receivedData;

#pragma mark location manager delegate methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"Latitude = %f, Longitude = %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
    
    // Set up location services
    BOOL locationServicesAreEnabled = NO;
    
    Method requiredClassMethod = class_getClassMethod([CLLocationManager class], @selector(locationServicesEnabled));
    
    if (requiredClassMethod != nil) {
        locationServicesAreEnabled = [CLLocationManager locationServicesEnabled];
    } else {
        // CLLocationManager *dummyManager = [[CLLocationManager alloc] init];
        
        // locationServicesAreEnabled = [dummyManager locationServicesEnabled];
        
        // [dummyManager release];
    }
    
    if (locationServicesAreEnabled == YES) {
        CLLocationManager *newLocationManager = [[CLLocationManager alloc] init];
        
        self.locationManager = newLocationManager;
        
        [newLocationManager release];
        
        self.locationManager.delegate = self;
        
        self.locationManager.purpose = @"To show deals near my current location";
        
        [self.locationManager startUpdatingLocation];
    }
    
    // get the tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    
    // give it a label
    [tbi setTitle:@"Capture"];
    
    UIImage *image = [UIImage imageNamed:@"74-location.png"];
    
    [tbi setImage:image];
    
  // [self setTitle:@"ZXing"];
  [resultsView setText:resultsToDisplay];
}

- (IBAction)scanPressed:(id)sender {
	
  ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    
  QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    
  NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    
  [qrcodeReader release];
    
  widController.readers = readers;
    
  [readers release];
    
  NSBundle *mainBundle = [NSBundle mainBundle];
    
  widController.soundToPlay =
      [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
    
  [self presentModalViewController:widController animated:YES];
    
  [widController release];
}


- (UIImage*)imageFromText:(NSString *)text {
    
    UIFont *font = [UIFont systemFontOfSize:20.0];
    CGSize size = [text sizeWithFont:font];
    
    UIGraphicsBeginImageContext(size);
    
    [text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
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
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    
    NSURL *mobiUrl = [NSURL URLWithString:result];
    
    NSString *paramString = [mobiUrl query];
    
    NSArray *cgiVars = [paramString componentsSeparatedByString:@"_"];
    
    // NSString *locationid = [cgiVars objectAtIndex:0];
    NSString *receiptid = [cgiVars objectAtIndex:1];
    // NSString *totalmt = [cgiVars objectAtIndex:2];
    NSString *cashback = [cgiVars objectAtIndex:3];
    
    NSMutableString *cashbackLine = [NSMutableString string];
    
    [cashbackLine appendString:@"Success!  You've received $"];
    [cashbackLine appendString:cashback];
    [cashbackLine appendString:@" back on this purchase."];
    
    UIImage *checkmark = [UIImage imageNamed:@"capture_successcheck.png"];
    
    checkmarkImageView = [[UIImageView alloc] initWithImage:checkmark];
    
    UIImage *successBoxImage = [UIImage imageNamed:@"capture_successbox.png"];
    
    messageImageView = [[UIImageView alloc] initWithImage:successBoxImage];
    
    CGSize size = [successBoxImage size];
    
    int MARGIN = 5.0;
    
    CGRect rect = CGRectMake(0.0 + MARGIN, 0.0 + MARGIN, size.width - MARGIN, size.height - MARGIN);
    
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    
    [label setBackgroundColor:[UIColor clearColor]];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setNumberOfLines:0];
    
    [label setFont:[UIFont systemFontOfSize:22.00]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setText:cashbackLine];
    
    [messageImageView addSubview:label];
    
  if (self.isViewLoaded) {
      
      CGRect bounds = self.view.bounds;
      
      messageImageView.center = CGPointMake(bounds.size.width/2, bounds.size.height - (size.height + MARGIN)/2);
      
      [self.view addSubview:messageImageView];
      
      checkmarkImageView.center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
      
      [self.view addSubview:checkmarkImageView];
      
      [messageImageView release];
      [checkmarkImageView release];
      
      [messageImageView setNeedsDisplay];
  }
    
  [self dismissModalViewControllerAnimated:NO];
    
    // ------------------
    
    NSMutableString* urlMutableString = [NSString stringWithString:@"http://173.246.103.0/mobi/api/claimreceiptjson/"];
    
    [urlMutableString appendString:receiptid];
    
    ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];

    
    NSMutableString* mutableContentString = [NSMutableString stringWithString:@"userinfo={username:"];
    [mutableContentString appendString:[appDelegate profileEmail]];
    [mutableContentString appendString:@"}"];
    
    NSData* content = [NSData dataWithBytes:[mutableContentString UTF8String] length:[mutableContentString length]];
    
    NSURL* url = [NSURL URLWithString:urlMutableString];
    
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

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
  [self dismissModalViewControllerAnimated:YES];
}


#pragma mark View lifecycle methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [checkmarkImageView removeFromSuperview];
    [messageImageView removeFromSuperview];
}

- (void)viewDidUnload {
  self.resultsView = nil;
    
    if (self.locationManager != nil) {
        [self.locationManager stopUpdatingLocation];
    }
    
    self.locationManager = nil;
}

- (void)dealloc {
    [locationManager stopUpdatingLocation];
    [locationManager release];
  [resultsView release];
  [resultsToDisplay release];
  [super dealloc];
}


@end

