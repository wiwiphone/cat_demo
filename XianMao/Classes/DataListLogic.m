//
//  DataListLogic.m
//  XianMao
//
//  Created by simon on 12/8/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "DataListLogic.h"
#import "NetworkManager.h"
#import "NSDictionary+Additions.h"
#import "Session.h"
#import "JSONKit.h"
#define kDataListLogicDefaultFetchSize 20

@interface DataListLogic ()

@property(nonatomic,assign) NSInteger nextPageIndex;
@property(nonatomic,assign) NSInteger size;
@property(nonatomic,readwrite) BOOL hasNextPage;

@property(nonatomic,copy) NSString *module;
@property(nonatomic,copy) NSString *path;
@property(nonatomic,assign) long long firstItemModifyTime;
@property(nonatomic,assign) long long lastItemModifyTime;
@property(nonatomic,assign) NSInteger fetchSize;
@property(nonatomic,assign) BOOL fetchEnd;
@property(nonatomic,assign) NSInteger fetchPageIndex;

@property(nonatomic,strong) HTTPRequest *request;
@property(nonatomic,assign) BOOL requestCanceled;

@end

@implementation DataListLogic

- (instancetype)initWithModulePath:(NSString*)module path:(NSString*)path pageSize:(NSInteger)pageSize fetchSize:(NSInteger)fetchSize {
    self = [super init];
    if (self) {
        [self initialize:module path:path pageSize:pageSize fetchSize:fetchSize];
    }
    return self;
}

- (instancetype)initWithModulePath:(NSString*)module path:(NSString*)path pageSize:(NSInteger)pageSize  {
    self = [super init];
    if (self) {
        [self initialize:module path:path pageSize:pageSize fetchSize:kDataListLogicDefaultFetchSize];
    }
    return self;
}

- (void)dealloc
{
    [_request cancel];
}

- (void)initialize:(NSString*)module path:(NSString*)path pageSize:(NSInteger)pageSize fetchSize:(NSInteger)fetchSize {
    _module = module;
    _path = path;
    
    _nextPageIndex = -1;
    _size = pageSize;
    _hasNextPage = YES;
    
    _firstItemModifyTime = 0;
    _lastItemModifyTime = 0;
    
    _requestCanceled = NO;
 
    _fetchPageIndex = -1;
    _fetchSize = fetchSize;
    if (_fetchSize<_size) {
        _fetchSize = _size;
    }
    _fetchEnd = NO;
}

- (NSInteger)totalCount {
    if (self.cacheStrategy && [self.cacheStrategy respondsToSelector:@selector(totalCount)]) {
        return [self.cacheStrategy totalCount];
    }
    return 0;
}

- (id)getItemAt:(NSInteger)index {
    if (self.cacheStrategy && [self.cacheStrategy respondsToSelector:@selector(getItemAt:)]) {
        return [self.cacheStrategy getItemAt:index];
    }
    return nil;
}

- (void)loadFromCache {
    _fetchPageIndex = -1;
    _nextPageIndex = -1;
    _firstItemModifyTime = 0;
    _lastItemModifyTime = 0;
    
    WEAKSELF;
    if (self.cacheStrategy) {
        if ([self.cacheStrategy totalCount]>0) {
            id firstItem = [weakSelf.cacheStrategy getItemAt:0];
            id lastItem = [weakSelf.cacheStrategy getItemAt:[weakSelf.cacheStrategy totalCount]-1];
            
            if ([firstItem isKindOfClass:[NSDictionary class]]) {
                weakSelf.firstItemModifyTime = [((NSDictionary*)firstItem) itemTimestamp];
            }
            if ([lastItem isKindOfClass:[NSDictionary class]]) {
                weakSelf.lastItemModifyTime = [((NSDictionary*)lastItem) itemTimestamp];
            }
        }
        
        NSArray *itemList = [self.cacheStrategy featchData:0 size:_size];
        if (itemList != nil && itemList > 0 ) {
            
            if (weakSelf.dataListLogicDidDataReceived) {
                weakSelf.dataListLogicDidDataReceived(self,itemList, !self.hasNextPage);
            }
        }
    }
}

- (void)firstLoadFromCache {
    [self loadFromCache];

    // 实现上调整为reloadDataListByForce一致（后面重构下）
    _firstItemModifyTime = 0;
    _lastItemModifyTime = 0;
    _fetchPageIndex = -1;
    _nextPageIndex = -1;
    _hasNextPage = NO;
    
    [self reloadDataList];
}

- (void)reloadDataListByForce
{
    _firstItemModifyTime = 0;
    _lastItemModifyTime = 0;
    _fetchPageIndex = -1;
    _nextPageIndex = -1;
    _hasNextPage = NO;
    
    [self reloadDataList];
}

- (id<DataListCacheStrategy>)cacheStrategy {
    if (!_cacheStrategy) {
        _cacheStrategy = [[DataListCacheArray alloc] init];
    }
    return _cacheStrategy;
}

