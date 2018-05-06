//
//  ForecastModelSpec.m
//  WeatherForecastTests
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>

#import "Forecast.h"

@import Quick;
@import Nimble;

@interface ForecastModelSpec: QuickSpec

@property(nonatomic, strong) Forecast* forecast;
@property(nonatomic, strong) NSError* error;

@end

@implementation ForecastModelSpec

- (void)getForecast:(NSString*)jsonFile{
    NSError* err;
    NSString* filePath = OHPathForFile(jsonFile, self.class);
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        self.error = err;
    }
    self.forecast = [MTLJSONAdapter modelOfClass:Forecast.class fromJSONDictionary:[dict valueForKey:@"forecast"] error:&err];
    if (err) {
        self.error = err;
    }
}

- (void)spec{
    [super spec];
    
    __weak typeof(self) weakSelf = self;
    describe(@"Parsing JSON to model", ^{
        beforeEach(^{
            self.forecast = nil;
            self.error = nil;
        });
        
        // Success when parse valid model
        context(@"Success", ^{
            it(@"Return valid Forecase object", ^{
                [weakSelf getForecast:@"valid_model.json"];
                expect(weakSelf.error).to(beNil());
                expect(weakSelf.forecast).notTo(beNil());
                expect(weakSelf.forecast.forecastDays.count).to(equal(4));
            });
        });
        
        // Fail when parse invalid model
        context(@"Fail", ^{
            it(@"Return a nil object because parsing invalid model", ^{
                [self getForecast:@"invalid_model.json"];
                expect(weakSelf.forecast).to(beNil());
            });
        });
        
        // Fail when parse invalid format json file
        context(@"Fail", ^{
            it(@"Return an Error because parsing invalid format file", ^{
                [weakSelf getForecast:@"invalid_format.json"];
                expect(weakSelf.error).notTo(beNil());
                expect(weakSelf.forecast).to(beNil());
            });
        });
    });
}

@end
