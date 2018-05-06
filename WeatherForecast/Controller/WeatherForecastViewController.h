//
//  WeatherForecastViewController.h
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Forecast.h"
#import "ForecastDay.h"

@interface WeatherForecastViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *smTempScale;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UIPickerView *cityPicker;
@property (nonatomic, weak) IBOutlet UILabel *lbError;
@property (nonatomic, strong) Forecast *forecast;
@property (nonatomic, strong) NSString *selectedState;
@property (nonatomic, strong) NSString *selectedCity;

- (IBAction)segmentDidChange:(id)sender;

@end

