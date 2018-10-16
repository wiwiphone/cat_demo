//
//  ForumAttachView.m
//  XianMao
//
//  Created by simon cai on 29/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ForumAttachView.h"
#import "Command.h"

#define kForumAttachItemViewMaxWidth 150

@interface ForumAttachContainerView ()
@property(nonatomic,weak) UIScrollView *scrollView;
@end

@implementation ForumAttachContainerView {
    UIView *_topLine;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        
        _scrollView = scrollView;
        _scrollView.showsVerticalScrollIndicator =  NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        [self addSubview:_topLine];
        
    }
    return self;
}

- (NSArray*)attachments {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *subviews = _scrollView.subviews;
    if ([subviews count]>0) {
        for (UIView *view in subviews) {
            if ([view isKindOfClass:[ForumAttachmentView class]]) {
                [array addObject:((ForumAttachmentView*)view).attachmentVO];
            }
        }
    }
    return array;
}

- (void)clear {
    NSArray *subviews = _scrollView.subviews;
    if ([subviews count]>0) {
        for (UIView *view in subviews) {
            if ([view isKindOfClass:[ForumAttachmentView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    self.hidden = YES;
}

- (void)attachItem:(ForumAttachmentVO*)attachmentVO {
    WEAKSELF;
    ForumAttachmentView *itemView = [ForumAttachmentView createAttachView:attachmentVO];
    if (itemView) {
        itemView.attachmentVO = attachmentVO;
        itemView.handleDeleteAttachmentBlock = ^(ForumAttachmentView* attachView) {
            for (UIView *view in weakSelf.scrollView.subviews) {
                if (view==itemView) {
                    [view removeFromSuperview];
                    [weakSelf setNeedsLayout];
                    break;
                }
            }
            if ([weakSelf.attachments count]==0) {
                weakSelf.hidden = YES;
            }
        };
        weakSelf.hidden = NO;
        [_scrollView addSubview:itemView];
        [self setNeedsLayout];
        
        [self bringSubviewToFront:_topLine];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _topLine.frame = CGRectMake(0, 0, self.width, 0.5f);
    _scrollView.frame = self.bounds;
    
    NSArray *subviews = _scrollView.subviews;
    if ([subviews count]>0) {
        CGFloat marginLeft = 8;
        for (UIView *view in subviews) {
            if ([view isKindOfClass:[ForumAttachmentView class]]) {
                view.frame = CGRectMake(marginLeft, 0, view.width, _scrollView.height);
                marginLeft += view.width;
                marginLeft += 8;
            }
        }
        _scrollView.contentSize = CGSizeMake(marginLeft, self.height);
    }
}

@end


@implementation ForumAttachmentView

- (id)initWithFrame:(CGRect)frame itemVO:(ForumAttachmentVO*)attachmentVO {
    return [self initWithFrame:frame itemVO:attachmentVO isShowDelBtn:YES];
}

- (id)initWithFrame:(CGRect)frame itemVO:(ForumAttachmentVO*)itemVO isShowDelBtn:(BOOL)isShowDelBtn {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (ForumAttachmentView*)createAttachView:(ForumAttachmentVO*)itemVO {
    if ([itemVO.item isKindOfClass:[ForumAttachItemGoodsVO class]]) {
        return [[ForumAttachmentViewGoods alloc] initWithFrame:CGRectZero itemVO:itemVO];
    }
    return [[ForumAttachmentViewRemindUpgrade alloc] initWithFrame:CGRectZero];
}

@end

@interface ForumAttachmentViewGoods () <UIGestureRecognizerDelegate>
@property(nonatomic,weak) UIImageView *attachmentView;
@property(nonatomic,weak) UILabel* goodsNameLbl;
@end

@implementation ForumAttachmentViewGoods {
    TapDetectingImageView *_delBtn;
    BOOL _isShowDelBtn;
}

- (id)initWithFrame:(CGRect)frame itemVO:(ForumAttachmentVO*)attachmentVO {
    return [self initWithFrame:frame itemVO:attachmentVO isShowDelBtn:YES];
}

- (id)initWithFrame:(CGRect)frame itemVO:(ForumAttachmentVO*)attachmentVO isShowDelBtn:(BOOL)isShowDelBtn {
    self = [super initWithFrame:frame];
    if (self) {
        
        _isShowDelBtn = isShowDelBtn;
        
        super.attachmentVO = attachmentVO;
        
        UIImageView *attachmentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forum_icon_attach"]];
        [self addSubview:attachmentView];
        _attachmentView = attachmentView;
        
        UILabel *goodsNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:goodsNameLbl];
        _goodsNameLbl = goodsNameLbl;
        _goodsNameLbl.font = [UIFont systemFontOfSize:14.f];
        _goodsNameLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _goodsNameLbl.numberOfLines = 1;
        _goodsNameLbl.text = ((ForumAttachItemGoodsVO*)(attachmentVO.item)).goods_name;
        
        if (_isShowDelBtn) {
            UIImage *delIcon = [UIImage imageNamed:@"forum_icon_attach_delete"];
            _delBtn = [[TapDetectingImageView alloc] initWithFrame:CGRectMake(0, 0, delIcon.size.width, delIcon.size.height)];
            _delBtn.image = delIcon;
            [self addSubview:_delBtn];
            
            WEAKSELF;
            _delBtn.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer) {
                if (weakSelf.handleDeleteAttachmentBlock) {
                    weakSelf.handleDeleteAttachmentBlock(weakSelf);
                }
            };
        }
        
        if (self.width==0) {
            self.frame = CGRectMake(0, 0, kScreenWidth, 0);
        }
        CGSize size = [self layoutSubviewsImpl];
        self.frame = CGRectMake(0, 0, size.width, size.height);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutSubviewsImpl];
}

- (CGSize)layoutSubviewsImpl {
    
    CGFloat marginLeft = 0.f;
    _attachmentView.frame = CGRectMake(marginLeft, (self.height-_attachmentView.height)/2, _attachmentView.width, _attachmentView.height);
    
    marginLeft += _attachmentView.width;
    marginLeft += 2;
    
    
    [_goodsNameLbl sizeToFit];
    if (_goodsNameLbl.width>kForumAttachItemViewMaxWidth) {
        _goodsNameLbl.width = kForumAttachItemViewMaxWidth;
    }
    _goodsNameLbl.frame = CGRectMake(marginLeft, 0, _goodsNameLbl.width, self.height);
    
    marginLeft +=  _goodsNameLbl.width;
    
    if (_isShowDelBtn) {
        _delBtn.frame = CGRectMake(marginLeft, (self.height-_delBtn.height)/2, _delBtn.width, _delBtn.height);
        marginLeft += _delBtn.width;
    }
    marginLeft += 2;
    
    return CGSizeMake(marginLeft, self.height);
}

@end

@implementation ForumAttachmentViewRemindUpgrade

- (id)initWithFrame:(CGRect)frame itemVO:(ForumAttachmentVO*)attachmentVO {
    return [self initWithFrame:frame itemVO:attachmentVO isShowDelBtn:YES];
}

@end

//[UIFont systemFontOfSize:12.0f]


@interface ForumReplyAttachContainerView ()

@end

@implementation ForumReplyAttachContainerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)updateAttachReplyView:(NSArray*)attachments {
    
}

@end


