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

- (instancetype)init {
    return [self initWithFrame: CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView {
    [self didLoadDataToTableView];
    [self resetDone];
    self.frame = CGRectMake(10, 20, MAIN_VIEW_W , MAIN_VIEW_H);
    [self setBackgroundColor:[UIColor blackColor]];
    // 左列表
    self.tb_l            = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TB_VIEW_W ,MAIN_VIEW_H)];
    self.tb_l.dataSource = self;
    self.tb_l.delegate   = self;
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

- (void)didLoadDataToTableView {
    if (self.delegate == nil) {
        NSLog(@"delegate is nil !");
        return;
    }
    NSString *json_l = [self.delegate didLoadDataToLeftTableView];
    
    NSLog(@"json -> %@", json_l);
    NSData *data   = [json_l dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject  = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
    if ([jsonObject isKindOfClass:[NSDictionary class]]){
        NSDictionary *dictionary = (NSDictionary *)jsonObject;
        //        NSLog(@"Dersialized JSON Dictionary = %@", dictionary);
    } else if ([jsonObject isKindOfClass:[NSArray class]]){
        NSArray *nsArray = (NSArray *)jsonObject;
        //        NSLog(@"Dersialized JSON Array = %@", nsArray);
    } else {
        //        NSLog(@"An error happened while deserializing the JSON data.");
    }
    NSDictionary *dict = (NSDictionary *)jsonObject;
    NSArray* arr_l = [dict objectForKey:@"data"];
    //    NSLog(@"list is %@",arr_l);
    
    self.cur_idx = 1;
    self.arr_l1 = arr_l;
    self.arr_r1 = [[NSArray alloc] initWithObjects:@"A1",@"A2",@"A3",@"A4",@"A5", nil];
    self.arr_r2 = [[NSArray alloc] initWithObjects:@"B1",@"B2",@"B3",@"B4",@"B5", nil];
    self.arr_r3 = [[NSArray alloc] initWithObjects:@"C1",@"C2",@"C3",@"C4",@"C5", nil];
    self.arr_r4 = [[NSArray alloc] initWithObjects:@"D1",@"D2",@"D3",@"D4",@"D5", nil];
    self.arr_r5 = [[NSArray alloc] initWithObjects:@"E1",@"E2",@"E3",@"E4",@"E5", nil];
    self.arr_r6 = [[NSArray alloc] initWithObjects:@"F1",@"F2",@"F3",@"F4",@"F5", nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tb_l) {
        return self.arr_l1.count;
    } else if (tableView == self.tb_r) {
        if (self.cur_idx == 1) return self.arr_r1.count;
        else if (self.cur_idx == 2) return self.arr_r2.count;
        else if (self.cur_idx == 3) return self.arr_r3.count;
        else if (self.cur_idx == 4) return self.arr_r4.count;
        else if (self.cur_idx == 5) return self.arr_r5.count;
        else if (self.cur_idx == 6) return self.arr_r6.count;
        else return 0;
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
        cell.tag            = [(NSDictionary *)[self.arr_l1 objectAtIndex:indexPath.row] objectForKey:@"id"];
        cell.textLabel.text = [NSString stringWithFormat: @"%@", [(NSDictionary *)[self.arr_l1 objectAtIndex:indexPath.row] objectForKey:@"name"]];
    } else if (tableView == self.tb_r) {
        if (self.cur_idx == 1) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text      = [NSString stringWithFormat: @"%@", [self.arr_r1 objectAtIndex:indexPath.row]];
            cell.textLabel.text  = _text;
            if ([_arr containsObject: _text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (self.cur_idx == 2) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text      = [NSString stringWithFormat: @"%@", [self.arr_r2 objectAtIndex:indexPath.row]];
            cell.textLabel.text  = _text;
            if ([_arr containsObject:_text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (self.cur_idx == 3) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text      = [NSString stringWithFormat: @"%@", [self.arr_r3 objectAtIndex:indexPath.row]];
            cell.textLabel.text  = _text;
            if ([_arr containsObject:_text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (self.cur_idx == 4) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text      = [NSString stringWithFormat: @"%@", [self.arr_r4 objectAtIndex:indexPath.row]];
            cell.textLabel.text  = _text;
            if ([_arr containsObject:_text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (self.cur_idx == 5) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text      = [NSString stringWithFormat: @"%@", [self.arr_r5 objectAtIndex:indexPath.row]];
            cell.textLabel.text  = _text;
            if ([_arr containsObject:_text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (self.cur_idx == 6) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text      = [NSString stringWithFormat: @"%@", [self.arr_r6 objectAtIndex:indexPath.row]];
            cell.textLabel.text  = _text;
            if ([_arr containsObject:_text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取被选中的cell对象
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    // 左列表
    if (tableView == self.tb_l) {
        self.cur_idx = [[(NSDictionary *)[self.arr_l1 objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
        [self.tb_r reloadData];
    }
    // 右列表
    else if (tableView == self.tb_r) {
        if (self.cur_idx == 1) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            id _arr_obj          = [self.arr_r1 objectAtIndex:indexPath.row];
            if (![_arr containsObject:_arr_obj])
                [_arr addObject:_arr_obj];
            else
                [_arr removeObject:_arr_obj];
            [self.tb_r reloadData];
            NSLog(@"after -> %@",_arr);
        }
        else if (self.cur_idx == 2) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            id _arr_obj          = [self.arr_r2 objectAtIndex:indexPath.row];
            if (![_arr containsObject:_arr_obj])
                [_arr addObject:_arr_obj];
            else
                [_arr removeObject:_arr_obj];
            [self.tb_r reloadData];
            NSLog(@"after -> %@",_arr);
        }
        else if (self.cur_idx == 3) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            id _arr_obj          = [self.arr_r3 objectAtIndex:indexPath.row];
            if (![_arr containsObject:_arr_obj])
                [_arr addObject:_arr_obj];
            else
                [_arr removeObject:_arr_obj];
            [self.tb_r reloadData];
            NSLog(@"after -> %@",_arr);
        }
        else if (self.cur_idx == 4) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            id _arr_obj          = [self.arr_r4 objectAtIndex:indexPath.row];
            if (![_arr containsObject:_arr_obj])
                [_arr addObject:_arr_obj];
            else
                [_arr removeObject:_arr_obj];
            [self.tb_r reloadData];
            NSLog(@"after -> %@",_arr);
        }
        
        else if (self.cur_idx == 5) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            id _arr_obj          = [self.arr_r5 objectAtIndex:indexPath.row];
            if (![_arr containsObject:_arr_obj])
                [_arr addObject:_arr_obj];
            else
                [_arr removeObject:_arr_obj];
            [self.tb_r reloadData];
            NSLog(@"after -> %@",_arr);
        }
        else if (self.cur_idx == 6) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            id _arr_obj          = [self.arr_r6 objectAtIndex:indexPath.row];
            if (![_arr containsObject:_arr_obj])
                [_arr addObject:_arr_obj];
            else
                [_arr removeObject:_arr_obj];
            [self.tb_r reloadData];
            NSLog(@"after -> %@",_arr);
        }
    }
}

#pragma mark 重置按钮事件

-(void)resetTap {
    [self resetDone];
    [self.tb_r reloadData];
}
-(void)resetDone {
    if (self.dict_selected != nil) [self.dict_selected removeAllObjects];
    else self.dict_selected = [[NSMutableDictionary alloc] init];
    for(int i=0; i<self.arr_l1.count; i++) {
        [self.dict_selected setObject:[[NSMutableArray alloc] init] forKey:[[(NSDictionary *)[self.arr_l1 objectAtIndex:i] objectForKey:@"id"] stringValue]];
    }
    NSLog(@"%@",self.dict_selected);
}

#pragma mark 确定按钮事件

-(void)okTap {
    [self okDone];
}
-(void)okDone {
    NSLog(@"%@",self.dict_selected);
}
@end
