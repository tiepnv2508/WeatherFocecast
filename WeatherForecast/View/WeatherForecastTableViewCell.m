//
//  WeatherForecastTableViewCell.m
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import "WeatherForecastTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Prefs.h"
#import "Date.h"
#import "Temperature.h"

@implementation WeatherForecastTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.lbDate.text = nil;
    self.lbConditions.text = nil;
    self.lbLowTemperature.text = nil;
    self.lbHighTemperature.text = nil;
    self.iconCondition.image = nil;
    self.highTemp = @"";
    self.lowTemp = @"";
}

- (void)setForecastDay:(ForecastDay*)forecastDay tempScale:(NSString*)tempScale {
    self.lbDate.text = forecastDay.forecastDate.weekDay;
    self.lbConditions.text = forecastDay.conditions;
    if ([tempScale isEqualToString:FAHRENHEIT]) {
        self.highTemp = forecastDay.highTemperature.fahrenheit;
        self.lowTemp = forecastDay.lowTemperature.fahrenheit;
    } else {
        self.highTemp = forecastDay.highTemperature.celsius;
        self.lowTemp = forecastDay.lowTemperature.celsius;
    }
    self.lbHighTemperature.text = [NSString stringWithFormat:@"%@%@",self.highTemp,tempScale];
    self.lbLowTemperature.text = [NSString stringWithFormat:@"%@%@",self.lowTemp,tempScale];
    [self.iconCondition sd_setImageWithURL:[NSURL URLWithString:forecastDay.iconUrl]];
}

@end