- (void)reloadDataList
{
    if (_dataListLogicStartRefreshList) {
        _dataListLogicStartRefreshList(self);
    }
    
    WEAKSELF;
    
    if (self.isPOST) {
        
        [self fetchDataPOST:_module path:_path latestTime:_firstItemModifyTime requestType:0 size:_fetchSize completionBlock:^(BOOL reload, BOOL hasNextPage, NSArray *itemList, long long timestamp)
        {
            if (reload) {
                if (weakSelf.cacheStrategy && [weakSelf.cacheStrategy respondsToSelector:@selector(saveItems:fefreshCache:)]) {
                    [weakSelf.cacheStrategy saveItems:itemList fefreshCache:YES];
                }
            } else {
                if (weakSelf.cacheStrategy && [weakSelf.cacheStrategy respondsToSelector:@selector(saveItemsAtBegin:)]) {
                    [weakSelf.cacheStrategy saveItemsAtBegin:itemList];
                }
            }
            
            if ((weakSelf.nextPageIndex==-1 && weakSelf.firstItemModifyTime == 0) || reload) //首次加载,或者服务器告知重新加载
            {
                weakSelf.fetchEnd = !hasNextPage;
                
                if ([itemList count]==0) {
                    weakSelf.hasNextPage = !weakSelf.fetchEnd;
                    if (weakSelf.dataListLoadFinishWithNoContent) {
                        weakSelf.dataListLoadFinishWithNoContent(weakSelf);
                    }
                } else {
                    NSArray *cachedItemList = [weakSelf.cacheStrategy featchData:0 size:weakSelf.size];
                    //1.1.2列表逻辑调整
                    //>>Start
                    /*
                     if (cachedItemList==nil||[cachedItemList count]<weakSelf.size) {
                     weakSelf.hasNextPage = hasNextPage;
                     if (!weakSelf.hasNextPage) {
                     if (weakSelf.dataListLogicDidRefresh) {
                     weakSelf.dataListLogicDidRefresh(weakSelf,YES, cachedItemList,!weakSelf.hasNextPage);
                     }
                     } else {
                     //ERROR.....
                     }
                     
                     } else {
                     weakSelf.nextPageIndex = 0;
                     weakSelf.hasNextPage = YES;
                     if (weakSelf.dataListLogicDidRefresh) {
                     weakSelf.dataListLogicDidRefresh(weakSelf,YES, cachedItemList,!weakSelf.hasNextPage);
                     }
                     }
                     */
                    if (cachedItemList==nil) {
                        weakSelf.hasNextPage = hasNextPage;
                        if (weakSelf.dataListLogicDidRefresh) {
                            weakSelf.dataListLogicDidRefresh(weakSelf,YES, cachedItemList,!weakSelf.hasNextPage);
                        }
                    } else {
                        if ([cachedItemList count]<weakSelf.size) {
                            weakSelf.nextPageIndex = 0;
                            weakSelf.hasNextPage = hasNextPage;
                            if (weakSelf.dataListLogicDidRefresh) {
                                weakSelf.dataListLogicDidRefresh(weakSelf,YES, cachedItemList,!weakSelf.hasNextPage);
                            }
                        } else {
                            weakSelf.nextPageIndex = 0;
                            weakSelf.hasNextPage = YES;
                            if (weakSelf.dataListLogicDidRefresh) {
                                weakSelf.dataListLogicDidRefresh(weakSelf,YES, cachedItemList,!weakSelf.hasNextPage);
                            }
                        }
                    }
                    //<<End
                }
            }
            else
            {
                if (weakSelf.dataListLogicDidRefresh) {
                    weakSelf.dataListLogicDidRefresh(weakSelf,NO, itemList,!weakSelf.hasNextPage);
                }
            }
            
            id firstItem = [weakSelf.cacheStrategy getItemAt:0];
            id lastItem = [weakSelf.cacheStrategy getItemAt:[weakSelf.cacheStrategy totalCount]-1];
            
            if ([firstItem isKindOfClass:[NSDictionary class]]) {
                weakSelf.firstItemModifyTime = [((NSDictionary*)firstItem) itemTimestamp];
            }
            if ([lastItem isKindOfClass:[NSDictionary class]]) {
                weakSelf.lastItemModifyTime = [((NSDictionary*)lastItem) itemTimestamp];
            }
            
        } cancel:^{
            if (weakSelf.dataListLogicDidCancel) {
                weakSelf.dataListLogicDidCancel(weakSelf);
            }
        } failure:^(XMError *error) {
            if (weakSelf.dataListLogicDidErrorOcurred) {
                weakSelf.dataListLogicDidErrorOcurred(weakSelf,error);
            }
        } queue:nil];
        
    } else {
        [self fetchData:_module path:_path latestTime:_firstItemModifyTime requestType:0 size:_fetchSize
        completionBlock:^(BOOL reload, BOOL hasNextPage, NSArray *itemList, long long timestamp)
         {
             if (reload) {
                 if (weakSelf.cacheStrategy && [weakSelf.cacheStrategy respondsToSelector:@selector(saveItems:fefreshCache:)]) {
                     [weakSelf.cacheStrategy saveItems:itemList fefreshCache:YES];
                 }
             } else {
                 if (weakSelf.cacheStrategy && [weakSelf.cacheStrategy respondsToSelector:@selector(saveItemsAtBegin:)]) {
                     [weakSelf.cacheStrategy saveItemsAtBegin:itemList];
                 }
             }
             
             if ((weakSelf.nextPageIndex==-1 && weakSelf.firstItemModifyTime == 0) || reload) //首次加载,或者服务器告知重新加载
             {
                 weakSelf.fetchEnd = !hasNextPage;
                 
                 if ([itemList count]==0) {
                     weakSelf.hasNextPage = !weakSelf.fetchEnd;
                     if (weakSelf.dataListLoadFinishWithNoContent) {
                         weakSelf.dataListLoadFinishWithNoContent(weakSelf);
                     }
                 } else {
                     NSArray *cachedItemList = [weakSelf.cacheStrategy featchData:0 size:weakSelf.size];
                     //1.1.2列表逻辑调整
                     //>>Start
                     /*
                      if (cachedItemList==nil||[cachedItemList count]<weakSelf.size) {
                      weakSelf.hasNextPage = hasNextPage;
                      if (!weakSelf.hasNextPage) {
                      if (weakSelf.dataListLogicDidRefresh) {
                      weakSelf.dataListLogicDidRefresh(weakSelf,YES, cachedItemList,!weakSelf.hasNextPage);
                      }
                      } else {
                      //ERROR.....
                      }
                      
                      } else {
                      weakSelf.nextPageIndex = 0;
                      weakSelf.hasNextPage = YES;
                      if (weakSelf.dataListLogicDidRefresh) {
                      weakSelf.dataListLogicDidRefresh(weakSelf,YES, cachedItemList,!weakSelf.hasNextPage);
                      }
                      }
                      */
                     if (cachedItemList==nil) {
                         weakSelf.hasNextPage = hasNextPage;
                         if (weakSelf.dataListLogicDidRefresh) {
                             weakSelf.dataListLogicDidRefresh(weakSelf,YES, cachedItemList,!weakSelf.hasNextPage);
                         }
                     } else {
                         if ([cachedItemList count]<weakSelf.size) {
                             weakSelf.nextPageIndex = 0;
                             weakSelf.hasNextPage = hasNextPage;
                             if (weakSelf.dataListLogicDidRefresh) {
                                 weakSelf.dataListLogicDidRefresh(weakSelf,YES, cachedItemList,!weakSelf.hasNextPage);
                             }
                         } else {
                             weakSelf.nextPageIndex = 0;
                             weakSelf.hasNextPage = YES;
                             if (weakSelf.dataListLogicDidRefresh) {
                                 weakSelf.dataListLogicDidRefresh(weakSelf,YES, cachedItemList,!weakSelf.hasNextPage);
                             }
                         }
                     }
                     //<<End
                 }
             }
             else
             {
                 if (weakSelf.dataListLogicDidRefresh) {
                     weakSelf.dataListLogicDidRefresh(weakSelf,NO, itemList,!weakSelf.hasNextPage);
                 }
             }
             
             id firstItem = [weakSelf.cacheStrategy getItemAt:0];
             id lastItem = [weakSelf.cacheStrategy getItemAt:[weakSelf.cacheStrategy totalCount]-1];
             
             if ([firstItem isKindOfClass:[NSDictionary class]]) {
                 weakSelf.firstItemModifyTime = [((NSDictionary*)firstItem) itemTimestamp];
             }
             if ([lastItem isKindOfClass:[NSDictionary class]]) {
                 weakSelf.lastItemModifyTime = [((NSDictionary*)lastItem) itemTimestamp];
             }
             
         } cancel:^{
             if (weakSelf.dataListLogicDidCancel) {
                 weakSelf.dataListLogicDidCancel(weakSelf);
             }
         } failure:^(XMError *error) {
             if (weakSelf.dataListLogicDidErrorOcurred) {
                 weakSelf.dataListLogicDidErrorOcurred(weakSelf,error);
             }
         } queue:nil];
    }
}

