//
//  NoticeCell.m
//  XianMao
//
//  Created by simon on 11/22/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "Notice.h"

#import "DataSources.h"

#import "CoordinatingController.h"

@interface NoticeTableViewCell ()

@property(nonatomic,retain) UILabel *eventLbl;
@property(nonatomic,retain) UIButton *timeLbl;
@property(nonatomic,retain) UILabel *noticeLbl;
@property(nonatomic,strong) UIImageView *arrowView;
@property(nonatomic,retain) CALayer *bottomLineLayer;

@end

@implementation NoticeTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([NoticeTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 95.f;
    Notice *notice = [dict objectForKeyedSubscript:[[self class] cellDictKeyForNotice]];
    if (notice && [notice isKindOfClass:[Notice class]]) {
        height = [[self class] calculateHeightAndLayoutSubviews:nil notice:notice];
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(Notice*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[NoticeTableViewCell class]];
    if (item)[dict setObject:item forKey:[self cellDictKeyForNotice]];
    return dict;
}

+ (NSString*)cellDictKeyForNotice {
    return @"item";
}

- (void)dealloc
{
    self.timeLbl = nil;
    self.eventLbl = nil;
    self.noticeLbl = nil;
    self.bottomLineLayer = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.eventLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.eventLbl.backgroundColor = [UIColor clearColor];
        self.noticeLbl.textColor = [DataSources noticeUnreadTextColor];
        self.eventLbl.font = [DataSources noticeNameTextFont];
        self.eventLbl.textAlignment = NSTextAlignmentLeft;
        self.eventLbl.enabled = NO;
        [self addSubview:self.eventLbl];
        
        self.timeLbl = [[UIButton alloc] initWithFrame:CGRectNull];
        self.timeLbl.backgroundColor = [UIColor clearColor];
        [self.timeLbl setTitleColor:[DataSources goodsOnSaleTimeTextColor] forState:UIControlStateDisabled];
        self.timeLbl.titleLabel.font = [DataSources goodsOnSaleTimeTextFont];
        [self.timeLbl setImage:[DataSources goodsOnSaleTimeImg] forState:UIControlStateDisabled];
        [self.timeLbl setTitleEdgeInsets: UIEdgeInsetsMake(0, 8, 0, 0)];
        self.timeLbl.enabled = NO;
        [self addSubview:self.timeLbl];
        
        self.noticeLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.noticeLbl.textColor = [DataSources noticeUnreadTextColor];
        self.noticeLbl.font = [DataSources noticeTextFont];
        self.noticeLbl.numberOfLines = 0;
        [self.contentView addSubview:self.noticeLbl];
        
        self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow_gray"]];
        [self addSubview:self.arrowView];
        
        self.bottomLineLayer = [CALayer layer];
        self.bottomLineLayer.backgroundColor = [DataSources noticeBottomLineColor].CGColor;
        [self.contentView.layer addSublayer:self.bottomLineLayer];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.eventLbl.frame = CGRectNull;
    self.timeLbl.frame = CGRectNull;
    self.noticeLbl.frame = CGRectNull;
    self.bottomLineLayer.frame = CGRectNull;
    self.arrowView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [[self class] calculateHeightAndLayoutSubviews:self notice:nil];
    
//    CGFloat marginLeft = 0;
//    marginLeft += 15.f;
//    
    self.bottomLineLayer.frame = CGRectMake(0, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width, 1);
//
//    CGFloat marginRight = 0.f;
//    [self.timeLbl sizeToFit];
//    CGFloat timeLblWidth = CGRectGetWidth(self.timeLbl.bounds)+self.timeLbl.titleEdgeInsets.left+self.timeLbl.titleEdgeInsets.right;
//    self.timeLbl.frame = CGRectMake(CGRectGetWidth(self.bounds)-15-timeLblWidth, 20, timeLblWidth, CGRectGetHeight(self.timeLbl.bounds));
//    marginRight += CGRectGetWidth(self.bounds)-self.timeLbl.frame.origin.x+10;
//    
//    CGFloat marginTop = 0.f;
//    marginTop += 20.f;
//    
//    CGFloat eventLblWidth = CGRectGetWidth(self.bounds)-marginRight-marginLeft;
//    [self.eventLbl sizeToFit];
//    CGSize eventLblSize = self.eventLbl.bounds.size;
//    self.eventLbl.frame = CGRectMake(marginLeft, marginTop, eventLblWidth, eventLblSize.height);
//    
//    marginTop += eventLblSize.height;
//    marginTop += 8;
//    
//    CGFloat noticeLblWidth = CGRectGetWidth(self.bounds)-marginLeft-15.f;
//    self.noticeLbl.frame = CGRectMake(marginLeft, marginTop, noticeLblWidth, 0);
//    [self.noticeLbl sizeToFit];
//    self.noticeLbl.frame = CGRectMake(marginLeft, marginTop, noticeLblWidth, self.noticeLbl.bounds.size.height);
    
}

+ (CGFloat)calculateHeightAndLayoutSubviews:(NoticeTableViewCell*)cell notice:(Notice*)notice {
    
    CGFloat marginLeft = 0;
    marginLeft += 15.f;
    
    CGFloat marginTop = 0.f;
    marginTop += 20.f;
    
    if (cell) {
        CGFloat marginRight = 0.f;
        [cell.timeLbl sizeToFit];
        CGFloat timeLblWidth = CGRectGetWidth(cell.timeLbl.bounds)+cell.timeLbl.titleEdgeInsets.left+cell.timeLbl.titleEdgeInsets.right;
        cell.timeLbl.frame = CGRectMake(CGRectGetWidth(cell.bounds)-15-timeLblWidth, 20, timeLblWidth, CGRectGetHeight(cell.timeLbl.bounds));
        marginRight += CGRectGetWidth(cell.bounds)-cell.timeLbl.frame.origin.x+10;
        
        CGFloat eventLblWidth = CGRectGetWidth(cell.bounds)-marginRight-marginLeft;
        [cell.eventLbl sizeToFit];
        CGSize eventLblSize = cell.eventLbl.bounds.size;
        cell.eventLbl.frame = CGRectMake(marginLeft, marginTop, eventLblWidth, eventLblSize.height);
        
        marginTop += eventLblSize.height;
        marginTop += 8;
    } else if (notice) {
        NSString *str = [NSString string];
        if (notice.title) {
            str = notice.title;
        } else {
            str = @"系统通知";
        }
        CGSize size = [str sizeWithFont:[DataSources noticeTextFont]
                      constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                          lineBreakMode:NSLineBreakByWordWrapping];
        
        marginTop += size.height;
        marginTop += 8;
    }
    
    if (cell) {
        CGFloat noticeLblWidth = CGRectGetWidth(cell.bounds)-marginLeft-15.f;
        if ([cell.arrowView isHidden])
            noticeLblWidth = CGRectGetWidth(cell.bounds)-marginLeft-15.f;
        else
            noticeLblWidth = CGRectGetWidth(cell.bounds)-marginLeft-15.f-20;
        cell.noticeLbl.frame = CGRectMake(marginLeft, marginTop, noticeLblWidth, 0);
        [cell.noticeLbl sizeToFit];
        cell.noticeLbl.frame = CGRectMake(marginLeft, marginTop, noticeLblWidth, cell.noticeLbl.bounds.size.height);
        
        marginTop += cell.noticeLbl.height;
    } else if (notice) {
        if ([notice.redirectUri length]>0) {
            CGSize size = [notice.message sizeWithFont:[DataSources noticeTextFont]
                                     constrainedToSize:CGSizeMake(kScreenWidth-30-20,MAXFLOAT)
                                         lineBreakMode:NSLineBreakByWordWrapping];
            marginTop += size.height;
        } else {
            CGSize size = [notice.message sizeWithFont:[DataSources noticeTextFont]
                                     constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                         lineBreakMode:NSLineBreakByWordWrapping];
            marginTop += size.height;
        }
    }
    
    marginTop += 15.f;
    
    if (cell) {
        cell.arrowView.frame = CGRectMake(cell.width-15-cell.arrowView.width, cell.noticeLbl.top+(cell.noticeLbl.height-cell.arrowView.height)/2, cell.arrowView.width, cell.arrowView.height);
    }
    
    return marginTop;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    Notice *notice = [dict objectForKeyedSubscript:[[self class] cellDictKeyForNotice]];
    if ([notice isKindOfClass:[Notice class]]) {
        //formattedDateDescription
        [self.timeLbl setTitle:[notice formattedDateDescription] forState:UIControlStateDisabled];
        if (notice.title) {
            self.eventLbl.text = notice.title;
        } else {
            self.eventLbl.text = @"系统通知";
        }
        self.noticeLbl.text = notice.message;
        
        self.arrowView.hidden = [notice.redirectUri length]>0?NO:YES;
    }
}

@end

