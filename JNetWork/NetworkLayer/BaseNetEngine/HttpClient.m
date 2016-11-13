//
//  HttpClient.m
//  Live
//
//  Created by Jacky on 16/11/13.
//  Copyright © 2016年 jacky. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworking.h"
#import "NSString+URL.h"

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL isOpenHttpsSSL()

/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
#define certName @""

BOOL isOpenHttpsSSL()
{
#ifdef kOpenHttpsSSL
    return YES;
#else
    return NO;
#endif
}

static const NSInteger kTimeOut = 30.0f;

@implementation HttpClient

static HttpClient *sharedInstance = NULL;
+ (HttpClient*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HttpClient alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark -- GET消息请求
//get消息请求
- (void)getReqWithUrl:(NSString*)url
              success:(void (^)(id operation, id responseObject))success
              failure:(void (^)(id operation, NSError *error))failure
{
    [self getReqWithUrl:url parameters:nil success:success failure:failure];
}

//get消息请求
- (void)getReqWithUrl:(NSString*)url
           parameters:(id)parameters
              success:(void (^)(id operation, id responseObject))success
              failure:(void (^)(id operation, NSError *error))failure
{
    [self getReqWithUrl:url parameters:parameters headerFields:nil success:success failure:failure];
}

//get消息请求
- (void)getReqWithUrl:(NSString*)url
         headerFields:(NSDictionary*)headerFields
              success:(void (^)(id operation, id responseObject))success
              failure:(void (^)(id operation, NSError *error))failure
{
    [self getReqWithUrl:url parameters:nil headerFields:headerFields success:success failure:failure];
    
}

//全参数请求
- (void)getReqWithUrl:(NSString*)url
           parameters:(id)parameters
         headerFields:(NSDictionary*)headerFields
              success:(void (^)(id operation, id responseObject))success
              failure:(void (^)(id operation, NSError *error))failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时时间30S
    [manager.requestSerializer setTimeoutInterval:kTimeOut];
    
    if (headerFields) {
        for (NSString *key in headerFields.allKeys) {
            [manager.requestSerializer setValue:headerFields[key] forHTTPHeaderField:key];
        }
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    NSURLSessionDataTask *task =[manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        if ((error.code == NSURLErrorCancelled)) {
            NSLog(@"error.code = %ld", (long)NSURLErrorCancelled);
            return ;
        }
        
        failure(task, error);
        
    }];
    
    [task resume];
    
}

#pragma mark -- POST消息请求
//post消息请求
- (void)postReqWithUrl:(NSString*)url
            parameters:(id)parameters
               success:(void (^)(id operation, id responseObject))success
               failure:(void (^)(id operation, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时时间30S
    [manager.requestSerializer setTimeoutInterval:kTimeOut];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //设置消息体
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        //POST消息体 json格式
        NSError *err;
        NSData  *strdata = [NSJSONSerialization dataWithJSONObject:parameters
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&err];
        NSString *reqString = [[NSString alloc] initWithData:strdata encoding:NSUTF8StringEncoding];
        NSLog(@"reqString = %@", reqString);
        NSString *dataString = [NSString stringWithFormat:@"%@=%@",@"data",reqString];
        
        return dataString;
        
    }];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    [manager POST:url parameters:parameters progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        failure(task, error);
    }];
    
}

- (void)postReqWithUrl:(NSString*)url
                  body:(NSData*)body
               success:(void (^)(id operation, id responseObject))success
               failure:(void (^)(id operation, NSError *error))failure
{
    [self postReqWithUrl:url headerFields:nil body:body success:success failure:failure];
}

- (void)postReqWithUrl:(NSString*)url
          headerFields:(NSDictionary*)headerFields
                  body:(id)body
               success:(void (^)(id operation, id responseObject))success
               failure:(void (^)(id operation, NSError *error))failure
{
    [self postRequestUrl:url headerFields:headerFields body:body success:success failure:failure];
}

//全参数Post请求接口
- (void)postRequestUrl:(NSString*)url
          headerFields:(NSDictionary*)headerFields
                  body:(id)body
               success:(void (^)(id operation, id responseObject))success
               failure:(void (^)(id operation, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时时间30S
    [manager.requestSerializer setTimeoutInterval:kTimeOut];
    
    if (headerFields) {
        for (NSString *key in headerFields.allKeys) {
            [manager.requestSerializer setValue:headerFields[key] forHTTPHeaderField:key];
        }
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    //设置消息体
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        //POST消息体 json格式
        if (parameters != nil) {
            if ([parameters isKindOfClass:[NSData class]]) {
                NSString *reqString = [[NSString alloc] initWithData:parameters encoding:NSUTF8StringEncoding];
                return reqString;
            }
            else
            {
                NSError *error;
                NSData*  strdata = [NSJSONSerialization dataWithJSONObject:body
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:&error];
                NSString *reqString = [[NSString alloc] initWithData:strdata encoding:NSUTF8StringEncoding];
                return reqString;
            }
        }
        
        return nil;
        
    }];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    [manager POST:url parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        failure(task, error);
    }];
    
}

