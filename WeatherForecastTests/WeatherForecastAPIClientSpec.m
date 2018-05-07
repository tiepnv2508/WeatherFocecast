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

@property(nonatomic, strong) Forecast* forecast;
@property(nonatomic, strong) NSError* error;

@end

@implementation WeatherForecastAPIClientSpec

- (void)getForecast:(NSString*)jsonFile city:(NSString*)city state:(NSString*)state {
    __weak typeof(self) weakSelf = self;
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *stringAPI = [NSString stringWithFormat:GET_FORECAST_BY_CITY_API,FORECAST_API_KEY,state,city];
        return [request.URL.relativePath isEqualToString:stringAPI];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *reques) {
        NSString *fixture = OHPathForFile(jsonFile, weakSelf.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type": @"application/json"}];
    }];
    
    [[WeatherForecastAPIClient sharedInstance] getWeatherForecastByCity:city state:state success:^(id responseData) {
        weakSelf.forecast = responseData;
    } failure:^(NSError *err) {
        weakSelf.error = err;
    }];
}

- (void)spec {
    [super spec];
    
    describe(@"Weather API Client Spec", ^{
        beforeEach(^{
            self.forecast = nil;
            self.error = nil;
        });
        
        afterEach(^{
            [OHHTTPStubs removeAllStubs];
        });
        
        context(@"Call API with correct params", ^{
            it(@"Return a valid Forcecast object", ^{
                [self getForecast:@"seattle_success.json" city:@"Seattle" state:@"Washington"];
                
                expect(self.forecast).toEventuallyNot(beNil());
                expect(self.forecast.forecastDays.count).toEventually(equal(4));
                expect(self.error).toEventually(beNil());
            });
        });
        
        context(@"Call API with incorrect params", ^{
            it(@"Return an error because invalid city name", ^{
                [self getForecast:@"seattl_error.json" city:@"Seattl" state:@"Washington"];
                
                expect(self.forecast).toEventually(beNil());
                expect(self.error).toEventuallyNot(beNil());
            });
        });
    });
}

@end
