//
//  AddDaysViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/1/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "AddDaysViewController.h"
#import "AppDelegate.h"
#import "ImageSelectViewController.h"
#import "RepeatSelectViewController.h"
#import "AlertSettingViewController.h"
#import "Flurry.h"
#import "BDCommon.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < 50 )

@interface AddDaysViewController ()
{
    
}

@end

@implementation AddDaysViewController

@synthesize dicDayInfo;
@synthesize m_dayDate;
@synthesize m_timeDate;

@synthesize lblDate;
@synthesize lblName;
@synthesize lblEditName;
@synthesize lblTitleName;
@synthesize lblRepeat;
@synthesize lblTime;
@synthesize btnBack;
@synthesize btnDone;
@synthesize btnName;
@synthesize btnRepeat;
@synthesize btnAlert;
@synthesize btnDelete;
@synthesize lblButtonDate;
@synthesize lblButtonTime;
@synthesize lblButtonImage;

@synthesize ivBg;

@synthesize viewName;
@synthesize tfName;
@synthesize inputFieldBg;
@synthesize btnEditCancel;
@synthesize btnEditDone;

//Select Date
@synthesize viewDate;
@synthesize lblSelectDate;
@synthesize lblSelectTime;
@synthesize datepicker;
@synthesize btnDateCancel;
@synthesize btnDateDone;
@synthesize btnDateDate;
@synthesize btnDateTime;
@synthesize lblDateTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"AddDaysViewController_iphone5" bundle:nibBundleOrNil];
    }
    else {
        self = [super initWithNibName:@"AddDaysViewController" bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIFont *font = [UIFont fontWithName:@"MyriadPro-Black" size:27];
    [lblEditName setFont:font];
    [lblTitleName setFont:font];
    
    if (dicDayInfo == nil) {
        
        nDayIndex = -1;
        
        dicDayInfo = [NSMutableDictionary dictionary];

        //Repeat
        [dicDayInfo setObject:@"off" forKey:@"repeat"];
        [dicDayInfo setObject:@"1" forKey:@"repeatterm"];
        [dicDayInfo setObject:@"Years" forKey:@"repeatunit"];
        //[dicDayInfo setObject:@"off" forKey:@"alert"];
        
        [dicDayInfo setObject:@"0" forKey:@"alertterm0"];
        [dicDayInfo setObject:@"Mins" forKey:@"alertunit0"];
        [dicDayInfo setObject:@"off" forKey:@"alertonoff0"];
        
        [dicDayInfo setObject:@"0" forKey:@"alertterm1"];
        [dicDayInfo setObject:@"Mins" forKey:@"alertunit1"];
        [dicDayInfo setObject:@"off" forKey:@"alertonoff1"];
        
        [dicDayInfo setObject:@"0" forKey:@"alertterm2"];
        [dicDayInfo setObject:@"Mins" forKey:@"alertunit2"];
        [dicDayInfo setObject:@"off" forKey:@"alertonoff2"];
        
        [dicDayInfo setObject:@"0" forKey:@"alertterm3"];
        [dicDayInfo setObject:@"Mins" forKey:@"alertunit3"];
        [dicDayInfo setObject:@"off" forKey:@"alertonoff3"];
        
        [dicDayInfo setObject:@"0" forKey:@"alertterm4"];
        [dicDayInfo setObject:@"Mins" forKey:@"alertunit4"];
        [dicDayInfo setObject:@"off" forKey:@"alertonoff4"];
        
        //ImageData
        UIImage *image = [UIImage imageNamed:@"default10.jpg"];
        NSData *imageData = nil;
        if (image) {
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        [dicDayInfo setObject:imageData forKey:@"imagedata"];
    }
    
    if (nDayIndex < 0) {
        btnDelete.hidden = YES;
        btnBack.hidden = YES;
    }
    
    NSString *strName = [dicDayInfo objectForKey:@"name"];
    if (strName) {
        lblName.text = strName;
        lblTitleName.text = strName;
    }
    else {
        lblName.text = @"";
        lblTitleName.text = @"";
    }
    
    keyboardVisible = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doViewWillAppear:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self.datepicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    //[self.switchRepeat addTarget:self action:@selector(repeatChanged:) forControlEvents:UIControlEventValueChanged];
    //[self.switchAlert addTarget:self action:@selector(alertChanged:) forControlEvents:UIControlEventValueChanged];
    
    datepicker.datePickerMode = UIDatePickerModeDate;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSString *strDate = [dicDayInfo objectForKey:@"targetdate"];
    NSString *strTime = [dicDayInfo objectForKey:@"targettime"];
    
    if (strDate && strTime) {
        [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
        NSLocale *currentLocale = dateFormat.locale;
        NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strTime]];
        if (date == nil)
        {
            dateFormat.locale = ENGLISH_LOCALE;
            NSString *stringDate = [NSString stringWithFormat:@"%@ %@", strDate, strTime];
            date = [dateFormat dateFromString:stringDate];
            if (date == nil)
                date = [APP_DELEGATE correctDate:stringDate];
        }
        dateFormat.locale = currentLocale;
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        lblDate.text = [dateFormat stringFromDate:date];
        [dateFormat setDateFormat:@"hh:mm a"];
        lblTime.text = [dateFormat stringFromDate:date];
        
        //NSDate *date = [dicDayInfo objectForKey:@"targetdatetime"];
        if (date == nil)
            date = [NSDate date];

        [datepicker setDate:date];
    }
    
    // For Button Labels
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    btnBack.titleLabel.font = SMALL_BUTTON_FONT;
    btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.5, 8, 0, 0);
    
    [btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    btnDone.titleLabel.font = SMALL_BUTTON_FONT;
    btnDone.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnDone.titleEdgeInsets = UIEdgeInsetsMake(9.5, 0, 0, 0);
    
    [btnName setTitle:NSLocalizedString(@"Name", nil) forState:UIControlStateNormal];
    btnName.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnName.titleEdgeInsets = UIEdgeInsetsMake(8, 9, 0, 0);
    
    [btnRepeat setTitle:NSLocalizedString(@"Repeat", nil) forState:UIControlStateNormal];
    btnRepeat.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnRepeat.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnRepeat.titleEdgeInsets = UIEdgeInsetsMake(8, 9, 0, 0);
    
    [btnAlert setTitle:NSLocalizedString(@"Alert", nil) forState:UIControlStateNormal];
    btnAlert.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnAlert.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnAlert.titleEdgeInsets = UIEdgeInsetsMake(8, 9, 0, 0);
    
    [btnDelete setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    btnDelete.titleLabel.font = [UIFont fontWithName:FONT_SEMIBOLD size:21.0];
    btnDelete.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnDelete.titleEdgeInsets = UIEdgeInsetsMake(12, 0, 0, 0);
    
    lblName.font = [UIFont fontWithName:FONT_SEMIBOLD size:17.0];
    lblDate.font = [UIFont fontWithName:FONT_SEMIBOLD size:17.0];
    lblTime.font = [UIFont fontWithName:FONT_SEMIBOLD size:17.0];
    lblRepeat.font = [UIFont fontWithName:FONT_SEMIBOLD size:17.0];
    
    lblButtonDate.text = NSLocalizedString(@"Date", nil);
    lblButtonDate.font = MIDDLE_BUTTON_FONT;
    
    lblButtonTime.text = NSLocalizedString(@"Time", nil);
    lblButtonTime.font = MIDDLE_BUTTON_FONT;
    
    lblButtonImage.text = NSLocalizedString(@"Image", nil);
    lblButtonImage.font = MIDDLE_BUTTON_FONT;
    
    lblDateTitle.font = TITLE_FONT;
    lblDateTitle.text = NSLocalizedString(@"Date", nil);
    
    [self didEndAnimation];
    
    [btnDateDate setTitle:NSLocalizedString(@"Date", nil) forState:UIControlStateNormal];
    btnDateDate.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnDateDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnDateDate.titleEdgeInsets = UIEdgeInsetsMake(9, 9, 0, 0);
    
    [btnDateTime setTitle:NSLocalizedString(@"Time", nil) forState:UIControlStateNormal];
    btnDateTime.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnDateTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnDateTime.titleEdgeInsets = UIEdgeInsetsMake(8, 9, 0, 0);
    
    lblSelectDate.font = MIDDLE_LABEL_FONT;
    lblSelectTime.font = MIDDLE_LABEL_FONT;
    
    //datepicker.locale = DEVICE_LOCALE;
}

- (void) setDayIndex:(int)nIndex
{
    nDayIndex = nIndex;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doViewWillAppear: (NSNotification *)notif
{
    if (nDayIndex >= 0) {
        NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
        NSData *data = [archive objectForKey:[NSString stringWithFormat:@"dayinfo_%d", nDayIndex]];
        if (data) {
            dicDayInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            NSString *strDate = [dicDayInfo objectForKey:@"targetdate"];
            NSString *strTime = [dicDayInfo objectForKey:@"targettime"];
            
            if (strDate && strTime) {
                [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
                NSLocale *currentLocale = dateFormat.locale;
                NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strTime]];
                if (date == nil)
                {
                    dateFormat.locale = ENGLISH_LOCALE;
                    NSString *stringDate = [NSString stringWithFormat:@"%@ %@", strDate, strTime];
                    date = [dateFormat dateFromString:stringDate];
                    if (date == nil)
                        date = [APP_DELEGATE correctDate:stringDate];
                }
                //dateFormat.locale = DEVICE_LOCALE;
                dateFormat.locale = currentLocale;
                [dateFormat setDateFormat:@"MMM dd, yyyy"];
                lblDate.text = [dateFormat stringFromDate:date];
                [dateFormat setDateFormat:@"hh:mm a"];
                lblTime.text = [dateFormat stringFromDate:date];
                //NSDate *date = [dicDayInfo objectForKey:@"targetdatetime"];
                if (date == nil)
                    date = [NSDate date];
                
                [datepicker setDate:date];
            }
        }
    }

    [self initViewWillAppear];
}

- (void) initViewWillAppear
{
    if (dicDayInfo) {
        UIImage * image = [UIImage imageWithData:[dicDayInfo objectForKey:@"imagedata"]];
        if (image) {
            float fWidth = image.size.width;
            float fHeight = image.size.height;
            if (fWidth > fHeight) {
                fWidth = 47 * fWidth / fHeight;
                fHeight = 47;
            }
            else {
                fHeight = 47 * fHeight / fWidth;
                fWidth = 47;
            }
            self.ivBg.image = [self imageWithImage:image scaledToSize:CGSizeMake(fWidth, fHeight)];
        }
        else {
            self.ivBg.image = nil;
        }
        
        NSString *strRepeat = [dicDayInfo objectForKey:@"repeat"];
        if (strRepeat != nil && [strRepeat isEqualToString:@"on"]) {
            
            NSString *strTerm = [dicDayInfo objectForKey:@"repeatterm"];
            if ([strTerm intValue] <= 1) {
                NSString *strUnit = [dicDayInfo objectForKey:@"repeatunit"];
                strUnit = [strUnit substringToIndex:strUnit.length - 1];
                lblRepeat.text = [NSString stringWithFormat:@"Every %@", NSLocalizedString(strUnit, nil)];
            }
            else {
                lblRepeat.text = [NSString stringWithFormat:@"%@ %@", strTerm, NSLocalizedString([dicDayInfo objectForKey:@"repeatunit"], nil)];
            }
        }
        else {
            lblRepeat.text = @"";
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self initViewWillAppear];
    
    isOnFullScreen = NO;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) keyboardWillShow: (NSNotification *)notif {
    if (keyboardVisible) {
        return;
    }
    
    NSDictionary *info = [notif userInfo];
    NSValue * aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = inputFieldBg.frame;
    frame.origin.x = 0;
    
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        frame.origin.y = screenHeight - frame.size.height - (keyboardSize.height) - 20;
    else
        frame.origin.y = screenHeight - frame.size.height - (keyboardSize.height) - 20;
    inputFieldBg.frame = frame;
    
    frame = tfName.frame;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        frame.origin.y = screenHeight - frame.size.height - (keyboardSize.height) - 20 - 5;
    else
        frame.origin.y = screenHeight - frame.size.height - (keyboardSize.height) - 20 - 5;
    tfName.frame = frame;
    
    keyboardVisible = YES;
    [UIView commitAnimations];
}

- (void) keyboardWillHide: (NSNotification *) notif {
    //NSLog(@"Received Notification");
    
    if (!keyboardVisible) {
        return;
    }
    
    NSDictionary * info = [notif userInfo];
    
    NSValue * aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = inputFieldBg.frame;
    frame.origin.x = 0;
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation))
        frame.origin.y = frame.origin.y + (keyboardSize.height);
    else
        frame.origin.y = frame.origin.y + (keyboardSize.width);
    inputFieldBg.frame = frame;
    
    frame = tfName.frame;
    
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation))
        frame.origin.y = frame.origin.y + (keyboardSize.height);
    else
        frame.origin.y = frame.origin.y + (keyboardSize.width);
    tfName.frame = frame;
    
    keyboardVisible = NO;
    [UIView commitAnimations];
}

