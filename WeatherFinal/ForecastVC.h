//
//  ForecastVC.h
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 24/02/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastVC : UIViewController <NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate, UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *locationName;

@property (nonatomic,strong) NSString *locationfrommain;
@property (nonatomic,strong) NSString *name_loc;

@property (nonatomic,strong) NSString *time;

@property (nonatomic,strong) NSString *apiKeyfvc;

@end
