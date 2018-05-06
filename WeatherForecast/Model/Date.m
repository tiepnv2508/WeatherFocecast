//
//  Date.m
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import "Date.h"

@implementation Date

+ (NSDictionary*)JSONKeyPathsByPropertyKey {
    return @{@"weekDay" : @"weekday", @"pretty" : @"pretty"};
}

@end
