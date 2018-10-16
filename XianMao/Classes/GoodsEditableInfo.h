//
//  GoodsEditableInfo.h
//  XianMao
//
//  Created by simon cai on 20/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PictureItem.h"


@interface GoodsEditableInfo : NSObject<NSCoding>

@property(nonatomic,strong) NSMutableArray *gallary;
@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,strong) PictureItem *mainPicItem;
@property(nonatomic,copy) NSString *goodsName;
@property(nonatomic,assign) double shopPrice;
@property(nonatomic,assign) double marketPrice;
@property(nonatomic,assign) NSInteger shopPriceCent;
@property(nonatomic,assign) NSInteger marketPriceCent;
@property(nonatomic,assign) NSInteger categoryId;
@property(nonatomic,copy) NSString *categoryName;
@property(nonatomic,assign) NSInteger brandId;
@property(nonatomic,copy) NSString *brandName;
@property(nonatomic,copy) NSString *brandEnName;
@property(nonatomic,assign) NSInteger grade;
@property (nonatomic, copy) NSString *gradeName;
@property(nonatomic,assign) NSInteger fitPeople;//0 未知道 1.男 2.女
@property(nonatomic,copy) NSString *summary;
@property(nonatomic,assign) BOOL isSupportReturn;
@property(nonatomic,strong) NSMutableArray *attrInfoList;
@property(nonatomic,strong) NSMutableArray *tagList;
@property(nonatomic, copy) NSString * orderId;
@property(nonatomic, strong) NSMutableArray *goodsResourceList;
@property(nonatomic, strong) NSMutableArray *voucherPictures;

@property(nonatomic,assign) BOOL isModified;

@property(nonatomic,assign) NSInteger expected_delivery_type;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;

+ (NSString*)fitPeopleString:(NSInteger)fitPeople;

@end

@interface GoodsEditableAttrIdValue : NSObject<NSCoding>
@property(nonatomic,assign) NSInteger attrId;
@property(nonatomic,copy) NSString *attrValue;
+ (GoodsEditableAttrIdValue*)buildAttrIdValue:(NSInteger)attrId attrValue:(NSString*)attrValue;
- (NSDictionary*)toDictionary;
- (BOOL)isValid;
@end

//goods_editable_info 增加  attr_info_list

@interface GoodsPublishResultInfo : NSObject

@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,assign) NSInteger totalNum;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end


@interface GradeInfo : NSObject

+ (GradeInfo*)allocGradeInfo:(NSInteger)grade gradeName:(NSString*)gradeName gradeDesc:(NSString*)gradeDesc;

@property(nonatomic,assign) NSInteger grade;
@property(nonatomic,copy) NSString *gradeName;
@property(nonatomic,copy) NSString *gradeDesc;
@property(nonatomic,copy) NSString *gradeSummary;

+ (GradeInfo*)gradeInfoByGrade:(NSInteger)grade;
+ (NSArray*)allGradeInfoArray;

@end

#define kTYPE_TEXT_INPUT 0
#define kTYPE_YES_OR_NO  1 //
#define kTYPE_SELECT     2 //单选
#define kTYPE_DATE       3

@interface AttrEditableInfo : NSObject<NSCoding>

@property(nonatomic,assign) NSInteger attrId;
@property(nonatomic,copy) NSString* attrName;
@property(nonatomic,copy) NSString *attrValue;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSArray *values;
@property(nonatomic,copy) NSString *placeholder;
@property(nonatomic,copy) NSString *explain;
@property(nonatomic,assign) BOOL isMust;

@property (nonatomic, assign) NSInteger is_multi_choice;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

//
//
////attr_id attr_name style list<String> placeholder
//private int attr_id;
//
//private String attr_name;
//
//@JsonInclude(Include.NON_NULL)
//private String attr_value;
//
//private int type;//0手输1是否2选择3日期
//
//@SuppressWarnings("rawtypes")
//private List list;// [string]
//
//private String placeholder; //提示
//
//@JsonInclude(Include.NON_NULL)
//private String explain; // 解释说明
//
//private int is_must; // 是否必输


