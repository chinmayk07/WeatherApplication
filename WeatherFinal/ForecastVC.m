//
//  ForecastVC.m
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 24/02/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//   MAIN APP FILE

#import "ForecastVC.h"
#import "TableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"

@interface ForecastVC ()
{
    NSMutableArray *result, *dayname, *dayimage, *dayhighC, *daylowC, *dayhighF, *daylowF, *results2, *condi;
    NSMutableDictionary *rslt, *results, *results1, *date, *temphigh, *templow;
    NSString *hign_tempC, *low_tempC, *hign_tempF, *low_tempF, *weekoftheday, *icon_url, *condin;
    
    int value;
    
    //NsuserDefaults
    NSUserDefaults *defaultss;
    NSString *conditionCheck;
    
    //Path of files
    NSArray *paths;
    NSString *documentsDirectory;
    
    //Reachability test
    Reachability *internetConn;
    
}

@end

@implementation ForecastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"FORECAST VIEW DID LOAD");
    NSLog(@"API KEY : %@",self.apiKeyfvc);
    
    //applications document directory path
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //to make tableview transparent
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;
    
    
    NSString *locationasdfasdf = self.locationfrommain;
    [self conditions];
    [self.tableView reloadData];    
    
    //NSString *locationasdfasdf = self.locationfrommain;
    NSLog(@"FORECASTasdfasdfasdfsaf : %@",locationasdfasdf);
    NSString *locattt= self.name_loc;
    NSLog(@"CURRENT LOCATION NAME : %@",locattt);
    NSString *backgroundtime = self.time;
    [self bcakgroundChange:backgroundtime];
    defaultss = [NSUserDefaults standardUserDefaults];
    conditionCheck = [defaultss objectForKey:@"temp"];
    NSLog(@"CONDITION CHECK : %@",conditionCheck);
    self.locationName.text = [NSString stringWithFormat:@"%@ ( in %@ )",locattt,conditionCheck];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)bcakgroundChange:(NSString *)timef {
    
    
    value = [timef intValue];
    
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


- (void)conditions {
    
    //NSString *str = [NSString stringWithFormat:@"%@",loc];
    
    NSString *apiCallUrl = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast10day%@.json",self.apiKeyfvc,self.locationfrommain];
    NSLog(@"new api string is : %@",apiCallUrl);
    [self callAPI:apiCallUrl];
    [self writeJsonToFile1:apiCallUrl];
    //NSLog(@"new string is : %@",str);
}

- (void)writeJsonToFile1:(NSString *)locs
{
    NSLog(@"PATH FOR JSON LOCATION : %@",locs);
    NSLog(@"PATH FOR JSON hourly FILE : %@",documentsDirectory);
    
    //live json data url
    NSString *stringURL = locs;
    NSURL *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    NSString *jsonfilename = self.name_loc;
    jsonfilename = [jsonfilename stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSLog(@"SELECTED LOCATIONS : %@",jsonfilename);
    NSString *hourlyFilename = [NSString stringWithFormat:@"%@10days",jsonfilename];
    
    //attempt to download live data
    if (urlData)
    {
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",hourlyFilename]];
        [urlData writeToFile:filePath atomically:YES];
    }
    //copy data from initial package into Documents folder
    else
    {
        //file to write to
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",hourlyFilename]];;
        
        NSLog(@"FILEPATH IN WRITING JSON : %@",filePath);
        //file to copy from
        NSString *json = [ [NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",hourlyFilename] ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:json];//options:kNilOptions error:nil];
        
        //write file to device
        [jsonData writeToFile:filePath atomically:YES];
    }
}

- (void)callAPI:(NSString *)callURL {
    
    internetConn = [Reachability reachabilityForInternetConnection];
    [internetConn startNotifier];
    
    NetworkStatus netwrkStat = [internetConn currentReachabilityStatus];
    if(netwrkStat == NotReachable)
    {
        NSLog(@"NETWORK IS NOT REACHABEL");
        NSError *error;
        
        NSString *jsonfilename = self.name_loc;
        jsonfilename = [jsonfilename stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *hourlyFilename = [NSString stringWithFormat:@"%@10days",jsonfilename];
        
        //NSLog(@"NAME OF JSON FILE : %@",hourlyFilename);
        
        NSString *pathDoc = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.json",hourlyFilename]];
        NSLog(@"PROPER PATH FOR JSON READING : %@",pathDoc);
        
        NSData *dataFromFile = [NSData dataWithContentsOfFile:pathDoc];
        
        if (error == nil) {
            NSLog(@"Able to load messages.");
            
            NSDictionary *datadict = [NSJSONSerialization JSONObjectWithData:dataFromFile options:NSJSONReadingMutableContainers error:nil];
            [self forecastCall:datadict];            
        }
        else {
            NSLog(@"Error: was not able to load messages.");
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
                [self forecastCall:res];
            }
        }];
        [datatask resume];
    }    
}

- (void)forecastCall : (NSDictionary *)dict {
    
    results = [dict objectForKey:@"forecast"];
    //NSLog(@" Result object dict : %@",results);
    
    results1 = [results objectForKey:@"simpleforecast"];
    //NSLog(@" RESULTS SIMPLE FORECAST %@",results1);
    
    results2 = [results1 objectForKey:@"forecastday"];
    
    dayhighC = [[NSMutableArray alloc]init];
    dayname = [[NSMutableArray alloc]init];
    daylowC = [[NSMutableArray alloc]init];
    dayimage = [[NSMutableArray alloc]init];
    dayhighF = [[NSMutableArray alloc]init];
    daylowF = [[NSMutableArray alloc]init];
    condi = [[NSMutableArray alloc]init];
    
    for (rslt in results2) {
        
        date = [rslt objectForKey:@"date"];
        temphigh = [rslt objectForKey:@"high"];
        templow = [rslt objectForKey:@"low"];
        
        //NSLog(@"WEEKOFTHEDAY : %@",date);
        //NSLog(@"ICON  : %@",conditions);
        //NSLog(@"low TEMPERATR : %@",templow);
        //NSLog(@"high TEMPERATURE : %@",temphigh);
        
        weekoftheday = [date objectForKey:@"weekday"];
        icon_url = [rslt objectForKey:@"icon_url"];
        low_tempC = [templow objectForKey:@"celsius"];
        hign_tempC = [temphigh objectForKey:@"celsius"];
        low_tempF = [templow objectForKey:@"fahrenheit"];
        hign_tempF = [temphigh objectForKey:@"fahrenheit"];
        condin = [rslt objectForKey:@"conditions"];
        
        //NSLog(@"weekoftheday : %@",weekoftheday);
        //NSLog(@"imageurl : %@",icon_url);
        //NSLog(@"lowTemp : %@",low_temp);
        //NSLog(@"highTemp : %@",hign_temp);
        
        [daylowC addObject:[NSString stringWithFormat:@"%@",low_tempC]];
        [dayimage addObject:[NSString stringWithFormat:@"%@",icon_url]];
        [dayhighC addObject:[NSString stringWithFormat:@"%@",hign_tempC]];
        [dayname addObject:[NSString stringWithFormat:@"%@",weekoftheday]];
        [daylowF addObject:[NSString stringWithFormat:@"%@",low_tempF]];
        [dayhighF addObject:[NSString stringWithFormat:@"%@",hign_tempF]];
        [condi addObject:[NSString stringWithFormat:@"%@",condin]];
        
        //NSLog(@"high ARRAY : %@",dayhigh);
        //NSLog(@"low ARRAY : %@",daylow);
        //NSLog(@"IMAGE ARRAY : %@",dayimage);
        //NSLog(@"weekday ARRAY : %@",dayname);
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellT";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new] ;
    cell.selectedBackgroundView = [UIView new];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dayimage objectAtIndex:indexPath.row]]];
    [cell.conditionImage sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached];
    cell.dayName.text = [NSString stringWithFormat:@"%@",[dayname objectAtIndex:indexPath.row]];
    
    //NSLog(@"NSUSERDEFAULTS CONDITION CHECK : %@",conditionCheck);
    
    if([conditionCheck isEqualToString:@"°C"])
    {
        cell.maxMintemp.text = [NSString stringWithFormat:@"Max :%@    Min :%@",[dayhighC objectAtIndex:indexPath.row],[daylowC objectAtIndex:indexPath.row]];
    }
    else {
        cell.maxMintemp.text = [NSString stringWithFormat:@"Max :%@    Min :%@",[dayhighF objectAtIndex:indexPath.row],[daylowF objectAtIndex:indexPath.row]];
    }
    
    cell.conditions.text = [NSString stringWithFormat:@"%@",[condi objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //// Dispose of any resources that can be recreated.
}



@end
