//
//  GoodsEditableInfo.m
//  XianMao
//
//  Created by simon cai on 20/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "GoodsEditableInfo.h"
#import "GoodsInfo.h"
#import "TagVo.h"

@implementation GoodsEditableAttrIdValue

+ (GoodsEditableAttrIdValue*)buildAttrIdValue:(NSInteger)attrId attrValue:(NSString*)attrValue {
    GoodsEditableAttrIdValue *idValue = [[GoodsEditableAttrIdValue alloc] init];
    idValue.attrId = attrId;
    idValue.attrValue = attrValue;
    return idValue;
}
- (NSDictionary*)toDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInteger:_attrId] forKey:@"attr_id"];
    if (_attrValue) [dict setObject:_attrValue forKey:@"attr_value"];
    return dict;
}
- (BOOL)isValid {
    return _attrId>0&&[_attrValue length]>0;
}

#pragma mark - coding
//归档方法
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.attrId] forKey:@"attrId"];
    [aCoder encodeObject:self.attrValue forKey:@"attrValue"];
}

//解档方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.attrId = [[aDecoder decodeObjectForKey:@"attrId"] integerValue];;
        self.attrValue = [aDecoder decodeObjectForKey:@"attrValue"];
    }
    return self;
}



@end

@implementation GoodsEditableInfo

@synthesize shopPrice = _shopPrice;
@synthesize marketPrice = _marketPrice;

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (double)marketPrice {
    return CENT_INTEGER_TO_FLOAT_YUAN(_marketPriceCent);
}

-(double)shopPrice {
    return CENT_INTEGER_TO_FLOAT_YUAN(_shopPriceCent);
}

- (id)init {
    self = [super init];
    if (self) {
        _fitPeople = -1;
        _grade = -1;
        _isModified = NO;
        _isSupportReturn = YES;
    }
    return self;
}

- (void)setIsModified:(BOOL)isModified
{
    if (_isModified!=isModified) {
        if (isModified ) {
            
        }
        _isModified = isModified;
    }
}

- (void)setGallary:(NSMutableArray *)gallary {
    if (_gallary!=gallary) {
        if (_gallary.count != gallary.count) {
            _gallary = gallary;
            self.isModified = YES;
        } else {
            for (NSInteger i=0;i<_gallary.count;i++) {
                PictureItem *item = _gallary[i];
                PictureItem *itemTemp = gallary[i];
                if (item.picId!=itemTemp.picId
                    || ![item.picUrl isEqualToString:itemTemp.picUrl]
                    || item.width!=itemTemp.width
                    || item.height!=itemTemp.height) {
                    self.isModified = YES;
                    _gallary = gallary;
                }
            }
        }
    }
}
- (void)setMainPicItem:(PictureItem *)mainPicItem {
    if (_mainPicItem!=mainPicItem
        || _mainPicItem.picId!=mainPicItem.picId
        || ![_mainPicItem.picUrl isEqualToString:mainPicItem.picUrl]
        || _mainPicItem.width != mainPicItem.width
        || _mainPicItem.height != mainPicItem.height) {
        _mainPicItem = mainPicItem;
        self.isModified = YES;
    }
}

- (void)setGoodsName:(NSString *)goodsName {
    if (![_goodsName  isEqualToString:goodsName]) {
        _goodsName = [goodsName copy];
        self.isModified = YES;
    }
}

- (void)setShopPrice:(double)shopPrice {
    if (_shopPrice!=shopPrice) {
        _shopPrice = shopPrice;
        _shopPriceCent = (NSInteger)(_shopPrice*100);
        self.isModified = YES;
    }
}

- (void)setShopPriceCent:(NSInteger)shopPriceCent {
    if (_shopPriceCent!=shopPriceCent) {
        _shopPriceCent = shopPriceCent;
        self.isModified = YES;
    }
}

- (void)setMarketPrice:(double)marketPrice {
    if (_marketPrice!=marketPrice) {
        _marketPrice = marketPrice;
        _marketPriceCent = (NSInteger)(_marketPrice*100);
        self.isModified = YES;
    }
}

- (void)setMarketPriceCent:(NSInteger)marketPriceCent {
    if (_marketPriceCent!=marketPriceCent) {
        _marketPriceCent = marketPriceCent;
        self.isModified = YES;
    }
}

- (void)setCategoryId:(NSInteger)categoryId {
    if (_categoryId!=categoryId) {
        _categoryId = categoryId;
        self.isModified = YES;
    }
}

