//
//  BigDaysDetailsViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/3/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BigDaysDetailsViewController.h"
#import "AddDaysViewController.h"
#import "AppDelegate.h"
#import "SHKActivityIndicator.h"
#import <Twitter/TWTweetComposeViewController.h>
#import "Flurry.h"
#import "BDCommon.h"
#import "BigDayPageViewController.h"

#import "FacebookFacade.h"
#import "MBProgressHUD.h"
#import "AppManager.h"

#define SLIDE_WIDTH         324
#define SLIDE_OFFSET        2

@interface BigDaysDetailsViewController ()
@property (strong, nonatomic) MBProgressHUD *downloadProgressHud;
@property (strong, nonatomic) FacebookFacade *facebookFacade;
@end

@implementation BigDaysDetailsViewController

@synthesize dragdropImageView;

@synthesize btnEdit;
@synthesize btnInfo;
@synthesize btnShare;

@synthesize shareView;
@synthesize infoView;

@synthesize infodateFlipView;
@synthesize infoflipBgImageView;
@synthesize infolblName;
@synthesize targetDate;
@synthesize tapGesture;

@synthesize dicDayInfo;

@synthesize lblInfoDays;
@synthesize lblInfoHours;
@synthesize lblInfoMins;
@synthesize lblInfoSecs;
@synthesize lblTapToDrag;
@synthesize btnClose;

//For Share
@synthesize btnSaveImage;
@synthesize btnSendMail;
@synthesize btnSendSMS;
@synthesize btnFacebook;
@synthesize btnTwitter;
@synthesize btnCancel;

