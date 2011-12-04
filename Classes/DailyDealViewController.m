//
//  DailyDealViewController.m
//  ScanTest
//
//  Created by Max Loukianov on 9/11/11.
//  Copyright 2011 Freelink Wireless Services. All rights reserved.
//

#import "DailyDealViewController.h"
#import "SBJson.h"

#import "ScanTestAppDelegate.h"

#import "asyncimageview.h"


@implementation DailyDealViewController

@synthesize search;
@synthesize resultsTable;
@synthesize segmentedControl;

@synthesize receivedData;

@synthesize jsonarray;

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
    
    // NSString* returnedString = [NSString stringWithUTF8String:[receivedData bytes]];
    
    NSLog(@"Received data %@", returnedString);
    
    SBJsonParser* jsonparser = [[[SBJsonParser alloc] init ] autorelease];
    
    NSError* error = nil;
    id jsonobject = [jsonparser objectWithString:returnedString error:&error];
    
    [jsonobject retain];
    
    if ([jsonobject isKindOfClass:[NSArray class]]) {
        // process it as an array
        NSLog(@"JSON object is NSArray");
        
        jsonarray = [NSArray arrayWithArray:jsonobject];
        
        [jsonarray retain];
        
        NSLog(@"JSON object is %@", jsonarray);
        
    } else if ([jsonobject isKindOfClass:[NSDictionary class]]) {
        // process it as a dictionary
        NSLog(@"JSON object is NSDictionary");
        
        NSDictionary* jsondict = jsonobject;
        
        if ( [jsondict objectForKey:@"error"] ) {
            NSLog(@"Error content");
            
            UIAlertView* loginFailedAlert = [[UIAlertView alloc] initWithTitle:@"Loading deals failed" message:@"Loading deals has failed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            
            [loginFailedAlert show];
            [loginFailedAlert release];
        } else {
            NSLog(@"not error content");
            
            NSString* profileEmail = [jsondict objectForKey:@"email"];
            NSString* profilePhone = [jsondict objectForKey:@"phone"];
            
            ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            appDelegate.profileEmail = profileEmail;
            appDelegate.profilePhone = profilePhone;
            
            // now we remove call the method on appDelegate to replace this with the tab control
            
            [appDelegate createMainTabControl];
        }
    }
    
    // [jsonparser release];
    
    // release the connection, and the data object
    [connection release];
    [receivedData release];

    [[self resultsTable] reloadData];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    UITabBarItem *tbi = [self tabBarItem];
    
    [tbi setTitle:@"Daily Deal"];
    
    UIImage *image = [UIImage imageNamed:@"07-map-marker.png"];
    
    [tbi setImage:image];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [segmentedControl release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark Segmented control methods

- (IBAction)segmentedControlIndexChanged {
    NSLog(@"Segmented control selection index : %d", self.segmentedControl.selectedSegmentIndex);
}

#pragma mark Table view methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"ImageCell";
    
    NSLog(@"Producing string for the row %d", [indexPath row]);

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    } else {
        AsyncImageView* oldImage = (AsyncImageView*) [cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }
    
    // NSLog(@"Dictionary: %@", [jsonarray objectAtIndex:indexPath.row]);
    
    // Set up the cell...
    // cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    NSDictionary* dict = (NSDictionary*)[jsonarray objectAtIndex:indexPath.row];
    
    CGRect frame;
	frame.size.width=75; frame.size.height=75;
	frame.origin.x=0; frame.origin.y=0;
	AsyncImageView* asyncImage = [[[AsyncImageView alloc]
                                   initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
    
    if ([dict objectForKey:@"id"]) {
    
        NSString* imageUrlString = [NSString stringWithFormat:@"http://173.246.103.0/mobile/app/deal/img/%@", [dict objectForKey:@"id"]];
    
        NSURL* url = [NSURL URLWithString:imageUrlString];
    
        [asyncImage loadImageFromURL:url];
        
        [cell.imageView addSubview:asyncImage];
    
        NSString* labeltext = [dict objectForKey:@"name"];
        NSString* detailedtext = [dict objectForKey:@"locationType"];
    
        cell.textLabel.text = labeltext;
        cell.detailTextLabel.text = detailedtext;
    }
    
    
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // open a alert with an OK and cancel button
    NSString *alertString = [NSString stringWithFormat:@"Clicked on row #%d", [indexPath row]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"View will appear got called");
    
    // load deals data fromm the web site
    NSMutableString* mutableUrlString = [NSMutableString stringWithString:@"http://173.246.103.0/mobile/app/deals/1"];
    
    NSURL* url = [NSURL URLWithString:mutableUrlString];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setHTTPShouldHandleCookies:TRUE];
    [urlRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [urlRequest setTimeoutInterval:60.0];
    
    // we have created NSURLRequest (in the form of NSMutableURLRequest)
    
    NSURLConnection* theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    if (theConnection) {
        receivedData = [[NSMutableData data] retain];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"View will disappear got called");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self view] setBackgroundColor:[UIColor greenColor]];
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
