//
//  BaseNetEngine.h
//  JNetWork
//
//  Created by Jacky on 16/10/15.
//  Copyright © 2016年 jacky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetEngine : NSObject

typedef NSString * (^HCReqMessageBodyBlock)(id parameters);

/**
 *  创建网络引擎的单利对象
 *
 *	@return	网络引擎对象单例
 */
+(BaseNetEngine *)sharedInstance;

//get 请求
-(void)getRequestWithUrl:(NSString *)url
                 success:(void (^)(id operation, id responseObject))success
                 failure:(void (^)(id operation, NSError *error))success;

-(void)getRequestWithUrl:(NSString *)url
              parameters:(id)parameters
                 success:(void (^)(id operation, id responseObject))success
                 failure:(void (^)(id operation, NSError *error))success;

-(void)getRequestWithUrl:(NSString *)url
            headerFields:(NSDictionary *)headerFields
                 success:(void (^)(id operation, id responseObject))success
                 failure:(void (^)(id operation, NSError *))success;

-(void)getRequestWithUrl:(NSString *)url
               parameter:(id)parameters
            headerFields:(NSDictionary *)headerFields
                 success:(void (^)(id operation, id responseObject))success
                 failure:(void (^)(id operation, NSError *error))failure;


//post 请求
-(void)postRequestWithUrl:(NSString *)url
                  success:(void (^)(id operation, id responseObject))success
                  failure:(void (^)(id operation, NSError *))success;

-(void)postRequestWithUrl:(NSString *)url
              parameters:(id)parameters
                 success:(void (^)(id operation, id responseObject))success
                 failure:(void (^)(id operation, NSError *))success;

-(void)postRequestWithUrl:(NSString *)url
                     body:(id)body
                  success:(void (^)(id operation, id responseObject))success
                  failure:(void (^)(id operation, NSError *))success;

-(void)postRequestWithUrl:(NSString *)url
             headerFields:(NSDictionary *)headerFields
                     body:(id)body
                  success:(void (^)(id operation, id responseObject))success
                  failure:(void (^)(id operation, NSError *))success;

-(void)postRequestWithUrl:(NSString *)url
         headerFields:(NSDictionary *)headerFields
         contentTypes:(NSSet *)set
                 body:(id)body
            bodyBlock:(HCReqMessageBodyBlock)bodyBlock
              success:(void (^)(id operation, id responseObject))success
              failure:(void (^)(id operation, NSError *))success;



@end
