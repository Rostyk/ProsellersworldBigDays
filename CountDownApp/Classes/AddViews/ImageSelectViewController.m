//
//  ImageSelectViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/14/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "ImageSelectViewController.h"
#import "AppDelegate.h"
#import "DefaultImageViewController.h"
#import "PurchaseManager.h"
#import "PurchaseViewController.h"
#import "PurchaseImageViewController.h"
#import "BDCommon.h"

@interface ImageSelectViewController ()

@end

@implementation ImageSelectViewController

@synthesize addViewController;
@synthesize originalImageData;
@synthesize scrIAPContents;
@synthesize lblTitle;

@synthesize btnBack;
@synthesize btnDone;
@synthesize btnDefault;
@synthesize btnPhotoAlbums;
@synthesize btnCamera;

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
    originalImageData = [addViewController.dicDayInfo objectForKey:@"imagedata"];
    [self configIAPUI];
    
    lblTitle.text = NSLocalizedString(@"Image", nil);
    lblTitle.font = TITLE_FONT;
    
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    btnBack.titleLabel.font = SMALL_BUTTON_FONT;
    btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.5, 8, 0, 0);
    
    [btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    btnDone.titleLabel.font = SMALL_BUTTON_FONT;
    btnDone.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnDone.titleEdgeInsets = UIEdgeInsetsMake(9.5, 0, 0, 0);
    
    [btnDefault setTitle:NSLocalizedString(@"Default Images", nil) forState:UIControlStateNormal];
    btnDefault.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnDefault.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnDefault.titleEdgeInsets = UIEdgeInsetsMake(9, 8, 0, 0);
    
    [btnPhotoAlbums setTitle:NSLocalizedString(@"Photo Albums", nil) forState:UIControlStateNormal];
    btnPhotoAlbums.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnPhotoAlbums.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnPhotoAlbums.titleEdgeInsets = UIEdgeInsetsMake(8, 8, 0, 0);
    
    [btnCamera setTitle:NSLocalizedString(@"Camera", nil) forState:UIControlStateNormal];
    btnCamera.titleLabel.font = MIDDLE_BUTTON_FONT;
    btnCamera.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnCamera.titleEdgeInsets = UIEdgeInsetsMake(8, 8, 0, 0);
    
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
}

- (void)configIAPUI
{
    NSMutableArray *arrayIPAItems = [PurchaseManager sharedInstance].arrayPurchase;
    for (int i = 0; i < arrayIPAItems.count; i++) {
        int row = i / 4;
        int col = i % 4;
        NSMutableDictionary *item = [arrayIPAItems objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:[item objectForKey:@"image"]] forState:UIControlStateNormal];
        button.tag = i;
        [button setFrame:CGRectMake(col * 75, row * 75, 75, 75)];
        [button addTarget:self action:@selector(onPurchaseImage:) forControlEvents:UIControlEventTouchUpInside];
        [scrIAPContents addSubview:button];
        
        UILabel *label = (UILabel*)[scrIAPContents viewWithTag:i + 100];
        label.text = [item objectForKey:@"title"];
    }
    
    for (int i = 0; i < arrayIPAItems.count; i++) {
        int row = i / 4;
        int col = i % 4;
        NSMutableDictionary *item = [arrayIPAItems objectAtIndex:i];
        UILabel *label = (UILabel*)[scrIAPContents viewWithTag:i + 100];
        label.text = NSLocalizedString([item objectForKey:@"title"], nil);
        label.text = [label.text uppercaseString];
        [label setFrame:CGRectMake(col * 75, row * 75 + 50, 75, 25)];
        label.font = [UIFont fontWithName:FONT_SEMIBOLD size:9.0];
        [scrIAPContents bringSubviewToFront:label];
    }
}

- (IBAction)onPurchaseImage:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSMutableArray *arrayPurchase = [PurchaseManager sharedInstance].arrayPurchase;
    NSMutableDictionary *item = [arrayPurchase objectAtIndex:button.tag];
    BOOL isPurchased = [[item objectForKey:@"purchase"] boolValue];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"LOCKED_ALL"] || isPurchased == YES)
    {
        PurchaseImageViewController *viewController = [[PurchaseImageViewController alloc] init];
        viewController.addViewController = self.addViewController;
        viewController.purchaseIndex = button.tag;
        [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
        return;
    }
    PurchaseViewController *viewController = [[PurchaseViewController alloc] init];
    viewController.purchaseIndex = button.tag;
    [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onDefaultImages:(id)sender
{
    DefaultImageViewController *viewController = [DefaultImageViewController new];
    viewController.addViewController = self.addViewController;
    [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onPhotoAlbums:(id)sender
{
    UIImagePickerController* pController = [[UIImagePickerController alloc] init];
	pController.delegate = self;
	pController.allowsEditing = NO;
	pController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController: pController animated: YES];
}

- (IBAction)onCamera:(id)sender
{
    UIImagePickerController* pController = [[UIImagePickerController alloc] init];
	pController.delegate = self;
	pController.allowsEditing = YES;
	pController.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController: pController animated: YES];
}

- (IBAction)onBack:(id)sender
{
    [addViewController.dicDayInfo setObject:originalImageData forKey:@"imagedata"];
    [APP_DELEGATE.viewController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    [APP_DELEGATE.viewController.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage* image = [info objectForKey: UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [addViewController.dicDayInfo setObject:imageData forKey:@"imagedata"];
	
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	// Dismiss the image selection and close the program
	[picker dismissModalViewControllerAnimated:YES];
}

@end
