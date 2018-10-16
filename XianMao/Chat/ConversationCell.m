//
//  ConversationCell.m
//  XianMao
//
//  Created by simon on 1/2/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ConversationCell.h"

@interface ConversationCell (){
    UILabel *_timeLabel;
    UILabel *_unreadLabel;
    UILabel *_detailLabel;

}
@end

@implementation ConversationCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80 -15, 23, 80, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 8, 20, 20)];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = [UIColor whiteColor];
        
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 10;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
//        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 42, 175, 20)];
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 42, 175, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:15.f];
        
       
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(66, 0, self.contentView.frame.size.width, 1)];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _lineView.backgroundColor = RGBACOLOR(207, 210, 213, 0.7);
        _lineView.hidden = NO;
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    //[self.imageView setImage:_placeholderImage];
    self.imageView.frame = CGRectMake(15, 20, 43, 43);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.f;
    self.imageView.clipsToBounds = YES;
    
    self.textLabel.text = _name;
//    self.textLabel.frame = CGRectMake(65, 21, 175, 20);
    self.textLabel.frame = CGRectMake(70, 21, 175, 20);
    
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    CGFloat labelWidth = [_timeLabel.text
                                boundingRectWithSize:_timeLabel.frame.size
                                options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{ NSFontAttributeName:_timeLabel.font }
                                context:nil].size.width;
    _timeLabel.frame = CGRectMake(kScreenWidth - labelWidth - 15, 23, 80, 16) ;
    if (_unreadCount > 0) {
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%d",_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
    
    frame = _lineView.frame;
    frame.origin.y = self.contentView.frame.size.height - 1;
    _lineView.frame = frame;
}

-(void)setName:(NSString *)name{
    _name = name;
    self.textLabel.text = name;
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}
@end