//For Slide
@synthesize scrBigDays;
@synthesize pageSlider;
@synthesize arrayPageViews;
@synthesize leftSwipeGesture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"BigDaysDetailsViewController_iphone5" bundle:nibBundleOrNil];
    }
    else {
        self = [super initWithNibName:@"BigDaysDetailsViewController" bundle:nibBundleOrNil];
    }
    if (self) {

        infodateFlipView = [[JDDateCountdownFlipView alloc] initWithType:1];
        [infodateFlipView setFlipNumberType:1];
        [infodateFlipView setUserInteractionEnabled:NO];
        //[dateFlipView setFrame:];
        //[self.infoView addSubview:infodateFlipView];
        [infodateFlipView setAutoresizingMask:UIViewAutoresizingNone];
        [self.infoflipBgImageView addSubview:infodateFlipView];
        [self.infolblName removeFromSuperview];
        [self.infoflipBgImageView addSubview:self.infolblName];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //UIFont *font = [UIFont fontWithName:@"MyriadPro-Black" size:27];
    UIFont *font = [UIFont fontWithName:@"MyriadPro-Semibold" size:27];
    [infolblName setFont:font];

    [infoflipBgImageView addTarget:self action:@selector(imageTouch:withEvent:) forControlEvents:UIControlEventTouchDown];
    [infoflipBgImageView addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doViewWillAppear:) name:UIApplicationWillEnterForegroundNotification object:nil];

    lblInfoHours.text = NSLocalizedString(@"HOURS", nil);
    lblInfoHours.font = SMALL_LABEL_FONT;

    lblInfoDays.text = NSLocalizedString(@"DAYS", nil);
    lblInfoDays.font = SMALL_LABEL_FONT;

    lblInfoMins.text = NSLocalizedString(@"MINS", nil);
    lblInfoMins.font = SMALL_LABEL_FONT;

    lblInfoSecs.text = NSLocalizedString(@"SECS", nil);
    lblInfoSecs.font = SMALL_LABEL_FONT;

    lblTapToDrag.text = NSLocalizedString(@"Tap to drag counter", nil);
    lblTapToDrag.font = [UIFont fontWithName:FONT_BOLD size:16.0];

    [btnClose setTitle:NSLocalizedString(@"Close", nil) forState:UIControlStateNormal];
    btnClose.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnClose.titleEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
    btnClose.titleLabel.font = SMALL_LABEL_FONT;

    [btnEdit setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    btnEdit.titleLabel.font = SMALL_BUTTON_FONT;
    btnEdit.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnEdit.titleEdgeInsets = UIEdgeInsetsMake(9.5, 0, 0, 0);

    [btnSaveImage setTitle:NSLocalizedString(@"Save Image", nil) forState:UIControlStateNormal];
    btnSaveImage.titleLabel.font = LARGE_BUTTON_BOLDFONT;
    btnSaveImage.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnSaveImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnSaveImage.titleEdgeInsets = UIEdgeInsetsMake(11.0, 17, 0, 0);

    [btnSendMail setTitle:NSLocalizedString(@"Send eMail", nil) forState:UIControlStateNormal];
    btnSendMail.titleLabel.font = LARGE_BUTTON_BOLDFONT;
    btnSendMail.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnSendMail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnSendMail.titleEdgeInsets = UIEdgeInsetsMake(11.0, 17, 0, 0);

    [btnSendSMS setTitle:NSLocalizedString(@"Send SMS", nil) forState:UIControlStateNormal];
    btnSendSMS.titleLabel.font = LARGE_BUTTON_BOLDFONT;
    btnSendSMS.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnSendSMS.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnSendSMS.titleEdgeInsets = UIEdgeInsetsMake(11.0, 17, 0, 0);

    [btnFacebook setTitle:NSLocalizedString(@"Facebook", nil) forState:UIControlStateNormal];
    btnFacebook.titleLabel.font = LARGE_BUTTON_BOLDFONT;
    btnFacebook.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnFacebook.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnFacebook.titleEdgeInsets = UIEdgeInsetsMake(11.0, 17, 0, 0);

    [btnTwitter setTitle:NSLocalizedString(@"Twitter", nil) forState:UIControlStateNormal];
    btnTwitter.titleLabel.font = LARGE_BUTTON_BOLDFONT;
    btnTwitter.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnTwitter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnTwitter.titleEdgeInsets = UIEdgeInsetsMake(11.0, 17, 0, 0);

    [btnCancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    btnCancel.titleLabel.font = LARGE_BUTTON_BOLDFONT;
    btnCancel.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnCancel.titleEdgeInsets = UIEdgeInsetsMake(13.0, 0, 0, 0);

    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];

    leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    leftSwipeGesture.delegate = self;
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;

    [self.infoflipBgImageView addSubview:infodateFlipView];

    arrayScrollLogs = [[NSMutableArray alloc] init];

    isTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self initViewWillAppear];

    [self hideStatusBar];

    isOnFullScreen = YES;

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        CGRect frame = btnInfo.frame;
        frame.origin.y = 40;
        btnInfo.frame = frame;

        frame = btnEdit.frame;
        frame.origin.y = 44;
        btnEdit.frame = frame;

        frame = btnShare.frame;
        frame.origin.y = 40;
        btnShare.frame = frame;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    isOnFullScreen = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    CGRect frame = self.navigationController.view.frame;
    frame.origin.y = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        frame.size.height = [UIScreen mainScreen].bounds.size.height - 49;
    else
        frame.size.height = [UIScreen mainScreen].bounds.size.height - 20 - 49;
    self.navigationController.view.frame = frame;

    [super viewWillDisappear:animated];

    isOnFullScreen = NO;
}

- (void)doViewWillAppear: (NSNotification *)notif
{
    [self initViewWillAppear];
}

- (void)hideStatusBar
{
    APP_DELEGATE.viewController.tabBar.alpha = 0.0;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    BOOL IS_IOS7UP;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        IS_IOS7UP = YES;
    else
        IS_IOS7UP = NO;

    CGRect frame = self.navigationController.view.frame;
    if (IS_IOS7UP == YES)
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
    else
        frame.size.height = [UIScreen mainScreen].bounds.size.height - 20;
    self.navigationController.view.frame = frame;

    frame = pageSlider.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 20 - frame.size.height;
    pageSlider.frame = frame;

    frame = self.view.frame;
    if (IS_IOS7UP == YES)
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
    else
        frame.size.height = [UIScreen mainScreen].bounds.size.height - 20;
    self.view.frame = frame;

    frame = scrBigDays.frame;
    if (IS_IOS7UP == YES)
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
    else
        frame.size.height = [UIScreen mainScreen].bounds.size.height - 20;
    scrBigDays.frame = frame;

    btnInfo.alpha = 0.0;
    btnEdit.alpha = 0.0;
    btnShare.alpha = 0.0;
}

