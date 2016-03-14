//
//  ViewController.h
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 23/02/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface ViewController : UIViewController <NSURLSessionTaskDelegate,NSURLSessionDataDelegate,NSURLSessionDelegate,CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    CLLocationManager *userLocation;
    double latitude_location, longitude_location;
}

@property NSInteger selectedLink;
@property (nonatomic,strong) NSString *selected_location;
@property (nonatomic,strong) NSString *selected_coordinates;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *FbShare;
- (IBAction)FbSharing:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *locationTime;
@property (weak, nonatomic) IBOutlet UILabel *location_name;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UIImageView *coditionImage;
@property (weak, nonatomic) IBOutlet UILabel *condition;
@property (weak, nonatomic) IBOutlet UILabel *minmaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *windDescription;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *visibility;
@property (weak, nonatomic) IBOutlet UILabel *precipitation;
@property (weak, nonatomic) IBOutlet UIImageView *windDirectionImage;
@property (weak, nonatomic) IBOutlet UILabel *pressure;

@end

