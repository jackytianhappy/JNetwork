//
//  ViewController.m
//  JNetWork
//
//  Created by Jacky on 16/10/13.
//  Copyright © 2016年 jacky. All rights reserved.
//

#import "ViewController.h"
#import "BaseNetEngine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[BaseNetEngine sharedInstance]getRequestWithUrl:@"http://example.vapor.codes/json" success:^(id operation, id responseObject) {
        
        NSLog(@"输出成功后的对象:%@",[responseObject objectForKey:@"number"]);
    } failure:^(id operation, NSError *error) {
        NSLog(@"输出失败后的错误:%@",error);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