- (void)didEndAnimation
{
    [btnEditCancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    btnEditCancel.titleLabel.font = SMALL_BUTTON_FONT;
    btnEditCancel.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnEditCancel.titleEdgeInsets = UIEdgeInsetsMake(9.5, 0, 0, 0);
    
    [btnEditDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    btnEditDone.titleLabel.font = SMALL_BUTTON_FONT;
    btnEditDone.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnEditDone.titleEdgeInsets = UIEdgeInsetsMake(9.5, 0, 0, 0);
    
    [btnDateCancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    btnDateCancel.titleLabel.font = SMALL_BUTTON_FONT;
    btnDateCancel.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnDateCancel.titleEdgeInsets = UIEdgeInsetsMake(9.5, 0, 0, 0);
    
    [btnDateDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    btnDateDone.titleLabel.font = SMALL_BUTTON_FONT;
    btnDateDone.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnDateDone.titleEdgeInsets = UIEdgeInsetsMake(9.5, 0, 0, 0);
}

- (IBAction)onSelectName:(id)sender
{
    tfName.text = @"";
    CGRect rctFrame = self.viewName.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.viewName.frame = rctFrame;
    self.lblEditName.text = lblName.text;
    [APP_DELEGATE.viewController.view addSubview:self.viewName];
    
    [UIView beginAnimations:@"EditName" context:nil];
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didEndAnimation)];
    //[UIView setAnimationWillStartSelector:@selector(animationWillStart:finished:context:)];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        rctFrame.origin = CGPointMake(0, 20);
    else
        rctFrame.origin = CGPointMake(0, 0);
    self.viewName.frame = rctFrame;
    
    [UIView commitAnimations];
    
    [self.tfName becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    lblName.text = newString;
    lblTitleName.text = newString;
    lblEditName.text = newString;
    return YES;
}

- (IBAction)onSelectDate:(id)sender
{
    datepicker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //dateFormat.locale = ENGLISH_LOCALE;
    //dateFormat.locale = DEVICE_LOCALE;
    //[dateFormat setDateStyle:NSDateFormatterLongStyle];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    NSString *strDate = [dateFormat stringFromDate:datepicker.date];
    self.m_dayDate = datepicker.date;
    
    lblSelectDate.text = strDate;
    strDate = lblSelectDate.text;
    
    [dateFormat setDateFormat:@"hh:mm a"];
    NSString *strTime = [dateFormat stringFromDate:datepicker.date];
    lblSelectTime.text = strTime;
    self.m_timeDate = datepicker.date;
    
    CGRect rctFrame = self.viewDate.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.viewDate.frame = rctFrame;
    [APP_DELEGATE.viewController.view addSubview:self.viewDate];
    
    [UIView beginAnimations:@"EditDate" context:nil];
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didEndAnimation)];
    //[UIView setAnimationWillStartSelector:@selector(animationWillStart:finished:context:)];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        rctFrame.origin = CGPointMake(0, 20);
    else
        rctFrame.origin = CGPointMake(0, 0);
    self.viewDate.frame = rctFrame;
    
    [UIView commitAnimations];
}

- (IBAction)onCancelEditName:(id)sender
{
    NSString *strName = [dicDayInfo objectForKey:@"name"];
    if (strName) {
        lblName.text = strName;
        lblTitleName.text = strName;
    }
    else {
        lblName.text = @"";
        lblTitleName.text = @"";
    }
    [UIView beginAnimations:@"EditName" context:nil];
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGRect rctFrame = self.viewName.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.viewName.frame = rctFrame;
    
    [UIView commitAnimations];
    [self.tfName resignFirstResponder];
}

- (IBAction)onDoneEditName:(id)sender
{
    lblName.text = tfName.text;
    lblTitleName.text = tfName.text;
    [dicDayInfo setObject:tfName.text forKey:@"name"];
    
    [UIView beginAnimations:@"EditName" context:nil];
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGRect rctFrame = self.viewName.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.viewName.frame = rctFrame;
    
    [UIView commitAnimations];
    [self.tfName resignFirstResponder];
}

/*- (void)animationWillStart:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"EditName"]) {
        [self.tfName becomeFirstResponder];
    }
}*/

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"EditName"]) {
        [self.viewName removeFromSuperview];
    }
    else if ([animationID isEqualToString:@"EditDate"]) {
        [self.viewDate removeFromSuperview];
    }
}