- (void)nextPage
{
    if (_hasNextPage && [self isRequestFinshed])
    {
        if (_dataListLogicStartLoadMore) {
            _dataListLogicStartLoadMore(self);
        }
        
        WEAKSELF;
        BOOL needFetchFromNetwork = YES;
        
        NSArray *cachedItemList = [self.cacheStrategy featchData:(_nextPageIndex+1)*_size size:_size];
        if (cachedItemList==nil||[cachedItemList count]<_size) {
            weakSelf.hasNextPage = !weakSelf.fetchEnd;
            if (!weakSelf.hasNextPage) {
                if (weakSelf.dataListLogicDidDataReceived) {
                    weakSelf.dataListLogicDidDataReceived(weakSelf,cachedItemList,!weakSelf.hasNextPage);
                }
            }
        } else {
            weakSelf.nextPageIndex += 1;
            if (weakSelf.dataListLogicDidDataReceived) {
                weakSelf.dataListLogicDidDataReceived(weakSelf,cachedItemList,!weakSelf.hasNextPage);
            }
        }
        
        if (weakSelf.fetchEnd) {
            needFetchFromNetwork = NO;
        } else {
            if ([weakSelf.cacheStrategy totalCount]>(_nextPageIndex+1)*_size+_size) {
                needFetchFromNetwork = NO;
            }
        }
        
        if (needFetchFromNetwork) {
            
            if (weakSelf.isPOST) {
                [self fetchDataPOST:_module path:_path latestTime:_lastItemModifyTime requestType:1 size:_fetchSize completionBlock:^(BOOL reload, BOOL hasNextPage, NSArray *itemList, long long timestamp) {
                    if (reload) {
                        if (weakSelf.dataListLogicDidErrorOcurred) {
                            weakSelf.dataListLogicDidErrorOcurred(weakSelf,[XMError errorWithCode:XMSeverDataListLogicExceptionError]);
                        }
                    } else {
                        
                        weakSelf.fetchEnd = !hasNextPage;
                        
                        if (weakSelf.cacheStrategy && [weakSelf.cacheStrategy respondsToSelector:@selector(saveItems:fefreshCache:)]) {
                            [weakSelf.cacheStrategy saveItems:itemList fefreshCache:NO];
                        }
                        
                        if (weakSelf.cacheStrategy && [weakSelf.cacheStrategy totalCount]>0) {
                            id firstItem = [weakSelf.cacheStrategy getItemAt:0];
                            id lastItem = [weakSelf.cacheStrategy getItemAt:[weakSelf.cacheStrategy totalCount]-1];
                            if ([firstItem isKindOfClass:[NSDictionary class]]) {
                                weakSelf.firstItemModifyTime = [((NSDictionary*)firstItem) itemTimestamp];
                            }
                            if ([lastItem isKindOfClass:[NSDictionary class]]) {
                                weakSelf.lastItemModifyTime = [((NSDictionary*)lastItem) itemTimestamp];
                            }
                        }
                        
                        if (weakSelf.cacheStrategy) {
                            NSArray *itemList2 = [weakSelf.cacheStrategy featchData:(weakSelf.nextPageIndex+1)*weakSelf.size size:weakSelf.size];
                            //1.1.2列表逻辑调整
                            //>>Start
                            /*
                             if (itemList2 == nil || [itemList2 count]<_size) {
                             weakSelf.hasNextPage = hasNextPage;
                             if (!weakSelf.hasNextPage) {
                             if (weakSelf.dataListLogicDidDataReceived) {
                             weakSelf.dataListLogicDidDataReceived(weakSelf,itemList2,!weakSelf.hasNextPage);
                             }
                             }
                             } else {
                             weakSelf.nextPageIndex +=1;
                             weakSelf.hasNextPage = YES;
                             if (weakSelf.dataListLogicDidDataReceived) {
                             weakSelf.dataListLogicDidDataReceived(weakSelf,itemList2,!weakSelf.hasNextPage);
                             }
                             }
                             */
                            if (itemList2 == nil) {
                                weakSelf.hasNextPage = hasNextPage;
                                if (weakSelf.dataListLogicDidDataReceived) {
                                    weakSelf.dataListLogicDidDataReceived(weakSelf,itemList2,!weakSelf.hasNextPage);
                                }
                            } else {
                                weakSelf.nextPageIndex +=1;
                                weakSelf.hasNextPage = YES;
                                if (weakSelf.dataListLogicDidDataReceived) {
                                    weakSelf.dataListLogicDidDataReceived(weakSelf,itemList2,!weakSelf.hasNextPage);
                                }
                            }
                            //<<End
                        }
                    }
                } cancel:^{
                    if (weakSelf.dataListLogicDidCancel) {
                        weakSelf.dataListLogicDidCancel(weakSelf);
                    }
                } failure:^(XMError *error) {
                    if (weakSelf.dataListLogicDidErrorOcurred) {
                        weakSelf.dataListLogicDidErrorOcurred(weakSelf,error);
                    }
                } queue:nil];
            } else {
                [self fetchData:_module path:_path latestTime:_lastItemModifyTime requestType:1 size:_fetchSize completionBlock:^(BOOL reload, BOOL hasNextPage, NSArray *itemList, long long timestamp) {
                    if (reload) {
                        if (weakSelf.dataListLogicDidErrorOcurred) {
                            weakSelf.dataListLogicDidErrorOcurred(weakSelf,[XMError errorWithCode:XMSeverDataListLogicExceptionError]);
                        }
                    } else {
                        
                        weakSelf.fetchEnd = !hasNextPage;
                        
                        if (weakSelf.cacheStrategy && [weakSelf.cacheStrategy respondsToSelector:@selector(saveItems:fefreshCache:)]) {
                            [weakSelf.cacheStrategy saveItems:itemList fefreshCache:NO];
                        }
                        
                        if (weakSelf.cacheStrategy && [weakSelf.cacheStrategy totalCount]>0) {
                            id firstItem = [weakSelf.cacheStrategy getItemAt:0];
                            id lastItem = [weakSelf.cacheStrategy getItemAt:[weakSelf.cacheStrategy totalCount]-1];
                            if ([firstItem isKindOfClass:[NSDictionary class]]) {
                                weakSelf.firstItemModifyTime = [((NSDictionary*)firstItem) itemTimestamp];
                            }
                            if ([lastItem isKindOfClass:[NSDictionary class]]) {
                                weakSelf.lastItemModifyTime = [((NSDictionary*)lastItem) itemTimestamp];
                            }
                        }
                        
                        if (weakSelf.cacheStrategy) {
                            NSArray *itemList2 = [weakSelf.cacheStrategy featchData:(weakSelf.nextPageIndex+1)*weakSelf.size size:weakSelf.size];
                            //1.1.2列表逻辑调整
                            //>>Start
                            /*
                             if (itemList2 == nil || [itemList2 count]<_size) {
                             weakSelf.hasNextPage = hasNextPage;
                             if (!weakSelf.hasNextPage) {
                             if (weakSelf.dataListLogicDidDataReceived) {
                             weakSelf.dataListLogicDidDataReceived(weakSelf,itemList2,!weakSelf.hasNextPage);
                             }
                             }
                             } else {
                             weakSelf.nextPageIndex +=1;
                             weakSelf.hasNextPage = YES;
                             if (weakSelf.dataListLogicDidDataReceived) {
                             weakSelf.dataListLogicDidDataReceived(weakSelf,itemList2,!weakSelf.hasNextPage);
                             }
                             }
                             */
                            if (itemList2 == nil) {
                                weakSelf.hasNextPage = hasNextPage;
                                if (weakSelf.dataListLogicDidDataReceived) {
                                    weakSelf.dataListLogicDidDataReceived(weakSelf,itemList2,!weakSelf.hasNextPage);
                                }
                            } else {
                                weakSelf.nextPageIndex +=1;
                                weakSelf.hasNextPage = YES;
                                if (weakSelf.dataListLogicDidDataReceived) {
                                    weakSelf.dataListLogicDidDataReceived(weakSelf,itemList2,!weakSelf.hasNextPage);
                                }
                            }
                            //<<End
                        }
                    }
                } cancel:^{
                    if (weakSelf.dataListLogicDidCancel) {
                        weakSelf.dataListLogicDidCancel(weakSelf);
                    }
                } failure:^(XMError *error) {
                    if (weakSelf.dataListLogicDidErrorOcurred) {
                        weakSelf.dataListLogicDidErrorOcurred(weakSelf,error);
                    }
                } queue:nil];
            }
        }
    }
}

