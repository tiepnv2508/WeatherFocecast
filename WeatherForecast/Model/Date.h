//
//  Date.h
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Date : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString* pretty;
@property (nonatomic, copy) NSString* weekDay;

@end
