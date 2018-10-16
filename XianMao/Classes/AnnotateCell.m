//
//  AnnotateCell.m
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "AnnotateCell.h"
#import "RTLabel.h"

@interface AnnotateCell ()

@property (nonatomic, strong) RTLabel *annotateLbl;

@end

@implementation AnnotateCell

-(RTLabel *)annotateLbl{
    if (!_annotateLbl) {
        _annotateLbl = [[RTLabel alloc] initWithFrame:CGRectZero];
        _annotateLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _annotateLbl.font = [UIFont systemFontOfSize:15.f];
        _annotateLbl.textAlignment = RTTextAlignmentCenter;
        [_annotateLbl sizeToFit];
    }
    return _annotateLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([AnnotateCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    InvitationVo *invationVo = dict[@"invationVo"];
    
//    CGSize sizeToFit = [[NSString stringWithFormat:@"%@", invationVo.notice] sizeWithFont:[UIFont systemFontOfSize:15.f] constrainedToSize:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    NSDictionary *Tdic  = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f],NSFontAttributeName, nil];
    CGRect  rect  = [invationVo.notice boundingRectWithSize:CGSizeMake(kScreenWidth-55, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:Tdic context:nil];
    height += rect.size.height;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(InvitationVo *)invationVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[AnnotateCell class]];
    if (invationVo)[dict setObject:invationVo forKey:@"invationVo"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.annotateLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.annotateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(55/2);
        make.right.equalTo(self.contentView.mas_right).offset(-55/2);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    InvitationVo *invationVo = dict[@"invationVo"];
    self.annotateLbl.text = [NSString stringWithFormat:@"%@", invationVo.notice];
}

@end
