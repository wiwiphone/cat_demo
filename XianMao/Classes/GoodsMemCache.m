//
//  GoodsMemCache.m
//  XianMao
//
//  Created by simon on 12/31/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "GoodsMemCache.h"
#import "SynthesizeSingleton.h"
#import "ZeroingWeakRef.h"
#import "GoodsInfo.h"

@interface ZeroingWeakMemCache ()
@property(nonatomic,strong) NSMutableDictionary *itemsDict;

- (id)storeData:(id<CachableItem>)newItem forKey:(NSString *)key isDataChanged:(BOOL*)isDataChanged;
- (void)storeData:(id<CachableItem>)newItem forKey:(NSString *)key;
- (void)removeForKey:(NSString *)key;
- (id)dataForKey:(NSString *)key;

@end

@implementation ZeroingWeakMemCache {
    
}

- (id)init {
    self = [super init];
    if (self) {
        _itemsDict = [[NSMutableDictionary alloc] initWithCapacity:80];
    }
    return self;
}

- (id)storeData:(id<CachableItem>)newItem forKey:(NSString *)key isDataChanged:(BOOL*)isDataChanged {
    if (key
        && class_conformsToProtocol([newItem class], @protocol(CachableItem)))
    {
        id<CachableItem> cachedItem = [self dataForKey:key];
        if (cachedItem) {
            if ([cachedItem respondsToSelector:@selector(updateWithItem:)])
            {
                BOOL dataChanged = [cachedItem updateWithItem:newItem];
                if (isDataChanged) {
                    *isDataChanged = dataChanged;
                }
            }
            return cachedItem;
        } else {
            [self storeData:newItem forKey:key];
        }
    }
    return newItem;
}

- (void)storeData:(id<CachableItem>)newItem forKey:(NSString *)key {
    WEAKSELF;
    ZeroingWeakRef *ref = [ZeroingWeakRef refWithTarget:newItem];
    [ref setCleanupBlock:^(id target) {
        [weakSelf.itemsDict removeObjectForKey:key];
    }];
    [_itemsDict setObject:ref forKey: key];
}

- (void)removeForKey:(NSString *)key
{
    [_itemsDict removeObjectForKey: key];
}

- (id)dataForKey:(NSString *)key
{
    ZeroingWeakRef *ref = [_itemsDict objectForKey: key];
    id obj = [ref target];
    // clean out keys whose objects have gone away
    if(ref && !obj)
        [_itemsDict removeObjectForKey: key];
    return obj;
}

@end

@interface GoodsMemCache ()
@property(nonatomic,strong) NSMutableDictionary *itemsDict;
@end

@implementation GoodsMemCache {
    
}

SYNTHESIZE_SINGLETON_FOR_CLASS(GoodsMemCache, sharedInstance);

- (void)initialize
{
    _itemsDict = [[NSMutableDictionary alloc] initWithCapacity:80];
}

- (GoodsInfo*)storeData:(GoodsInfo*)goodsInfo isDataChanged:(BOOL*)isDataChanged
{
    if (goodsInfo && [goodsInfo.goodsId length]>0)
    {
        id<CachableItem> cachedItem = [self dataForKey:goodsInfo.goodsId];
        if (cachedItem) {
            if ([cachedItem respondsToSelector:@selector(updateWithItem:)])
            {
                BOOL dataChanged = [cachedItem updateWithItem:goodsInfo];
                if (isDataChanged) {
                    *isDataChanged = dataChanged;
                }
            }
            return cachedItem;
        } else {
            [self storeData:goodsInfo forKey:goodsInfo.goodsId];
        }
    }
    return goodsInfo;
}

- (void)storeData:(id<CachableItem>)newItem forKey:(NSString *)key {
    WEAKSELF;
    ZeroingWeakRef *ref = [ZeroingWeakRef refWithTarget:newItem];
    [ref setCleanupBlock:^(id target) {
        [weakSelf.itemsDict removeObjectForKey:key];
    }];
    [_itemsDict setObject:ref forKey: key];
}

- (void)removeForKey:(NSString *)key
{
    [_itemsDict removeObjectForKey: key];
}

- (id)dataForKey:(NSString *)key
{
    ZeroingWeakRef *ref = [_itemsDict objectForKey: key];
    id obj = [ref target];
    // clean out keys whose objects have gone away
    if(ref && !obj)
        [_itemsDict removeObjectForKey: key];
    return obj;
}

@end


