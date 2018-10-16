//
//  GoodsDetailPictureCell.m
//  XianMao
//
//  Created by simon on 1/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "GoodsDetailPictureCell.h"
#import "CoordinatingController.h"

#import "GoodsDetailInfo.h"
#import "DataSources.h"
#import "Masonry.h"

@interface GoodsDetailPictureCell ()

@property(nonatomic,retain) UILabel *descLbl;
@end

@implementation GoodsDetailPictureCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsDetailPictureCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    NSObject *obj = [dict objectForKey:[self cellDictKeyForGoodsPicture]];
    if ([obj isKindOfClass:[GoodsDetailPicItem class]]) {
        GoodsDetailPicItem *item = (GoodsDetailPicItem*)obj;
        height = [GoodsDetailPictureCell calculateHeightAndLayoutSubviews:nil item:item];
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsDetailPicItem*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsDetailPictureCell class]];
    if (item)[dict setObject:item forKey:@"item"];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsPicture {
    return @"item";
}

- (void)dealloc
{
    self.picView = nil;
    self.descLbl = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.picView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        self.picView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        self.picView.contentMode = UIViewContentModeScaleAspectFill;
        self.picView.clipsToBounds = YES;
        [self.contentView addSubview:self.picView];
        
//        _picView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
//            
//        };
        
        self.descLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.descLbl.backgroundColor = [UIColor clearColor];
        self.descLbl.textColor = [UIColor colorWithHexString:@"333333"];
        self.descLbl.font = [UIFont systemFontOfSize:11.f];
        self.descLbl.numberOfLines = 0;
        //        [self.descLbl setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateDisabled];
        //        self.descLbl.titleLabel.font = [UIFont systemFontOfSize:11.f];
        //        self.descLbl.enabled = NO;
        //        self.descLbl.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.descLbl];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.picView.frame = CGRectNull;
    self.descLbl.frame = CGRectNull;
}

+ (CGFloat)calculateHeightAndLayoutSubviews:(GoodsDetailPictureCell*)cell item:(GoodsDetailPicItem*)item
{
    CGFloat marginTop = 0.f;
    
    //marginTop += 19.f;
    
    CGFloat height = 0;
    if (item && [item.picUrl length]>0
        && item.width>0 && item.height>0) {
        marginTop += 12;
        height = item.height * kScreenWidth/item.width;
        marginTop += height;
        
    } else if (cell && cell.picView.height>0) {
        marginTop += 12;
        cell.picView.frame = CGRectMake(0, marginTop, kScreenWidth, cell.picView.height);
        height = cell.picView.height;
        marginTop += height;
    }
    
    NSString *descString = cell?cell.descLbl.text:item.picDescription;
    if (descString && descString.length > 0) {
        marginTop += 12;
        CGSize descSize = [descString sizeWithFont:[UIFont systemFontOfSize:11.f]
                                 constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                     lineBreakMode:NSLineBreakByWordWrapping];
        if (cell)cell.descLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, descSize.height);
        marginTop += descSize.height;
        marginTop += 12;
    }
    
    return marginTop;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    NSObject *obj = [dict objectForKey:[[self class] cellDictKeyForGoodsPicture]];
    if ([obj isKindOfClass:[GoodsDetailPicItem class]]) {
        GoodsDetailPicItem *picItem = (GoodsDetailPicItem*)obj;
        
//        if ([picItem.picDescription length]>0) {
//            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"▲  %@",picItem.picDescription]];
//            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"D0B87F"] range:NSMakeRange(0, 1)];
//            self.descLbl.attributedText = attrString;
//        }
        self.descLbl.text = picItem.picDescription;
        
        CGFloat height= 0.f;
        if ([picItem.picUrl length]>0 && picItem.width>0 && picItem.height>0) {
            height = picItem.height * kScreenWidth/picItem.width;
        }
        self.picView.frame = CGRectMake(0, 0, kScreenWidth, height);
        
        
        [self.picView setImageWithURL:picItem.picUrl placeholderImage:nil size:CGSizeMake(kScreenWidth*2, kScreenWidth*height/320*2) progressBlock:nil succeedBlock:nil failedBlock:nil];

        [GoodsDetailPictureCell calculateHeightAndLayoutSubviews:self item:nil];
    }
}


@end



@interface GoodsDetailTitleCell ()
@property(nonatomic,retain) UILabel *titleLbl;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
//@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *titleContentLbl;

