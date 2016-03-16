//
//  ViewController.m
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 23/02/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "ForecastVC.h"
#import "autoSearchTVC.h"
#import <Social/Social.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"

@interface ViewController ()
{
    NSString *location;
    NSMutableArray *results4, *results1, *results2, *results3 ;
    NSMutableDictionary *reslts, *outside, *result1, *results12,*results22,*results23;
    NSString *passedLoc, *passedCoordinates, *timetodisplayforbackground;
    
    //collectionView
    NSMutableArray *results, *results112312312, *tempCresult,*tempFresult,*timeresult,*timeeresult,*imageresult,*conditionresult;
    NSMutableDictionary *result, *FCTTIME, *temp, *dewpoint, *winspd, *windir, *feelslike;
    NSString *temperaturea, *temperatureaF, *image, *time, *time_h, *time_m, *conditionc;
    unsigned long count;
    
    //Call from selecting
    NSString *passedLocations, *passedCoordinate;
    NSString *shareURL;
    
    //to send for forecast
    NSString *nameLoc, *timevalue;
    int value;
    
    //Facebook Button
    FBSDKShareButton *sharebutton;
    
    //NSUserdefaults strings
    NSString *tempMetric, *visiMetric, *preciMetric, *pressureMetric, *windSpeedMetric;
    
    //Reachability test
    Reachability *internetConn;
    
    //Path of files
    NSArray *paths;
    NSString *documentsDirectory;
    
    //Key For api
    NSString *apiKey;
    
    //Fb sharing
    NSString *tempFb, *conditionFb, *placeFb, *windFb, *status, *urlFb;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Changes in API to Be Done only HERE...!!
    apiKey = [NSString stringWithFormat:@"355f204a9db504ed"];
    
    //applications document directory path
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
        
    passedLocations = self.selected_location;
    NSLog(@"VIEW CONTROLLER LOCATION rty : %@",passedLocations);
    
    passedCoordinate = self.selected_coordinates;
    NSLog(@"VIEW CONTROLLER COORDINATES RTY : %@",passedCoordinate);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //to make collectionview transparent
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.opaque = NO;
    self.collectionView.backgroundView = nil;
    
    [self loadUserLocation];
    
    [self.collectionView reloadData];
    
    NSUserDefaults *defaultss = [NSUserDefaults standardUserDefaults];
    
    tempMetric = [defaultss objectForKey:@"temp"];
    //NSLog(@"NSUSERDEFAULTS TEMP METRIC : %@",tempMetric);
    windSpeedMetric = [defaultss objectForKey:@"windSpeed"];
    preciMetric = [defaultss objectForKey:@"precipitation"];
    pressureMetric = [defaultss objectForKey:@"pressure"];
    visiMetric = [defaultss objectForKey:@"visibility"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //NSLog(@"Latitude location : %f",latitude_location);
    //NSLog(@"Longitude location : %f",longitude_location);
    
    location = [NSString stringWithFormat:@"/q/%f,%f",latitude_location,longitude_location];
    
    NSString *ifcondition = passedCoordinate;
    
    ////condition to check if selected locatons passes to view is null or not
    if(ifcondition.length == 0)
    {
        [self conditions:location tag:1];
        [self conditions:location tag:2];
    }
    else
    {
        [self conditions:passedCoordinate tag:1];
        [self conditions:passedCoordinate tag:2];
    }
    [userLocation stopUpdatingLocation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"SelectingLocations"])
    {
        autoSearchTVC *aTVC = [segue destinationViewController];
        NSLog(@"HI : %@",aTVC);
    }
    else
    {
        ForecastVC *fvc = [segue destinationViewController];
        NSLog(@"LOCATION TO SEND : %@",location);
        
        NSString *ifcondition = passedCoordinate;
        
        NSLog(@"ASD : %lu",(unsigned long)ifcondition.length);
        NSLog(@"PAASED COORDINATE : %@",passedCoordinate);
        
        if(ifcondition.length == 0)
        {
            fvc.locationfrommain = location;
            fvc.name_loc = nameLoc;
            fvc.time = timevalue;
            fvc.apiKeyfvc = apiKey;
        }
        else
        {
            fvc.locationfrommain = passedCoordinate;
            fvc.name_loc = nameLoc;
            fvc.time = timevalue;
            fvc.apiKeyfvc = apiKey;
        }       
    }   
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [userLocation stopUpdatingLocation];
}

