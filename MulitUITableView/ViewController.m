//
//  ViewController.m
//  MulitUITableView
//
//  Created by mac373 on 16/3/31.
//  Copyright © 2016年 ole. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tb_LRMC = [[LRMultiCheckTableView alloc] init];
    self.tb_LRMC.delegate = self;
    [self.tb_LRMC drawView];
    [self.view addSubview:self.tb_LRMC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)didLoadDataToLeftTableView {
    NSLog(@"hello world");
    return [NSString stringWithFormat:@"{\"data\":[{\"id\":1,\"name\":\"A\"},{\"id\":2,\"name\":\"B\"},{\"id\":3,\"name\":\"C\"},{\"id\":4,\"name\":\"D\"},{\"id\":5,\"name\":\"E\"},{\"id\":6,\"name\":\"F\"}]}"];
}
@end