- (BOOL)isRequestFinshed {
    return self.request == nil?YES:NO;
}

//requestType， 0刷新，1:加载更多
- (void)fetchData:(NSString*)module
             path:(NSString*)path
       latestTime:(long long)latestTime
      requestType:(NSInteger)requestType
             size:(NSInteger)size
completionBlock:(void (^)(BOOL reload, BOOL hasNextPage, NSArray *itemList, long long timestamp))completionBlock
           cancel:(void (^)())cancelBlock failure:(void (^)(XMError *error))failureBlock queue:(dispatch_queue_t)queue {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
//    if (![Session sharedInstance].isLoggedIn) {
//        userId = 0;
//    }
    
    NSMutableDictionary *parameters =
              self.parameters?[[NSMutableDictionary alloc] initWithDictionary:self.parameters]:[[NSMutableDictionary alloc] init];
    if (![parameters objectForKey:@"user_id"]) {
        [parameters setObject:[NSNumber numberWithInteger:userId] forKey:@"user_id"];
    }
    [parameters setObject:[NSNumber numberWithLongLong:latestTime] forKey:@"latesttime"];
    [parameters setObject:[NSNumber numberWithInteger:requestType] forKey:@"reqtype"];
    [parameters setObject:[NSNumber numberWithInteger:size] forKey:@"size"];
    [parameters setObject:[NSNumber numberWithInteger:_fetchPageIndex+1] forKey:@"page"];
    
    //for search>>start
    if ([self.parameters objectForKey:@"timestamp"]) {
        [parameters setObject:[self.parameters objectForKey:@"timestamp"] forKey:@"latesttime"];
    }
    //<<end
    
//    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]
//                                 , @"latesttime":[NSNumber numberWithLongLong:latestTime]
//                                 , @"reqtype":[NSNumber numberWithInteger:requestType]
//                                 , @"size":[NSNumber numberWithInteger:size]};
    WEAKSELF;
    if (_request && ![_request isFinished]) {
        [_request cancel];
        _request = nil;
        _requestCanceled = YES;
    }
    weakSelf.request = [[NetworkManager sharedInstance] requestWithMethodGET:module path:path parameters:parameters completionBlock:^(NSDictionary *data) {
        weakSelf.request = nil;
        weakSelf.fetchPageIndex+=1;
//        NSLog(@"-------------------/n%ld/n-------------------", weakSelf.fetchPageIndex);
        NSString *str = [[data toJSONDictionary] JSONString];
        NSLog(@"%@", str);
        BOOL hasNextPage = [data hasNextPage];
        long long timestamp = [data timestamp];
        NSArray *itemList = [data itemList];
        BOOL reload = [data reload];
        if ([NSThread isMainThread]) {
//            weakSelf.requestCanceled = NO;
            if(completionBlock) completionBlock(reload,hasNextPage,itemList,timestamp);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.requestCanceled = NO;
                if(completionBlock) completionBlock(reload,hasNextPage,itemList,timestamp);
            });
        }
        
    } failure:^(XMError *error) {
        
        void(^callbackBlock)() = ^(){
            if (weakSelf.requestCanceled/* || error.errorCode == -999*/) {
                if (cancelBlock) cancelBlock();
            } else {
                if (failureBlock) failureBlock(error);
            }
            weakSelf.requestCanceled = NO;
            weakSelf.request = nil;
        };
        if ([NSThread isMainThread]) {
            callbackBlock();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callbackBlock();
            });
        }
    } queue:queue];
}

