//
//  RepeatSelectViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/16/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "RepeatSelectViewController.h"
#import "AppDelegate.h"
#import "BDCommon.h"

@interface RepeatSelectViewController ()

@end

@implementation RepeatSelectViewController

@synthesize switchRepeat;
@synthesize pickerView;
@synthesize addViewController;

@synthesize lblTitle;
@synthesize lblOn;
@synthesize lblOff;
@synthesize btnBack;
@synthesize btnRepeat;
@synthesize btnDone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *strRepeat = [addViewController.dicDayInfo objectForKey:@"repeat"];
    if (strRepeat != nil && [strRepeat isEqualToString:@"on"]) {
        [switchRepeat setOn:YES action:NO];
    }
    else {
        [switchRepeat setOn:NO action:NO];
    }
    
    NSString *strTerm = [addViewController.dicDayInfo objectForKey:@"repeatterm"];
    if (strTerm) {
        int nSelected = [strTerm intValue];
        [pickerView selectRow:(nSelected - 1) inComponent:0 animated:NO];
    }
    NSString *strUnit = [addViewController.dicDayInfo objectForKey:@"repeatunit"];
    if (strUnit) {
        int nSelected = 0;
        if ([strUnit isEqualToString:@"Secs"]) {
            nSelected = 0;
        }
        else if ([strUnit isEqualToString:@"Mins"]) {
            nSelected = 1;
        }
        else if ([strUnit isEqualToString:@"Hours"]) {
            nSelected = 2;
        }
        else if ([strUnit isEqualToString:@"Days"]) {
            nSelected = 3;
        }
        else if ([strUnit isEqualToString:@"Months"]) {
            nSelected = 4;
        }
        else if ([strUnit isEqualToString:@"Years"]) {
            nSelected = 5;
        }
        [pickerView selectRow:nSelected inComponent:1 animated:NO];
    }
    
    lblTitle.text = NSLocalizedString(@"Repeating", nil);
    lblTitle.font = TITLE_FONT;
    
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    btnBack.titleLabel.font = SMALL_BUTTON_FONT;
    btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.5, 8, 0, 0);
    
    [btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    btnDone.titleLabel.font = SMALL_BUTTON_FONT;
    btnDone.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnDone.titleEdgeInsets = UIEdgeInsetsMake(9.5, 0, 0, 0);
    
    lblOn.text = NSLocalizedString(@"On", nil);
    lblOn.font = [UIFont fontWithName:FONT_SEMIBOLD size:13.0];
    
    lblOff.text = NSLocalizedString(@"Off", nil);
    lblOff.font = [UIFont fontWithName:FONT_SEMIBOLD size:13.0];
    
    [btnRepeat setTitle:NSLocalizedString(@"Repeat", nil) forState:UIControlStateNormal];
    btnRepeat.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnRepeat.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnRepeat.titleEdgeInsets = UIEdgeInsetsMake(8, 6, 0, 0);
    
    isTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender
{
    [APP_DELEGATE.viewController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    if (switchRepeat.on) {
        [addViewController.dicDayInfo setObject:@"on" forKey:@"repeat"];
        int nSelected = [pickerView selectedRowInComponent:0];
        [addViewController.dicDayInfo setObject:[NSString stringWithFormat:@"%d", nSelected + 1] forKey:@"repeatterm"];
        
        nSelected = [pickerView selectedRowInComponent:1];
        NSString *strUnit;
        switch (nSelected) {
            case 0:
                strUnit = @"Secs";
                break;
            case 1:
                strUnit = @"Mins";
                break;
            case 2:
                strUnit = @"Hours";
                break;
            case 3:
                strUnit = @"Days";
                break;
            case 4:
                strUnit = @"Months";
                break;
            case 5:
                strUnit = @"Years";
                break;
            default:
                break;
        }
        [addViewController.dicDayInfo setObject:strUnit forKey:@"repeatunit"];
    }
    else {
        [addViewController.dicDayInfo setObject:@"off" forKey:@"repeat"];
    }
    [APP_DELEGATE.viewController.navigationController popViewControllerAnimated:YES];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 60;
    }
    else {
        return 6;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%d", row + 1];
    }
    else {
        NSString *strUnit;
        switch (row) {
            case 0:
                strUnit = @"Secs";
                break;
            case 1:
                strUnit = @"Mins";
                break;
            case 2:
                strUnit = @"Hours";
                break;
            case 3:
                strUnit = @"Days";
                break;
            case 4:
                strUnit = @"Months";
                break;
            case 5:
                strUnit = @"Years";
                break;
            default:
                break;
        }
        return NSLocalizedString(strUnit, nil);
    }
}

@end
