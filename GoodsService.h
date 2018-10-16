//
//  GoodsService.h
//  XianMao
//
//  Created by simon cai on 13/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseService.h"
#import "NetworkManager.h"
#import "CommentVo.h"

@interface GoodsService : BaseService

//获取指定的回收商
+ (void)getSpecifiedUser:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure;

//整理分享接口
+ (void)setSharePOST:(NSDictionary *)params Completion:(void (^)(NSDictionary *dict))completion failure:(void (^)(XMError *error))failure;

//求回收商品数据
+ (void)setListPreference:(NSDictionary *)params Completion:(void (^)(NSDictionary *dict))completion failure:(void (^)(XMError *error))failure;
//查看回收商信息
+ (void)getRecoverUserInfo:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure;
//设置接受push条数
+ (void)setPushPreference:(NSDictionary *)params Completion:(void (^)(NSDictionary *dict))completion failure:(void (^)(XMError *error))failure;
//设置用户偏好
+ (void)setPreference:(NSMutableArray *)params Completion:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure;
//获取求回收用户偏好设置信息
+ (void)getRecoverPreferenceCompletion:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure;
//获取偏好设置数据
+ (void)getRecoverFondCompletion:(void (^)(NSDictionary *))completion failure:(void (^)(XMError *))failure;

+ (void)cancelCurOption;

+ (void)switchOnSale:(NSString*)goodsId onsale:(BOOL)onsale
          completion:(void (^)())completion
             failure:(void (^)(XMError *error))failure;

+ (void)refreshGoods:(NSString*)goodsId
          completion:(void (^)(long long modifyTime))completion
             failure:(void (^)(XMError *error))failure;

+ (void)deleteGoods:(NSString*)goodsId
          completion:(void (^)())completion
             failure:(void (^)(XMError *error))failure;

+ (void)sale_again:(NSString*)goodsId
        completion:(void (^)())completion
           failure:(void (^)(XMError *error))failure;


+ (void)recommend_goods:(NSString*)goods_id
             completion:(void (^)(NSArray* goods_list))completion
                failure:(void (^)(XMError *error))failure;

+ (void)shoppingCartRecommendGoods:(void (^)(NSArray* goods_list))completion
                           failure:(void (^)(XMError *error))failure;



//goods/refresh
//goods/sale_again[POST]{goods_id} 再次上架

//goods/delete[POST] {goods_id, user_id}

//goods/search_goods【GET、分页】 {keywords} 搜索商品，返回结构同在售商品列表。
//trade/goods_order_list[GET，分页] 根据商品获取订单列表 ，返回结构同 trade/order_detail_list

+ (void)comment_publish:(NSString*)goods_id
          reply_user_id:(NSInteger)reply_user_id
                content:(NSString*)content
            attachments:(NSArray*)attachments
             completion:(void (^)(CommentVo *commentVo))completion
                failure:(void (^)(XMError *error))failure;

+ (void)comment_delete:(NSInteger)comment_id
             completion:(void (^)())completion
                failure:(void (^)(XMError *error))failure;

+ (void)comment_list:(NSString*)goods_id
                size:(NSInteger)size
            completion:(void (^)(NSArray* comments))completion
               failure:(void (^)(XMError *error))failure;
@end


//goods/publish_check[GET] {user_id} 返回｛result, message, url｝ (result=0正常，非0不允许发布，弹框提示或者直接跳url)      发布前检测接口  @白骁 @卢云  交互 @无崖 定义下

//express/get_mail_type 获取所有快递公司


///recommend/goods[GET]{goods_id} 获取推荐商品｛ goods_list(List<GoodsRecommendInfo>) ｝

//
///comment/publish[POST]{goods_id, content， reply_user_id（被回复用户id，可选）} 发表评论 {comment(commentVo(comment_id, create_time， user_id， username， content， reply_user_id， reply_username) )}
///comment/list[GET]分页 获取评论 {List<CommentVo>}
///comment/delete[POST]{comment_id} 删除评论 {}
//