///////////////////

//requestType， 0刷新，1:加载更多
- (void)fetchDataPOST:(NSString*)module
             path:(NSString*)path
       latestTime:(long long)latestTime
      requestType:(NSInteger)requestType
             size:(NSInteger)size
  completionBlock:(void (^)(BOOL reload, BOOL hasNextPage, NSArray *itemList, long long timestamp))completionBlock
           cancel:(void (^)())cancelBlock failure:(void (^)(XMError *error))failureBlock queue:(dispatch_queue_t)queue {
    
    NSInteger userId = [Session sharedInstance].currentUser?[Session sharedInstance].currentUserId:0;
    //    if (![Session sharedInstance].isLoggedIn) {
    //        userId = 0;
    //    }
    
    NSMutableDictionary *parameters =
    self.parameters?[[NSMutableDictionary alloc] initWithDictionary:self.parameters]:[[NSMutableDictionary alloc] init];
    if (![parameters objectForKey:@"user_id"]) {
        [parameters setObject:[NSNumber numberWithInteger:userId] forKey:@"user_id"];
    }
    [parameters setObject:[NSNumber numberWithLongLong:latestTime] forKey:@"latesttime"];
    [parameters setObject:[NSNumber numberWithInteger:requestType] forKey:@"reqtype"];
    [parameters setObject:[NSNumber numberWithInteger:size] forKey:@"size"];
    [parameters setObject:[NSNumber numberWithInteger:_fetchPageIndex+1] forKey:@"page"];
    
    //for search>>start
    if ([self.parameters objectForKey:@"timestamp"]) {
        [parameters setObject:[self.parameters objectForKey:@"timestamp"] forKey:@"latesttime"];
    }
    NSLog(@"%@", parameters);
    //<<end
    
    //    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId]
    //                                 , @"latesttime":[NSNumber numberWithLongLong:latestTime]
    //                                 , @"reqtype":[NSNumber numberWithInteger:requestType]
    //                                 , @"size":[NSNumber numberWithInteger:size]};
    WEAKSELF;
    if (_request && ![_request isFinished]) {
        [_request cancel];
        _request = nil;
        _requestCanceled = YES;
    }
    weakSelf.request = [[NetworkManager sharedInstance] requestWithMethodPOST:module path:path parameters:parameters completionBlock:^(NSDictionary *data) {
        weakSelf.fetchPageIndex+=1;
        NSString *str = [[data toJSONDictionary] JSONString];
        NSLog(@"%@", str);
        BOOL hasNextPage = [data hasNextPage];
        long long timestamp = [data timestamp];
//        NSArray *arr = data[@"list"];
//        NSArray *itemList = [NSArray array];
//        if (arr.count != 0) {
//            itemList = arr;
//        } else {
//            itemList = nil;
//        }
        NSArray *itemList = [data itemList];
        BOOL reload = [data reload];
        if ([NSThread isMainThread]) {
            //            weakSelf.requestCanceled = NO;
            if(completionBlock) completionBlock(reload,hasNextPage,itemList,timestamp);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                weakSelf.requestCanceled = NO;
                if(completionBlock) completionBlock(reload,hasNextPage,itemList,timestamp);
            });
        }
        weakSelf.request = nil;
    } failure:^(XMError *error) {
        
        void(^callbackBlock)() = ^(){
            if (weakSelf.requestCanceled/* || error.errorCode == -999*/) {
                if (cancelBlock) cancelBlock();
            } else {
                if (failureBlock) failureBlock(error);
            }
            weakSelf.requestCanceled = NO;
            weakSelf.request = nil;
        };
        if ([NSThread isMainThread]) {
            callbackBlock();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callbackBlock();
            });
        }
    } queue:queue];
}