- (void)initViewWillAppear
{
    //NSLog(@"BigDaysDetails viewWillAppear");

    // Page Control
    [self configBigDays];

    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSData *data = [archive objectForKey:[NSString stringWithFormat:@"dayinfo_%d", nDayIndex]];
    if (data) {
        dicDayInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dicDayInfo) {
            infolblName.text = [dicDayInfo objectForKey:@"name"];

            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];

            NSString *strDate = [dicDayInfo objectForKey:@"targetdate"];
            NSString *strTime = [dicDayInfo objectForKey:@"targettime"];

            [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];

            NSString *stringDate = [NSString stringWithFormat:@"%@ %@", strDate, strTime];
            targetDate = [dateFormat dateFromString:stringDate];
            if (targetDate == nil)
            {
                dateFormat.locale = ENGLISH_LOCALE;
                NSString *stringDate = [NSString stringWithFormat:@"%@ %@", strDate, strTime];
                targetDate = [dateFormat dateFromString:stringDate];
                if (targetDate == nil)
                    targetDate = [APP_DELEGATE correctDate:stringDate];
            }
            targetDate = [dicDayInfo objectForKey:@"targetdatetime"];

            if (targetDate)
                [self.infodateFlipView setTargetDate:targetDate];

            NSString *strOriginX = [dicDayInfo objectForKey:@"counter_x"];
            NSString *strOriginY = [dicDayInfo objectForKey:@"counter_y"];
            if (strOriginX != nil && strOriginY != nil) {
                CGRect rt = infoflipBgImageView.frame;
                rt.origin.x = [strOriginX floatValue];
                rt.origin.y = [strOriginY floatValue];

                if (rt.origin.x < dragdropImageView.frame.origin.x + 10) {
                    rt.origin.x = dragdropImageView.frame.origin.x + 10;
                }
                else if (rt.origin.x > dragdropImageView.frame.origin.x + dragdropImageView.frame.size.width - 10 - rt.size.width) {
                    rt.origin.x = dragdropImageView.frame.origin.x + dragdropImageView.frame.size.width - 10 - rt.size.width;
                }

                if (rt.origin.y < dragdropImageView.frame.origin.y + 15) {
                    rt.origin.y = dragdropImageView.frame.origin.y + 15;
                }
                else if (rt.origin.y > dragdropImageView.frame.origin.y + dragdropImageView.frame.size.height - 32 - rt.size.height) {
                    rt.origin.y = dragdropImageView.frame.origin.y + dragdropImageView.frame.size.height - 32 - rt.size.height;
                }

                infoflipBgImageView.frame = rt;
            }
        }
    }
    [self setCounterAndNameFrame];

    if (isOnFullScreen == YES)
        [self performSelector:@selector(hideStatusBar) withObject:nil afterDelay:0.2];
}