- (IBAction)onCancelSelectDate:(id)sender
{
    [UIView beginAnimations:@"EditDate" context:nil];
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGRect rctFrame = self.viewDate.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.viewDate.frame = rctFrame;
    
    [UIView commitAnimations];
}

- (IBAction)onDoneSelectDate:(id)sender
{
    lblDate.text = lblSelectDate.text;
    lblTime.text = lblSelectTime.text;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = ENGLISH_LOCALE;
    
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    NSString *strDate = [dateFormat stringFromDate:m_dayDate];
    [dateFormat setDateFormat:@"hh:mm a"];
    NSString *strTime = [dateFormat stringFromDate:m_timeDate];
    
    /*
    [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
    NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strTime]];
    dateFormat.locale = ENGLISH_LOCALE;
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    strDate = [dateFormat stringFromDate:date];
    [dateFormat setDateFormat:@"hh:mm a"];
    strTime = [dateFormat stringFromDate:date];
    */
    
    [dicDayInfo setObject:strDate forKey:@"targetdate"];
    [dicDayInfo setObject:strTime forKey:@"targettime"];
    
    [dicDayInfo setObject:self.datepicker.date forKey:@"targetdatetime"];

    [UIView beginAnimations:@"EditDate" context:nil];
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGRect rctFrame = self.viewDate.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.viewDate.frame = rctFrame;
    
    [UIView commitAnimations];
}