- (void)setBrandId:(NSInteger)brandId {
    if (_brandId != brandId) {
        _brandId = brandId;
        self.isModified = YES;
    }
}

- (void)setGrade:(NSInteger)grade {
    if (_grade!=grade) {
        _grade = grade;
        self.isModified = YES;
    }
}

- (void)setIsSupportReturn:(BOOL)isSupportReturn {
    if (_isSupportReturn!=isSupportReturn) {
        _isSupportReturn = isSupportReturn;
        self.isModified = YES;
    }
}

- (void)setSummary:(NSString *)summary {
    if (![_summary isEqualToString:summary]) {
        _summary = [summary copy];
        self.isModified = YES;
    }
}

- (void)setAttrInfoList:(NSMutableArray *)attrInfoList {
    if (_attrInfoList != attrInfoList) {
        _attrInfoList = attrInfoList;
        self.isModified = YES;
    }
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        
        NSMutableArray *gallaryItems = [[NSMutableArray alloc] init];
        NSArray *detailPicItemDicts = [dict arrayValueForKey:@"gallary"];
        if ([detailPicItemDicts isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in detailPicItemDicts) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [gallaryItems addObject:[PictureItem createWithDict:dict]];
                }
            }
        }
        _gallary = gallaryItems;
        
        _goodsId = [dict stringValueForKey:@"goods_id"];
        _goodsName = [dict stringValueForKey:@"goods_name" defaultValue:@""];
        _shopPrice = [[dict decimalNumberKey:@"shop_price"] doubleValue];
        _marketPrice = [[dict decimalNumberKey:@"market_price"] doubleValue];
        
        _shopPriceCent = [dict integerValueForKey:@"shop_price_cent"];
        _marketPriceCent = [dict integerValueForKey:@"market_price_cent"];
        
        _mainPicItem = [PictureItem createWithDict:[dict dictionaryValueForKey:@"main_pic"]];
        _categoryId = [dict integerValueForKey:@"category_id" defaultValue:0];
        _categoryName = [dict stringValueForKey:@"category_name"];
        _brandId = [dict integerValueForKey:@"brand_id" defaultValue:0];
        _brandName = [dict stringValueForKey:@"brand_name"];
        _brandEnName = [dict stringValueForKey:@"brand_en_name"];
        _grade = [dict integerValueForKey:@"grade" defaultValue:0];
        _gradeName = [dict stringValueForKey:@"gradeName"];
        _fitPeople = [dict integerValueForKey:@"fit_people" defaultValue:0];
        _summary = [dict stringValueForKey:@"summary"];
        _isSupportReturn = [dict integerValueForKey:@"is_support_return" defaultValue:0]>0?YES:NO;
        
        _goodsResourceList = [[dict arrayValueForKey:@"goodsResourceList"] mutableCopy];
        _voucherPictures = [[dict arrayValueForKey:@"voucherPictures"] mutableCopy];
        
        _expected_delivery_type = [dict integerValueForKey:@"expected_delivery_type"];
        
        NSArray *attrInfoListDict = [dict arrayValueForKey:@"attr_info_list"];
        NSMutableArray *attrInfoList = [[NSMutableArray alloc] initWithCapacity:attrInfoListDict.count];
        for (NSDictionary *dict in attrInfoListDict) {
            [attrInfoList addObject:[AttrEditableInfo createWithDict:dict]];
        }
        _attrInfoList = attrInfoList;
        
        NSArray *tagListDict = [dict arrayValueForKey:@"tag_list"];
        NSMutableArray *tagList = [[NSMutableArray alloc] initWithCapacity:tagListDict.count];
        for (NSDictionary *dict in tagListDict) {
            [tagList addObject:[TagVo createWithDict:dict]];
        }
        _tagList = tagList;
    }
    return self;
}

- (NSDictionary*)toDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_goodsId?_goodsId:@"" forKey:@"goods_id"];
    [dict setObject:_goodsName?_goodsName:@"" forKey:@"goods_name"];
    [dict setObject:_orderId?_orderId:@"" forKey:@"order_id"];
    [dict setObject:[NSNumber numberWithFloat:_shopPrice] forKey:@"shop_price"];
    [dict setObject:[NSNumber numberWithFloat:_marketPrice] forKey:@"market_price"];
    
    [dict setObject:[NSNumber numberWithInteger:_shopPriceCent] forKey:@"shop_price_cent"];
    [dict setObject:[NSNumber numberWithInteger:_marketPriceCent] forKey:@"market_price_cent"];
    
    [dict setObject:_goodsResourceList?_goodsResourceList:@[] forKey:@"goodsResourceList"];
