//
//  ViewController.h
//  MulitUITableView
//
//  Created by mac373 on 16/3/31.
//  Copyright © 2016年 ole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *arr_l1;
@property (nonatomic, strong) NSArray *arr_r1;
@property (nonatomic, strong) NSArray *arr_r2;
@property (nonatomic, strong) NSArray *arr_r3;
@property (nonatomic, strong) NSArray *arr_r4;
@property (nonatomic, strong) NSArray *arr_r5;
@property (nonatomic, strong) NSArray *arr_r6;
@property (nonatomic, strong) UITableView *tb_l;
@property (nonatomic, strong) UITableView *tb_r;
@property NSInteger *cur_idx;

/* 已选数组集合，数据结构为：
 [
     {key:id,items:[1,2,3,...]},
     {key:id,items:[1,2,3,...]},
     {key:id,items:[1,2,3,...]},
     ...
 ]
 */
@property (nonatomic, strong) NSMutableDictionary *dict_selected;
//@property (nonatomic, strong) NSMutableArray<NSMutableDictionary*> *arr_selected;

@end

