//
//  SeekToPurchaseCell.m
//  XianMao
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SeekToPurchaseCell.h"
#import "SeekToPurchasePublishController.h"

@interface SeekToPurchaseCell ()

@property (nonatomic, strong) XMWebImageView *bgImageView;

@end

@implementation SeekToPurchaseCell

-(XMWebImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.image = [UIImage imageNamed:@"publish_seek"];
    }
    return _bgImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SeekToPurchaseCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait {
    
    CGFloat rowHeight = 135.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SeekToPurchaseCell class]];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bgImageView];
        
        self.bgImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
            SeekToPurchasePublishController *seekController = [[SeekToPurchasePublishController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:seekController animated:YES];
        };
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
}

@end
