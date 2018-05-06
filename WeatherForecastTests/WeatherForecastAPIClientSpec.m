//
//  WeatherForecastAPIClientSpec.m
//  WeatherForecastTests
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>

#import "WeatherForecastAPIClient.h"
#import "Forecast.h"
#import "Prefs.h"

@import Quick;
@import Nimble;

@interface WeatherForecastAPIClientSpec: QuickSpec
@end

@implementation WeatherForecastAPIClientSpec

- (void)spec{
    [super spec];
    
    //Success when test an success json file.
    context(@"Success", ^{
        __block Forecast* forecast = nil;
        __block NSError* error = nil;
        NSString* state = @"WA";
        NSString* city = @"Seattle";
        
        it(@"Return a valid Forcecast object", ^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
                NSString *stringAPI = [NSString stringWithFormat:GET_FORECAST_BY_CITY_API,FORECAST_API_KEY,state,city];
                return [request.URL.relativePath isEqualToString:stringAPI];
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *reques){
                NSString *fixture = OHPathForFile(@"seattle_success.json", self.class);
                return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type": @"application/json"}];
            }];
            
            [[WeatherForecastAPIClient sharedAPIClient] getWeatherForecastByCity:city state:state success:^(id responseData){
                forecast = responseData;
            } failure:^(NSError *err){
                error = err;
            }];
            
            expect(forecast).toEventuallyNot(beNil());
            expect(forecast.forecastDays.count).toEventually(equal(4));
            expect(error).toEventually(beNil());
        });
    });
    
    //Fail when test an error json file
    context(@"Fail", ^{
        __block Forecast* forecast = nil;
        __block NSError* error = nil;
        NSString* state = @"WA";
        NSString* city = @"Seattl";
        it(@"Return an error because invalid city name", ^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
                NSString *stringAPI = [NSString stringWithFormat:GET_FORECAST_BY_CITY_API,FORECAST_API_KEY,state,city];
                return [request.URL.relativePath isEqualToString:stringAPI];
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *reques){
                NSString *fixture = OHPathForFile(@"seattl_error.json", self.class);
                return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type": @"application/json"}];
            }];
            
            [[WeatherForecastAPIClient sharedAPIClient] getWeatherForecastByCity:city state:state success:^(id responseData){
                forecast = responseData;
            } failure:^(NSError *err){
                error = err;
            }];
            
            expect(forecast).toEventually(beNil());
            expect(error).toEventuallyNot(beNil());
        });
    });
}

@end