- (IBAction)onSetModeDate:(id)sender
{
    datepicker.datePickerMode = UIDatePickerModeDate;
}

- (IBAction)onSetModeTime:(id)sender
{
    datepicker.datePickerMode = UIDatePickerModeTime;
}

- (void) dateChanged:(id)sender {
    if (datepicker.datePickerMode == UIDatePickerModeDate) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //dateFormat.locale = ENGLISH_LOCALE;
        //dateFormat.locale = DEVICE_LOCALE;
        //[dateFormat setDateStyle:NSDateFormatterLongStyle];
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        NSString *strDate = [dateFormat stringFromDate:datepicker.date];
        lblSelectDate.text = strDate;
        strDate = lblSelectDate.text;
        self.m_dayDate = datepicker.date;
    }
    else if (datepicker.datePickerMode == UIDatePickerModeTime) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //dateFormat.locale = ENGLISH_LOCALE;
        //dateFormat.locale = DEVICE_LOCALE;
        [dateFormat setDateFormat:@"hh:mm a"];
        NSString *strTime = [dateFormat stringFromDate:datepicker.date];
        lblSelectTime.text = strTime;
        self.m_timeDate = datepicker.date;
    }
}

- (IBAction)onSelectImage:(id)sender
{
    ImageSelectViewController *viewController = [ImageSelectViewController new];
    viewController.addViewController = self;
    [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onSelectRepeat:(id)sender
{
    RepeatSelectViewController *viewController = [RepeatSelectViewController new];
    viewController.addViewController = self;
    [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
}

/*- (IBAction) repeatChanged:(id)sender {
    if (switchRepeat.on && !switchRepeat.hidden) {
        RepeatSelectViewController *viewController = [RepeatSelectViewController new];
        viewController.addViewController = self;
        [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction) alertChanged:(id)sender {
    if (switchAlert.on) {
        [dicDayInfo setObject:@"on" forKey:@"alert"];
    }
    else {
        [dicDayInfo setObject:@"off" forKey:@"alert"];
    }
}*/

- (IBAction)onAlertSetting:(id)sender
{
    AlertSettingViewController *viewController = [AlertSettingViewController new];
    viewController.addViewController = self;
    [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onDoneDayInfo:(id)sender
{
    if (dicDayInfo == nil) {
        return;
    }
    
    NSString *strName = [dicDayInfo objectForKey:@"name"];
    if (strName == nil || strName.length == 0) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please input Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        return;
    }
    
    NSString *strDate = [dicDayInfo objectForKey:@"targetdate"];
    NSString *strTime = [dicDayInfo objectForKey:@"targettime"];
    if (strDate == nil || strTime == nil || strDate.length == 0 || strTime.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please select Target Date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }

    /*
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
    
    NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strTime]];
     if (date == nil)
     {
         dateFormat.locale = ENGLISH_LOCALE;
         date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strTime]];
     }
    
    if ([date compare:[NSDate date]] != NSOrderedDescending) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Date and Time must be after current Date and Time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    */
    
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    if (nDayIndex >= 0) {
        //Modify Day Info
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dicDayInfo];
        [archive setObject:data forKey:[NSString stringWithFormat:@"dayinfo_%d", nDayIndex]];
        
        [archive synchronize];
        
        [self setLocalNotifications];
        
        [self.navigationController popViewControllerAnimated:YES];
        [Flurry logEvent:@"BigDay Modified"];
        return;
    }
    else {
        //Add new Day
        NSString *strCount = [archive objectForKey:@"dayscount"];
        int nCount = 0;
        if (strCount) {
            nCount = [strCount intValue];
        }
        nCount++;
        
        [archive setObject:[NSString stringWithFormat:@"%d", nCount] forKey:@"dayscount"];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dicDayInfo];
        [archive setObject:data forKey:[NSString stringWithFormat:@"dayinfo_%d", nCount - 1]];
        
        [archive synchronize];
    }
    
    [self setLocalNotifications];
    
    [Flurry logEvent:@"New BigDay Added"];
    
    [self clearData];
    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Successfully Done", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    successAlert.tag = 100;
    [successAlert show];
}

- (void)clearData
{
    nDayIndex = -1;
    dicDayInfo = nil;
    dicDayInfo = [NSMutableDictionary dictionary];
    
    //Repeat
    [dicDayInfo setObject:@"off" forKey:@"repeat"];
    [dicDayInfo setObject:@"1" forKey:@"repeatterm"];
    [dicDayInfo setObject:@"Years" forKey:@"repeatunit"];
    //[dicDayInfo setObject:@"off" forKey:@"alert"];
    
    [dicDayInfo setObject:@"0" forKey:@"alertterm0"];
    [dicDayInfo setObject:@"Mins" forKey:@"alertunit0"];
    [dicDayInfo setObject:@"off" forKey:@"alertonoff0"];
    
    [dicDayInfo setObject:@"0" forKey:@"alertterm1"];
    [dicDayInfo setObject:@"Mins" forKey:@"alertunit1"];
    [dicDayInfo setObject:@"off" forKey:@"alertonoff1"];
    
    [dicDayInfo setObject:@"0" forKey:@"alertterm2"];
    [dicDayInfo setObject:@"Mins" forKey:@"alertunit2"];
    [dicDayInfo setObject:@"off" forKey:@"alertonoff2"];
    
    [dicDayInfo setObject:@"0" forKey:@"alertterm3"];
    [dicDayInfo setObject:@"Mins" forKey:@"alertunit3"];
    [dicDayInfo setObject:@"off" forKey:@"alertonoff3"];
    
    [dicDayInfo setObject:@"0" forKey:@"alertterm4"];
    [dicDayInfo setObject:@"Mins" forKey:@"alertunit4"];
    [dicDayInfo setObject:@"off" forKey:@"alertonoff4"];
    
    //ImageData
    UIImage *image = [UIImage imageNamed:@"default10.jpg"];
    NSData *imageData = nil;
    if (image) {
        imageData = UIImageJPEGRepresentation(image, 0);
    }
    [dicDayInfo setObject:imageData forKey:@"imagedata"];
    
    lblName.text = @"";
    lblTitleName.text = @"";
    
    datepicker.datePickerMode = UIDatePickerModeDate;
    [datepicker setDate:[NSDate date]];
    
    lblDate.text = @"";
    lblTime.text = @"";
    
    [self initViewWillAppear];
}

- (IBAction)onBackDayInfo:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDeleteDayInfo:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Do you really want to delete this?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        [APP_DELEGATE.viewController setSelectedIndex:0];
        [(UINavigationController *)APP_DELEGATE.viewController.selectedViewController popToRootViewControllerAnimated:YES];
    }
    else if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self deleteDayInfo];
        [Flurry logEvent:@"BigDay Delete"];
    }
}

