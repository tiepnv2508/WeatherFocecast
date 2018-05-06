//
//  WeatherForecastAPIClient.h
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherForecastAPIClient : NSObject

extern NSString* const BASE_URL;
extern NSString* const GET_FORECAST_BY_CITY_API;

+ (id)sharedAPIClient;

- (void)getWeatherForecastByCity:(NSString*)city state:(NSString*)state success:(void(^)(id responseData))success failure:(void(^)(NSError* error))failure;

@end