- (void)conditions:(NSString *)loc tag:(int)tag{
    
    int tagnum = tag;
    
    if (tagnum == 1) {
        //NSLog(@"COnditions Call");
        NSString *apiCallUrl = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions%@.json",apiKey,loc];
        //NSLog(@"new api string is : %@",apiCallUrl);
        [self callAPI:apiCallUrl tag:tagnum];
        [self writeJsonToFile:apiCallUrl tag:tagnum];
    }
    else if(tagnum == 2)
    {
        NSString *apiCallUrl = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/hourly%@.json",apiKey,loc];
        //NSLog(@"new api string is : %@",apiCallUrl);
        [self callAPI:apiCallUrl tag:tagnum];
        [self writeJsonToFile:apiCallUrl tag:tagnum];
    }
}

- (void)writeJsonToFile:(NSString *)locs tag:(int)tagnum
{
    //applications Documents dirctory path
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    NSLog(@"PATH FOR write JSON FILE : %@",documentsDirectory);
    
    //live json data url
    NSString *stringURL = locs;
    NSURL *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    NSString *jsonfilename = self.selected_location;
    jsonfilename = [jsonfilename stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSLog(@"SELECTED LOCATIONS : %@",jsonfilename);
    NSString *hourlyFilename = [[NSString alloc]init];
    
    if(tagnum == 1) {
        hourlyFilename = [NSString stringWithFormat:@"%@",jsonfilename];
    }
    else {
        hourlyFilename = [NSString stringWithFormat:@"%@hourly",jsonfilename];
    }
    
    //attempt to download live data if connections available
    if (urlData)
    {
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",hourlyFilename]];
        [urlData writeToFile:filePath atomically:YES];
    }
    //copy data from initial package to Documents folder
    else
    {
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",hourlyFilename]];
        
        NSLog(@"FILEPATH IN WRITING JSON : %@",filePath);
        //file to copy from
        NSString *json = [ [NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",hourlyFilename] ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:json ]; //options:kNilOptions error:nil];
        
        //write file to device/documents folder for search
        [jsonData writeToFile:filePath atomically:YES];
    }
}

- (void)callAPI:(NSString *)callURL tag:(int)tagno {
    
    internetConn = [Reachability reachabilityForInternetConnection];
    [internetConn startNotifier];
    
    NetworkStatus netwrkStat = [internetConn currentReachabilityStatus];
    if(netwrkStat == NotReachable)
    {
        NSLog(@"NETWORK IS NOT REACHABEL");
        NSError *error;
        
        NSString *jsonfilename = passedLocations;
        jsonfilename = [jsonfilename stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *hourlyFilename = [[NSString alloc]init];
        
        if(tagno == 1) {
            hourlyFilename = [NSString stringWithFormat:@"%@",jsonfilename];
        }
        else {
            hourlyFilename = [NSString stringWithFormat:@"%@hourly",jsonfilename];
        }
        
        NSString *documentDir = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.json",hourlyFilename]];
        NSLog(@"PROPER PATH FOR JSON READING : %@",documentDir);
        NSData *dataFromFile = [NSData dataWithContentsOfFile:documentDir];
        //NSLog(@"DICTIONARY AFTER READING FROM FILE : %@",dataFromFile);
        if(error == nil) {
            
            NSDictionary *datadict = [NSJSONSerialization JSONObjectWithData:dataFromFile options:NSJSONReadingMutableContainers error:nil];
            
            if (tagno == 1)
            {
                [self conditionCall:datadict];
            }
            else
            {
                [self hourlyCall:datadict];
            }
        }
    }
    else if ((netwrkStat == ReachableViaWiFi) || (netwrkStat == ReachableViaWWAN))
    {
        NSLog(@"NETWORK IS REACHABLE");
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:callURL]];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error == nil) {
                
                NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if (tagno == 1)
                {
                    [self conditionCall:res];
                }
                else
                {
                    [self hourlyCall:res];
                }
            }
        }];
        [datatask resume];
    }
}

//Home View Data - RESPONSE FOR CONDITION DATA

