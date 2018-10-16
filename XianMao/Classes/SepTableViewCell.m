//
//  SepTableViewCell.m
//  XianMao
//
//  Created by simon cai on 11/11/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "SepTableViewCell.h"
#import "Command.h"
#import "GoodsInfo.h"

@implementation SepTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 10;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepTableViewCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

@implementation SepWhiteTableViewCell1

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepWhiteTableViewCell1 class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 12;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepWhiteTableViewCell1 class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

@implementation SepWhiteTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepWhiteTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 7;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepWhiteTableViewCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

@implementation SepTwoTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepTwoTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 7;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepTwoTableViewCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

@implementation SegTabViewCellSmallMF

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SegTabViewCellSmallMF class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 1;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SegTabViewCellSmallMF class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth - 24, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        [self.contentView addSubview:view];
        //        self.contentView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    }
    return self;
}

@end

@implementation SegTabViewCellSmall

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SegTabViewCellSmall class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 1;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SegTabViewCellSmall class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(25, 0, kScreenWidth - 50, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        [self.contentView addSubview:view];
//        self.contentView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    }
    return self;
}

@end

@implementation SegTabViewCellSmallTwo

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SegTabViewCellSmallTwo class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 1;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SegTabViewCellSmallTwo class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        [self.contentView addSubview:view];
        //        self.contentView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    }
    return self;
}

@end

@implementation OrderTabViewCellSmallTwo

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SegTabViewCellSmallTwo class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 0.5f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SegTabViewCellSmallTwo class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self.contentView addSubview:view];
        //        self.contentView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    }
    return self;
}

@end

@interface SepPictureViewCell ()

@end

@implementation SepPictureViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepPictureViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 0;
    NSMutableArray *mutable = [NSMutableArray arrayWithObjects:@{@"value":@"买家下单并付款"}, @{@"value":@"卖家承担运费发货给爱丁猫免费鉴定"}, @{@"value":@"爱丁猫顺丰包邮发货给买家"}, nil];
    rowHeight = 44*mutable.count + 3;
    
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepPictureViewCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSMutableArray *mutable = [NSMutableArray arrayWithObjects:@{@"value":@"买家下单并付款"}, @{@"value":@"卖家承担运费发货给爱丁猫免费鉴定"}, @{@"value":@"爱丁猫顺丰包邮发货给买家"}, nil];

        for (int i = 0; i < mutable.count; i++) {
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, i*44, kScreenWidth, 44)];
            UILabel *subLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            subLbl.text = mutable[i][@"value"];
            subLbl.font = [UIFont systemFontOfSize:12.f];
            subLbl.textColor = [UIColor colorWithHexString:@"4c4c4c"];
            [subLbl sizeToFit];
            [self.contentView addSubview:cellView];
            [cellView addSubview:subLbl];
            subLbl.frame = CGRectMake(kScreenWidth-subLbl.width-15, cellView.height/2-subLbl.height/2, subLbl.width, subLbl.height);
            
            if (i == 0) {
                UIView *segView = [[UIView alloc] initWithFrame:CGRectMake(0, cellView.top, kScreenWidth, 1)];
                segView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
                [self.contentView addSubview:segView];
            } else {
                UIView *segView = [[UIView alloc] initWithFrame:CGRectMake(12, cellView.top, kScreenWidth-24, 1)];
                segView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
                [self.contentView addSubview:segView];
            }
            
//            UILabel *numLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, cellView.height/2-12, 24, 24)];
//            numLbl.layer.masksToBounds = YES;
//            numLbl.layer.cornerRadius = 12;
//            numLbl.textAlignment = NSTextAlignmentCenter;
//            numLbl.backgroundColor = [UIColor colorWithHexString:@"150c0f"];
//            numLbl.textColor = [UIColor colorWithHexString:@"ffffff"];
//            numLbl.text = [NSString stringWithFormat:@"%d", i+1];
//            numLbl.font = [UIFont systemFontOfSize:13.f];
//            [cellView addSubview:numLbl];
            UIImageView * point = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point"]];
            point.frame = CGRectMake(15, cellView.height/2-point.image.size.width/2, point.image.size.width, point.image.size.height);
            [cellView addSubview:point];
        }
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end


@implementation SepUserHomeViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepUserHomeViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 5;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepUserHomeViewCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        [self.contentView addSubview:view];
        //        self.contentView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    }
    return self;
}

@end

@implementation SepSWTableViewCell1

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepSWTableViewCell1 class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 12;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepSWTableViewCell1 class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
    }
    return self;
}

@end

@implementation SepSWTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepSWTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 18;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepSWTableViewCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
    }
    return self;
}

@end

@implementation SepLeftTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepLeftTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 1;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepLeftTableViewCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth-12, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        [self.contentView addSubview:view];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

@implementation SepLeftTableViewCell1

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepLeftTableViewCell1 class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 0.5;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepLeftTableViewCell1 class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(66, 0, kScreenWidth-66, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        [self.contentView addSubview:view];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