- (void)configBigDays
{
    [scrBigDays removeGestureRecognizer:leftSwipeGesture];

    if (arrayPageViews == nil)
        self.arrayPageViews = [NSMutableArray array];
    else
        [arrayPageViews removeAllObjects];

    for (UIView *view in scrBigDays.subviews)
        [view removeFromSuperview];

    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSString *strCount = [archive objectForKey:@"dayscount"];
    int nCount = 0;
    if (strCount)
        nCount = [strCount intValue];

    int pageIndex = nDayIndex / 10;
    int pageFrom = pageIndex * 10;
    int pageTo = pageIndex * 10 + 10;
    if (pageTo > nCount)
        pageTo = pageFrom + nCount % 10;
    for (int i = pageFrom; i < pageTo; i++)
    {
        BigDayPageViewController *controller;
        if (IS_IPHONE_5)
            controller = [[BigDayPageViewController alloc] initWithNibName:@"BigDayPageViewController_iPhone5" bundle:nil];
        else
            controller = [[BigDayPageViewController alloc] initWithNibName:@"BigDayPageViewController" bundle:nil];
        controller.nDayIndex = i;
        CGRect frame = controller.view.frame;
        frame.origin.x = SLIDE_OFFSET + (i - pageFrom) * SLIDE_WIDTH;
        frame.origin.y = 0;
        frame.size.width = 320;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
            frame.size.height = [UIScreen mainScreen].bounds.size.height;
        else
            frame.size.height = [UIScreen mainScreen].bounds.size.height - 20;
        controller.view.frame = frame;
        [controller initFlipView];
        [scrBigDays addSubview:controller.view];

        [arrayPageViews addObject:controller];

        if (i == nDayIndex)
        {
            self.dicDayInfo = controller.dicDayInfo;
            nScrollIndex = i - pageFrom;
            self.targetDate = controller.targetDate;
        }
    }
    pageSlider.numberOfPages = pageTo - pageFrom;
    pageSlider.currentPage = nScrollIndex;

    CGSize contentsize = scrBigDays.contentSize;
    contentsize.width = (pageTo - pageFrom) * SLIDE_WIDTH;
    scrBigDays.contentSize = contentsize;

    scrBigDays.contentOffset = CGPointMake(SLIDE_WIDTH * nScrollIndex, 0);

    if (pageSlider.numberOfPages == 1)
    {
        CGSize contentsize = scrBigDays.contentSize;
        contentsize.width = (pageTo - pageFrom) * SLIDE_WIDTH + 1;
        scrBigDays.contentSize = contentsize;

        //[scrBigDays addGestureRecognizer:leftSwipeGesture];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer*)gestureRecognizer
{
    CGRect frame = pageSlider.frame;
    if (btnInfo.alpha == 1.0)
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 20 - frame.size.height;
    else
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 20 - frame.size.height - APP_DELEGATE.viewController.tabBar.frame.size.height;

    pageSlider.frame = frame;
    pageSlider.alpha = 0.0;

    [UIView animateWithDuration:0.3 animations:^
     {
         pageSlider.alpha = 1.0;
         if (btnInfo.alpha == 1.0)
         {
             btnInfo.alpha = 0.0;
             btnEdit.alpha = 0.0;
             btnShare.alpha = 0.0;

             APP_DELEGATE.viewController.tabBar.alpha = 0.0;
             [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
         }
         else
         {
             btnInfo.alpha = 1.0;
             btnEdit.alpha = 1.0;
             btnShare.alpha = 1.0;

             APP_DELEGATE.viewController.tabBar.alpha = 1.0;
             [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
         }
     }];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (nDayIndex == 0)
        return;

    nDayIndex -= 1;
    isSwipeGesture = YES;

    [self configBigDays];
}

- (IBAction)imageTouch:(id)sender withEvent:(UIEvent *)event
{
    touchPoint = [[[event allTouches] anyObject] locationInView:self.infoView];
}

- (IBAction)imageMoved:(id)sender withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.infoView];

    CGRect rt = infoflipBgImageView.frame;
    rt.origin.x += (point.x - touchPoint.x);
    rt.origin.y += (point.y - touchPoint.y);
    if (rt.origin.x < dragdropImageView.frame.origin.x + 10) {
        rt.origin.x = dragdropImageView.frame.origin.x + 10;
    }
    else if (rt.origin.x > dragdropImageView.frame.origin.x + dragdropImageView.frame.size.width - 10 - rt.size.width) {
        rt.origin.x = dragdropImageView.frame.origin.x + dragdropImageView.frame.size.width - 10 - rt.size.width;
    }

    if (rt.origin.y < dragdropImageView.frame.origin.y + 15) {
        rt.origin.y = dragdropImageView.frame.origin.y + 15;
    }
    else if (rt.origin.y > dragdropImageView.frame.origin.y + dragdropImageView.frame.size.height - 32 - rt.size.height) {
        rt.origin.y = dragdropImageView.frame.origin.y + dragdropImageView.frame.size.height - 32 - rt.size.height;
    }

    infoflipBgImageView.frame = rt;
    int pageIndex = pageSlider.currentPage;
    BigDayPageViewController *controller = [arrayPageViews objectAtIndex:pageIndex];
    controller.flipBgImageView.frame = rt;

    [self setCounterAndNameFrame];
    touchPoint = point;
}

- (void)setCounterAndNameFrame
{
    BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
    CGRect rt = bigday.flipBgImageView.frame;
    [bigday.dateFlipView setFrame:CGRectMake(rt.origin.x + 5, rt.origin.y + 45, rt.size.width - 10, rt.size.height / 4 )];
    bigday.lblName.frame = CGRectMake(rt.origin.x + 10, rt.origin.y + 5, rt.size.width - 20, 35);
    bigday.lblDays.frame = CGRectMake(rt.origin.x + 35, rt.origin.y + 84, 45, 25);
    bigday.lblHours.frame = CGRectMake(rt.origin.x + 112, rt.origin.y + 84, 50, 25);
    bigday.lblMins.frame = CGRectMake(rt.origin.x + 170, rt.origin.y + 84, 45, 25);
    bigday.lblSecs.frame = CGRectMake(rt.origin.x + 228, rt.origin.y + 84, 45, 25);

    infolblName.text = bigday.lblName.text;
    [infodateFlipView setTargetDate:bigday.targetDate];
    rt = bigday.flipBgImageView.frame;
    infoflipBgImageView.frame = rt;
    [infodateFlipView setFrame:CGRectMake(5, 45, rt.size.width - 10, rt.size.height / 4 )];
    //[infodateFlipView setFrame:CGRectMake(5 + rt.origin.x, 45 + rt.origin.y, rt.size.width - 10, rt.size.height / 4 )];
    infolblName.frame = CGRectMake(10 + rt.origin.x, 6 + rt.origin.y, rt.size.width - 20, 35);
    lblInfoDays.frame = CGRectMake(rt.origin.x + 35, rt.origin.y + 84, 45, 25);
    lblInfoHours.frame = CGRectMake(rt.origin.x + 112, rt.origin.y + 84, 50, 25);
    lblInfoMins.frame = CGRectMake(rt.origin.x + 170, rt.origin.y + 84, 45, 25);
    lblInfoSecs.frame = CGRectMake(rt.origin.x + 228, rt.origin.y + 84, 45, 25);
}

- (void)setDayIndex:(int)nIndex
{
    nDayIndex = nIndex;
}

- (IBAction)onEditInfo:(id)sender
{
    AddDaysViewController *viewController = [AddDaysViewController new];
    viewController.dicDayInfo = self.dicDayInfo;
    [viewController setDayIndex:nDayIndex];
    [self.navigationController pushViewController:viewController animated:YES];

    [Flurry logEvent:@"BigDay_Edit"];
}

- (IBAction)onCancelShare:(id)sender {
    [self onCancelShare:sender completionBlock:^{
        NSLog(@"cancel");
    }];
}

- (void)onCancelShare:(id)sender
          completionBlock:(SimpleCallBack)completion {
    [UIView animateWithDuration:0.75
                          delay:0
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^{
                         CGRect rctFrame = self.shareView.frame;
                         rctFrame.origin = CGPointMake(0, 800);
                         self.shareView.frame = rctFrame;
                     } completion:^(BOOL finished) {
                         [self.shareView removeFromSuperview];
                         BLOCK_SAFE_RUN(completion);
                     }];
}

- (IBAction)onCancelInfo:(id)sender
{
    BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
    bigday.flipBgImageView.frame = infoflipBgImageView.frame;
    [dicDayInfo setObject:[NSString stringWithFormat:@"%f", bigday.flipBgImageView.frame.origin.x] forKey:@"counter_x"];
    [dicDayInfo setObject:[NSString stringWithFormat:@"%f", bigday.flipBgImageView.frame.origin.y] forKey:@"counter_y"];
    [self setCounterAndNameFrame];
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    if (nDayIndex >= 0) {
        //Modify Day Info
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dicDayInfo];
        [archive setObject:data forKey:[NSString stringWithFormat:@"dayinfo_%d", nDayIndex]];

        [archive synchronize];
    }

    [UIView beginAnimations:@"CancelInfoView" context:nil];
    [UIView setAnimationDuration:0.75];

    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

    CGRect rctFrame = self.infoView.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.infoView.frame = rctFrame;

    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"CancelShareView"]) {
        [shareView removeFromSuperview];
    }
    else if ([animationID isEqualToString:@"CancelInfoView"]) {
        [infoView removeFromSuperview];

        if (targetDate) {
            BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
            [bigday.dateFlipView setTargetDate:targetDate];
            [self.infodateFlipView setTargetDate:targetDate];
        }
    }
}

