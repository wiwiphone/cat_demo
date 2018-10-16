//
//  GoodsPictureCell.m
//  XianMao
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsPictureCell.h"

@interface GoodsPictureCell ()

@property (nonatomic, strong) XMWebImageView *picImageView;
@property (nonatomic, strong) PictureItem *item;

@end

@implementation GoodsPictureCell

-(XMWebImageView *)picImageView{
    if (!_picImageView) {
        _picImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _picImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        [_picImageView setContentMode:UIViewContentModeScaleAspectFill];
        _picImageView.clipsToBounds = YES;
    }
    return _picImageView;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsPictureCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 0;
    
    PictureItem *item = dict[@"item"];
    XMWebImageView *imageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
    [imageView setImageWithURL:item.picUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    [imageView sizeToFit];
    height += (kScreenWidth-24)*item.height/item.width;// imageView.height;
//    height += item.height;
//    if (height > 0) {
//        height -= 100;
//    }
    
//    NSLog(@"%.2f------%ld--------%ld", height, item.height, item.width);
    
    return (!isnan(height))?height:0;
}

+ (NSMutableDictionary*)buildCellDict:(PictureItem *)item index:(NSInteger)index
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsPictureCell class]];
    if (item) {
        [dict setObject:item forKey:@"item"];
    }
    [dict setObject:@(index) forKey:@"index"];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WEAKSELF;
        [self.contentView addSubview:self.picImageView];
        
        self.picImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
            if (weakSelf.showPicDetail) {
                weakSelf.showPicDetail(view);
            }
        };
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(12);
//        make.left.equalTo(self.contentView.mas_left).offset(12);
//        make.right.equalTo(self.contentView.mas_right).offset(-12);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//    }];
    
    if (self.item.height > 0) {
        self.picImageView.frame = CGRectMake(12, 0, kScreenWidth-24, (kScreenWidth-24)*self.item.height/self.item.width);
    }
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    PictureItem *item = dict[@"item"];
    self.item = item;
    NSInteger index = ((NSNumber *)dict[@"index"]).integerValue;
    self.picImageView.tag = index;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/3/w/%ld/h/%ld/q/90", item.picUrl, (NSInteger)(kScreenWidth-24), (NSInteger)((kScreenWidth-24)*item.height/item.width)]] placeholderImage:nil];//setImageWithURL:[NSString stringWithFormat:@"%@?imageView2/3/w/200/h/100/q/90", item.picUrl] placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    
    
}

@end
