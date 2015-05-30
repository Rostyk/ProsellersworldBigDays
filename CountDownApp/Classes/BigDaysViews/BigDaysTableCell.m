//
//  BigDaysTableCell.m
//  CountDownApp
//
//  Created by Eagle on 11/2/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BigDaysTableCell.h"
#import "BDCommon.h"

@implementation BigDaysTableCell

@synthesize titleLabel;
@synthesize dateLabel;
@synthesize thumbImageView;
@synthesize bgImageView;
@synthesize flipView;

@synthesize lblDays;
@synthesize lblHours;
@synthesize lblMins;
@synthesize lblSecs;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    /*if (self) {
        flipView = [[JDDateCountdownFlipView alloc] initWithFrame:CGRectMake(84, 30, 196, 23)];
        [self addSubview:flipView];
    }*/
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initFlipView
{
    if (self) {
        flipView = [[JDDateCountdownFlipView alloc] initWithType:0];
        [self addSubview:flipView];
        [flipView setFlipNumberType:0];
        [flipView setFrame:CGRectMake(76, 26, 220, 23)];
        
        lblHours.text = NSLocalizedString(@"HOURS", nil);
        lblHours.font = SMALL_LABEL_FONT;
        
        lblDays.text = NSLocalizedString(@"DAYS", nil);
        lblDays.font = SMALL_LABEL_FONT;
        
        lblMins.text = NSLocalizedString(@"MINS", nil);
        lblMins.font = SMALL_LABEL_FONT;
        
        lblSecs.text = NSLocalizedString(@"SECS", nil);
        lblSecs.font = SMALL_LABEL_FONT;
        
        titleLabel.font = [UIFont fontWithName:FONT_SEMIBOLD size:15.0];
        dateLabel.font = [UIFont fontWithName:FONT_SEMIBOLD size:15.0];
    }
}

@end
