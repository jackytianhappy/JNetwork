//
//  BaseNetEngine.m
//  JNetWork
//
//  Created by Jacky on 16/10/15.
//  Copyright © 2016年 jacky. All rights reserved.
//

#import "BaseNetEngine.h"
#import "AFNetworking.h"

@implementation BaseNetEngine

+(BaseNetEngine *)sharedInstance{
    static BaseNetEngine *baseNetEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            baseNetEngine = [[BaseNetEngine alloc]init];
    });
    return baseNetEngine;
}



@end