//    [dict setObject:_voucherPictures?_voucherPictures:[@[] mutableCopy] forKey:@"voucherPictures"];
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    if (_voucherPictures) {
        for (NSInteger i = 0; i < _voucherPictures.count; i++) {
            if ([_voucherPictures[i] class] == [PictureItem class]) {
                [tempArr addObject:[_voucherPictures[i] toDictionary]];
            } else {
                [tempArr addObject:_voucherPictures[i]];
            }
        }
    }
    [dict setObject:tempArr forKey:@"voucherPictures"];
    
    if (_mainPicItem) {
        [dict setObject:[_mainPicItem toDictionary] forKey:@"main_pic"];
    }
    [dict setObject:[NSNumber numberWithInteger:_categoryId] forKey:@"category_id"];
    
    //修改业务逻辑 发布时可选 不可选 2016.3.31 Feng
    [dict setObject:_categoryName?_categoryName:@"" forKey:@"category_name"];
    
    [dict setObject:[NSNumber numberWithInteger:_brandId] forKey:@"brand_id"];
    [dict setObject:_brandName?_brandName:@"" forKey:@"brand_name"];
    [dict setObject:_brandEnName?_brandEnName:@"" forKey:@"brand_en_name"];
    [dict setObject:[NSNumber numberWithInteger:_grade] forKey:@"grade"];
    [dict setObject:_gradeName?_gradeName:@"" forKey:@"gradeName"];
    [dict setObject:[NSNumber numberWithInteger:_fitPeople] forKey:@"fit_people"];
    [dict setObject:_summary?_summary:@"" forKey:@"summary"];
    [dict setObject:[NSNumber numberWithInteger:_isSupportReturn?1:0] forKey:@"is_support_return"];
    
    [dict setObject:[NSNumber numberWithInteger:_expected_delivery_type] forKey:@"expected_delivery_type"];
    
    NSMutableArray *gallaryItems = [[NSMutableArray alloc] init];
    for (PictureItem *item in _gallary) {
        NSDictionary *dict = [item toDictionary];
        if (dict) {
            [gallaryItems addObject:dict];
        }
    }
    [dict setObject:gallaryItems forKey:@"gallary"];
    
    NSMutableArray *attrInfoList = [[NSMutableArray alloc] init];
    for (AttrEditableInfo *editInfo in _attrInfoList) {
        GoodsEditableAttrIdValue *IdValue = [GoodsEditableAttrIdValue buildAttrIdValue:editInfo.attrId attrValue:editInfo.attrValue];
        if ([IdValue isValid]) {
            [attrInfoList addObject:[[GoodsEditableAttrIdValue buildAttrIdValue:editInfo.attrId attrValue:editInfo.attrValue] toDictionary]];
        }
    }
    [dict setObject:attrInfoList forKey:@"attr_info_list"];
    
    NSMutableArray *tagDictList = [[NSMutableArray alloc] init];
    for (TagVo *tagVo in _tagList) {
        [tagDictList addObject:[tagVo toDictionary]];
    }
    [dict setObject:tagDictList forKey:@"tag_list"];
    
    return dict;
}

+ (NSString*)fitPeopleString:(NSInteger)fitPeople
{
    switch (fitPeople) {
        case 0: return @"所有人";
        case 1: return @"男";
        case 2: return @"女";
    }
    return @"";
}


#pragma mark - coding
//归档方法
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //归档name
    [aCoder encodeObject:self.gallary forKey:@"gallary"];
    [aCoder encodeObject:self.goodsId forKey:@"goodsId"];
    [aCoder encodeObject:self.mainPicItem forKey:@"mainPicItem"];
    [aCoder encodeObject:self.goodsName forKey:@"goodsName"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.shopPrice] forKey:@"shopPrice"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.marketPrice] forKey:@"marketPrice"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.shopPriceCent] forKey:@"shopPriceCent"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.marketPriceCent] forKey:@"marketPriceCent"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.categoryId] forKey:@"categoryId"];
    [aCoder encodeObject:self.categoryName forKey:@"categoryName"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.brandId] forKey:@"brandId"];
    [aCoder encodeObject:self.brandName forKey:@"brandName"];
    [aCoder encodeObject:self.brandEnName forKey:@"brandEnName"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.grade] forKey:@"grade"];
    [aCoder encodeObject:self.gradeName forKey:@"gradeName"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fitPeople] forKey:@"fitPeople"];
    [aCoder encodeObject:self.summary forKey:@"summary"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isSupportReturn] forKey:@"isSupportReturn"];
    [aCoder encodeObject:self.attrInfoList forKey:@"attrInfoList"];
    [aCoder encodeObject:self.tagList forKey:@"tagList"];
    [aCoder encodeObject:self.goodsResourceList forKey:@"goodsResourceList"];
    [aCoder encodeObject:self.voucherPictures forKey:@"voucherPictures"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isModified] forKey:@"isModified"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.expected_delivery_type] forKey:@"expected_delivery_type"];
}

