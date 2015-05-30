//
//  MoreAppsViewController.h
//  CountDownApp
//
//  Created by Eagle on 11/1/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import "AReachability.h"

@interface MoreAppsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *appsTableView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSMutableArray *arrayApps;

@property (strong, nonatomic) AReachability *internetReachable;
@property (nonatomic) BOOL isInternetActive;

@property (nonatomic, strong) UIImage *imageTableBg0;
@property (nonatomic, strong) UIImage *imageTableBg1;
@property (nonatomic, strong) UIFont *fontBold;
@property (nonatomic, strong) UIFont *fontRegular;

- (BOOL) checkNetworkStatus;

@end
