//
//  FeedbackViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/1/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AppDelegate.h"
#import "Flurry.h"
#import "BDCommon.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize lblFeedback;
@synthesize lblSupport;
@synthesize btnFriends;
@synthesize btnRate;
@synthesize btnReport;

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    lblFeedback.font = TITLE_FONT;
    lblFeedback.text = NSLocalizedString(@"Feedback", nil);
    
    lblSupport.font = MIDDLE_LABEL_FONT;
    lblSupport.text = NSLocalizedString(@"Support", nil);
    
    [btnRate setTitle:NSLocalizedString(@"Rate this App", nil) forState:UIControlStateNormal];
    btnRate.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnRate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnRate.titleEdgeInsets = UIEdgeInsetsMake(7, 9, 0, 0);
    
    [btnFriends setTitle:NSLocalizedString(@"Tell Your Friends About this App", nil) forState:UIControlStateNormal];
    btnFriends.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnFriends.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnFriends.titleEdgeInsets = UIEdgeInsetsMake(7, 9, 0, 0);
    
    [btnReport setTitle:NSLocalizedString(@"Report a Problem", nil) forState:UIControlStateNormal];
    btnReport.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnReport.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnReport.titleEdgeInsets = UIEdgeInsetsMake(7, 9, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isOnFullScreen = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRate:(id)sender
{
//    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Rate this App", nil) message:NSLocalizedString(@"If you like our app, we would greatly appreciate if you can take a moment to rate and write a great review. \nThanks for your support!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No Thanks", nil) otherButtonTitles:NSLocalizedString(@"Rate Now!", nil), nil] show];//@"Remind me Later",
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Do you enjoy using Big Days of Our Lives CountDown?", nil) message:NSLocalizedString(@"If you do, please take the time to give us a nice review or rating. It really helps us a lot! =)", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No Thanks", nil) otherButtonTitles:NSLocalizedString(@"Rate Now!", nil), nil]show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id581481166?ls=1&mt=8"]];
        
        [Flurry logEvent:@"Rate_App"];
    }
    else if (buttonIndex != alertView.cancelButtonIndex) {
        
    }
}

- (IBAction)onTellFriends:(id)sender
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    if (controller) {
        controller.mailComposeDelegate = self;
        [controller setSubject:NSLocalizedString(@"Check out this app", nil)];
        
        NSString *strBody = [NSString stringWithFormat:NSLocalizedString(@"Hey,<br/><br/>I just downloaded \"Big Day Countdown\" on my %@!<br/><br/>It's a great app that helps you Countdown your Big Days or Events!<br/><br/>You can download it from the app store:<a href=\"https://itunes.apple.com/app/id581481166?ls=1&mt=8\">https://itunes.apple.com/app/id581481166?ls=1&mt=8</a>", nil), [[UIDevice currentDevice] model]];
        
        [controller setMessageBody:strBody isHTML:YES];
        //[controller setBccRecipients:[NSArray arrayWithObjects:@"guy.outsourcing@gmail.com", nil]];
        //[controller setCcRecipients:[NSArray arrayWithObjects:@"guy.outsourcing@gmail.com", nil]];
        
        [APP_DELEGATE.viewController presentModalViewController:controller animated:YES];
    }
    
    [Flurry logEvent:@"Tell Friends"];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"Sent!");
    }
    [APP_DELEGATE.viewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)onReport:(id)sender
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    if (controller) {
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObjects:@"info@bigday-countdown.com", nil]];
        [controller setSubject:NSLocalizedString(@"Bug Report Big Days Countdown", nil)];
        
        //[controller setBccRecipients:[NSArray arrayWithObjects:@"guy.outsourcing@gmail.com", nil]];
        //[controller setCcRecipients:[NSArray arrayWithObjects:@"guy.outsourcing@gmail.com", nil]];
        
        [APP_DELEGATE.viewController presentModalViewController:controller animated:YES];
    }
    
    [Flurry logEvent:@"Report"];
}

@end
