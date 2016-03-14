//
//  SettingsTVC.h
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 29/02/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTVC : UITableViewController
{
    NSMutableIndexSet *expandedSections;
}

@property (weak, nonatomic) IBOutlet UISwitch *switchforTemptoggle;

@property (weak, nonatomic) IBOutlet UILabel *tempMetricSelected;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedMetric;
@property (weak, nonatomic) IBOutlet UILabel *visibilityMetric;
@property (weak, nonatomic) IBOutlet UILabel *precipitaionMetric;
@property (weak, nonatomic) IBOutlet UILabel *pressureMetric;

- (IBAction)toggleSwitch:(id)sender;


@end