- (void) deleteDayInfo {
    //Delete Day Info
    if (nDayIndex >= 0) {
        NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
        NSString *strCount = [archive objectForKey:@"dayscount"];
        int nCount = 0;
        if (strCount) {
            nCount = [strCount intValue];
        }
        if (nCount <= 0) {
            return;
        }
        nCount--;
        
        [archive setObject:[NSString stringWithFormat:@"%d", nCount] forKey:@"dayscount"];
        
        NSData *data = nil;//[NSKeyedArchiver archivedDataWithRootObject:dicDayInfo];
        for (int i = nDayIndex; i < nCount; ++i) {
            data = [archive objectForKey:[NSString stringWithFormat:@"dayinfo_%d", i + 1]];
            [archive setObject:data forKey:[NSString stringWithFormat:@"dayinfo_%d", i]];
        }
        [archive setObject:nil forKey:[NSString stringWithFormat:@"dayinfo_%d", nCount]];
        
        [archive synchronize];
        
        [self setLocalNotifications];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSString *strCount = [archive objectForKey:@"dayscount"];
    int nCount = 0;
    if (strCount) {
        nCount = [strCount intValue];
    }
    if (nCount <= 0) {
        return;
    }
    
    UILocalNotification *notification;
    
    for (int i = 0; i < nCount; ++i) {
        NSData *data = [archive objectForKey:[NSString stringWithFormat:@"dayinfo_%d", i]];
        NSMutableDictionary *dayinfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSString *strDate = [dayinfo objectForKey:@"targetdate"];
        NSString *strTime = [dayinfo objectForKey:@"targettime"];
        
        if (strDate && strTime) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            //dateFormat.locale = DEVICE_LOCALE;
            [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
            
            NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strTime]];
            if (date == nil)
            {
                dateFormat.locale = ENGLISH_LOCALE;
                NSString *stringDate = [NSString stringWithFormat:@"%@ %@", strDate, strTime];
                date = [dateFormat dateFromString:stringDate];
                if (date == nil)
                    date = [APP_DELEGATE correctDate:stringDate];
            }
            //date = [dicDayInfo objectForKey:@"targetdatetime"];
            if (date == nil)
                date = [NSDate date];

            NSDate *currentDate = [NSDate date];
            
            if ([date compare:currentDate] == NSOrderedDescending) {
                NSDate *alertDate = nil;
                
                for (int j = 0; j < 5; ++j) {
                    NSString *strValue = [dayinfo objectForKey:[NSString stringWithFormat:@"alertonoff%d", j]];
                    if ([strValue isEqualToString:@"on"]) {
                        NSString *strTerm = [dayinfo objectForKey:[NSString stringWithFormat:@"alertterm%d", j]];
                        NSString *strUnit = [dayinfo objectForKey:[NSString stringWithFormat:@"alertunit%d", j]];
                        
                        NSString *strTime = [NSString stringWithFormat:@"%@ %@", strTerm, strUnit];
                        BOOL bExist = NO;
                        
                        for (int k = 0; k < j; ++k) {
                            NSString *strTermBefore = [dayinfo objectForKey:[NSString stringWithFormat:@"alertterm%d", k]];
                            NSString *strUnitBefore = [dayinfo objectForKey:[NSString stringWithFormat:@"alertunit%d", k]];
                            
                            NSString *strTimeBefore = [NSString stringWithFormat:@"%@ %@", strTermBefore, strUnitBefore];
                            
                            if ([strTime isEqualToString:strTimeBefore]) {
                                bExist = YES;
                                break;
                            }
                        }
                        
                        if (!bExist && ![strTerm isEqualToString:@"0"])
                        {
                            
                            alertDate = [self getAlertDate:date AlertTerm:strTerm AlertUnit:strUnit];
                            
                            if ([alertDate compare:currentDate] == NSOrderedDescending) {
                                notification = [UILocalNotification new];
                                notification.fireDate = alertDate;
                                notification.alertBody = [NSString stringWithFormat:@"%@ is coming in %@ %@!", [dayinfo objectForKey:@"name"], strTerm, strUnit];
                                notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                                notification.soundName = UILocalNotificationDefaultSoundName;
                                notification.alertAction = @"View";
                                notification.repeatInterval = 0;
                                
                                NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                                [infoDict setObject:[NSString stringWithFormat:@"dayinfo_%d", i] forKey:@"dayinfo_index"];
                                [infoDict setObject:[NSString stringWithFormat:@"%d", j] forKey:@"alert_index"];
                                notification.userInfo = infoDict;
                                
                                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                            }
                            
                        }
                        
                    }
                }
                
                notification = [UILocalNotification new];
                notification.fireDate = date;
                notification.alertBody = [NSString stringWithFormat:@"%@!", [dayinfo objectForKey:@"name"]];
                notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.hasAction = NO;
                //notification.alertAction = @"View";
                notification.repeatInterval = 0;
                
                NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                [infoDict setObject:[NSString stringWithFormat:@"dayinfo_%d", i] forKey:@"dayinfo_index"];
                [infoDict setObject:@"-1" forKey:@"alert_index"];
                notification.userInfo = infoDict;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
            else {
                NSString *strRepeat = [dayinfo objectForKey:@"repeat"];
                if ([strRepeat isEqualToString:@"on"]) {
                    NSString *strTerm = [dayinfo objectForKey:@"repeatterm"];
                    NSString *strUnit = [dayinfo objectForKey:@"repeatunit"];
                    
                    while ([date compare:currentDate] != NSOrderedDescending) {
                        date = [self getRepeatDate:date RepeatTerm:strTerm RepeatUnit:strUnit];
                    }
                    
                    [dateFormat setDateFormat:@"MMM dd, yyyy"];
                    [dayinfo setObject:[dateFormat stringFromDate:date] forKey:@"targetdate"];
                    [dateFormat setDateFormat:@"hh:mm a"];
                    [dayinfo setObject:[dateFormat stringFromDate:date] forKey:@"targettime"];
                    
                    [dayinfo setObject:date forKey:@"targetdatetime"];

                    [archive setObject:[NSKeyedArchiver archivedDataWithRootObject:dayinfo] forKey:[NSString stringWithFormat:@"dayinfo_%d", i]];
                    [archive synchronize];
                    
                    NSDate *alertDate = nil;
                    
                    for (int j = 0; j < 5; ++j) {
                        NSString *strValue = [dayinfo objectForKey:[NSString stringWithFormat:@"alertonoff%d", j]];
                        if ([strValue isEqualToString:@"on"]) {
                            NSString *strTerm = [dayinfo objectForKey:[NSString stringWithFormat:@"alertterm%d", j]];
                            NSString *strUnit = [dayinfo objectForKey:[NSString stringWithFormat:@"alertunit%d", j]];
                            
                            NSString *strTime = [NSString stringWithFormat:@"%@ %@", strTerm, strUnit];
                            BOOL bExist = NO;
                            
                            for (int k = 0; k < j; ++k) {
                                NSString *strTermBefore = [dayinfo objectForKey:[NSString stringWithFormat:@"alertterm%d", k]];
                                NSString *strUnitBefore = [dayinfo objectForKey:[NSString stringWithFormat:@"alertunit%d", k]];
                                
                                NSString *strTimeBefore = [NSString stringWithFormat:@"%@ %@", strTermBefore, strUnitBefore];
                                
                                if ([strTime isEqualToString:strTimeBefore]) {
                                    bExist = YES;
                                    break;
                                }
                            }
                            
                            if (!bExist && ![strTerm isEqualToString:@"0"])
                            {
                                
                                alertDate = [self getAlertDate:date AlertTerm:strTerm AlertUnit:strUnit];
                                
                                if ([alertDate compare:currentDate] == NSOrderedDescending) {
                                    notification = [UILocalNotification new];
                                    notification.fireDate = alertDate;
                                    notification.alertBody = [NSString stringWithFormat:@"%@ is coming in %@ %@!", [dayinfo objectForKey:@"name"], strTerm, strUnit];
                                    notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                                    notification.soundName = UILocalNotificationDefaultSoundName;
                                    notification.alertAction = @"View";
                                    notification.repeatInterval = 0;
                                    
                                    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                                    [infoDict setObject:[NSString stringWithFormat:@"dayinfo_%d", i] forKey:@"dayinfo_index"];
                                    [infoDict setObject:[NSString stringWithFormat:@"%d", j] forKey:@"alert_index"];
                                    notification.userInfo = infoDict;
                                    
                                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                                }
                                
                            }
                            
                        }
                    }
                    
                    notification = [UILocalNotification new];
                    notification.fireDate = date;
                    notification.alertBody = [NSString stringWithFormat:@"%@!", [dayinfo objectForKey:@"name"]];
                    notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    notification.hasAction = NO;
                    //notification.alertAction = @"View";
                    notification.repeatInterval = 0;
                    
                    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                    [infoDict setObject:[NSString stringWithFormat:@"%d", i] forKey:@"dayinfo_index"];
                    [infoDict setObject:@"-1" forKey:@"alert_index"];
                    notification.userInfo = infoDict;
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                }
            }
            
        }
    }
}

