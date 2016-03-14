//
//  autoSearchtable.h
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 24/02/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface autoSearchtable : UITableViewController
{
    NSString *listPath;
    NSMutableDictionary *dict;
}

@property (nonatomic,strong) NSMutableArray *searchAuto;

@end
