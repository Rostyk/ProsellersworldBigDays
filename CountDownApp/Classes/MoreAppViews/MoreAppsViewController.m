//
//  MoreAppsViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/1/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "MoreAppsViewController.h"
#import "MoreAppsTableCell.h"
#import "XMLMoreAppsParser.h"
#import <QuartzCore/QuartzCore.h>
#import "Flurry.h"
#import "AppDelegate.h"

@interface MoreAppsViewController ()

@end

@implementation MoreAppsViewController

@synthesize appsTableView;
@synthesize activityIndicator;
@synthesize arrayApps;
@synthesize internetReachable, isInternetActive;

@synthesize imageTableBg0;
@synthesize imageTableBg1;
@synthesize fontBold;
@synthesize fontRegular;

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
    
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    imageTableBg0 = [UIImage imageNamed:@"more_app_tablecell_bg0.png"];
    imageTableBg1 = [UIImage imageNamed:@"more_app_tablecell_bg1.png"];
    
    fontBold = [UIFont fontWithName:@"MyriadPro-Black" size:16];
    fontRegular = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
    
    self.internetReachable = [AReachability reachabilityForInternetConnection];
	[self.internetReachable startNotifier];
    
    if ([self checkNetworkStatus]) {
        [NSThread detachNewThreadSelector:@selector(actionRefresh) toTarget:self withObject:nil];
    }
    else {
        [activityIndicator stopAnimating];
        activityIndicator.hidden = YES;
    }
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

- (void)actionRefresh
{
    @autoreleasepool {
        XMLMoreAppsParser *xmlparser = [[XMLMoreAppsParser alloc] init];
        self.arrayApps = xmlparser.arrayApps;
        [self performSelectorOnMainThread:@selector(actionReload) withObject:nil waitUntilDone:NO];
    }
}

- (void)actionReload
{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    [appsTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger nCount = 0;
    if (self.arrayApps) {
        nCount = self.arrayApps.count;
        nCount = (nCount >=1) ? nCount - 1 : nCount;
    }
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%ld_%ld", indexPath.section, indexPath.row];
    
    MoreAppsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed: @"MoreAppsTableCell" owner: nil options: nil] objectAtIndex: 0];
        [cell.lblName setFont:fontBold];
        [cell.lblFeature setFont:fontRegular];
        cell.imgIcon.layer.masksToBounds = YES;
        cell.imgIcon.layer.cornerRadius = 8;
        // cell.imgIcon.layer.borderWidth=1;
        
    }
    
    if (indexPath.row % 2) {
        [cell.imgBg setImage:imageTableBg1];
        [cell.lblFeature setTextColor:[UIColor whiteColor]];
    }
    else {
        [cell.imgBg setImage:imageTableBg0];
        [cell.lblFeature setTextColor:[UIColor colorWithRed:0.4274 green:0.4117 blue:0.3921 alpha:1.0]];
    }
    
    NSMutableDictionary *appData = [self.arrayApps objectAtIndex:indexPath.row];
    if (appData) {
        cell.lblName.text = [appData objectForKey:@"name"];
        cell.lblFeature.text = [appData objectForKey:@"feature"];
        
        NSData *imageData = [appData objectForKey:@"imageData"];
        if (imageData) {
            cell.imgIcon.image = [UIImage imageWithData:imageData];
        }
        else {
            NSDictionary *dicParameter = [NSDictionary dictionaryWithObjectsAndKeys:cell, @"cell",
                                          [NSString stringWithFormat:@"%ld", (long)indexPath.row], @"index", nil];
            [NSThread detachNewThreadSelector:@selector(setImageToCell:) toTarget:self withObject:dicParameter];
        }
    }
    
    return cell;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setImageToCell:(NSDictionary *)dicParameter
{
    @autoreleasepool {
        MoreAppsTableCell *cell = [dicParameter objectForKey:@"cell"];
        NSString *strIndex = [dicParameter objectForKey:@"index"];
        
        if (cell == nil || strIndex == nil) {
            return;
        }
        
        NSMutableDictionary *appData = [self.arrayApps objectAtIndex:strIndex.intValue];
        
        NSString *imageUrl = [[appData objectForKey:@"icon_link"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *datImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        if (datImage) {
            UIImage *image = [self imageWithImage:[UIImage imageWithData:datImage] scaledToSize:CGSizeMake(140, 140)];
            
            datImage = UIImageJPEGRepresentation(image, 0);
            
            [appData setObject:datImage forKey:@"imageData"];
            [cell.imgIcon performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            //[self performSelectorOnMainThread:@selector(setImageToCell:) withObject:dicParameter waitUntilDone:NO];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *appData = [self.arrayApps objectAtIndex:indexPath.row];
    NSString *strLink = [appData objectForKey:@"link"];
    //NSLog(@"%@", strLink);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strLink]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [Flurry logEvent:@"More Apps Select"];
}

- (BOOL)checkNetworkStatus
{
	NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
	switch (internetStatus) {
		case NotReachable:
			self.isInternetActive = NO;
			break;
            
		case ReachableViaWiFi:
			self.isInternetActive = YES;
			break;
            
		case ReachableViaWWAN:
			self.isInternetActive = YES;
			break;
	}
	
	if (self.isInternetActive == NO) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"No internet available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
        
	} else {
        // [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    }
    return self.isInternetActive;
}

@end
