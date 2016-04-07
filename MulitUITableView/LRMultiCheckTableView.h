//
//  LRMultiCheckTableView.h
//  MultiUITableView
//
//  Created by mac373 on 16/4/7.
//  Copyright © 2016年 ole. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LRMultiCheckTableViewDelegate<NSObject>
@required
- (NSString *)didLoadDataToLeftTableView;
@end

@interface LRMultiCheckTableView : UIView <UITableViewDataSource,UITableViewDelegate>
{
     id <LRMultiCheckTableViewDelegate> delegate;
}
@property (nonatomic, weak) id <LRMultiCheckTableViewDelegate> delegate;

@property (nonatomic, strong) NSArray     *arr_l1;
@property (nonatomic, strong) NSArray     *arr_r1;
@property (nonatomic, strong) NSArray     *arr_r2;
@property (nonatomic, strong) NSArray     *arr_r3;
@property (nonatomic, strong) NSArray     *arr_r4;
@property (nonatomic, strong) NSArray     *arr_r5;
@property (nonatomic, strong) NSArray     *arr_r6;
@property (nonatomic, strong) UITableView *tb_l;
@property (nonatomic, strong) UITableView *tb_r;
@property (nonatomic, strong) UIView      *bar_bottom;
@property (nonatomic, strong) UIButton    *btn_reset;
@property (nonatomic, strong) UIButton    *btn_ok;

@property NSInteger *cur_idx;

/* 已选数组集合，数据结构：

 {key:[1,2,3,...]},
 {key:[1,2,3,...]},
 {key:[1,2,3,...]},
 ...
 */
@property (nonatomic, strong) NSMutableDictionary *dict_selected;

- (void)drawView;
@end

