//
//  RootViewController.h
//  ScanTest
//
//  Created by David Kavanagh on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"

@interface RootViewController : UIViewController <ZXingDelegate, CLLocationManagerDelegate> {
    // IBOutlet UITextView *resultsView;
    
    NSString *resultsToDisplay;
    UIImageView *checkmarkImageView;
    UIImageView *messageImageView;
    
    NSMutableData* receivedData;
    
    @public
    CLLocationManager *locationManager;
  
}
@property (nonatomic, retain) IBOutlet UITextView *resultsView;
@property (nonatomic, copy) NSString *resultsToDisplay;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) NSMutableData* receivedData;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (IBAction)scanPressed:(id)sender;

- (UIImage*)imageFromText:(NSString*)text;

@end
