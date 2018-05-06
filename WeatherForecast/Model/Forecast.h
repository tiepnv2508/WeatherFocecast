//
//  Forecast.h
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Forecast : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSArray* forecastDays;

@end
