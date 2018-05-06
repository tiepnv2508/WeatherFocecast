//
//  WeatherForecastTableViewCell.h
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForecastDay.h"

@interface WeatherForecastTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* lbDate;
@property (nonatomic, weak) IBOutlet UILabel* lbConditions;
@property (nonatomic, weak) IBOutlet UILabel* lbLowTemperature;
@property (nonatomic, weak) IBOutlet UILabel* lbHighTemperature;
@property (nonatomic, weak) IBOutlet UIImageView* iconCondition;
@property (nonatomic, strong) NSString *lowTemp;
@property (nonatomic, strong) NSString *highTemp;

- (void)setForecastDay:(ForecastDay*)forecastDay tempScale:(NSString*)tempScale;

@end
