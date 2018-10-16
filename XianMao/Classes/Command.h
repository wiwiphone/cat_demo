//
//  Command.h
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayWayDO.h"
#import "CateNewInfo.h"
#import "BrandVO.h"
#import "ActionVo.h"
@interface Command : NSObject

@property (nonatomic, retain) NSDictionary *userInfo;

- (void) execute;
- (void) undo;

@end

@interface Action : NSObject

@property (nonatomic,copy) id (^action)(id parameters);

- (id)execute;
- (id)execute:(id)parameters;

+ (Action*)create:(id (^)(id parameters))action;

@end

@interface NSMutableDictionary (ActionBlock)

typedef id (^ActionBlockType)(id parameters);

- (NSMutableDictionary*)setObjectReturnSelf:(id)anObject forKey:(id <NSCopying>)aKey;
- (NSMutableDictionary*)fillAction:(void (^)())action;
- (NSMutableDictionary*)fillAction:(void (^)())action withKey:(NSString*)withKey;
- (NSMutableDictionary*)fillActionAndReturn:(id (^)())action;
- (NSMutableDictionary*)fillActionAndReturn:(id (^)())action withKey:(NSString*)withKey;
- (NSMutableDictionary*)fillActionWithParameters:(void (^)(id parameters))action;
- (NSMutableDictionary*)fillActionWithParameters:(void (^)(id parameters))action withKey:(NSString*)withKey;
- (NSMutableDictionary*)fillActionWithParametersAndReturn:(void (^)(id parameters))action;
- (NSMutableDictionary*)fillActionWithParametersAndReturn:(id (^)(id parameters))action withKey:(NSString*)withKey;
- (id)doAction;
- (id)doAction:(NSString*)withKey;
- (id)doActionWithParameters:(id)parameters;
- (id)doActionWithParameters:(id)parameters withKey:(NSString*)withKey;
@end

@interface NSDictionary (ActionBlock)

- (id)doAction;
- (id)doAction:(NSString*)withKey;
- (id)doActionWithParameters:(id)parameters;
- (id)doActionWithParameters:(id)parameters withKey:(NSString*)withKey;

@end


@class CommandButton;
typedef void(^CommandButtonHandleClickBlock)(CommandButton *sender);

@interface CommandButton : UIButton
@property (nonatomic, assign) NSInteger attrId;
@property (nonatomic, copy) NSString *queryKey;
@property (nonatomic, copy) NSString *queryValue;
@property (nonatomic, assign) NSInteger isMultiSelected;
@property (nonatomic, assign) NSInteger isSelectedYes;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger YesOrNo;//判断是否已经选中
@property(nonatomic,strong) id userData;
@property (nonatomic, strong) PayWayDO *payWay;

@property (nonatomic, strong) CateNewInfo *cateInfo;
@property (nonatomic, strong) BrandVO *brandVo;
@property (nonatomic, strong) ActionVo * actionVo;

@property (nonatomic, copy) NSString *recommendUrl;
@property(nonatomic,copy) CommandButtonHandleClickBlock handleClickBlock;
@end


@interface VerticalCommandButton : CommandButton

@property(nonatomic,assign) CGFloat imageTextSepHeight;
@property(nonatomic,assign) CGFloat contentMarginTop;
@property(nonatomic,assign) BOOL    contentAlignmentCenter;

@property (nonatomic, strong) NSString *shareName;
@end



@interface TapDetectingLabel : UILabel <UIGestureRecognizerDelegate>
@property(nonatomic,copy) void(^handleSingleTapDetected)(TapDetectingLabel *view, UIGestureRecognizer *recognizer);
@end


@interface TapDetectingView : UIView <UIGestureRecognizerDelegate>

@property(nonatomic,strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic,copy) void(^handleSingleTapDetected)(TapDetectingView *view, UIGestureRecognizer *recognizer);

@end


@interface TapDetectingImageView : UIImageView <UIGestureRecognizerDelegate>

@property(nonatomic,strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic,copy) void(^handleSingleTapDetected)(TapDetectingImageView *view, UIGestureRecognizer *recognizer);

@end



