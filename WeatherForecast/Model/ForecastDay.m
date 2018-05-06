//
//  ForecastDay.m
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import "ForecastDay.h"
#import "Temperature.h"
#import "Date.h"

@implementation ForecastDay

+ (NSDictionary*)JSONKeyPathsByPropertyKey{
    return @{
             @"lowTemperature" : @"low",
             @"highTemperature" : @"high",
             @"forecastDate" : @"date",
             @"conditions" : @"conditions",
             @"iconUrl" : @"icon_url"
             };
}

+ (NSValueTransformer*)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"lowTemperature"] || [key isEqualToString:@"highTemperature"]) {
        return [MTLJSONAdapter dictionaryTransformerWithModelClass:Temperature.class];
    } else if ([key isEqualToString:@"forecastDate"]) {
        return [MTLJSONAdapter dictionaryTransformerWithModelClass:Date.class];
    }
    return nil;
}

@end
