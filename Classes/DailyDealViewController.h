//
//  DailyDealViewController.h
//  ScanTest
//
//  Created by Max Loukianov on 9/11/11.
//  Copyright 2011 Freelink Wireless Services. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DailyDealViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UISearchBar* search;
    IBOutlet UITableView* resultsTable;
    IBOutlet UISegmentedControl* segmentedControl;
    
    NSMutableData* receivedData;
    
    NSArray* jsonarray;
    
}

@property (nonatomic, retain) UISearchBar* search;
@property (nonatomic, retain) UITableView* resultsTable;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;

@property (nonatomic, retain) NSMutableData* receivedData;

@property (nonatomic, retain) NSArray* jsonarray;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;


@end