- (void)conditionCall : (NSDictionary *)conditionDict {
    
    results12 = [conditionDict objectForKey:@"current_observation"];
    results22 = [results12 objectForKey:@"image"];
    results23 = [results12 objectForKey:@"display_location"];
    
    NSString *timec = [results12 objectForKey:@"local_time_rfc822"];
    NSString *tempC = [results12 objectForKey:@"temp_c"];
    NSString *tempF = [results12 objectForKey:@"temp_f"];
    NSString *url = [results12 objectForKey:@"icon_url"];
    NSURL *urll = [NSURL URLWithString:url];
    NSString *icon = [results12 objectForKey:@"icon"];
    NSString *feelslikeC = [results12 objectForKey:@"feelslike_c"];
    NSString *feelslikeF = [results12 objectForKey:@"feelslike_f"];
    NSString *loc = [results23 objectForKey:@"full"];
    NSString *humidity = [results12 objectForKey:@"relative_humidity"];
    
    NSString *wind_speedkph = [results12 objectForKey:@"wind_kph"];
    NSString *wind_speedmph = [results12 objectForKey:@"wind_mph"];
    
    NSString *pressuremb = [results12 objectForKey:@"pressure_mb"];
    NSString *pressurein = [results12 objectForKey:@"pressure_in"];
    
    NSString *wind_direction = [results12 objectForKey:@"wind_dir"];
    NSString *wind_directionFB = [results12 objectForKey:@"wind_string"];
    
    NSString *visibilitykm = [results12 objectForKey:@"visibility_km"];
    NSString *visibilitymi = [results12 objectForKey:@"visibility_mi"];
    
    NSString *precipitationin = [results12 objectForKey:@"precip_today_in"];
    NSString *precipitationmetric = [results12 objectForKey:@"precip_today_metric"];
    
    NSString *forecastshare = [results12 objectForKey:@"forecast_url"];
    
    nameLoc = loc;
    timetodisplayforbackground = timec;
    shareURL = forecastshare;
    windFb = wind_directionFB;
    urlFb = url;
    
    status = [NSString stringWithFormat:@"FORECAST FOR LOCATION : %@ \n Local Time : %@ \n Teparature will be  %@ °C / %@ °F \n Wind will be %@ \n Visibility will be %@ meters / %@ km \n Humidity is %@ \n Pressure will be %@ mBar / %@ in \n Rainfall is %@ in / %@ mm \n\n Click Below link for Detailed Forecast information : %@",loc,timec,tempC,tempF,wind_directionFB,visibilitymi,visibilitykm,humidity,pressuremb,pressurein,precipitationin,precipitationmetric,shareURL];
    
    //NSLog(@"FACEBOOK STATUS FOR SHARING %@",status);
    
    self.location_name.text = [NSString stringWithFormat:@"%@",loc];
    self.locationTime.text = [NSString stringWithFormat:@"%@",timec];
    
    //After checking userDefaults change temp metric
    if([tempMetric isEqualToString:@"°F"]){
        
        NSInteger tf = [tempF integerValue];
        self.temperature.text = [NSString stringWithFormat:@"%ld°F",(long)tf];
        self.minmaxLabel.text = [NSString stringWithFormat:@"Feels Like : %@ °F",feelslikeF];
    }
    else
    {
        NSInteger tf = [tempC integerValue];
        self.temperature.text = [NSString stringWithFormat:@"%ld°C",(long)tf];
        self.minmaxLabel.text = [NSString stringWithFormat:@"Feels Like : %@ °C",feelslikeC];
    }
    
    //setting image on home screen
    self.condition.text = [NSString stringWithFormat:@"%@",icon];
    [self.coditionImage sd_setImageWithURL:urll placeholderImage:nil options:SDWebImageRefreshCached];
    
    //setting humidity text
    self.humidity.text = [NSString stringWithFormat:@"Humidity : %@",humidity];
    
    //checking for windspeed toggle
    if([windSpeedMetric isEqualToString:@"kph"]){
        
        self.windSpeed.text = [NSString stringWithFormat:@"Wind Speed : %@ kph",wind_speedkph];
    }
    else
    {
        self.windSpeed.text = [NSString stringWithFormat:@"Wind Speed : %@ mph",wind_speedmph];
    }
    
    //checking for visibility toggle
    if([visiMetric isEqualToString:@"km"]){
        
        self.visibility.text = [NSString stringWithFormat:@"Visibility : %@ km",visibilitykm];
    }
    else
    {
        self.visibility.text = [NSString stringWithFormat:@"Visibility : %@ mtrs",visibilitymi];
    }
    
    self.windDescription.text = [NSString stringWithFormat:@"From the direction : %@",wind_direction];
    
    //checking for pressure toggle
    if([pressureMetric isEqualToString:@"mBar"]){
        
        self.pressure.text = [NSString stringWithFormat:@"Pressure : %@ mBar",pressuremb];
    }
    else
    {
        self.pressure.text = [NSString stringWithFormat:@"Pressure : %@ in",pressurein];
    }
    
    //checking for precipitation null values
    if ([precipitationin isEqualToString:@""] || [precipitationmetric isEqualToString:@""]) {
        self.precipitation.text = [NSString stringWithFormat:@"Precipitation : -- "];
    }
    else {
        
        if([precipitationmetric isEqualToString:@"in"]){
            
            self.precipitation.text = [NSString stringWithFormat:@"Precipitation : %@in",precipitationin];
        }
        else
        {
            self.precipitation.text = [NSString stringWithFormat:@"Precipitation : %@mm",precipitationmetric];
        }
    }
    
    //wind direction image selection
    if ([wind_direction isEqualToString:@"NNW"] || [wind_direction isEqualToString:@"WNW"] || [wind_direction isEqualToString:@"NW"]) {
        self.windDirectionImage.image = [UIImage imageNamed:@"NNW"];
    }
    else if ([wind_direction isEqualToString:@"SSE"] || [wind_direction isEqualToString:@"ESE"] || [wind_direction isEqualToString:@"SE"]) {
        self.windDirectionImage.image = [UIImage imageNamed:@"SSE"];
    }
    else if ([wind_direction isEqualToString:@"NNE"] || [wind_direction isEqualToString:@"ENE"] || [wind_direction isEqualToString:@"NE"]) {
        self.windDirectionImage.image = [UIImage imageNamed:@"NNE"];
    }
    else if ([wind_direction isEqualToString:@"SSW"] || [wind_direction isEqualToString:@"WSW"] || [wind_direction isEqualToString:@"SW"]) {
        self.windDirectionImage.image = [UIImage imageNamed:@"SSW"];
    }
    else if ([wind_direction isEqualToString:@"North"] || [wind_direction isEqualToString:@"N"]) {
        self.windDirectionImage.image = [UIImage imageNamed:@"N"];
    }
    else if ([wind_direction isEqualToString:@"South"] || [wind_direction isEqualToString:@"S"]) {
        self.windDirectionImage.image = [UIImage imageNamed:@"S"];
    }
    else if ([wind_direction isEqualToString:@"East"] || [wind_direction isEqualToString:@"E"]) {
        self.windDirectionImage.image = [UIImage imageNamed:@"E"];
    }
    else if ([wind_direction isEqualToString:@"West"] || [wind_direction isEqualToString:@"W"]) {
        self.windDirectionImage.image = [UIImage imageNamed:@"W"];
    }
    results1 = results4;
}

