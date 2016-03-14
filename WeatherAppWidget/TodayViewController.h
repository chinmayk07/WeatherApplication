//
//  TodayViewController.h
//  WeatherAppWidget
//
//  Created by Mac-Mini-3 on 01/03/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface TodayViewController : UIViewController <NSURLSessionTaskDelegate,NSURLSessionDataDelegate,NSURLSessionDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *userLocation;
    double latitude_location, longitude_location;
}

@property (weak, nonatomic) IBOutlet UIImageView *widgetImage;
@property (weak, nonatomic) IBOutlet UILabel *widgetTemp;
@property (weak, nonatomic) IBOutlet UILabel *widgetCondition;
@end
