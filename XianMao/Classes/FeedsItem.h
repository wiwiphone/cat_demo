//
//  FeedsItem.h
//  XianMao
//
//  Created by simon cai on 11/9/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedsItem : NSObject <NSCoding>

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@property(nonatomic,assign) NSInteger feedsId;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSObject *item;

@end

//{"code":0,"msg":"success","data":{"hasNextPage":1,"list":[{"type":0,"id":7,"item":{"goods_id":"00134555456","goods_name":"LV经典款","seller_info":{"user_id":1,"username":"wubin","avatar_url":"123.jpg"},"main_pic_url":null,"thumb_url":null,"summary":null,"market_price":124.99,"shop_price":99.99,"goods_stat":{"share_num":0,"comment_num":0,"like_num":1},"likes":{"total":1,"users":[{"user_id":20,"username":"hello world","avatar_url":null}]},"approve_tags":[],"status":2,"onsale_time":1416980329000}}],"timestamp":1418213152609}}

//
//feeds表结构：{ feeds_id[自增id], user_id[用户id，前期都为0，因为推送给每个用户的内容一样], type[类型], idvalue[字符串，表示推送给用户的具体商品或专题id] }
//
//问题1：
//feeds表结构的维护有些复杂，例如：1）.新增宝贝上架［新增feeds表纪录］  2）宝贝下架［不应改显示给用户，应该删除掉纪录或着获取列表的时候过滤掉］  3）宝贝交易锁定 [即别的用户打算付费了，打算不显示给用户]  4）宝贝交易解除锁定，即别的用户可以购买［别的用户现在可以看到宝贝］
//
//问题2:
//客户端也有缓存，刷新不及时。
//
//解决：
//服务器端：对于feeds表正常流程只增不删；后台会有个运行在后台的过程去做一些删除工作。
//客户端：a. 数据做同步的时候，会更新本地宝贝状态，并过滤掉上述状态不展示给用户或者限制用户的操作；
//b. 对于没有及时更新到的宝贝：当进入宝贝详情的时候，客户端会向服务器重新请求宝贝详情数据并更新本地数据，并根据宝贝详情的状态限制用户的操作。
//
