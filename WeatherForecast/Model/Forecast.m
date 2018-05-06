//
//  Forecast.m
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import "Forecast.h"
#import "ForecastDay.h"

@implementation Forecast

+ (NSDictionary*)JSONKeyPathsByPropertyKey{
    return @{@"forecastDays": @"simpleforecast.forecastday"};
}

+ (NSValueTransformer*)JSONTransformerForKey:(NSString *)key {
    if([key isEqualToString:@"forecastDays"]){
        return [MTLJSONAdapter arrayTransformerWithModelClass:ForecastDay.class];
    }
    return nil;
}

@end
