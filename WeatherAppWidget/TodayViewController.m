//
//  TodayViewController.m
//  WeatherAppWidget
//
//  Created by Mac-Mini-3 on 01/03/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
{
    NSMutableArray *results, *results112312312, *tempCresult, *tempFresult, *timeresult,*timeeresult, *imageresult, *conditionresult;
    NSMutableDictionary *result, *FCTTIME, *temp, *dewpoint, *winspd, *windir, *feelslike;
    NSString *temperaturea, *temperatureaF, *image, *time, *time_h, *time_m, *conditionc;
    unsigned long count;
    NSString *location;
    NSString *passedLocations, *passedCoordinate;
    NSMutableDictionary *reslts, *outside, *result1, *results12,*results22,*results23;
    NSUserDefaults *defaults;
    
    //NSUserdefaults strings
    NSString *tempMetric;
}

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    defaults = [NSUserDefaults standardUserDefaults];
    [self loadUserLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    //[self loadUserLocation];

    completionHandler(NCUpdateResultNewData);
}

- (void)loadUserLocation {
    
    userLocation = [[CLLocationManager alloc]init];
    userLocation.delegate = self;
    userLocation.distanceFilter = kCLDistanceFilterNone;
    userLocation.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if([userLocation respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [userLocation requestWhenInUseAuthorization];
    }
    [userLocation startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *newLocation = [locations lastObject];
    latitude_location = newLocation.coordinate.latitude;
    longitude_location = newLocation.coordinate.longitude;
    
    location = [NSString stringWithFormat:@"/q/%f,%f",latitude_location,longitude_location];
    [self conditions:location];
    [userLocation stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [userLocation stopUpdatingLocation];
}

- (void)conditions:(NSString *)loc {
    
    NSString *apiCallUrl = [NSString stringWithFormat:@"http://api.wunderground.com/api/bb4b2fea52b0b9e9/conditions%@.json",loc];
    NSLog(@"new api string is : %@",apiCallUrl);
    [self callAPI:apiCallUrl];
    //NSLog(@"new string is : %@",str);
}

- (void)callAPI:(NSString *)callURL {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:callURL]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error == nil) {
            
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            results12 = [res objectForKey:@"current_observation"];
            results22 = [results12 objectForKey:@"display_location"];
            
            NSString *tempC = [results12 objectForKey:@"temp_c"];
            NSString *tempF = [results12 objectForKey:@"temp_f"];
            NSString *url = [results12 objectForKey:@"icon_url"];
            NSString *icon = [results12 objectForKey:@"icon"];
            NSString *city = [results22 objectForKey:@"city"];
            NSString *state = [results22 objectForKey:@"state"];
            NSString *country = [results22 objectForKey:@"country"];
            NSString *locName = [NSString stringWithFormat:@"%@,%@,%@",city,state,country];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            
            NSLog(@"image url : %@",url);
            NSLog(@"Location : %@",locName);
            
            //After checking userDefaults change temp metric
            if([tempMetric isEqualToString:@"°F"]){
                
                self.widgetTemp.text = [NSString stringWithFormat:@"%@°F",tempF];
            }
            else
            {
                self.widgetTemp.text = [NSString stringWithFormat:@"%@°C",tempC];
            }
            
            self.widgetCondition.text = [NSString stringWithFormat:@"%@",icon];
            self.widgetImage.image = [[UIImage alloc] initWithData:data];
        }
    }];
    [datatask resume];
}

@end
