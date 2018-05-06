//
//  Temperature.m
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import "Temperature.h"

@implementation Temperature

+ (NSDictionary*)JSONKeyPathsByPropertyKey {
    return @{@"fahrenheit" : @"fahrenheit", @"celsius" : @"celsius"};
}

@end
