//
//  PurchaseViewController.m
//  CountDownApp
//
//  Created by ALIAD on 4/3/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "PurchaseViewController.h"
#import "PurchaseManager.h"
#import "InAppPurchaseObserver.h"
#import "ActivityIndicator.h"
#import "BDCommon.h"

@interface PurchaseViewController () <InAppPurchaseObserverDelegate, SKPaymentTransactionObserver>
{
    InAppPurchaseObserver *purchaseObserver;
    BOOL isProcessPurchase;
    BOOL isUnlockAll;
}

@end

@implementation PurchaseViewController

@synthesize lblTitle;
@synthesize lblName;
@synthesize lblUnlock;
@synthesize purchaseIndex;
@synthesize viewUnlockAll;
@synthesize imgIcon;
@synthesize btnRestoreAll;
@synthesize btnBack;
@synthesize btnUnlockAll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    purchaseObserver.delegate = nil;
    purchaseObserver = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lblTitle.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:26];
    lblName.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:20];
    lblUnlock.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];

    [btnRestoreAll setTitle:NSLocalizedString(@"Restore", nil) forState:UIControlStateNormal];
    btnRestoreAll.titleLabel.font = SMALL_BUTTON_FONT;
    btnRestoreAll.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnRestoreAll.titleEdgeInsets = UIEdgeInsetsMake(8.5, 0, 0, 0);
    
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    btnBack.titleLabel.font = SMALL_BUTTON_FONT;
    btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.5, 8, 0, 0);
    
    [btnUnlockAll setTitle:NSLocalizedString(@"Unlock All Images", nil) forState:UIControlStateNormal];
    btnUnlockAll.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnUnlockAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnUnlockAll.titleEdgeInsets = UIEdgeInsetsMake(9.5, 50, 0, 0);
    
    NSMutableArray *arrayPurchase = [PurchaseManager sharedInstance].arrayPurchase;
    NSMutableDictionary *item = [arrayPurchase objectAtIndex:purchaseIndex];
    lblTitle.text = NSLocalizedString([item objectForKey:@"title"], nil);
    lblName.text = NSLocalizedString([item objectForKey:@"title"], nil);
    if ([[item objectForKey:@"purchase"] boolValue] == NO)
        lblUnlock.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Unlock", nil), NSLocalizedString([item objectForKey:@"title"], nil)];
    else
        lblUnlock.hidden = YES;
    
    imgIcon.image = [UIImage imageNamed:[item objectForKey:@"icon"]];
    
    BOOL isPurchase = YES;
    for (int i = 0; i < arrayPurchase.count; i++)
    {
        NSMutableDictionary *item = [arrayPurchase objectAtIndex:i];
        if ([[item objectForKey:@"purchase"] boolValue] == NO)
        {
            isPurchase = NO;
            break;
        }
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"LOCKED_ALL"] == YES && isPurchase == NO)
        viewUnlockAll.hidden = YES;
    
    isTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initObserver
{
    /*
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    purchaseObserver.delegate = nil;
    */
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onUnlockAll:(id)sender
{
    //Purchase this image item ALL_IMAGES
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    if (purchaseObserver == nil)
        purchaseObserver = [[InAppPurchaseObserver alloc] init];
    
    purchaseObserver.delegate = self;
    [purchaseObserver requestPurchaseWithProductIndentifier:@"ALL_IMAGES"];
    
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"Purchasing...", nil) isLock:YES];
    
    isProcessPurchase = YES;
    isUnlockAll = YES;
}

- (IBAction)onUnlock:(id)sender
{
    //Purchase all images
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    NSMutableDictionary *item = [[PurchaseManager sharedInstance].arrayPurchase objectAtIndex:purchaseIndex];
    NSString *identifier = [item objectForKey:@"product"];
    if (purchaseObserver == nil)
        purchaseObserver = [[InAppPurchaseObserver alloc] init];
    
    purchaseObserver.delegate = self;
    [purchaseObserver requestPurchaseWithProductIndentifier:identifier];
    
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"Purchasing...", nil) isLock:YES];
    
    isProcessPurchase = YES;
    isUnlockAll = NO;
}

- (IBAction)onRestore:(id)sender
{
    if (purchaseObserver)
        purchaseObserver.delegate = nil;
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"Restoring...", nil) isLock:YES];
    
    isProcessPurchase = YES;
}

#pragma mark - InAppPurchaseObserverDelegate
- (void)didFinishPurchaseResult:(BOOL)status error:(NSError *)error
{
    [[ActivityIndicator currentIndicator] hide];
    
    if (isProcessPurchase == NO)
        return;
    
    isProcessPurchase = NO;
    if (status == YES)
    {
        if (isUnlockAll == YES)
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:YES forKey:@"LOCKED_ALL"];
            [userDefault synchronize];
        }
        else
        {
            NSMutableArray *arrayPurchase = [PurchaseManager sharedInstance].arrayPurchase;
            NSMutableDictionary *item = [arrayPurchase objectAtIndex:purchaseIndex];
            [item setObject:[NSNumber numberWithBool:YES] forKey:@"purchase"];
            [arrayPurchase replaceObjectAtIndex:purchaseIndex withObject:item];
            
            [[PurchaseManager sharedInstance] setPurchaseInfo:arrayPurchase];
        }
        
        NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Purchase was successful.", nil), NSLocalizedString(@"Thank you.", nil)];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Purchase failed.", nil), NSLocalizedString(@"Please try again.", nil)];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    [[ActivityIndicator currentIndicator] hide];
    
    if (isProcessPurchase == NO)
        return;
    
    isProcessPurchase = NO;
    
    NSMutableArray *arrayPurchases = [[PurchaseManager sharedInstance] arrayPurchase];
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSString *product = transaction.payment.productIdentifier;
        if ([product isEqualToString:@"ALL_IMAGES"])
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:YES forKey:@"LOCKED_ALL"];
            [userDefault synchronize];
            
            continue;
        }
        
        for (int i = 0; i < arrayPurchases.count; i++)
        {
            NSMutableDictionary *item = [arrayPurchases objectAtIndex:i];
            NSString *identifier = [item objectForKey:@"product"];
            if ([product isEqualToString:identifier])
            {
                [item setObject:[NSNumber numberWithBool:YES] forKey:@"purchase"];
                [arrayPurchases replaceObjectAtIndex:i withObject:item];
                [[PurchaseManager sharedInstance] setPurchaseInfo:arrayPurchases];
                break;
            }
        }
    }
    
    NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Restore was successful.", nil), NSLocalizedString(@"Thank you.", nil)];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    
    //[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [[ActivityIndicator currentIndicator] hide];
    
    if (isProcessPurchase == NO)
        return;
    
    isProcessPurchase = NO;
    
    NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Restore failed.", nil), NSLocalizedString(@"Please try again.", nil)];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    
    //[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [[ActivityIndicator currentIndicator] hide];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [[ActivityIndicator currentIndicator] hide];
}

// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    [[ActivityIndicator currentIndicator] hide];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

@end
