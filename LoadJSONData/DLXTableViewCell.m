//
//  DLXTableViewCell.m
//  LoadJSONData
//
//  Created by admin on 15/9/17.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "DLXTableViewCell.h"

@implementation DLXTableViewCell
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(10, 5, 70, 70)];
    [self.textLabel setFrame:CGRectMake(90, 10, 180, 30)];
    [self.detailTextLabel setFrame:CGRectMake(90, 50, 150, 20)];
    [_priceLabel setFrame:CGRectMake(240, 30, 70, 20)];

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _priceLabel  = [[UILabel alloc]init];
        [self.textLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [self.textLabel setTextColor:[UIColor blackColor]];
        [self.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [self.priceLabel setTextAlignment:NSTextAlignmentRight];
        [self.priceLabel setTextColor:[UIColor redColor]];
        [_priceLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [self.contentView addSubview:_priceLabel];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        [self setBackgroundColor:[UIColor blueColor]];
    }
    else
        [self setBackgroundColor:[UIColor whiteColor]];

}
@end
