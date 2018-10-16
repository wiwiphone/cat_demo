//
//  ShoppingCartNocontentCell.m
//  XianMao
//
//  Created by Marvin on 2017/4/1.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ShoppingCartNocontentCell.h"
#import "Command.h"

@implementation ShoppingCartNocontentCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ShoppingCartNocontentCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat rowHeight = 300;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ShoppingCartNocontentCell class]];
    return dict;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"shoppingCar_no_content_new"];
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView.mas_top).offset(80);
        }];
        
        UILabel * lbl = [[UILabel alloc] init];
        lbl.text = @"您还未添加任何商品";
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [lbl sizeToFit];
        [self.contentView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(imageView.mas_bottom).offset(28);
        }];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];

    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary*)dict{
    
}

@end
