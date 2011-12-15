//
//  DailyDealViewController.m
//  ScanTest
//
//  Created by Max Loukianov on 9/11/11.
//  Copyright 2011 Gimme!Deals LLC. All rights reserved.
//

#import "DailyDealViewController.h"
#import "SBJson.h"

#import "ScanTestAppDelegate.h"
#import "DailyDealDetailViewController.h"


@implementation DailyDealViewController

@synthesize search;
@synthesize resultsTable;
@synthesize segmentedControl;

@synthesize receivedData;
@synthesize jsonarray;


#pragma mark NSURLConnection delegate methods

// this class is a delegate for the connection methods

- (void)connection:(NSURLConnection *)connection
  didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    if (receivedData == nil) {
        NSLog(@"receivedData is nil - error!");
    }
    
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection 
  didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    
    NSLog(@"didReceiveData on connection; appeningData to NSMutableData");
    
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"Connection didFailWithError; receivedData released");
    // release data and url connection
    [receivedData release];
    receivedData = nil;
    [connection release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* returnedString = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"Connection didFinishLoading; preparing to parse");
    
    NSLog(@"Received data %@", returnedString);
    
    SBJsonParser* jsonparser = [[[SBJsonParser alloc] init ] autorelease];
    
    NSError* error = nil;
    id jsonobject = [[jsonparser objectWithString:returnedString error:&error] retain];
    
    if ([jsonobject isKindOfClass:[NSArray class]]) {
        // process it as an array
        jsonarray = [[NSArray arrayWithArray:jsonobject] retain];
        NSLog(@"JSON object (of type NSArray) is %@", jsonarray);
        
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
    
    // release the connection, and the data object
    [jsonobject release];
    [receivedData release];
    receivedData = nil;
    [connection release];

    [[self resultsTable] reloadData];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        UITabBarItem *tbi = [self tabBarItem];
        
        [tbi setTitle:@"Daily Deal"];
        
        UIImage *image = [UIImage imageNamed:@"07-map-marker.png"];
        
        [tbi setImage:image];
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
    }    
    
    NSDictionary* dict = (NSDictionary*)[jsonarray objectAtIndex:indexPath.row];
    
    CGRect frame;
    
	frame.size.width=75; frame.size.height=75;
	frame.origin.x=0; frame.origin.y=0;
    
    if ([dict objectForKey:@"id"]) {
    
        // NSString* imageUrlString = [NSString stringWithFormat:@"http://173.246.103.0/mobile/app/deal/img/%@", [dict objectForKey:@"id"]];
    
        // NSURL* url = [NSURL URLWithString:imageUrlString];
    
        NSString* labeltext = [dict objectForKey:@"name"];
        NSString* detailedtext = [dict objectForKey:@"locationType"];
    
        cell.textLabel.text = labeltext;
        cell.detailTextLabel.text = detailedtext;
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Clicked on chevron at row #%d", [indexPath row]);
    
    ScanTestAppDelegate* appDelegate = (ScanTestAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    DailyDealDetailViewController *dealDetailViewController = [[DailyDealDetailViewController alloc] init];
    
    [[appDelegate dealNavController] pushViewController:dealDetailViewController animated:YES];
    
    [dealDetailViewController release];

}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Clicked on row #%d", [indexPath row]);
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
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    if (connection) {
        [receivedData release];
        [self setReceivedData:[[NSMutableData data] retain]];    // retained by the property setter
    } else {
        // the connection has failed; need to inform the user
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
