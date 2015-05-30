//
//  DefaultImageViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/15/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "DefaultImageViewController.h"
#import "BDCommon.h"

@interface DefaultImageViewController ()

@end

@implementation DefaultImageViewController

@synthesize addViewController;
@synthesize lblImage;
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
    lblImage.font = [UIFont fontWithName:FONT_BOLD size:27.0];
    lblImage.text = NSLocalizedString(@"Image", nil);
    
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

- (IBAction)onSelectImage:(UIButton *)sender
{
    NSString *strImageName = [NSString stringWithFormat:@"default%d.jpg", sender.tag];
    UIImage *image = [UIImage imageNamed:strImageName];
    NSData *imageData = nil;
    if (image) {
        imageData = UIImageJPEGRepresentation(image, 0);
    }
    [addViewController.dicDayInfo setObject:imageData forKey:@"imagedata"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
