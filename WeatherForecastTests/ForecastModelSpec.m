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
@end

@implementation ForecastModelSpec

- (void)spec{
    [super spec];
    
    describe(@"Parsing JSON to model", ^{
        // Success when parse valid model
        context(@"Success", ^{
            it(@"Return valid Forecase object", ^{
                NSError* error;
                NSString* validFile = OHPathForFile(@"valid_model.json", self.class);
                NSData* data = [NSData dataWithContentsOfFile:validFile];
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
                Forecast* forecast = [MTLJSONAdapter modelOfClass:Forecast.class fromJSONDictionary:[dict valueForKey:@"forecast"] error:&error];
                
                expect(error).to(beNil());
                expect(forecast).notTo(beNil());
                expect(forecast.forecastDays.count).to(equal(4));
            });
        });
        
        // Fail when parse invalid model
        context(@"Fail", ^{
            it(@"Return a nil object because parsing invalid model", ^{
                NSError* error;
                NSString* invalidModelFile = OHPathForFile(@"invalid_model.json", self.class);
                NSData* data = [NSData dataWithContentsOfFile:invalidModelFile];
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
                Forecast* forecast = [MTLJSONAdapter modelOfClass:Forecast.class fromJSONDictionary:[dict valueForKey:@"forecast"] error:&error];
                
                expect(forecast).to(beNil());
            });
        });
        
        // Fail when parse invalid format json file
        context(@"Fail", ^{
            it(@"Return an Error because parsing invalid format file", ^{
                NSError* error;
                NSString* invalidFormatFile = OHPathForFile(@"invalid_format.json", self.class);
                NSData* data = [NSData dataWithContentsOfFile:invalidFormatFile];
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
                expect(error).notTo(beNil());
                
                Forecast* forecast = [MTLJSONAdapter modelOfClass:Forecast.class fromJSONDictionary:[dict valueForKey:@"forecast"] error:&error];
                
                expect(forecast).to(beNil());
            });
        });
    });
}

@end
