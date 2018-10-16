//
//  TabBarButton.m
//  VoPai
//
//  Created by simon cai on 10/15/13.
//  Copyright (c) 2013 taobao.com. All rights reserved.
//

#import "TabBarButton.h"
#import "NSDictionary+Additions.h"

NSString *const kTabBarButtonSelectedImage = @"TabBarButtonSelectedImage";
NSString *const kTabBarButtonImage = @"TabBarButtonImage";
NSString *const kTabBarButtonText = @"TabBarButtonNormalText";
NSString *const kTabBarButtonTextFont = @"TabBarButtonTextFont";
NSString *const kTabBarButtonTextColor = @"TabBarButtonTextColor";
NSString *const kTabBarButtonSelectedTextColor = @"TabBarButtonSelectedTextColor";
NSString *const KTabBarButtonHasSelectedState = @"TabBarButtonHasSelectedState";
NSString *const KTabBarIsCheckableBtn = @"TabBarIsCheckableBtn";
NSString *const KTabBarButtonIconPaddingTop = @"TabBarButtonIconPaddingTop";

@interface TabBarButton() <UIGestureRecognizerDelegate>
{
    UILongPressGestureRecognizer *_longPress;
}

@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UILabel *textLbl;

@property(nonatomic,retain) UIColor *textColor;
@property(nonatomic,retain) UIColor *selectedTextColor;

@property(nonatomic,retain) UIImage *image;
@property(nonatomic,retain) UIImage *selectedImage;

@property(nonatomic,readwrite) BOOL isCheckableBtn;

@property(nonatomic,assign) NSInteger iconPaddingTop;

@property(nonatomic,strong) UIButton *notifiCountLbl;
@property(nonatomic,assign) NSInteger notifiCount;

@end

@implementation TabBarButton

-(void)dealloc
{
    self.imageView = nil;
    self.textLbl = nil;
    
    self.textColor = nil;
    self.selectedTextColor = nil;
    
    self.image = nil;
    self.selectedImage = nil;
    
    _longPress = nil;
    _notifiCountLbl = nil;
}

- (id)initWithFrame:(CGRect)frame dict:(NSDictionary*)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _longPress = [[UILongPressGestureRecognizer alloc] init];
        _longPress.delegate = self;
        _longPress.minimumPressDuration = 0.8f;
        _longPress.allowableMovement = 10.0f;
        [_longPress addTarget:self action:@selector(handleLongPressed:)];
        [self addGestureRecognizer:_longPress];
        
        self.userInteractionEnabled = YES;
        
        if ([dict objectForKey:kTabBarButtonTextColor]
            && [[dict objectForKey:kTabBarButtonTextColor] isKindOfClass:[UIColor class]]) {
            self.textColor = [dict objectForKey:kTabBarButtonTextColor];
        }
        if ([dict objectForKey:kTabBarButtonSelectedTextColor]
            && [[dict objectForKey:kTabBarButtonSelectedTextColor] isKindOfClass:[UIColor class]]) {
            self.selectedTextColor = [dict objectForKey:kTabBarButtonSelectedTextColor];
        }
        if ([dict objectForKey:kTabBarButtonImage]
            && [[dict objectForKey:kTabBarButtonImage] isKindOfClass:[UIImage class]]) {
            self.image = [dict objectForKey:kTabBarButtonImage];
        }
        if ([dict objectForKey:kTabBarButtonSelectedImage]
            && [[dict objectForKey:kTabBarButtonSelectedImage] isKindOfClass:[UIImage class]]) {
            self.selectedImage = [dict objectForKey:kTabBarButtonSelectedImage];
        }
        self.isCheckableBtn = NO;
        if ([dict objectForKey:KTabBarIsCheckableBtn]
            && [[dict objectForKey:KTabBarIsCheckableBtn] isKindOfClass:[NSNumber class]]) {
            self.isCheckableBtn = [[dict objectForKey:KTabBarIsCheckableBtn] boolValue];
        }
        
        self.iconPaddingTop = 0;
        if ([dict objectForKey:KTabBarButtonIconPaddingTop]) {
            self.iconPaddingTop = [[dict objectForKey:KTabBarButtonIconPaddingTop] integerValue];
        }
        
        NSString *text = [dict stringValueForKey:kTabBarButtonText];
        if ([text length]>0) {
            self.textLbl = [[UILabel alloc] initWithFrame:self.bounds];
            self.textLbl.backgroundColor = [UIColor clearColor];
            self.textLbl.text = text;
            self.textLbl.textAlignment = NSTextAlignmentCenter;
            self.textLbl.textColor = self.textColor;
            [self.textLbl sizeToFit];
            [self addSubview:self.textLbl];
        }
        if ([dict objectForKey:kTabBarButtonTextFont]) {
            self.textLbl.font = [dict objectForKey:kTabBarButtonTextFont];
        }
        
        if (self.image) {
            self.imageView = [[UIImageView alloc] initWithImage:self.image];
            self.imageView.userInteractionEnabled = YES;
            [self addSubview:self.imageView];
        }
        
        _notifiCount = 0;
        
        _enabled = YES;
        _selected = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLbl.frame = self.bounds;
    [self.textLbl sizeToFit];
    
    //(CGRectGetHeight(self.bounds)-CGRectGetHeight(self.imageView.bounds))/2
    self.imageView.frame = CGRectMake((CGRectGetWidth(self.bounds)-CGRectGetWidth(self.imageView.bounds))/2,
                                      self.iconPaddingTop,
                                      CGRectGetWidth(self.imageView.bounds),
                                      CGRectGetHeight(self.imageView.bounds));
    
    self.textLbl.frame = CGRectMake((CGRectGetWidth(self.bounds)-CGRectGetWidth(self.textLbl.bounds))/2,
                                    CGRectGetHeight(self.bounds)-3-CGRectGetHeight(self.textLbl.bounds)*(kScreenWidth/320),
                                    CGRectGetWidth(self.textLbl.bounds),
                                    CGRectGetHeight(self.textLbl.bounds));
    
    self.notifiCountLbl.frame = CGRectMake(self.bounds.size.width/2+self.image.size.width/2-8, 4, self.notifiCountLbl.width, self.notifiCountLbl.height);
}

