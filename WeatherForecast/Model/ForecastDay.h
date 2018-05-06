//
//  ForecastDay.h
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import <Mantle/Mantle.h>

@class Temperature;
@class Date;

@interface ForecastDay : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) Date* forecastDate;
@property (nonatomic, copy) NSString* conditions;
@property (nonatomic, copy) NSString* iconUrl;
@property (nonatomic, copy) Temperature* lowTemperature;
@property (nonatomic, copy) Temperature* highTemperature;

@end