//Collection View Data - RESPONCE FOR HOURLY DATA

- (void)hourlyCall: (NSDictionary *)callDict {
    
    results = [callDict objectForKey:@"hourly_forecast"];
    results112312312 = [[callDict objectForKey:@"hourly_forecast"] objectAtIndex:0];
    
    tempCresult = [[NSMutableArray alloc]init];
    timeresult = [[NSMutableArray alloc]init];
    imageresult = [[NSMutableArray alloc]init];
    conditionresult = [[NSMutableArray alloc]init];
    timeeresult = [[NSMutableArray alloc]init];
    tempFresult = [[NSMutableArray alloc]init];
    
    for (result in results) {
        
        dewpoint = [result objectForKey:@"dewpoint"];
        FCTTIME = [result objectForKey:@"FCTTIME"];
        temp = [result objectForKey:@"temp"];
        winspd = [result objectForKey:@"wspd"];
        windir = [result objectForKey:@"wdir"];
        feelslike = [result objectForKey:@"feelslike"];
        
        temperaturea = [temp objectForKey:@"metric"];
        temperatureaF = [temp objectForKey:@"english"];
        image = [result objectForKey:@"icon_url"];
        time_h = [FCTTIME objectForKey:@"civil"];
        time_m = [FCTTIME objectForKey:@"hour"];
        conditionc = [result objectForKey:@"condition"];
        
        time = [NSString stringWithFormat:@"%@:%@",time_h,time_m];
        count = [result count];
        
        /*NSLog(@"DEWPOINT : %@",dewpoint);
         NSLog(@"FCTTIME : %@",FCTTIME);
         NSLog(@"TEMPERATR : %@",temp);
         NSLog(@"WIND SPEED : %@",winspd);
         NSLog(@"WIND DIR : %@",windir);
         NSLog(@"FEELS LIKE : %@",feelslike);
         NSLog(@"temperature : %@",temperature);
         NSLog(@"imageurl : %@",image);
         NSLog(@"time : %@",time);*/
        
        [tempCresult addObject:[NSString stringWithFormat:@"%@",temperaturea]];
        [tempFresult addObject:[NSString stringWithFormat:@"%@",temperatureaF]];
        [timeresult addObject:[NSString stringWithFormat:@"%@",time_h]];
        [imageresult addObject:[NSString stringWithFormat:@"%@",image]];
        [conditionresult addObject:[NSString stringWithFormat:@"%@",conditionc]];
        [timeeresult addObject:[NSString stringWithFormat:@"%@",time_m]];
        
        //NSLog(@"TEMP ARRAY : %@",tempresult);
        //NSLog(@"TIME ARRAY : %@",timeresult);
        //NSLog(@"IMAGE ARRAY : %@",imageresult);
        //NSLog(@"CONDITION ARRAY : %@",conditionresult);
        //NSLog(@"Imateasf :%@",timeeresult);
        //NSLog(@"COUNT OF RESULTS %lu",(unsigned long)[result count]);
    }
    if(timeeresult.count > 0) {
        NSString *timeselectes = [timeeresult objectAtIndex:0];
        //NSLog(@"TIMEEEEEEEEEEEEE : %@",timeselectes);
        [self bcakgroundChange:timeselectes];
    }
}

