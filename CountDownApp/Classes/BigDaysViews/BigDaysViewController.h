//
//  BigDaysViewController.h
//  CountDownApp
//
//  Created by Eagle on 11/1/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"

@interface BigDaysViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *daysTable;
@property (nonatomic, strong) IBOutlet UILabel *lblBigDays;

- (IBAction)onPlus:(id)sender;

- (void)sortDataByDate;
- (NSArray*)sortArrayByDate:(NSArray*)array;

@end
