//
//  BaseViewController.m
//  CountDownApp
//
//  Created by FeltonWang on 9/30/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize viewContents;

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
	// Do any additional setup after loading the view.
    isTabBar = YES;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = viewContents.frame;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        frame.origin.y = 20;
        if (isTabBar == YES)
            frame.size.height = [UIScreen mainScreen].bounds.size.height - 20 - 49;
        else
            frame.size.height = [UIScreen mainScreen].bounds.size.height - 20;
    }
    viewContents.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
