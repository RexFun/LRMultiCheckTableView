//
//  LRMultiCheckTableView.m
//  MultiUITableView
//
//  Created by mac373 on 16/4/7.
//  Copyright © 2016年 ole. All rights reserved.
//

#import "LRMultiCheckTableView.h"

#define WEIGHT [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define MAIN_VIEW_W [UIScreen mainScreen].bounds.size.width-20
#define MAIN_VIEW_H [UIScreen mainScreen].bounds.size.height-30
#define TB_VIEW_W ([UIScreen mainScreen].bounds.size.width-20) / 2

@implementation LRMultiCheckTableView

// setter
- (void)setDelegate:(id <LRMultiCheckTableViewDelegate>)_delegate {
    delegate = _delegate;
    [self drawView];
}
// getter
- (id <LRMultiCheckTableViewDelegate>)delegate {
    return delegate;
}

- (void)drawView {
    [self didLoadDataToView];
    [self resetDone];
    self.frame = CGRectMake(10, 20, MAIN_VIEW_W , MAIN_VIEW_H);
    [self setBackgroundColor:[UIColor blackColor]];
    // 左列表
    self.tb_l            = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TB_VIEW_W ,MAIN_VIEW_H)];
    self.tb_l.dataSource = self;
    self.tb_l.delegate   = self;
    // 默认选中第一行
    [self.tb_l selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                           animated:YES
                     scrollPosition:UITableViewScrollPositionTop];
    [self addSubview:self.tb_l];
    // 右列表
    self.tb_r            = [[UITableView alloc] initWithFrame:CGRectMake(TB_VIEW_W, 0, TB_VIEW_W ,MAIN_VIEW_H)];
    self.tb_r.dataSource = self;
    self.tb_r.delegate   = self;
    [self addSubview:self.tb_r];
    // 底部操作栏(采用约束布局)
    self.bar_bottom                 = [[UIView alloc] init];
    self.bar_bottom.backgroundColor = [UIColor lightGrayColor];
    // 底部操作栏 # 重置按钮
    self.btn_reset                 = [[UIButton alloc] init];
    self.btn_reset.backgroundColor = [UIColor whiteColor];
    [self.btn_reset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn_reset setTitle:@"重置" forState:UIControlStateNormal];
    [self.btn_reset addTarget:self action:@selector(resetTap) forControlEvents:UIControlEventTouchUpInside];
    [self.bar_bottom addSubview:self.btn_reset];
    // 底部操作栏 # 确定按钮
    self.btn_ok                 = [[UIButton alloc] init];
    self.btn_ok.backgroundColor = [UIColor redColor];
    [self.btn_ok setTitle:@"确定" forState:UIControlStateNormal];
    [self.btn_ok addTarget:self action:@selector(okTap) forControlEvents:UIControlEventTouchUpInside];
    [self.bar_bottom addSubview:self.btn_ok];
    //
    [self addSubview:self.bar_bottom];
    //
    [self initConstraint];
}