//http://121.41.46.28:8000/feeds/list_t?latesttime=1416267536717&reqtype=0&size=5
//{"code":0,"msg":"success","data":{"reload":0,"hasNextPage":0,"list":[{"type":0,"item":{"modify_time":1416999006969,"goods_id":"00134555456","goods_name":"LV经典款","seller_info":{"user_id":1,"username":"wubin","avatar_url":"123.jpg"},"main_pic_url":"http://img04.taobaocdn.com/imgextra/i4/829250210/TB28sqUbXXXXXaiXXXXXXXXXXXX_!!829250210.jpg_.webp","thumb_url":"http://gi2.md.alicdn.com/imgextra/i2/829250210/TB2wAORbXXXXXcrXXXXXXXXXXXX_!!829250210.jpg_60x60q90.jpg","summary":"[JONBAG】大牌品质，行业前三，描述服务物流超高评分　　　　　　　　　　　　　[JONBAG】100%实物拍摄，7天无理由退换，12日全场包邮，抢券拼单再满减　　　　[JONBAG】12/12尽享狂欢，再来一次双11，并有29元秒杀，前五十名送包，数量有限抢不到等一年，快快收藏并加购物车","market_price":124.99,"shop_price":99.99,"goods_stat":{"share_num":0,"comment_num":0,"like_num":1},"likes":{"total":1,"users":[{"user_id":20,"username":"hello world","avatar_url":null}]},"approve_tags":[{"tagId":1,"name":"正品验证","icon_url":null},{"tagId":2,"name":"7天包退","icon_url":null},{"tagId":3,"name":"平台寄售","icon_url":null},{"tagId":4,"name":"全新未拆","icon_url":null},{"tagId":5,"name":"支付宝担保","icon_url":null}],"status":2,"onsale_time":1416980329000}}]}}