- (IBAction)onShare:(id)sender
{
    CGRect rctFrame = self.shareView.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.shareView.frame = rctFrame;
    [APP_DELEGATE.viewController.view addSubview:self.shareView];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];

    rctFrame.origin = CGPointMake(0, 0);
    self.shareView.frame = rctFrame;

    [UIView commitAnimations];
}

- (IBAction)onInfo:(id)sender
{
    [self setCounterAndNameFrame];

    CGRect rctFrame = self.infoView.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.infoView.frame = rctFrame;
    [APP_DELEGATE.viewController.view addSubview:self.infoView];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];

    rctFrame.origin = CGPointMake(0, 0);
    self.infoView.frame = rctFrame;

    [UIView commitAnimations];

    if (targetDate) {
        //[self.dateFlipView setTargetDate:targetDate];
        [self.infodateFlipView setTargetDate:targetDate];
    }
}

- (IBAction)onSaveImage:(id)sender
{
    [self saveImageToPhotosAlbum];
    [Flurry logEvent:@"BigDay_Save_Image"];
}

- (void)saveImageToPhotosAlbum {
    btnInfo.hidden = YES;
    btnEdit.hidden = YES;
    btnShare.hidden = YES;

    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);

    btnInfo.hidden = NO;
    btnEdit.hidden = NO;
    btnShare.hidden = NO;
    [self showMessage:@"Saved to camera roll." title:@""];
}