@property (nonatomic, strong) UIImageView *promptArrowhead;
@end

@implementation GoodsDetailTitleCell

-(UIImageView *)promptArrowhead{
    if (!_promptArrowhead) {
        _promptArrowhead = [[UIImageView alloc] initWithFrame:CGRectZero];
        _promptArrowhead.image = [UIImage imageNamed:@"GoodsDown"];
        [_promptArrowhead sizeToFit];
    }
    return _promptArrowhead;
}

-(UILabel *)titleContentLbl{
    if (!_titleContentLbl) {
        _titleContentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleContentLbl.font = [UIFont systemFontOfSize:14.f];
        _titleContentLbl.textColor = [UIColor colorWithHexString:@"c3c3c3"];
        [_titleContentLbl sizeToFit];
        _titleContentLbl.text = @"丨Production information";
    }
    return _titleContentLbl;
}

-(UIView *)rightView{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightView.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"];
    }
    return _rightView;
}

-(UIView *)leftView{
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftView.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"];
    }
    return _leftView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsDetailTitleCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 50.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSString*)title isOpen:(NSInteger)isOpen b2cOrc2c:(NSInteger)b2cOrc2c;
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsDetailTitleCell class]];
    if (title)[dict setObject:title forKey:[self cellDictKeyForTitle]];
    [dict setObject:@(isOpen) forKey:@"isOpen"];
    [dict setObject:@(b2cOrc2c) forKey:@"b2cOrc2c"];
    return dict;
}

+ (NSString*)cellDictKeyForTitle {
    return @"title";
}

- (void)dealloc
{
    self.titleLbl = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];//[UIColor colorWithHexString:@"E2BB66"];
        _titleLbl.numberOfLines = 1;
        _titleLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLbl];
        [self.contentView addSubview:self.leftView];
        [self.contentView addSubview:self.rightView];
        [self.contentView addSubview:self.titleContentLbl];
        [self.contentView addSubview:self.promptArrowhead];
//        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
//        _bottomLine.backgroundColor = [UIColor redColor];//[UIColor colorWithHexString:@"F7F7F7"];
//        [self.contentView addSubview:_bottomLine];
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleLbl.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _bottomLine.frame = CGRectMake(25, kScreenHeight - 1, kScreenWidth - 50, 100);
    _titleLbl.frame = CGRectMake(25, 0, self.contentView.width-30, self.contentView.height);
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake((kScreenWidth-_titleLbl.width)/2, (self.contentView.height-_titleLbl.height)/2, _titleLbl.width, _titleLbl.height);
    
//    [self.titleContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLbl.mas_right).offset(8);
//        make.centerY.equalTo(self.titleLbl.mas_centerY);
//    }];
    
//    [self.promptArrowhead mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.right.equalTo(self.contentView.mas_right).offset(-12);
//    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.right.equalTo(self.titleLbl.mas_left).offset(-12);
        make.width.equalTo(@36);
        make.height.equalTo(@1);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.left.equalTo(self.titleLbl.mas_right).offset(12);
        make.width.equalTo(@36);
        make.height.equalTo(@1);
    }];
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    NSInteger isOpen = ((NSNumber *)dict[@"isOpen"]).integerValue;
    if (isOpen == 1) {
        self.userInteractionEnabled = YES;
        self.promptArrowhead.hidden = NO;
        self.promptArrowhead.image = [UIImage imageNamed:@"GoodsUp"];
    } else if (isOpen == 0) {
        self.userInteractionEnabled = YES;
        self.promptArrowhead.hidden = NO;
        self.promptArrowhead.image = [UIImage imageNamed:@"GoodsDown"];
    } else {
        self.promptArrowhead.hidden = YES;
        self.userInteractionEnabled = NO;
    }
    
    NSInteger b2cOrc2c = ((NSNumber *)dict[@"b2cOrc2c"]).integerValue;
    
    if (b2cOrc2c == 1) {
        self.promptArrowhead.hidden = YES;
    }else{
        self.promptArrowhead.hidden = NO;
    }
    
    NSString *title = [dict objectForKey:[[self class] cellDictKeyForTitle]];
    if ([title isKindOfClass:[NSString class]]) {
        _titleLbl.text = title;
        [self setNeedsLayout];
    }
}


@end