- (NSDate *) getAlertDate:(NSDate *)targetDate AlertTerm:(NSString *)strTerm AlertUnit:(NSString *)strUnit
{
    NSDate *alertDate = nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [NSDateComponents new];
    
    if ([strUnit isEqualToString:@"Secs"]) {
        [dateComponents setSecond:-strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Mins"]) {
        [dateComponents setMinute:-strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Hours"]) {
        [dateComponents setHour:-strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Days"]) {
        [dateComponents setDay:-strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Months"]) {
        [dateComponents setMonth:-strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Years"]) {
        [dateComponents setYear:-strTerm.intValue];
    }
    
    alertDate = [gregorian dateByAddingComponents:dateComponents toDate:targetDate options:0];
    
    return alertDate;
}

- (NSDate *) getRepeatDate:(NSDate *)targetDate RepeatTerm:(NSString *)strTerm RepeatUnit:(NSString *)strUnit
{
    NSDate *alertDate = nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [NSDateComponents new];
    
    if ([strUnit isEqualToString:@"Secs"]) {
        [dateComponents setSecond:strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Mins"]) {
        [dateComponents setMinute:strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Hours"]) {
        [dateComponents setHour:strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Days"]) {
        [dateComponents setDay:strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Months"]) {
        [dateComponents setMonth:strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Years"]) {
        [dateComponents setYear:strTerm.intValue];
    }
    
    alertDate = [gregorian dateByAddingComponents:dateComponents toDate:targetDate options:0];
    
    return alertDate;
}

@end
