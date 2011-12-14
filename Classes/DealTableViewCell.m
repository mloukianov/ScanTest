//
//  DealTableViewCell.m
//  ScanTest
//
//  Created by Max Loukianov on 12/4/11.
//  Copyright (c) 2011 Freelink Wireless Services. All rights reserved.
//

#import "DealTableViewCell.h"

@implementation DealTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
