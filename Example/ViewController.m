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
    self.btn = [[UIButton alloc]init];

    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn setTitle:@"弹出" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(clickTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    self.btn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0
                                                           constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0
                                                           constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:0.5
                                                           constant:0]];
    
//    self.tb_LRMC = [[LRMultiCheckTableView alloc] init];
//    self.tb_LRMC.delegate = self;
//    [self.view addSubview:self.tb_LRMC];
//    // 布局约束
//    self.tb_LRMC.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_LRMC
//                                                     attribute:NSLayoutAttributeWidth
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.view
//                                                     attribute:NSLayoutAttributeWidth
//                                                    multiplier:1
//                                                      constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_LRMC
//                                                     attribute:NSLayoutAttributeHeight
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.view
//                                                     attribute:NSLayoutAttributeHeight
//                                                    multiplier:1
//                                                      constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_LRMC
//                                                     attribute:NSLayoutAttributeBottom
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.view
//                                                     attribute:NSLayoutAttributeBottom
//                                                    multiplier:1
//                                                      constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_LRMC
//                                                     attribute:NSLayoutAttributeLeft
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.view
//                                                     attribute:NSLayoutAttributeLeft
//                                                    multiplier:1
//                                                      constant:0]];
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
    [self.controller_div dismissViewControllerAnimated:YES completion:nil];
}


-(void)clickTap {
    // 二次点击时，不需重新实例化UIViewController，保留上次选过的记录
    if (self.controller_div == nil) {
        NSLog(@"it's nil!");
        self.tb_lrmc                               = [[LRMultiCheckTableView alloc] init];
        self.tb_lrmc.delegate                      = self;
        self.controller_div                        = [[UIViewController alloc]init];
        self.controller_div.view                   = self.tb_lrmc;
        self.controller_div.modalPresentationStyle = UIModalPresentationPopover;
    } else {
        NSLog(@"it's not nil!");
    }
    
    self.controller_pop                        = self.controller_div.popoverPresentationController;
    self.controller_pop.delegate               = self;
    self.controller_pop.sourceView             = self.btn;
    self.controller_pop.sourceRect             = self.btn.frame;
    
    [self presentViewController:self.controller_div animated:YES completion:nil];
}

//.FullScreen or .OverFullScreen, the difference being that fullscreen will remove the presenting view controller's view,
//whereas over-fullscreen won't.
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
@end
