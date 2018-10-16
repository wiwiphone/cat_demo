//
//  GoodsBrandCell.m
//  XianMao
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsBrandCell.h"
#import "Masonry.h"
#import "DataSources.h"

@interface GoodsBrandCell ()

@property (nonatomic, strong) XMWebImageView *mainImageView;
@property (nonatomic, strong) UILabel *descLbl;

//@property (nonatomic, strong) UIView *leftLineView;
//@property (nonatomic, strong) UIView *rightLineView;
//@property (nonatomic, strong) UILabel *titleLbl;
//@property (nonatomic, strong) UILabel *titleContentLbl;

@end

@implementation GoodsBrandCell

//-(UILabel *)titleContentLbl{
//    if (!_titleContentLbl) {
//        _titleContentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleContentLbl.font = [UIFont systemFontOfSize:14];
//        _titleContentLbl.textColor = [UIColor colorWithHexString:@"c3c3c3"];
//        _titleContentLbl.text = @"丨Brand story";
//        [_titleContentLbl sizeToFit];
//    }
//    return _titleContentLbl;
//}
//
//-(UILabel *)titleLbl{
//    if (!_titleLbl) {
//        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLbl.font = [UIFont systemFontOfSize:14];
//        _titleLbl.textColor = [UIColor colorWithHexString:@"4c4c4c"];
//        _titleLbl.text = @"品牌故事";
//        [_titleLbl sizeToFit];
//    }
//    return _titleLbl;
//}

//-(UIView *)rightLineView{
//    if (!_rightLineView) {
//        _rightLineView = [[UIView alloc] initWithFrame:CGRectZero];
//        _rightLineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    }
//    return _rightLineView;
//}
//
//-(UIView *)leftLineView{
//    if (!_leftLineView) {
//        _leftLineView = [[UIView alloc] initWithFrame:CGRectZero];
//        _leftLineView.backgroundColor = [UIColor colorWithHexString:@"c9c9c9"];
//    }
//    return _leftLineView;
//}

-(UILabel *)descLbl{
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLbl.font = [UIFont systemFontOfSize:15.f];
        _descLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _descLbl.numberOfLines = 0;
        [_descLbl sizeToFit];
    }
    return _descLbl;
}

-(XMWebImageView *)mainImageView{
    if (!_mainImageView) {
        _mainImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _mainImageView.userInteractionEnabled = YES;
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _mainImageView.clipsToBounds = YES;
    }
    return _mainImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsBrandCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
//    height += 45;
//    height += 20;
    BrandInfo *brandInfo = dict[@"brandInfo"];
//    XMWebImageView *mainImageView = [[XMWebImageView alloc] init];
//    [mainImageView setImageWithURL:brandInfo.iconUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
//    height += mainImageView.height;
    
    CGSize size=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:brandInfo.iconUrl]]].size;
    height += size.height;
    height += 10;
//    UILabel *lbl = [[UILabel alloc] init];
//    lbl.font = [UIFont systemFontOfSize:14.f];
//    lbl.text = brandInfo.brandDesc;
//    [lbl sizeToFit];
//    lbl.frame = CGRectMake(15, height, kScreenWidth - 30, lbl.height);
//    lbl.numberOfLines = 0;
//    CGSize titleSize = [brandInfo.brandDesc sizeWithFont:[UIFont systemFontOfSize:14.f] constrainedToSize:CGSizeMake(lbl.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
//    height += titleSize.height;
    NSDictionary *Tdic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f],NSFontAttributeName, nil];
    
    CGRect  rect  = [brandInfo.brandDesc boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:Tdic context:nil];
    height += rect.size.height+20;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(BrandInfo *)brandInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsBrandCell class]];
    if (brandInfo)[dict setObject:brandInfo forKey:@"brandInfo"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        [self.contentView addSubview:self.leftLineView];
//        [self.contentView addSubview:self.rightLineView];
//        [self.contentView addSubview:self.titleLbl];
        
        
        [self.contentView addSubview:self.mainImageView];
        [self.contentView addSubview:self.descLbl];
        
//        [self.contentView addSubview:self.titleContentLbl];
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    
//    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(12);
//        make.top.equalTo(self.contentView.mas_top).offset(15);
//    }];
//    
//    [self.titleContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLbl.mas_right).offset(8);
//        make.centerY.equalTo(self.titleLbl.mas_centerY);
//    }];
//    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.left.equalTo(self.contentView.mas_left).offset(12);
//        make.right.equalTo(self.contentView.mas_right).offset(-12);
//        make.height.equalTo(@0.5);
//    }];
    
//    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.titleLbl.mas_bottom).offset(20);
//        make.left.equalTo(self.contentView.mas_left);
//        make.right.equalTo(self.contentView.mas_right);
//        make.height.equalTo(@0.5);
//    }];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    BrandInfo *brandInfo = dict[@"brandInfo"];
    [self.mainImageView setImageWithURL:brandInfo.iconUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.descLbl.text = brandInfo.brandDesc;
    
}

@end
