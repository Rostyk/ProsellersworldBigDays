//
//  FeedbackViewController.h
//  CountDownApp
//
//  Created by Eagle on 11/1/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface FeedbackViewController : BaseViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *lblFeedback;
@property (nonatomic, strong) IBOutlet UILabel *lblSupport;
@property (nonatomic, strong) IBOutlet UIButton *btnRate;
@property (nonatomic, strong) IBOutlet UIButton *btnFriends;
@property (nonatomic, strong) IBOutlet UIButton *btnReport;

- (IBAction)onRate:(id)sender;
- (IBAction)onTellFriends:(id)sender;
- (IBAction)onReport:(id)sender;

@end