- (IBAction)onSendEmail:(id)sender
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];

    if (controller) {
        controller.mailComposeDelegate = self;

        BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
        [controller setSubject:bigday.lblName.text];

        btnInfo.hidden = YES;
        btnEdit.hidden = YES;
        btnShare.hidden = YES;
        pageSlider.hidden = YES;

        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        btnInfo.hidden = NO;
        btnEdit.hidden = NO;
        btnShare.hidden = NO;
        pageSlider.hidden = NO;

        NSData *imageData = UIImagePNGRepresentation(viewImage);
        [controller addAttachmentData:imageData mimeType:@"image/png" fileName:bigday.lblName.text];

        NSString *strBody = [NSString stringWithFormat:@"%@ is coming in %d days, %d hours, %d minutes, %d seconds!", bigday.lblName.text, bigday.dateFlipView.mFlipNumberViewDay.intValue, bigday.dateFlipView.mFlipNumberViewHour.intValue, bigday.dateFlipView.mFlipNumberViewMinute.intValue, bigday.dateFlipView.mFlipNumberViewSecond.intValue];
        [controller setMessageBody:strBody isHTML:NO];

        [APP_DELEGATE.viewController presentModalViewController:controller animated:YES];
    }

    [Flurry logEvent:@"BigDay_Send_Email"];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        //NSLog(@"Sent!");
        [Flurry logEvent:@"BigDay_Email_Sent"];
    }
    [APP_DELEGATE.viewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)onSendSMS:(id)sender
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
        NSString *strBody = [NSString stringWithFormat:@"%@ is coming in %d days, %d hours, %d minutes, %d seconds!", bigday.lblName.text, bigday.dateFlipView.mFlipNumberViewDay.intValue, bigday.dateFlipView.mFlipNumberViewHour.intValue, bigday.dateFlipView.mFlipNumberViewMinute.intValue, bigday.dateFlipView.mFlipNumberViewSecond.intValue];
        controller.body = strBody;
        controller.messageComposeDelegate = self;

        [APP_DELEGATE.viewController presentModalViewController:controller animated:YES];
    }

    [Flurry logEvent:@"BigDay_Send_SMS"];
}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultSent) {
        //NSLog(@"Sent!");
        [Flurry logEvent:@"BigDay_SMS_Sent"];
    }
    [APP_DELEGATE.viewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)onFacebook:(id)sender {
    [self onCancelShare:nil
        completionBlock:^{
            if (![AppManager sharedInstance].isLoginFromSocial) {
                NSLog(@"[AppManager sharedInstance].isLoginFromSocial:%d",[AppManager sharedInstance].isLoginFromSocial);
                UIAlertView *facebookNotify =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Facebook authentication", nil)
                                                                          message:NSLocalizedString(@"For this actions you should login to Facebook", nil)
                                                                         delegate:self
                                                                cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                                otherButtonTitles:NSLocalizedString(@"Login", nil), nil];
                facebookNotify.tag = 200;
                [facebookNotify show];
            } else {
                [self facebookLoginHandler];
            }
        }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            [self facebookLoginHandler];
        }
    } else {
        NSLog(@"Cancel Facebook Login");
    }
}

