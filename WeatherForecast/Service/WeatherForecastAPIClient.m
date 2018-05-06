//
//  WeatherForecastAPIClient.m
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import "WeatherForecastAPIClient.h"
#import <AFNetworking/AFNetworking.h>
#import "Forecast.h"
#import "Prefs.h"

NSString* const BASE_URL = @"http://api.wunderground.com/api/";
NSString* const GET_FORECAST_BY_CITY_API = @"%@/forecast/q/%@/%@.json";

@interface WeatherForecastAPIClient()

@property (nonatomic, strong) AFHTTPSessionManager* sessionManager;

@end

@implementation WeatherForecastAPIClient

- (id)init{
    if (self == [super init]){
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    
    return self;
}

+ (id)sharedAPIClient{
    static WeatherForecastAPIClient* sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

- (void)getWeatherForecastByCity:(NSString*)city state:(NSString*)state success:(void(^)(id responseData))success failure:(void(^)(NSError* error))failure{
    //Build API URL
    NSString* stringAPI = [NSString stringWithFormat:GET_FORECAST_BY_CITY_API,FORECAST_API_KEY,state,city];
    NSString* stringAPIEncoded = [stringAPI stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //Call API
    [self.sessionManager GET:stringAPIEncoded parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject){
        NSError* error = nil;
        id forecast = [MTLJSONAdapter modelOfClass:Forecast.class fromJSONDictionary:[responseObject valueForKey:@"forecast"] error:&error];
        
        if (error) {
            //Occur error when do JSON parser to model
            if (failure){
                failure(error);
            }
        }else{
            if (forecast == nil){
                //Analyze error return from server
                NSDictionary* dictError = [responseObject valueForKeyPath:@"response.error"];
                if (dictError){
                    error = [[NSError alloc] initWithDomain:[dictError valueForKey:@"type"]
                                                       code:404
                                                   userInfo:@{NSLocalizedDescriptionKey : [dictError valueForKey:@"description"]}];
                }else{
                    error = [[NSError alloc] initWithDomain:@"No results for this city!"
                                                       code:404
                                                   userInfo:@{NSLocalizedDescriptionKey : @"No results for this city!"}];
                }
                if (error) {
                    if (failure){
                        failure(error);
                    }
                }
            }else{
                //Success
                if (success) {
                    success(forecast);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        if (failure) {
            failure(error);
        }
    }];
}

@end
