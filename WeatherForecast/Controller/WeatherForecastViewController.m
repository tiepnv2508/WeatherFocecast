//
//  WeatherForecastViewController.m
//  WeatherForecast
//
//  Created by Tiep Nguyen on 5/4/18.
//  Copyright © 2018 Tiep Nguyen. All rights reserved.
//

#import "WeatherForecastViewController.h"
#import "WeatherForecastTableViewCell.h"
#import "WeatherForecastAPIClient.h"
#import "Prefs.h"

@interface WeatherForecastViewController ()

@end

@implementation WeatherForecastViewController{
    NSDictionary *dictStateCity;
    NSArray *arrayStates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //hide empty row in table
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //initialize state and city
    self.selectedCity = @"DETROIT";
    self.selectedState = @"Michigan";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadCityStateData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //Set initial State and City for UIPickerView
    NSArray *arrayCities = dictStateCity[self.selectedState];
    [self.cityPicker selectRow:[arrayStates indexOfObject:self.selectedState] inComponent:0 animated:YES];
    [self.cityPicker selectRow:[arrayCities indexOfObject:self.selectedCity] inComponent:1 animated:YES];
    
    //Get initial Forecast
    [self getForecast];
}

- (void)loadCityStateData{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"StateCity" ofType:@".json"];
    NSData *data = [NSData dataWithContentsOfFile:dataFile];
    NSError *error;
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error){
        NSLog(@"Parse JSON failed: %@",error.localizedDescription);
        return;
    }
    
    arrayStates = [dict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    dictStateCity = dict;
}

- (void)getForecast{
    if (!self.lbError.isHidden){
        [self.lbError setHidden:YES];
    }
    self.forecast = nil;
    [self.tableView reloadData];
    [self.activityIndicatorView startAnimating];
    
    __weak typeof(self) weakSelf = self;
    [[WeatherForecastAPIClient sharedAPIClient] getWeatherForecastByCity:self.selectedCity state:self.selectedState success:^(id responseData){
        weakSelf.forecast = responseData;
        [weakSelf.activityIndicatorView stopAnimating];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error){
        [weakSelf.activityIndicatorView stopAnimating];
        [weakSelf.lbError setText:error.localizedDescription];
        [weakSelf.lbError setHidden:NO];
    }];
}

- (IBAction)btnForecastTapped:(id)sender{
    [self getForecast];
}

#pragma mark UISegmentedControl

- (IBAction)segmentDidChange:(id)sender{
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.forecast.forecastDays.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForecastDay *forecastDay = self.forecast.forecastDays[indexPath.row];
    WeatherForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherForecastTableViewCell" forIndexPath:indexPath];
    
    //Get Temperature Scale type before set Forecast Data to cell
    NSString *tempScale = self.smTempScale.selectedSegmentIndex == 0 ? FAHRENHEIT : CELSIUS;
    
    [cell setForecastDay:forecastDay tempScale:tempScale];
    return cell;
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0){
        return arrayStates.count;
    }else{
        NSArray *arrayCities = dictStateCity[self.selectedState];
        return arrayCities.count;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return arrayStates[row];
    }else{
        return dictStateCity[self.selectedState][row];
    }
}

#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        //Reload City Component when did change State Component
        self.selectedState = arrayStates[row];
        [self.cityPicker reloadComponent:1];
        NSUInteger citySelectedRow = [self.cityPicker selectedRowInComponent:1];
        self.selectedCity = dictStateCity[self.selectedState][citySelectedRow];
    }else{
        self.selectedCity = dictStateCity[self.selectedState][row];
    }
}


@end
