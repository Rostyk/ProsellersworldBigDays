//
//  AppDelegate.h
//  CountDownApp
//
//  Created by Eagle on 10/31/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//  com.guyvan.countdownapp

#import <UIKit/UIKit.h>
#import "JBTabBarController.h"
#import "JBTabBar.h"
#import "BigDaysViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < 50 )

extern NSLocale *DEVICE_LOCALE;
extern NSLocale *ENGLISH_LOCALE;
BOOL isOnFullScreen;

@interface AppDelegate : UIResponder <UIApplicationDelegate, JBTabBarControllerDelegate, UIAlertViewDelegate>
{
    BOOL bSameViewController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JBTabBarController *viewController;
@property (strong, nonatomic) NSMutableArray* imagesType0;
@property (strong, nonatomic) NSMutableArray* imagesType1;
@property (strong, nonatomic) NSMutableArray* imagesMinusType0;
@property (strong, nonatomic) NSMutableArray* imagesMinusType1;
@property (strong, nonatomic) UIAlertView *theAlertView;

- (NSDate*)correctDate:(NSString*)dateString;

@end

#define APP_DELEGATE    ((AppDelegate*)[[UIApplication sharedApplication] delegate])