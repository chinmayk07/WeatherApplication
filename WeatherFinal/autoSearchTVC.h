//
//  autoSearchTVC.h
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 24/02/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface autoSearchTVC : UITableViewController <UISearchBarDelegate, NSURLSessionDataDelegate,NSURLSessionDelegate, NSURLSessionTaskDelegate,UISearchResultsUpdating>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)backBarButton:(id)sender;

@end
