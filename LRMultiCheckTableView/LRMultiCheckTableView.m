//
//  LRMultiCheckTableView.m
//  MultiUITableView
//
//  Created by mac373 on 16/4/7.
//  Copyright © 2016年 ole. All rights reserved.
//

#import "LRMultiCheckTableView.h"

// 宏 rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 宏 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
// 宏 屏幕尺寸
#define WEIGHT [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define MAIN_VIEW_W [UIScreen mainScreen].bounds.size.width-20
#define MAIN_VIEW_H [UIScreen mainScreen].bounds.size.height-30
#define TB_VIEW_W ([UIScreen mainScreen].bounds.size.width-20) / 2

@implementation LRMultiCheckTableView

// setter
- (void)setDelegate:(id <LRMultiCheckTableViewDelegate>)_delegate {
    delegate = _delegate;
    [self showView];
}
// getter
- (id <LRMultiCheckTableViewDelegate>)delegate {
    return delegate;
}

- (void)showView {
    [self didLoadDataToView];
    [self resetDone];
    [self setBackgroundColor:[UIColor blackColor]];
    // 左列表
    self.tb_l            = [[UITableView alloc] init];
    self.tb_l.dataSource = self;
    self.tb_l.delegate   = self;
    // 默认选中第一行
    [self.tb_l selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                           animated:YES
                     scrollPosition:UITableViewScrollPositionTop];
    self.tb_l.tableFooterView = [[UIView alloc]init];//去掉多余分割线
    [self addSubview:self.tb_l];
    // 右列表
    self.tb_r            = [[UITableView alloc] init];
    self.tb_r.dataSource = self;
    self.tb_r.delegate   = self;
    self.tb_r.tableFooterView = [[UIView alloc]init];//去掉多余分割线
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
    // 设置控件约束 # 左边tableview
    self.tb_l.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_l
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.5
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_l
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:-70]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_l
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_l
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.bar_bottom
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_l
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    // 设置控件约束 # 右边tableview
    self.tb_r.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_r
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.5
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_r
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:-70]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_r
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_r
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.bar_bottom
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tb_r
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
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
                                                      constant:70]];
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
    self.curRowIndexL = 0;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (tableView == self.tb_l) {
        NSDictionary *_d    = (NSDictionary *)[self.arrL objectAtIndex:indexPath.row];
        cell.tag            = [_d objectForKey:@"id"];
        cell.textLabel.text = [NSString stringWithFormat: @"%@", [_d objectForKey:@"name"]];
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        // 判断全部
        NSDictionary *_ds = [self.dataSelected objectAtIndex:indexPath.row];
        NSArray *_a       = [_ds objectForKey:@"items"];
        if(_a.count > 0) cell.detailTextLabel.text = @"";
        else             cell.detailTextLabel.text = @"全部";
        // 判断选中背景变色
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        if(indexPath.row == self.curRowIndexL) cell.backgroundColor = UIColorFromRGB(0xF0F0F0);
        else                                   cell.backgroundColor = [UIColor clearColor];
    } else if (tableView == self.tb_r) {
        NSDictionary *_d    = (NSDictionary *)[self.arrR objectAtIndex:indexPath.row];
        cell.tag            = [_d objectForKey:@"id"];
        cell.textLabel.text = [NSString stringWithFormat: @"%@", [_d objectForKey:@"name"]];
        // 判断选中打钩
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0xF0F0F0);
        NSDictionary *_d_selected = [self.dataSelected objectAtIndex:self.curRowIndexL];
        NSArray *_a_selected      = [_d_selected objectForKey:@"items"];
        id _o                     = [_d objectForKey:@"id"];
        if ([_a_selected containsObject:_o]) cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else                                 cell.accessoryType = UITableViewCellAccessoryNone;
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
        self.curRowIndexL = indexPath.row;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            self.arrR = [self jsonStrToArr:[delegate didLoadDataToViewR:selectedItemDict]];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self.tb_r reloadData];
            });
        });
        [self.tb_l reloadData];
    }
    // 右列表
    else if (tableView == self.tb_r) {
        NSDictionary *_d_selected   = [self.dataSelected objectAtIndex:self.curRowIndexL];
        NSMutableArray *_a_selected = [_d_selected objectForKey:@"items"];
        id _o                       = [[self.arrR objectAtIndex:indexPath.row] objectForKey:@"id"];
        if (![_a_selected containsObject:_o])
            [_a_selected addObject:_o];
        else
            [_a_selected removeObject:_o];
        [self.tb_l reloadData];
        [self.tb_r reloadData];
    }
}

#pragma mark 分割线顶头
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tb_l) {
        /*
         *以下代码兼容IOS6-8
         *IOS7仅需要设置separatorInset为UIEdgeInsetsZero就可以让分割线顶头了
         *而IOS8需要将separatorInset设置为UIEdgeInsetsZero并且还需要将tabelView和tabelViewCell的layoutMargins设置为UIEdgeInsetsZero
         */
        
        //setSeparatorInset IOS7之后才支持
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        //setLayoutMargins IOS8之后才支持
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    //     不要分割线
    //    if (tableView == self.tb_r) tableView.separatorStyle = NO;
}

#pragma mark 重置按钮事件

-(void)resetTap {
    [self resetDone];
    [self.tb_r reloadData];
}
-(void)resetDone {
    if (self.dataSelected != nil) [self.dataSelected removeAllObjects];
    else self.dataSelected = [[NSMutableArray alloc] init];
    for(int i=0; i<self.arrL.count; i++) {
        NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
        [item setObject:[(NSDictionary *)[self.arrL objectAtIndex:i] objectForKey:@"id"] forKey:@"id"];
        [item setObject:[[NSMutableArray alloc] init] forKey:@"items"];
        [self.dataSelected addObject:item];
    }
}

#pragma mark 确定按钮事件

-(void)okTap {
    [self okDone];
}
-(void)okDone {
    [self.delegate getResultData:self.dataSelected];
}

#pragma mark JSON字符串转NSArray
-(NSArray *)jsonStrToArr:(NSString*)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObj       = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSArray *arr     = (NSArray *)jsonObj;
    return arr;
}

@end
