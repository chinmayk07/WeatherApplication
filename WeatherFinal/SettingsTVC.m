//
//  SettingsTVC.m
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 29/02/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import "SettingsTVC.h"

@interface SettingsTVC ()
{
    NSArray *sectionrows, *sectionHeaders;
    NSUserDefaults *defaults;
}

@end

@implementation SettingsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TempMetric settings
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self InitialToggleCheck];
    
    ////collapsing of tables
    sectionrows = [NSArray arrayWithObjects:@"5",@"1", nil];
    self.switchforTemptoggle.selected = false;
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc]init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [sectionrows count];
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
}

- (void)InitialToggleCheck
{
    NSString *onLoadTemp = [defaults objectForKey:@"temp"];
    NSString *onLoadWindSpeed = [defaults objectForKey:@"windSpeed"];
    NSString *onLoadVisibility = [defaults objectForKey:@"visibility"];
    NSString *onLoadPrecipitation = [defaults objectForKey:@"precipitation"];
    NSString *onLoadPressure = [defaults objectForKey:@"pressure"];
    
    //NSLog(@"ON LOAD TOGGLE temp : %@",onLoadTemp);
    //NSLog(@"ON LOAD TOGGLE wind speed : %@",onLoadWindSpeed);
    //NSLog(@"ON LOAD TOGGLE visibility : %@",onLoadVisibility);
    //NSLog(@"ON LOAD TOGGLE precipitation : %@",onLoadPrecipitation);
    //NSLog(@"ON LOAD TOGGLE pressure : %@",onLoadPressure);
    
    if([onLoadTemp isEqualToString:@"°C"])
    {
        self.tempMetricSelected.text = onLoadTemp;
        [self.switchforTemptoggle setOn:YES animated:YES];
    }
    else
    {
        self.tempMetricSelected.text = onLoadTemp;
        [self.switchforTemptoggle setOn:NO animated:YES];
    }
    
    if([onLoadWindSpeed isEqualToString:@"windSpeed"])
    {
        self.windSpeedMetric.text = onLoadWindSpeed;
        [self.switchforSpeedToggle setOn:YES animated:YES];
    }
    else
    {
        self.windSpeedMetric.text = onLoadWindSpeed;
        [self.switchforSpeedToggle setOn:NO animated:YES];
    }
    
    if([onLoadVisibility isEqualToString:@"visibility"])
    {
        self.visibilityMetric.text = onLoadVisibility;
        [self.switchforVisibilityToggle setOn:YES animated:YES];
    }
    else
    {
        self.visibilityMetric.text = onLoadVisibility;
        [self.switchforVisibilityToggle setOn:NO animated:YES];
    }
    
    if([onLoadPrecipitation isEqualToString:@"precipitation"])
    {
        self.precipitaionMetric.text = onLoadPrecipitation;
        [self.switchforPrecipitaionToggle setOn:YES animated:YES];
    }
    else
    {
        self.precipitaionMetric.text = onLoadPrecipitation;
        [self.switchforPrecipitaionToggle setOn:NO animated:YES];
    }
    
    if([onLoadPressure isEqualToString:@"pressure"])
    {
        self.pressureMetric.text = onLoadPressure;
        [self.switchforPressureToggle setOn:YES animated:YES];
    }
    else
    {
        self.pressureMetric.text = onLoadPressure;
        [self.switchforPressureToggle setOn:NO animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            return 5; //inside rows
        }
        return 1; //just show header and first row
    }
    return 5; //return no of rows in section
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            //temp array to store no of rows
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            //condition checking whether rows are expanded or not
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
                [tableView footerViewForSection:indexPath.section].textLabel.text = @"Tap for more options";
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
                [tableView footerViewForSection:indexPath.section].textLabel.text = @"Tap for less options";
            }
        }
    }    
}

- (IBAction)toggleSwitch:(id)sender {
    
    long tagNum = [sender tag];
    NSLog(@"TAGNUM : %ld",tagNum);
    
    switch (tagNum) {
        case 1:
            NSLog(@"TAGNUM inside switch : %ld",tagNum);
            if ([sender isOn]) {
                NSLog(@"Switch is ON");
                self.tempMetricSelected.text = @"°C";
                [defaults setObject:[NSString stringWithFormat:@"°C"] forKey:@"temp"];
                [defaults synchronize];
                NSLog(@"Switch is °C");
            }
            else
            {
                NSLog(@"Switch is OFF");
                self.tempMetricSelected.text = @"°F";
                [defaults setObject:[NSString stringWithFormat:@"°F"] forKey:@"temp"];
                [defaults synchronize];
                NSLog(@"Switch is °F");
            }
            break;
            
        case 2:
            if ([sender isOn]) {
                NSLog(@"Switch is ON");
                self.windSpeedMetric.text = @"kph";
                [defaults setObject:[NSString stringWithFormat:@"kph"] forKey:@"windSpeed"];
                [defaults synchronize];
                NSLog(@"Switch is kph");
            }
            else
            {
                NSLog(@"Switch is OFF");
                self.windSpeedMetric.text = @"mph";
                [defaults setObject:[NSString stringWithFormat:@"mph"] forKey:@"windSpeed"];
                [defaults synchronize];
                NSLog(@"Switch is mph");
            }

            break;
            
        case 3:
            if ([sender isOn]) {
                NSLog(@"Switch is ON");
                self.visibilityMetric.text = @"km";
                [defaults setObject:[NSString stringWithFormat:@"km"] forKey:@"visibility"];
                [defaults synchronize];
                NSLog(@"Switch is km");
            }
            else
            {
                NSLog(@"Switch is OFF");
                self.visibilityMetric.text = @"mtr";
                [defaults setObject:[NSString stringWithFormat:@"mtr"] forKey:@"visibility"];
                [defaults synchronize];
                NSLog(@"Switch is mtr");
            }
            break;
            
        case 4:
            if ([sender isOn]) {
                NSLog(@"Switch is ON");
                self.precipitaionMetric.text = @"in";
                [defaults setObject:[NSString stringWithFormat:@"in"] forKey:@"precipitation"];
                [defaults synchronize];
                NSLog(@"Switch is in");
            }
            else
            {
                NSLog(@"Switch is OFF");
                self.precipitaionMetric.text = @"mm";
                [defaults setObject:[NSString stringWithFormat:@"mm"] forKey:@"precipitation"];
                [defaults synchronize];
                NSLog(@"Switch is mm");
            }

            break;
            
        case 5:
            if ([sender isOn]) {
                NSLog(@"Switch is ON");
                self.pressureMetric.text = @"in";
                [defaults setObject:[NSString stringWithFormat:@"in"] forKey:@"pressure"];
                [defaults synchronize];
                NSLog(@"Switch is in");
            }
            else
            {
                NSLog(@"Switch is OFF");
                self.pressureMetric.text = @"mBar";
                [defaults setObject:[NSString stringWithFormat:@"mBar"] forKey:@"pressure"];
                [defaults synchronize];
                NSLog(@"Switch is mBar");
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)backBarButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
