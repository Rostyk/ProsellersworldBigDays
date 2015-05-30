//
//  PurchaseImageViewController.m
//  CountDownApp
//
//  Created by Felton on 4/5/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "PurchaseImageViewController.h"
#import "PurchaseManager.h"
#import "BDCommon.h"

@interface PurchaseImageViewController ()

@end

@implementation PurchaseImageViewController

@synthesize lblTitle;
@synthesize scrImages;
@synthesize addViewController;
@synthesize purchaseIndex;
@synthesize btnBack;

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
    [self configButtons];
    
    lblTitle.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:26];
    
    NSMutableArray *arrayPurchase = [PurchaseManager sharedInstance].arrayPurchase;
    NSMutableDictionary *item = [arrayPurchase objectAtIndex:purchaseIndex];
    lblTitle.text = NSLocalizedString([item objectForKey:@"title"], nil);
    
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    btnBack.titleLabel.font = SMALL_BUTTON_FONT;
    btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.5, 8, 0, 0);
    
    isTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configButtons
{
    NSMutableDictionary *item = [[PurchaseManager sharedInstance].arrayPurchase objectAtIndex:purchaseIndex];
    NSString *imagePrefix = [item objectForKey:@"title"];
    for (int i = 0; i < 32; i++) {
        /*
        UIButton *button = (UIButton*)[self.view viewWithTag:i + 100];
        if ([button isKindOfClass:[UIButton class]] == NO)
            continue;
        */
        
        int row = i % 4, col = i / 4;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(row * 79, col * 100, 76, 96);
        button.tag = i + 100;
        [button addTarget:self action:@selector(onSelectImage:) forControlEvents:UIControlEventTouchUpInside];
        [scrImages addSubview:button];
        
        NSString *index = [NSString stringWithFormat:@"%d", i + 1];
        if (i < 9)
            index = [NSString stringWithFormat:@"0%d", i + 1];
        NSString *fileName = [NSString stringWithFormat:@"%@ iPhone4-Thumb-%@.png", imagePrefix, index];
        UIImage *image = [UIImage imageNamed:fileName];
        if (image == nil)
        {
            fileName = [NSString stringWithFormat:@"%@ iPhone5-Thumb-%@.png", imagePrefix, index];
            image = [UIImage imageNamed:fileName];
        }
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    scrImages.contentSize = CGSizeMake(312, 8 * 100);
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSelectImage:(UIButton *)sender
{
    NSMutableDictionary *item = [[PurchaseManager sharedInstance].arrayPurchase objectAtIndex:purchaseIndex];
    NSString *imagePrefix = [item objectForKey:@"title"];
    //Anniversaries iPhone4 Full-1.jpg
    NSString *strImageName = [NSString stringWithFormat:@"%@ iPhone4-Full-Screen-%d.jpg", imagePrefix, sender.tag - 100 + 1];
    UIImage *image = [UIImage imageNamed:strImageName];
    if (image == nil)
    {
        strImageName = [NSString stringWithFormat:@"%@ iPhone5-Full-Screen-%d.jpg", imagePrefix, sender.tag - 100 + 1];
        image = [UIImage imageNamed:strImageName];
    }
    NSData *imageData = nil;
    if (image) {
        imageData = UIImageJPEGRepresentation(image, 0);
    }
    [addViewController.dicDayInfo setObject:imageData forKey:@"imagedata"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