- (void)bcakgroundChange:(NSString *)timef {
    
    timevalue = timef;
    value = [timevalue intValue];
    
    NSLog(@"TIME IN SELECTED CITY : %d",value);
    
    if(value > 19)
    {
        if(value <24)
        {
            [self imageName:@"night_sky.jpg"];
        }
    }
    if (value < 8)
    {
        [self imageName:@"night_sky.jpg"];
    }
    if (value > 7)
    {
        if(value < 12)
        {
            //NSLog(@"IT is morning time");
            //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"autumn.jpg"]];
            [self imageName:@"autumn.jpg"];
        }
    }
    if (value > 11 )
    {
        if(value < 16)
        {
            //NSLog(@"IT is afternoon time");
            //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunny.jpg"]];
            [self imageName:@"sunny.jpg"];
        }
    }
    if (value > 15)
    {
        if(value < 20)
        {
            //NSLog(@"IT is evening time");
            //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunset.jpg"]];
            [self imageName:@"sunset.jpg"];
        }
    }
    //NSLog(@"SELECTED TIME FOR BACKGROUND CHANGE : %@",timef);
}

- (void)imageName :(NSString *)nameImage {
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:nameImage] drawInRect:self.view.bounds];
    UIImage *imagea = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:imagea];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 20;
}

//Hourly Collection Data set to CollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CellO";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageresult objectAtIndex:indexPath.row]]];
    [cell.imageConditions sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",[timeresult objectAtIndex:indexPath.row]];
    cell.conditionLabel.text = [NSString stringWithFormat:@"%@",[conditionresult objectAtIndex:indexPath.row]];
    
    //After checking on NSuserdefaults change temp metric in collectionview
    if([tempMetric isEqualToString:@"°F"]){
        
        cell.tempLabel.text = [NSString stringWithFormat:@"%@ °F",[tempFresult objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.tempLabel.text = [NSString stringWithFormat:@"%@ °C",[tempCresult objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (IBAction)FbSharing:(id)sender {
     
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        NSLog(@"Share URL%@",shareURL);
        SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbSheet setInitialText:[NSString stringWithFormat:@"%@",status]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlFb]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        //[fbSheet addURL:[NSURL URLWithString:[NSString stringWithFormat:@"Click Below link for Detailed Forecast \n %@",shareURL]]];
        [fbSheet addImage:[UIImage imageWithData:data]];
        [self presentViewController:fbSheet animated:YES completion:nil];        
    }
    else
    {
        NSLog(@"Share URL%@",shareURL);
        [self displayAlert:@"You are not logged in for the service FBShare" service:@"FB"];
    }
}

- (void)displayAlert:(NSString *)msg service:(NSString *)service {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ALERT" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OKAY" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        if ([service isEqualToString:@"FB"]) {
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=FACEBOOK"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];

    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