- (void)initConstraint {
    // 设置控件约束 # 底部操作栏
    self.bar_bottom.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bar_bottom
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1
                                                          constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bar_bottom
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0
                                                          constant:80]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bar_bottom
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bar_bottom
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:0]];
    // 设置控件约束 # 底部操作栏 # 重置按钮
    self.btn_reset.translatesAutoresizingMaskIntoConstraints  = NO;
    [self.bar_bottom addConstraint:[NSLayoutConstraint constraintWithItem:self.btn_reset
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bar_bottom
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
    [self.bar_bottom addConstraint:[NSLayoutConstraint constraintWithItem:self.btn_reset
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bar_bottom
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
    [self.bar_bottom addConstraint:[NSLayoutConstraint constraintWithItem:self.btn_reset
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bar_bottom
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:0.5
                                                               constant:0]];
    [self.bar_bottom addConstraint:[NSLayoutConstraint constraintWithItem:self.btn_reset
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bar_bottom
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:-0.5]];
    // 设置控件约束 # 底部操作栏 # 确定按钮
    self.btn_ok.translatesAutoresizingMaskIntoConstraints     = NO;
    [self.bar_bottom addConstraint:[NSLayoutConstraint constraintWithItem:self.btn_ok
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bar_bottom
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
    [self.bar_bottom addConstraint:[NSLayoutConstraint constraintWithItem:self.btn_ok
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bar_bottom
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
    [self.bar_bottom addConstraint:[NSLayoutConstraint constraintWithItem:self.btn_ok
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bar_bottom
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:0.5
                                                               constant:0]];
    [self.bar_bottom addConstraint:[NSLayoutConstraint constraintWithItem:self.btn_ok
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bar_bottom
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:0]];
}

- (void)didLoadDataToView {
    if (delegate == nil) {
        NSLog(@"delegate is nil !");
        return;
    }
    self.arrL = [self jsonStrToArr:[delegate didLoadDataToViewL]];
    self.arrR = [self jsonStrToArr:[delegate didLoadDataToViewR:[self.arrL objectAtIndex:0]]];
    self.curIndex = [[(NSDictionary *)[self.arrL objectAtIndex:0] objectForKey:@"id"] integerValue];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tb_l) {
        return self.arrL.count;
    } else if (tableView == self.tb_r) {
        return self.arrR.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell id
    static NSString *identifier = @"Cell";
    // 1.缓存中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView == self.tb_l) {
        NSDictionary *_d     = (NSDictionary *)[self.arrL objectAtIndex:indexPath.row];
        cell.tag             = [_d objectForKey:@"id"];
        cell.textLabel.text  = [NSString stringWithFormat: @"%@", [_d objectForKey:@"name"]];
    } else if (tableView == self.tb_r) {
        NSDictionary *_d = (NSDictionary *)[self.arrR objectAtIndex:indexPath.row];
        cell.tag            = [_d objectForKey:@"id"];
        cell.textLabel.text = [NSString stringWithFormat: @"%@", [_d objectForKey:@"name"]];
        //判断是否打钩
        NSMutableArray *_arr = [self.dataSelected objectForKey:[NSString stringWithFormat:@"%d", self.curIndex]];
        id _arr_obj          = [_d objectForKey:@"id"];
        if ([_arr containsObject:_arr_obj])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取被选中的cell对象
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    // 左列表
    if (tableView == self.tb_l) {
        NSDictionary *selectedItemDict = (NSDictionary *)[self.arrL objectAtIndex:indexPath.row];
        self.curIndex = [[selectedItemDict objectForKey:@"id"] integerValue];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            self.arrR = [self jsonStrToArr:[delegate didLoadDataToViewR:selectedItemDict]];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self.tb_r reloadData];
            });    
            
        });
    }
    // 右列表
    else if (tableView == self.tb_r) {
        NSMutableArray *_arr = [self.dataSelected objectForKey:[NSString stringWithFormat:@"%d", self.curIndex]];
        id _arr_obj          = [[self.arrR objectAtIndex:indexPath.row] objectForKey:@"id"];
        if (![_arr containsObject:_arr_obj])
            [_arr addObject:_arr_obj];
        else
            [_arr removeObject:_arr_obj];
        [self.tb_r reloadData];
        NSLog(@"after -> %@",_arr);
    }
}

#pragma mark 重置按钮事件

-(void)resetTap {
    [self resetDone];
    [self.tb_r reloadData];
}
-(void)resetDone {
    if (self.dataSelected != nil) [self.dataSelected removeAllObjects];
    else self.dataSelected = [[NSMutableDictionary alloc] init];
    for(int i=0; i<self.arrL.count; i++) {
        [self.dataSelected setObject:[[NSMutableArray alloc] init] forKey:[[(NSDictionary *)[self.arrL objectAtIndex:i] objectForKey:@"id"] stringValue]];
    }
    NSLog(@"%@",self.dataSelected);
}

#pragma mark 确定按钮事件

-(void)okTap {
    [self okDone];
}
-(void)okDone {
    NSLog(@"%@",self.dataSelected);
}

#pragma mark JSON字符串转NSArray
-(NSArray *)jsonStrToArr:(NSString*)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObj       = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSArray *arr     = [(NSDictionary *)jsonObj objectForKey:@"data"];
    return arr;
}

@end