//解档方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.gallary = [aDecoder decodeObjectForKey:@"gallary"];
        self.goodsId = [aDecoder decodeObjectForKey:@"goodsId"];
        self.mainPicItem = [aDecoder decodeObjectForKey:@"mainPicItem"];
        self.goodsName = [aDecoder decodeObjectForKey:@"goodsName"];
        self.shopPrice = [[aDecoder decodeObjectForKey:@"shopPrice"] doubleValue];
        self.marketPrice = [[aDecoder decodeObjectForKey:@"marketPrice"] doubleValue];
        self.shopPriceCent = [[aDecoder decodeObjectForKey:@"shopPriceCent"] integerValue];
        self.marketPriceCent = [[aDecoder decodeObjectForKey:@"marketPriceCent"] integerValue];
        self.categoryId = [[aDecoder decodeObjectForKey:@"categoryId"] integerValue];
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        self.brandId = [[aDecoder decodeObjectForKey:@"brandId"] integerValue];
        self.brandName = [aDecoder decodeObjectForKey:@"brandName"];
        self.brandEnName = [aDecoder decodeObjectForKey:@"brandEnName"];
        self.grade = [[aDecoder decodeObjectForKey:@"grade"] integerValue];
        self.gradeName = [aDecoder decodeObjectForKey:@"gradeName"];
        self.fitPeople = [[aDecoder decodeObjectForKey:@"fitPeople"] integerValue];
        self.summary = [aDecoder decodeObjectForKey:@"summary"];
        self.isSupportReturn = [[aDecoder decodeObjectForKey:@"isSupportReturn"] boolValue]>0?YES:NO;
        self.attrInfoList = [aDecoder decodeObjectForKey:@"attrInfoList"];
        self.tagList = [aDecoder decodeObjectForKey:@"tagList"];
        self.goodsResourceList = [aDecoder decodeObjectForKey:@"goodsResourceList"];
        self.voucherPictures = [aDecoder decodeObjectForKey:@"voucherPictures"];
        self.isModified = [[aDecoder decodeObjectForKey:@"isModified"] boolValue]>0?YES:NO;
        self.expected_delivery_type = [[aDecoder decodeObjectForKey:@"expected_delivery_type"] integerValue];
        
    }
    return self;
}
@end


@implementation GoodsPublishResultInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _goodsId = [dict stringValueForKey:@"goods_id"];
        _totalNum = [dict integerValueForKey:@"total_num" defaultValue:0];
    }
    return self;
}

@end


@implementation GradeInfo
+ (GradeInfo*)allocGradeInfo:(NSInteger)grade gradeName:(NSString*)gradeName gradeDesc:(NSString*)gradeDesc {
    GradeInfo *gradeInfo = [[GradeInfo alloc] init];
    gradeInfo.grade = grade;
    gradeInfo.gradeName = gradeName;
    gradeInfo.gradeDesc = gradeDesc;
    return gradeInfo;
}

+ (GradeInfo*)allocGradeInfo:(NSInteger)grade gradeName:(NSString*)gradeName gradeDesc:(NSString*)gradeDesc summary:(NSString*)summary {
    GradeInfo *gradeInfo = [[GradeInfo alloc] init];
    gradeInfo.grade = grade;
    gradeInfo.gradeName = gradeName;
    gradeInfo.gradeDesc = gradeDesc;
    gradeInfo.gradeSummary = summary;
    return gradeInfo;
}

+ (GradeInfo*)gradeInfoByGrade:(NSInteger)grade
{
    NSArray *array = [self allGradeInfoArray];
    for (GradeInfo *info in array) {
        if (info.grade == grade) {
            return info;
        }
    }
    return nil;
}

