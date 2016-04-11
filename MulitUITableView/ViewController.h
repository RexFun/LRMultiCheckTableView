//
//  ViewController.h
//  MulitUITableView
//
//  Created by mac373 on 16/3/31.
//  Copyright © 2016年 ole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRMultiCheckTableView.h"

@interface ViewController : UIViewController <UIPopoverPresentationControllerDelegate,LRMultiCheckTableViewDelegate>
@property (nonatomic, strong) UIPopoverPresentationController *controller_pop;
@property (nonatomic, strong) UIViewController *controller_div;
@property (nonatomic, strong) LRMultiCheckTableView *tb_lrmc;
@property (nonatomic, strong) UIButton *btn;
@end

