//
//  DataListLogic.h
//  XianMao
//
//  Created by simon on 12/8/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

///===================================================================================
@class XMError;
@class DataListLogic;

typedef void(^DataListLogicStartRefreshList)(DataListLogic *dataListLogic);
typedef void(^DataListLogicDidRefresh)(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished);
typedef void(^DataListLogicStartLoadMore)(DataListLogic *dataListLogic);
typedef void(^DataListLogicDidDataReceived)(DataListLogic *dataListLogic, const NSArray* addedItems, BOOL loadFinished);
typedef void(^DataListLogicDidErrorOcurred)(DataListLogic *dataListLogic, XMError *error);
typedef void(^DataListLogicDidCancel)(DataListLogic *dataListLogic);
typedef void(^DataListLogicLoadFinishWithNoContent)(DataListLogic *dataListLogic);
                                            
@protocol DataListLogicDataSource;

@protocol DataListCacheStrategy <NSObject>
@optional
- (void)saveItemsAtBegin:(NSArray*)itemList;
- (void)saveItems:(NSArray*)itemList fefreshCache:(BOOL)fefreshCache;
- (id)getItemAt:(NSInteger)index;
- (NSInteger)totalCount;
- (NSArray*)featchData:(NSInteger)startIndex size:(NSInteger)size;
- (void)saveToFile:(NSString*)filePath maxCount:(NSInteger)maxCount;
@end

@interface DataListLogic : NSObject

@property(nonatomic,assign) id<DataListLogicDataSource> dataSource;
@property(nonatomic,strong) id<DataListCacheStrategy> cacheStrategy;

@property (nonatomic, assign) BOOL isPOST;
@property(nonatomic,readonly) BOOL hasNextPage;

- (instancetype)initWithModulePath:(NSString*)module path:(NSString*)path pageSize:(NSInteger)pageSize fetchSize:(NSInteger)fetchSize;
- (instancetype)initWithModulePath:(NSString*)module path:(NSString*)path pageSize:(NSInteger)pageSize;

@property(nonatomic,copy) DataListLogicStartRefreshList dataListLogicStartRefreshList;
@property(nonatomic,copy) DataListLogicDidRefresh dataListLogicDidRefresh;
@property(nonatomic,copy) DataListLogicStartLoadMore dataListLogicStartLoadMore;
@property(nonatomic,copy) DataListLogicDidDataReceived dataListLogicDidDataReceived;
@property(nonatomic,copy) DataListLogicDidErrorOcurred dataListLogicDidErrorOcurred;
@property(nonatomic,copy) DataListLogicDidCancel dataListLogicDidCancel;
@property(nonatomic,copy) DataListLogicLoadFinishWithNoContent dataListLoadFinishWithNoContent;

@property(nonatomic,strong) NSDictionary *parameters;

- (void)loadFromCache;
- (void)firstLoadFromCache;
- (void)reloadDataListByForce;
- (void)reloadDataList;
- (void)nextPage;

- (NSInteger)totalCount;
- (id)getItemAt:(NSInteger)index;

@end

@interface NSDictionary (DataListLogic)

- (BOOL)hasNextPage;
- (NSArray*)itemList;
- (long long)timestamp;
- (BOOL)reload;

@end

@interface NSDictionary (DataListItem)

- (long long)itemTimestamp;

@end


@interface DataListItem : NSObject

@property(nonatomic,assign) NSInteger type;
@property(nonatomic,assign) NSInteger lastUpdateTime;
@property(nonatomic,strong) id item;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

@protocol DataListLogicDataSource <NSObject>
@optional
- (NSArray*)featchData:(NSInteger)startIndex size:(NSInteger)size;
- (void)loadData:(NSInteger)page size:(NSInteger)size;
@end

@interface DataListCacheArray : NSObject<DataListCacheStrategy>

- (void)saveItemsAtBegin:(NSArray*)itemList;
- (void)saveItems:(NSArray*)itemList fefreshCache:(BOOL)fefreshCache;
- (id)getItemAt:(NSInteger)index;
- (NSInteger)totalCount;

- (NSArray*)featchData:(NSInteger)startIndex size:(NSInteger)size;
- (void)loadData:(NSInteger)page size:(NSInteger)size;

- (void)saveToFile:(NSString*)filePath maxCount:(NSInteger)maxCount;
- (void)loadFromFile:(NSString*)filePath;

@end

//@interface DataListCacheDB : NSObject<DataListCacheStrategy>
//
//- (void)saveItems:(NSArray*)itemList;
//- (void)saveItems:(NSArray*)itemList fefresh:(BOOL)fefresh;
//- (id)getItemAt:(NSInteger)index;
//- (NSInteger)totalCount;
//
//@end

//@interface DataListLogicDataSourceMemory : NSObject
//
//@end

//@interface DataListLogicDataSourceDB : NSObject
//- (void)save:(NSInteger)itemId item:(NSObject*)item;
//@end
//
//@interface DataListLogicDataSourceNetwork : NSObject
//
//@end

//1.page=0&size=15

//2.conmission_order_num=1  -> apns 推

//3.
//getConmissionOrderlistByUserId:(userId)
//getConmissionOrderStatusById:(c_orderId)

//
//请求：
//firstId, lastId,  size,
//
//1. 如果firstId和lastId都是空，为刷新， 返回最新size个
//2. 如果firstId为空  lastId不为空， 那么为从lastId 开始请求size个
//3. 如果firstId不为空，lastId为空，如果有比firstId还新的数据 返回size个，否则不返回数据。
//
//items: { }
//hasNextPage:1
//




/*
 查看物流：
 1.根据物流单号，
 
 */

//

//{data:}




