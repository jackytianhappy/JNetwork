//
//  BaseNetEngine.h
//  JNetWork
//
//  Created by Jacky on 16/10/15.
//  Copyright © 2016年 jacky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetEngine : NSObject

/**
 *  创建网络引擎的单利对象
 *
 *	@return	网络引擎对象单例
 */
+(BaseNetEngine *)sharedInstance;

-(void)getRequestWithUrl:(NSString *)Url
        success 




@end