@end


@implementation NSDictionary (DataListLogic)

- (BOOL)hasNextPage {
    return [self integerValueForKey:@"hasNextPage" defaultValue:0]>0?YES:NO;
}
- (NSArray*)itemList {
    return [self arrayValueForKey:@"list"];
}
- (long long)timestamp {
    return [self integerValueForKey:@"timestamp" defaultValue:0];
}
- (BOOL)reload {
    return [self integerValueForKey:@"reload" defaultValue:0]>0?YES:NO;
}

@end

@implementation NSDictionary (DataListItem)

- (long long)itemTimestamp {
    long long timestamp = [self longLongValueForKey:@"timestamp" defaultValue:0];
    if (timestamp == 0) {
        timestamp = [self longLongValueForKey:@"modify_time" defaultValue:0];
    }
    if (timestamp==0) {
        timestamp = [self longLongValueForKey:@"create_time" defaultValue:0];
    }
    return timestamp;
}

@end


@implementation DataListItem

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[super alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.type = [dict integerValueForKey:@"type" defaultValue:0];
        self.lastUpdateTime = [dict integerValueForKey:@"lastUpdateTime" defaultValue:0];
        self.item = [dict objectForKey:@"item"];
    }
    return self;
}

@end


@interface DataListCacheArray () <DataListLogicDataSource>

@property(nonatomic,strong) NSMutableArray *itemList;

@end

@implementation DataListCacheArray

- (void)saveItemsAtBegin:(NSArray*)itemList {
    NSMutableArray *newList = [NSMutableArray arrayWithArray:itemList];
    [newList addObjectsFromArray:self.itemList];
    self.itemList = newList;
}

- (void)saveItems:(NSArray*)itemList fefreshCache:(BOOL)fefreshCache {
    if (fefreshCache) {
        NSMutableArray *newList = [NSMutableArray arrayWithArray:itemList];
        self.itemList = newList;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithArray:self.itemList];
        [newList addObjectsFromArray:itemList];
        self.itemList = newList;
    }
}

- (id)getItemAt:(NSInteger)index {
    if (index < [self.itemList count]) {
        return [self.itemList objectAtIndex:index];
    }
    return nil;
}

- (NSInteger)totalCount {
    return [self.itemList count];
}

- (NSMutableArray*)itemList {
    if (!_itemList) {
        _itemList = [[NSMutableArray alloc] init];
    }
    return _itemList;
}

- (NSArray*)featchData:(NSInteger)startIndex size:(NSInteger)size {
    if (startIndex>=0 && startIndex+size<=[self.itemList count]) {
        NSRange range = NSMakeRange(startIndex,size);
        
        __unsafe_unretained id *objects = (__unsafe_unretained id *)malloc(sizeof(id) * range.length);
        [self.itemList getObjects:objects range:range];
        NSArray *newList = [NSArray arrayWithObjects:objects count:range.length];
        free(objects);
        return newList;
    } else if (startIndex>=0 && startIndex<[self.itemList count]) {
        NSRange range = NSMakeRange(startIndex,[self.itemList count]-startIndex);
        __unsafe_unretained id *objects = (__unsafe_unretained id *)malloc(sizeof(id) * range.length);
        [self.itemList getObjects:objects range:range];
        NSArray *newList = [NSArray arrayWithObjects:objects count:range.length];
        free(objects);
        return newList;
    }
    return nil;
}

