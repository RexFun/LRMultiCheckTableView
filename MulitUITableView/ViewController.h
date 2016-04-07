//
//  ViewController.h
//  MulitUITableView
//
//  Created by mac373 on 16/3/31.
//  Copyright © 2016年 ole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRMultiCheckTableView.h"

@interface ViewController : UIViewController <LRMultiCheckTableViewDelegate>
@property (nonatomic, strong) LRMultiCheckTableView *tb_LRMC;
@end

