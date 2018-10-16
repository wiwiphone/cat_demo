//
//  ConversationCell.m
//  XianMao
//
//  Created by simon on 11/22/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ConversationTableViewCell.h"
#import "Conversation.h"

#import "DataSources.h"

#import "CoordinatingController.h"


@interface ConversationTableViewCell ()

@property(nonatomic,retain) UIButton *avatarView;
@property(nonatomic,retain) UIButton *nickNameLbl;
@property(nonatomic,retain) UIButton *timeLbl;
@property(nonatomic,retain) UILabel *messageLbl;
@property(nonatomic,retain) CALayer *bottomLineLayer;

@end

@implementation ConversationTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ConversationTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 80.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(Conversation*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ConversationTableViewCell class]];
    if (item)[dict setObject:item forKey:@"item"];
    return dict;
}

- (void)dealloc
{
    self.avatarView = nil;
    self.nickNameLbl = nil;
    self.timeLbl = nil;
    self.messageLbl = nil;
    self.bottomLineLayer = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.avatarView = [[UIButton alloc] initWithFrame:CGRectNull];
        self.avatarView.layer.masksToBounds=YES;
        self.avatarView.layer.cornerRadius=42/2;    //最重要的是这个地方要设成imgview高的一半
        self.avatarView.backgroundColor = [DataSources avatarBackgroundColor];
        [self.avatarView addTarget:self action:@selector(avatarClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarView];
        
        self.nickNameLbl = [[UIButton alloc] initWithFrame:CGRectNull];
        self.nickNameLbl.backgroundColor = [UIColor clearColor];
        [self.nickNameLbl setTitleColor:[DataSources conversationNickNameTextColor] forState:UIControlStateDisabled];
        self.nickNameLbl.titleLabel.font = [DataSources conversationNickNameTextFont];
        self.nickNameLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.nickNameLbl.enabled = NO;
        [self addSubview:self.nickNameLbl];
        
        self.timeLbl = [[UIButton alloc] initWithFrame:CGRectNull];
        self.timeLbl.backgroundColor = [UIColor clearColor];
        [self.timeLbl setTitleColor:[DataSources goodsOnSaleTimeTextColor] forState:UIControlStateNormal];
        self.timeLbl.titleLabel.font = [DataSources goodsOnSaleTimeTextFont];
        [self.timeLbl setImage:[DataSources goodsOnSaleTimeImg] forState:UIControlStateNormal];
        [self.timeLbl setTitleEdgeInsets: UIEdgeInsetsMake(0, 8, 0, 0)];
        [self addSubview:self.timeLbl];
        
        self.messageLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.messageLbl.textColor = [DataSources conversationMessageTextColor];
        self.messageLbl.font = [DataSources conversationMessageTextFont];
        [self.contentView addSubview:self.messageLbl];
        
        self.bottomLineLayer = [CALayer layer];
        self.bottomLineLayer.backgroundColor = [DataSources conversationBottomLineColor].CGColor;
        [self.contentView.layer addSublayer:self.bottomLineLayer];
        
        [self.timeLbl setTitle:@"3 h" forState:UIControlStateNormal];
        
        [self.nickNameLbl setImage:[DataSources userRankCrown] forState:UIControlStateDisabled];
        [self.nickNameLbl setTitle:@"Nick name" forState:UIControlStateNormal];
        
        self.messageLbl.text = @"你好 你好 你好 你好 你好 你好 你好 你好 你好 你好 ";
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.avatarView.frame = CGRectNull;
    self.nickNameLbl.frame = CGRectNull;
    self.messageLbl.frame = CGRectNull;
    self.bottomLineLayer.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginLeft = 0;
    marginLeft += 15.f;
    self.avatarView.frame = CGRectMake(marginLeft, (self.contentView.bounds.size.height-42)/2, 42, 42);
    marginLeft += self.avatarView.bounds.size.width;
    
    marginLeft += 15.f;
    
    self.bottomLineLayer.frame = CGRectMake(marginLeft, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-marginLeft, 1);
    
    CGFloat marginRight = 0.f;
    [self.timeLbl sizeToFit];
    CGFloat timeLblWidth = CGRectGetWidth(self.timeLbl.bounds)+self.timeLbl.titleEdgeInsets.left+self.timeLbl.titleEdgeInsets.right;
    self.timeLbl.frame = CGRectMake(CGRectGetWidth(self.bounds)-15-timeLblWidth, 10, timeLblWidth, CGRectGetHeight(self.timeLbl.bounds));
    marginRight += CGRectGetWidth(self.bounds)-self.timeLbl.frame.origin.x+10;
    
    CGFloat marginTop = 0.f;
    marginTop += 20.f;
    
    CGFloat nickNameLblWidth = CGRectGetWidth(self.bounds)-marginRight-marginLeft;
    [self.nickNameLbl sizeToFit];
    CGSize nickNameLblSize = self.nickNameLbl.bounds.size;
    [self.nickNameLbl setImageEdgeInsets:UIEdgeInsetsMake(0, nickNameLblSize.width-[DataSources userRankCrown].size.width+8, 0, 0)];
    [self.nickNameLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, -[DataSources userRankCrown].size.width, 0, 0)];
    self.nickNameLbl.frame = CGRectMake(marginLeft, marginTop, nickNameLblWidth, nickNameLblSize.height);
    
    marginTop += nickNameLblSize.height;
    marginTop += 8;
    
    CGFloat messageLblWidth = CGRectGetWidth(self.bounds)-marginLeft-15.f;
    [self.messageLbl sizeToFit];
    self.messageLbl.frame = CGRectMake(marginLeft, marginTop, messageLblWidth, self.messageLbl.bounds.size.height);
    
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
}

- (void)avatarClicked:(UIButton*)sender
{
    //[[CoordinatingController sharedInstance] gotoUserHomeViewController:YES];
}

@end