- (void)facebookLoginHandler {
    [Flurry logEvent:@"BigDay_Facebook"];
    self.downloadProgressHud.labelText = @"Posting...";
    self.downloadProgressHud.detailsLabelText = @"";
    [self.downloadProgressHud show:YES];
    [self.facebookFacade openSessionWithCompletionHandler:^{
        if ([self.facebookFacade isSessionOpen]) {
            [self.facebookFacade startRequestForMeWithCompletionHandler:^(id result, NSError *error) {
                NSLog(@"result:%@",result);
                NSLog(@"error:%@",error);
                if (!error) {
                    btnInfo.hidden = YES;
                    btnEdit.hidden = YES;
                    btnShare.hidden = YES;
                    self.downloadProgressHud.hidden = YES;
                    UIGraphicsBeginImageContext(self.view.bounds.size);
                    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    self.downloadProgressHud.hidden = NO;

                    btnInfo.hidden = NO;
                    btnEdit.hidden = NO;
                    btnShare.hidden = NO;

                    BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
                    NSString *strBody = [NSString stringWithFormat:@"%@ is coming in %d days, %d hours, %d minutes, %d seconds!",
                                         bigday.lblName.text,
                                         bigday.dateFlipView.mFlipNumberViewDay.intValue,
                                         bigday.dateFlipView.mFlipNumberViewHour.intValue,
                                         bigday.dateFlipView.mFlipNumberViewMinute.intValue,
                                         bigday.dateFlipView.mFlipNumberViewSecond.intValue];

                    NSLog(@"strBody:%@",strBody);

                    [AppManager sharedInstance].isLoginFromSocial = YES;
                    [[AppManager sharedInstance] saveLogin];

                    [Flurry logEvent:@"BigDay_Facebook_Login_Success"];
                    [self.facebookFacade postOpenGraphStoryWithImage:viewImage
                                                           withTitle:strBody
                                                     completionBlock:^{
                                                         self.downloadProgressHud.detailsLabelText = NSLocalizedStringFromTable(@"Your Big Day has been posted successfully.", @"Strings", @"");
                                                         [self.downloadProgressHud hide:YES afterDelay:3];
                                                         [Flurry logEvent:@"BigDay_Facebook_Posted"];
                                                     }
                                                     andFailureBlock:^{
                                                         self.downloadProgressHud.detailsLabelText = NSLocalizedStringFromTable(@"Failed posting your Big Day.", @"Strings", @"");
                                                         [self.downloadProgressHud hide:YES afterDelay:3];                                                                 [Flurry logEvent:@"BigDay_Facebook_Post_Failed"];
                                                     }];
                }
            }];
        }
    } andFailureBlock:^{
        self.downloadProgressHud.detailsLabelText = NSLocalizedStringFromTable(@"Facebook Login Failed.", @"Strings", @"");
        [self.downloadProgressHud hide:YES afterDelay:3];
        [Flurry logEvent:@"BigDay_Facebook_Login_Failed"];
    }];
}

- (void)showMessage:(NSString *)message title:(NSString *)title {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles: nil];
    [alert show];
}