- (void)loadData:(NSInteger)page size:(NSInteger)size {
    
}

- (void)saveToFile:(NSString*)filePath maxCount:(NSInteger)maxCount
{
    NSInteger count = maxCount<[self.itemList count]?maxCount:[self.itemList count];
    if (count>0) {
        NSRange range = NSMakeRange(0,count);
        __unsafe_unretained id *objects = (__unsafe_unretained id *)malloc(sizeof(id) * range.length);
        [self.itemList getObjects:objects range:range];
        NSArray *newList = [NSArray arrayWithObjects:objects count:range.length];
        free(objects);
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInteger:count] forKey:@"count"];
        [dict setObject:newList forKey:@"items"];
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:dict forKey:@"data"];
        [archiver finishEncoding];
        [data writeToFile:filePath atomically:YES];
    }
}

- (void)loadFromFile:(NSString*)filePath
{
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:filePath isDirectory:&isDirectory]
        && !isDirectory) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *dict = [unarchiver decodeObjectForKey:@"data"];
        [unarchiver finishDecoding];
        self.itemList = [[NSMutableArray alloc] initWithArray:[dict arrayValueForKey:@"items"]];
    }
}

@end


//latest_id, timestamp, page, size,
//刷新，
// >latest_id && < size && page==0

//latest_id==0 || page==0 取第一页

//latest_id!=0 && page==0 取第一页

//page > 0, 1,2,3

/*
 
 page == 1 && size==20 > 20->39
 
 latest_id==0, page size, latestModifyTime {  }
 
 page*size + size
 
 latest_id==100
 id ==80 -> 修改 想置顶
 
 
 if (page==0) {
     //取第一页
     if (latest_id==0) {
        //给我最最新的 reload=1
     } else {
        //
        if (有比latest_id更新的数据) ｛
           //只返回最新的
           if (更新的数据<size) {
               只返回更新的数据（数据条目<size）
           } else {
               //>=size
               只返回更新的数据size条
           }
        ｝
 
        //
        if ()
     }
 } else {
     if (latest_id==0) {
        //先返回错误，
     } else {
        //从latest_id开始，下面page＊size+1 -> page＊size+size
     }
 }
 
 
 */

// 新增表
// id, goods_id, modifyTime (需要更新这个时间，包括：主图，名字，鉴定标签，描述，价格),

//
//[type:0, id:,item:{ }, modifyTime]



//

//"data":{"hasNextPage":1,"list":[｛"type":0,"id":7,"lastupdatetime":1418213152609,"item":{},｝｛｝]，"timestamp":1418213152609}

//{"code":0,"msg":"success","data":{"hasNextPage":1,"list":[{"type":0,"id":7,"item":{"goods_id":"00134555456","goods_name":"LV经典款","seller_info":{"user_id":1,"username":"wubin","avatar_url":"123.jpg"},"main_pic_url":null,"thumb_url":null,"summary":null,"market_price":124.99,"shop_price":99.99,"goods_stat":{"share_num":0,"comment_num":0,"like_num":1},"likes":{"total":1,"users":[{"user_id":20,"username":"hello world","avatar_url":null}]},"approve_tags":[],"status":2,"onsale_time":1416980329000}}],"timestamp":1418213152609}}


//服务器：

//goods表
//goods_modify_time { id, goods_id, create_time, modifyTime  (需要更新这个时间，包括：主图，名字，鉴定标签，描述，价格，置顶) }


//
//request:  reqtype=0|1, size, latestModifyTime //

//第一条的时间
//最后一条时间

/*
 if (reqtype==0) {
     if (latestModifyTime==0) {
       //reaload=1
       //latestModifyTime纪录这个时间（以第一条为准）
     } else {
        latestModifyTime!=0;
        //有没有modifyTime比客户端传来的modifyTime更新&&create_time更旧
        if（有） ｛
           reload=1
        ｝else {
 
        }
 
     }
 } else {
     if (latestModifyTime==0) {
         //错误
     } else {
       以latestModifyTime为时间点，
       page*size+size
     }
 }
 
 
 
 */
//
//rsp:hasNextPage, reload=1[客户端缓存全部失效], "list":｛[type:0, id:100,item:{ }, modifyTime]｝， "timestamp":1418213152609


//#define kBGISIOS7                  ([UIDevice TBSystemVersion] >= 7.0)
//#define kBGScreenWidth             ((float)[[UIScreen mainScreen] bounds].size.width)
//#define kBGScreenHeight            ((float)[[UIScreen mainScreen] bounds].size.height)
//#define kBGScreenAvailableHeight   (kBGScreenHeight - (kBGISIOS7 ? 0 : 20))


