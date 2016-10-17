//
//  BaseNetEngine.m
//  JNetWork
//
//  Created by Jacky on 16/10/15.
//  Copyright © 2016年 jacky. All rights reserved.
//

#import "BaseNetEngine.h"
#import "AFNetworking.h"

static const NSInteger kTimeout = 30;

@implementation BaseNetEngine

+(BaseNetEngine *)sharedInstance{
    static BaseNetEngine *baseNetEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            baseNetEngine = [[BaseNetEngine alloc]init];
    });
    return baseNetEngine;
}


#pragma mark -get
-(void)getRequestWithUrl:(NSString *)url
                 success:(void (^)(id, id))success
                 failure:(void (^)(id, NSError *))failure{
    [self getRequestWithUrl:url parameters:nil success:success failure:failure];
}

-(void)getRequestWithUrl:(NSString *)url
              parameters:(id)parameters
                 success:(void (^)(id, id))success
                 failure:(void (^)(id, NSError *))failure{
    [self getRequestWithUrl:url parameter:parameters headerFields:nil success:success failure:failure];
}

-(void)getRequestWithUrl:(NSString *)url
            headerFields:(NSDictionary *)headerFields
                 success:(void (^)(id, id))success
                 failure:(void (^)(id, NSError *))failure{
    [self getRequestWithUrl:url parameter:nil headerFields:headerFields success:success failure:failure];

}

//通过AFNetworking 进行请求
-(void)getRequestWithUrl:(NSString *)url
               parameter:(id)parameters
            headerFields:(NSDictionary *)headerFields
                 success:(void (^)(id operation, id responseObject))success
                 failure:(void (^)(id operation, NSError *error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求超时时间
    [manager.requestSerializer setTimeoutInterval:kTimeout];
    
    if (headerFields) {//设置请求头
        for (NSString *key in headerFields.allKeys) {
            [manager.requestSerializer setValue:headerFields[key] forHTTPHeaderField:key];
        }
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];

    NSURLSessionDataTask *task = [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        if (error.code == NSURLErrorCancelled) {
            return ;
        }
        
        failure(task,error);
    }];
    
    [task resume];
    
}

#pragma mark -POST
-(void)postRequestWithUrl:(NSString *)url success:(void (^)(id, id))success failure:(void (^)(id, NSError *error))failure{
    [self postRequestWithUrl:url parameters:nil success:success failure:failure];
}
-(void)postRequestWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id, id))success failure:(void (^)(id, NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超长时间
    [manager.requestSerializer setTimeoutInterval:kTimeout];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    
//    //设置消息体
//    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
//        NSError *err;
//        NSData *strdata = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&err];
//        NSString *reqString = [[NSString alloc]initWithData:strdata encoding:NSUTF8StringEncoding];
//        NSString *dataString = [NSString stringWithFormat:@"%@=%@",@"data",reqString];
//        return dataString;
//    }];
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        failure(task,error);
        
    }];
}

//以下暂时感觉用不到 先不予以测试
//-(void)postRequestWithUrl:(NSString *)url body:(id)body success:(void (^)(id, id))success failure:(void (^)(id, NSError *))failure{
//    [self postRequestWithUrl:url headerFields:nil contentTypes:nil body:body bodyBlock:nil success:success failure:failure];
//}
//
//-(void)postRequestWithUrl:(NSString *)url headerFields:(NSDictionary *)headerFields body:(id)body success:(void (^)(id, id))success failure:(void (^)(id, NSError *))failure{
//    [self postRequestWithUrl:url headerFields:headerFields contentTypes:nil body:body bodyBlock:nil success:success failure:failure];
//}
//
//-(void)postRequestWithUrl:(NSString *)url headerFields:(NSDictionary *)headerFields contentTypes:(NSSet *)set body:(id)body bodyBlock:(HCReqMessageBodyBlock)bodyBlock success:(void (^)(id, id))success failure:(void (^)(id, NSError *))failure{
// 
//    
//    
//}

@end