- (IBAction)onTwitter:(id)sender
{
    if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];

        btnInfo.hidden = YES;
        btnEdit.hidden = YES;
        btnShare.hidden = YES;

        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        btnInfo.hidden = NO;
        btnEdit.hidden = NO;
        btnShare.hidden = NO;

        BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
        NSString *strBody = [NSString stringWithFormat:@"%@ is coming in %d days, %d hours, %d minutes, %d seconds!", bigday.lblName.text, bigday.dateFlipView.mFlipNumberViewDay.intValue, bigday.dateFlipView.mFlipNumberViewHour.intValue, bigday.dateFlipView.mFlipNumberViewMinute.intValue, bigday.dateFlipView.mFlipNumberViewSecond.intValue];

        [controller setInitialText:strBody];
        [controller addImage:viewImage];
        //Adding URL
        NSURL *url = [NSURL URLWithString:@"http://www.bigday-countdown.com"];
        [controller addURL:url];

        [controller setCompletionHandler:^(TWTweetComposeViewControllerResult result) {

            [APP_DELEGATE.viewController dismissModalViewControllerAnimated:YES];
        }];

        [APP_DELEGATE.viewController presentModalViewController:controller animated:YES];
    }
    else {
        // Show Alert View When The Application Cannot Send Tweets
        NSString *message = @"The application cannot send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    }

    [Flurry logEvent:@"BigDay_Twitter"];
}

- (IBAction)onSlidePage:(id)sender
{
    int index = nDayIndex / 10;
    nDayIndex = index * 10 + pageSlider.currentPage;
    nScrollIndex = pageSlider.currentPage;

    BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:index];
    self.dicDayInfo = bigday.dicDayInfo;
    [scrBigDays setContentOffset:CGPointMake(SLIDE_WIDTH * pageSlider.currentPage, 0) animated:YES];
    nDayIndex = bigday.nDayIndex;
    self.targetDate = bigday.targetDate;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]])
        return NO;

    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (isSwipeGesture == YES)
    {
        isSwipeGesture = NO;
        return;
    }

    [self didScrollForPage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"Y ================================== %.2f", scrollView.contentOffset.x);
    [arrayScrollLogs addObject:[NSNumber numberWithFloat:scrollView.contentOffset.x]];
    if (arrayScrollLogs.count >= 4)
        [arrayScrollLogs removeObjectAtIndex:0];

    CGPoint offset = scrollView.contentOffset;
    offset.y = 0;
    scrollView.contentOffset = offset;
}

- (void)didScrollForPage
{
    CGPoint contentOffset = scrBigDays.contentOffset;
    int index = contentOffset.x / SLIDE_WIDTH;
    pageSlider.currentPage = index;
    if ((index == 0 || index == 9) && nScrollIndex == index)
    {
        if (nDayIndex == 0)
            return;

        BOOL isNeedNext = NO;
        if (index == 0)
        {
            for (int i = 0; i < arrayScrollLogs.count; i++)
            {
                float offset = [[arrayScrollLogs objectAtIndex:i] floatValue];
                if (offset == contentOffset.x)
                    continue;
                if (offset < 0)
                {
                    isNeedNext = YES;
                    break;
                }
                else
                    isNeedNext = NO;
            }
            if (isNeedNext)
                nDayIndex -= 1;
        }
        else
        {
            for (int i = 0; i < arrayScrollLogs.count; i++)
            {
                float offset = [[arrayScrollLogs objectAtIndex:i] floatValue];
                if (offset == contentOffset.x)
                    continue;
                if (offset > SLIDE_WIDTH * 9)
                {
                    isNeedNext = YES;
                    break;
                }
                else
                    isNeedNext = NO;
            }
            if (isNeedNext)
            {
                nDayIndex += 1;
                NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
                NSString *strCount = [archive objectForKey:@"dayscount"];
                int nCount = 0;
                if (strCount)
                    nCount = [strCount intValue];
                if (nDayIndex == nCount)
                {
                    nDayIndex -= 1;
                    return;
                }
            }
        }

        if (isNeedNext == YES)
            [self configBigDays];
    }
    else
    {
        nScrollIndex = index;

        BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
        self.dicDayInfo = bigday.dicDayInfo;
        [self setDayIndex:bigday.nDayIndex];
        self.targetDate = bigday.targetDate;
    }

    [arrayScrollLogs removeAllObjects];
}

- (FacebookFacade *)facebookFacade {
    if (!_facebookFacade) {
        _facebookFacade = [FacebookFacade sharedInstance];
    }
    return _facebookFacade;
}

- (MBProgressHUD *)downloadProgressHud {
    if (!_downloadProgressHud) {
        _downloadProgressHud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_downloadProgressHud];
        _downloadProgressHud.labelText = @"Posting...";
        _downloadProgressHud.mode = MBProgressHUDModeIndeterminate;
    }
    return _downloadProgressHud;
}

@end
