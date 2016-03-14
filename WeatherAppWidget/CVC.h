//
//  CVC.h
//  WeatherFinal
//
//  Created by Mac-Mini-3 on 02/03/16.
//  Copyright © 2016 Mac-Mini-3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVC : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *widgetCollectionTemp;
@property (weak, nonatomic) IBOutlet UIImageView *widgetCollectionImage;
@property (weak, nonatomic) IBOutlet UILabel *widgetCollectionCondition;
@end
