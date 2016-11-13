//
//  ViewController.m
//  JNetWork
//
//  Created by Jacky on 16/10/13.
//  Copyright © 2016年 jacky. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];

    
    [[HttpClient sharedInstance]getReqWithUrl:@"http://url.cn/41Po34E" success:^(id operation, id responseObject) {
        NSLog(@"success:%@",responseObject);
    } failure:^(id operation, NSError *error) {
        NSLog(@"fail:%@",error);
    }];
    
    //get 请求
//    [[BaseNetEngine sharedInstance]getRequestWithUrl:@"http://url.cn/41Po34E" success:^(id operation, id responseObject) {
//        NSLog(@"输出成功后的对象:%@",responseObject);
//    } failure:^(id operation, NSError *error) {
//        NSLog(@"输出失败后的错误:%@",error);
//    }];
    
    //post 请求
//    [[BaseNetEngine sharedInstance]postRequestWithUrl:@"http://0.0.0.0:8080/name" parameters:nil success:^(id operation, id responseObject) {
//        NSLog(@"输出成功后的对象:%@",responseObject);
//    } failure:^(id operation, NSError *error) {
//        NSLog(@"输出失败后的对象:%@",error);
//    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
