//
//  ViewController.m
//  MulitUITableView
//
//  Created by mac373 on 16/3/31.
//  Copyright © 2016年 ole. All rights reserved.
//

#import "ViewController.h"

#define WEIGHT [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define MAIN_VIEW_W [UIScreen mainScreen].bounds.size.width-20
#define MAIN_VIEW_H [UIScreen mainScreen].bounds.size.height-30
#define TB_VIEW_W ([UIScreen mainScreen].bounds.size.width-20) / 2

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArr];
    [self initView];
    [self resetDone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initArr {
    NSString *json_str_l = @"{\"data\":[{\"id\":1,\"name\":\"A\"},{\"id\":2,\"name\":\"B\"},{\"id\":3,\"name\":\"C\"},{\"id\":4,\"name\":\"D\"},{\"id\":5,\"name\":\"E\"},{\"id\":6,\"name\":\"F\"}]}";
    NSData *data= [json_str_l dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
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

- (void)initView {
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, MAIN_VIEW_W , MAIN_VIEW_H)];
    [mainView setBackgroundColor:[UIColor blackColor]];
    // 左列表
    self.tb_l = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TB_VIEW_W ,MAIN_VIEW_H)];
    self.tb_l.dataSource = self;
    self.tb_l.delegate = self;
    [mainView addSubview:self.tb_l];
    // 右列表
    self.tb_r = [[UITableView alloc] initWithFrame:CGRectMake(TB_VIEW_W, 0, TB_VIEW_W ,MAIN_VIEW_H)];
    self.tb_r.dataSource = self;
    self.tb_r.delegate = self;
    [mainView addSubview:self.tb_r];
    // 底部操作栏(采用约束布局)
    UIView *bottomBarView = [[UIView alloc] init];
    bottomBarView.backgroundColor = [UIColor lightGrayColor];
    // 底部操作栏 # 重置按钮
    UIButton *resetBtn = [[UIButton alloc] init];
    resetBtn.backgroundColor = [UIColor whiteColor];
    [resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetTap) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarView addSubview:resetBtn];
    // 底部操作栏 # 确定按钮
    UIButton *okBtn = [[UIButton alloc] init];
    okBtn.backgroundColor = [UIColor redColor];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okTap) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarView addSubview:okBtn];
    //
    [mainView addSubview:bottomBarView];
    //
    [self.view addSubview:mainView];
    
    // 设置控件约束
    // 设置控件约束 # 底部操作栏
    bottomBarView.translatesAutoresizingMaskIntoConstraints = NO;
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:bottomBarView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1
                                                          constant:0]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:bottomBarView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0
                                                          constant:80]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:bottomBarView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:bottomBarView
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:0]];
    // 设置控件约束 # 底部操作栏 # 重置按钮
    resetBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomBarView addConstraint:[NSLayoutConstraint constraintWithItem:resetBtn
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:bottomBarView
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0]];
    [bottomBarView addConstraint:[NSLayoutConstraint constraintWithItem:resetBtn
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:bottomBarView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
    [bottomBarView addConstraint:[NSLayoutConstraint constraintWithItem:resetBtn
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:bottomBarView
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:0.5
                                                               constant:0]];
    [bottomBarView addConstraint:[NSLayoutConstraint constraintWithItem:resetBtn
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:bottomBarView
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:-0.5]];
    // 设置控件约束 # 底部操作栏 # 确定按钮
    okBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomBarView addConstraint:[NSLayoutConstraint constraintWithItem:okBtn
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:bottomBarView
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]];
    [bottomBarView addConstraint:[NSLayoutConstraint constraintWithItem:okBtn
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:bottomBarView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
    [bottomBarView addConstraint:[NSLayoutConstraint constraintWithItem:okBtn
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:bottomBarView
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:0.5
                                                               constant:0]];
    [bottomBarView addConstraint:[NSLayoutConstraint constraintWithItem:okBtn
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:bottomBarView
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:0]];
}

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
        cell.tag = [(NSDictionary *)[self.arr_l1 objectAtIndex:indexPath.row] objectForKey:@"id"];
        cell.textLabel.text = [NSString stringWithFormat: @"%@", [(NSDictionary *)[self.arr_l1 objectAtIndex:indexPath.row] objectForKey:@"name"]];
    } else if (tableView == self.tb_r) {
        if (self.cur_idx == 1) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text = [NSString stringWithFormat: @"%@", [self.arr_r1 objectAtIndex:indexPath.row]];
            cell.textLabel.text = _text;
            if ([_arr containsObject: _text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (self.cur_idx == 2) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text = [NSString stringWithFormat: @"%@", [self.arr_r2 objectAtIndex:indexPath.row]];
            cell.textLabel.text = _text;
            if ([_arr containsObject:_text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (self.cur_idx == 3) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text = [NSString stringWithFormat: @"%@", [self.arr_r3 objectAtIndex:indexPath.row]];
            cell.textLabel.text = _text;
            if ([_arr containsObject:_text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (self.cur_idx == 4) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text = [NSString stringWithFormat: @"%@", [self.arr_r4 objectAtIndex:indexPath.row]];
            cell.textLabel.text = _text;
            if ([_arr containsObject:_text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (self.cur_idx == 5) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text = [NSString stringWithFormat: @"%@", [self.arr_r5 objectAtIndex:indexPath.row]];
            cell.textLabel.text = _text;
            if ([_arr containsObject:_text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (self.cur_idx == 6) {
            NSMutableArray *_arr = [self.dict_selected objectForKey:[NSString stringWithFormat:@"%d", self.cur_idx]];
            NSString *_text = [NSString stringWithFormat: @"%@", [self.arr_r6 objectAtIndex:indexPath.row]];
            cell.textLabel.text = _text;
            if ([_arr containsObject:_text])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

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
