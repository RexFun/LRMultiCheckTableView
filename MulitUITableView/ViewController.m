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
    [self.view addSubview:self.tb_LRMC];
    // 布局约束
    self.tb_LRMC.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_LRMC
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_LRMC
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_LRMC
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_LRMC
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)didLoadDataToViewL {
    return [NSString stringWithFormat:@"[{\"id\":11,\"name\":\"A\"},{\"id\":12,\"name\":\"B\"},{\"id\":13,\"name\":\"C\"},{\"id\":14,\"name\":\"D\"},{\"id\":15,\"name\":\"E\"},{\"id\":16,\"name\":\"F\"}]"];
}

- (NSString *)didLoadDataToViewR:(id)itemViewL {
    NSDictionary *d = (NSDictionary*)itemViewL;
    NSLog(@"selectedItemL -> %@",d);
    return [NSString stringWithFormat:@"[{\"id\":1,\"name\":\"%@_1\"},{\"id\":2,\"name\":\"%@_2\"},{\"id\":3,\"name\":\"%@_3\"},{\"id\":4,\"name\":\"%@_4\"},{\"id\":5,\"name\":\"%@_5\"},{\"id\":6,\"name\":\"%@_6\"}]",[d objectForKey:@"name"],[d objectForKey:@"name"],[d objectForKey:@"name"],[d objectForKey:@"name"],[d objectForKey:@"name"],[d objectForKey:@"name"]];
}

- (void)getResultData:(id)data {
    NSLog(@"data -> %@", data);
}
@end
