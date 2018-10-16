//
//  ShoppingCartDelCell.m
//  XianMao
//
//  Created by Marvin on 2017/5/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ShoppingCartDelCell.h"
#import "Command.h"

@implementation ShoppingCartDelCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ShoppingCartDelCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat rowHeight = 75;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ShoppingCartDelCell class]];
    return dict;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CommandButton *button = [[CommandButton alloc] init];
        [button setTitle:@"清除失效商品" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        button.handleClickBlock = ^(CommandButton *sender) {
            if (self.handleShoppingCartDeleteBlcok) {
                self.handleShoppingCartDeleteBlcok();
            }
        };
        [self.contentView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView.mas_top).offset(30);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
        }];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary*)dict{
    
}

@end
