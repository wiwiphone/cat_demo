/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "EMChatTimeCell.h"

@implementation EMChatTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:12.f];
    self.textLabel.textColor = [UIColor whiteColor];  //根据需求修改chat时间字体颜色 2016.4.19 Feng
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    
    self.textLabel.frame = CGRectMake(kScreenWidth/2-self.textLabel.width/2, self.height/2-self.textLabel.height/2, self.textLabel.width+15, self.textLabel.height+6);
    self.textLabel.backgroundColor = [UIColor colorWithHexString:@"b2b2b2"];
    self.textLabel.layer.masksToBounds = YES;
    self.textLabel.layer.cornerRadius = self.textLabel.height/2;
}
@end



@implementation EMChatTimeCell1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
//    self.backgroundColor = [UIColor clearColor];
//    self.textLabel.backgroundColor = [UIColor clearColor];
//    self.textLabel.textAlignment = NSTextAlignmentCenter;
//    self.textLabel.font = [UIFont systemFontOfSize:9.f];
//    self.textLabel.textColor = [UIColor colorWithHexString:@"898989"];  //根据需求修改chat时间字体颜色 2016.4.19 Feng
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, kScreenWidth-50, 50)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor colorWithHexString:@"434342"];
    lbl.font = [UIFont systemFontOfSize:13.f];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:lbl];
    
    self.onLineLbl = lbl;
    
//    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(lbl.mas_centerX);
//        make.centerY.equalTo(lbl.mas_centerY);
//        make.width.equalTo(@(kScreenWidth-50));
//    }];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