- (void)resetNumOfNotifications:(NSInteger)n
{
    _notifiCount = n;
    [self resetNotifiCountLbl];
}

-(void)addNumOfNotifications:(NSInteger)n
{
    _notifiCount += n;
    [self resetNotifiCountLbl];
}

-(void)removeNumOfNotifications:(NSInteger)n
{
    _notifiCount -= n;
    if (_notifiCount<0) {
        _notifiCount = 0;
    }
    [self resetNotifiCountLbl];
}

- (void)clearNotifications
{
    _notifiCount = 0;
    [self resetNotifiCountLbl];
}

- (void)resetNotifiCountLbl {
    if (_notifiCount > 0)
    {
        //tabbarview中添加了一个子控件，这里fream需要修改一下   2016.3.28 Feng
        self.notifiCountLbl.hidden = NO;
        if (_notifiCount<10) {
            [self.notifiCountLbl setTitle:[NSString stringWithFormat:@"%d",(int)_notifiCount] forState:UIControlStateDisabled];
            [self.notifiCountLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            self.notifiCountLbl.frame = CGRectMake(0, 5, 17, 16);
            self.notifiCountLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            self.notifiCountLbl.layer.masksToBounds = YES;
            self.notifiCountLbl.layer.cornerRadius = 8;
        } else if (_notifiCount<99) {
            [self.notifiCountLbl setTitle:[NSString stringWithFormat:@"%d",(int)_notifiCount] forState:UIControlStateDisabled];
            [self.notifiCountLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            self.notifiCountLbl.frame = CGRectMake(0, 5, 20, 16);
            self.notifiCountLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            self.notifiCountLbl.layer.masksToBounds = YES;
            self.notifiCountLbl.layer.cornerRadius = 8;
        } else {
            [self.notifiCountLbl setTitle:@"..." forState:UIControlStateDisabled];
            [self.notifiCountLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
            self.notifiCountLbl.frame = CGRectMake(0, 5, 17, 16);
            self.notifiCountLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            self.notifiCountLbl.layer.masksToBounds = YES;
            self.notifiCountLbl.layer.cornerRadius = 8;
        }
        [self setNeedsLayout];
        UIApplication *application = [UIApplication sharedApplication];
        application.applicationIconBadgeNumber =  _notifiCount;
    } else {
        self.notifiCountLbl.hidden = YES;
        UIApplication *application = [UIApplication sharedApplication];
        application.applicationIconBadgeNumber = 0;
    }
}

-(UIButton*)notifiCountLbl
{
    if (!_notifiCountLbl) {
        _notifiCountLbl = [[UIButton alloc] initWithFrame:CGRectNull];
        _notifiCountLbl.titleLabel.font = [UIFont systemFontOfSize:9.5f];
        _notifiCountLbl.backgroundColor = [UIColor redColor];
        _notifiCountLbl.enabled = NO;
        [_notifiCountLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self addSubview:_notifiCountLbl];
    }
    return _notifiCountLbl;
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        self.imageView.image = _selected?self.selectedImage:self.image;
        self.textLbl.textColor = _selected?self.selectedTextColor:self.textColor;
        
        if ([[SkinIconManager manager] getTabbarType]) {
            self.textLbl.hidden = selected;
            if (selected) {
                self.imageView.frame = CGRectMake((CGRectGetWidth(self.bounds)-CGRectGetWidth(self.imageView.bounds))/2,
                                                  self.iconPaddingTop,
                                                  self.selectedImage.size.width,
                                                  self.selectedImage.size.height);
            }else{
                self.imageView.frame = CGRectMake((CGRectGetWidth(self.bounds)-CGRectGetWidth(self.imageView.bounds))/2,
                                                  self.iconPaddingTop,
                                                  self.image.size.width,
                                                  self.image.size.height);
            }
        } else {
            self.textLbl.hidden = NO;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return _enabled;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
	NSUInteger tapCount = touch.tapCount;
    if (tapCount == 1) {
        if (!_isCheckableBtn) {
            [self setSelected:YES];
        }
    }
    [[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
		case 1:
			[self handleSingleTap:touch];
			break;
		case 2:
			[self handleDoubleTap:touch];
			break;
		default:
            if (!_isCheckableBtn) {
                [self setSelected:NO];
            }
			break;
	}
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch {
	if (self.delegate && [self.delegate respondsToSelector:@selector(handleTabBarButtonSingleTap:)]) {
        [self.delegate handleTabBarButtonSingleTap:self];
    }
}

- (void)handleDoubleTap:(UITouch *)touch {
	if (self.delegate && [self.delegate respondsToSelector:@selector(handleTabBarButtonDoubleTap:)]) {
        [self.delegate handleTabBarButtonDoubleTap:self];
    }
}

- (void)handleLongPressed:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleTabBarButtonLongPressed:)]) {
        [self.delegate handleTabBarButtonLongPressed:self];
    }
}

@end