////////////////////////////
//全参数Post请求接口 contentTypes:post响应类型
- (void)postRequestUrl:(NSString*)url
          headerFields:(NSDictionary*)headerFields
          contentTypes:(NSSet *)set
                  body:(id)body
             bodyBlock:(HCReqMessageBodyBlock)bodyBlock
               success:(void (^)(id operation, id responseObject))success
               failure:(void (^)(id operation, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时时间30S
    [manager.requestSerializer setTimeoutInterval:kTimeOut];
    
    if (headerFields) {
        for (NSString *key in headerFields.allKeys) {
            [manager.requestSerializer setValue:headerFields[key] forHTTPHeaderField:key];
        }
    }
    //
    manager.responseSerializer.acceptableContentTypes = set;
    //    [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    //设置消息体
    //    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
    //        //POST消息体 json格式
    //        if (parameters != nil) {
    //            if ([parameters isKindOfClass:[NSData class]]) {
    //                NSString *reqString = [[NSString alloc] initWithData:parameters encoding:NSUTF8StringEncoding];
    //                return reqString;
    //            }
    //            else
    //            {
    //                NSError *error;
    //                NSData*  strdata = [NSJSONSerialization dataWithJSONObject:body
    //                                                                   options:NSJSONWritingPrettyPrinted
    //                                                                     error:&error];
    //                NSString *reqString = [[NSString alloc] initWithData:strdata encoding:NSUTF8StringEncoding];
    //                return reqString;
    //            }
    //        }
    //
    //        return nil;
    //
    //    }];
    
    //设置消息体
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        //POST消息体 json格式
        if (!parameters) {
            return nil;
        }
        
        NSString *dataString = bodyBlock(parameters);
        
        return (dataString != nil)?dataString:nil;
        
    }];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    
    [manager POST:url parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //success
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //failure
        failure(task, error);
    }];
    
}

#pragma mark -- UPLOAD图片上传请求
//上传图片 兼容之前接口添加path
- (void)uploadImageWithUrl:(NSString*)url
                  fileData:(NSData*)fileData
                      path:(NSString *)path
                parameters:(NSDictionary*)parameters
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时时间30S
    [manager.requestSerializer setTimeoutInterval:kTimeOut];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSString *fileName = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]];
    
    NSString *reqUrl = [NSString URLString:url fromDictionary:parameters];
    
    NSMutableURLRequest *mRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:reqUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:fileData name:@"img" fileName:fileName mimeType:@"image/png"];
        
    } error:nil];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:mRequest fromData:nil progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //
        //响应数据
        if (error) {
            NSLog(@"Error: %@", error);
            failure(response, error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
            success(response, responseObject);
        }
        
    }];
    
    [uploadTask resume];
}

- (void)uploadImageWithUrl:(NSString*)url
                      path:(NSString *)path
                parameters:(NSDictionary*)parameters
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURL *filePath = [NSURL fileURLWithPath:path]; //@"file://path/to/image.png"
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            failure(response, error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
            success(response, responseObject);
        }
    }];
    
    [uploadTask resume];
}

//上传图片
//- (void)uploadImageWithUrl:(NSString*)url
//                  fileData:(NSData*)fileData
//                      path:(NSString *)path
//                parameters:(NSDictionary*)parameters
//                   success:(void (^)(id operation, id responseObject))success
//                   failure:(void (^)(id operation, NSError *error))failure
//{
//    NSString *fileName = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]];
//
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" fileName:fileName mimeType:@"image/jpeg" error:nil];
//    } error:nil];
//
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
//    NSURLSessionUploadTask *uploadTask;
//        uploadTask = [manager
//                      uploadTaskWithStreamedRequest:request
//                      progress:nil
//                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                          if (error) {
//                              NSLog(@"Error: %@", error);
//                          } else {
//                              NSLog(@"%@ %@", response, responseObject);
//                          }
//                      }];
//
//    [uploadTask resume];
//}

//下载图片
- (void)downloadImageWithUrl:(NSString*)url
                     success:(void (^)(id operation, id responseObject))success
                     failure:(void (^)(id operation, NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        if (!error) {
            //成功回调
            success(response, location);
        }
        else
        {
            //失败
            failure(response,error);
        }
        
        
    }];
    
    [downloadTask resume];
}


#pragma mark -- SSL证书验证
- (AFSecurityPolicy*)customSecurityPolicy
{
#ifndef kCancelHttpsValidation
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certName ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
#endif
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
#ifndef kCancelHttpsValidation
    securityPolicy.pinnedCertificates = @[certData];
#endif
    
    return securityPolicy;
}

@end