+ (NSArray*)allGradeInfoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[GradeInfo allocGradeInfo:1 gradeName:@"全新" gradeDesc:@"未使用品" summary:@"全新品未曾使用，无任何痕迹"]];
    [array addObject:[GradeInfo allocGradeInfo:5 gradeName:@"98成新" gradeDesc:@"未使用品，陈列品" summary:@"有极其轻微放置痕迹，因陈列导致有极其轻微的磨损"]];
    [array addObject:[GradeInfo allocGradeInfo:2 gradeName:@"95成新" gradeDesc:@"几乎未使用过" summary:@"整体成色较新，有轻微使用痕迹，品相完整"]];
    [array addObject:[GradeInfo allocGradeInfo:3 gradeName:@"9成新" gradeDesc:@"偶尔使用" summary:@"外观有日常使⽤用痕迹，局部有少数划痕、污渍、磨损等情况，品相良好"]];
    [array addObject:[GradeInfo allocGradeInfo:6 gradeName:@"85成新" gradeDesc:@"正常使用" summary:@"外观有⽇常使⽤用痕迹，局部有明显划痕、污渍、磨损等情况，品相普通"]];
    [array addObject:[GradeInfo allocGradeInfo:4 gradeName:@"8成新" gradeDesc:@"长期使用" summary:@"外观有长期使用痕迹，局部有较严重划痕、污渍、磨损等情况，不影响正常使⽤"]];
    return array;
}

@end

//全新：未使用 全新品未曾使用，无任何痕迹 95新
//
//95新：几乎未使用过！
//           包：仅皮面、手柄上有非常细小的痕迹，内里微小使用痕迹;
//           配饰：眼镜边框有细小刮痕；皮带有轻微使用痕迹
//     我们不接受：里面或外面有污渍印记、四角或边缘有使用痕迹、光面皮有刮痕、麂皮掉皮、褪色等;金属生锈、褪色或有明显划痕 眼镜片有刮痕；围巾有污点、松懈、有味道等
//
//9新 ：偶尔使用！
//           包：使用痕迹不明显，如皮面上有一点摩擦，仅内里有一点污渍
//           配饰：轻微使用痕迹，略有点松懈、金属细微掉色或变色
//     我们不接受：边角凹陷不平、内里明显有脏的痕迹、有味道、明显护理痕迹等； 装饰元素有脱落、铆钉；织料部分拉丝、压痕明显
//
//8新 ：正常使用！
//          包：边角稍有不平，轻微磨损、皮面有个别摩擦痕迹，内里稍微松懈变旧
//          配饰：个别装饰元素脱落，扣子，铆钉，贴片等


@implementation AttrEditableInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _attrId = [dict integerValueForKey:@"attr_id" defaultValue:0];
        _attrName = [dict stringValueForKey:@"attr_name"];
        _attrValue = [dict stringValueForKey:@"attr_value"];
        _placeholder = [dict stringValueForKey:@"placeholder"];
        _explain = [dict stringValueForKey:@"explain"];
        _isMust = [dict integerValueForKey:@"is_must" defaultValue:0]?YES:NO;
        _type = [dict integerValueForKey:@"type" defaultValue:kTYPE_SELECT];
        _is_multi_choice = [dict integerValueForKey:@"is_multi_choice"];
        _values = [[NSMutableArray alloc] initWithArray:[dict arrayValueForKey:@"list"]];
    }
    return self;
}


//归档方法
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //归档name
    [aCoder encodeObject:[NSNumber numberWithInteger:self.attrId] forKey:@"attrId"];
    [aCoder encodeObject:self.attrName forKey:@"attrName"];
    [aCoder encodeObject:self.attrValue forKey:@"attrValue"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [aCoder encodeObject:self.values forKey:@"values"];
    [aCoder encodeObject:self.placeholder forKey:@"placeholder"];
    [aCoder encodeObject:self.explain forKey:@"explain"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isMust] forKey:@"isMust"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.is_multi_choice] forKey:@"is_multi_choice"];

}

//解档方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.attrId = [[aDecoder decodeObjectForKey:@"attrId"] integerValue];
        self.attrName = [aDecoder decodeObjectForKey:@"attrName"];
        self.attrValue = [aDecoder decodeObjectForKey:@"attrValue"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
        self.values = [aDecoder decodeObjectForKey:@"values"];
        self.placeholder = [aDecoder decodeObjectForKey:@"placeholder"];
        self.explain = [aDecoder decodeObjectForKey:@"explain"];
        self.isMust = [[aDecoder decodeObjectForKey:@"isMust"] boolValue];
        self.is_multi_choice = [[aDecoder decodeObjectForKey:@"is_multi_choice"] integerValue];
    }
    return self;
}

@end


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



