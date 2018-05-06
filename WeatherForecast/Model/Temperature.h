//
//  Temperature.h
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Temperature : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString* fahrenheit;
@property (nonatomic, copy) NSString* celsius;

@end

