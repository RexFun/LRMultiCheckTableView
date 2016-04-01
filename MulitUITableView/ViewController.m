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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initArr {
    self.arr1 = [[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F", nil];
    self.arr2 = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
}

- (void)initView {
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, MAIN_VIEW_W , MAIN_VIEW_H)];
    [mainView setBackgroundColor:[UIColor blackColor]];
    
    self.tb1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TB_VIEW_W ,MAIN_VIEW_H)];
    self.tb1.dataSource = self;
    self.tb1.delegate = self;
    [mainView addSubview:self.tb1];
    
    self.tb2 = [[UITableView alloc] initWithFrame:CGRectMake(TB_VIEW_W, 0, TB_VIEW_W ,MAIN_VIEW_H)];
    self.tb2.dataSource = self;
    self.tb2.delegate = self;
    [mainView addSubview:self.tb2];
    
    [self.view addSubview:mainView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tb1) {
        return self.arr1.count;
    } else if (tableView == self.tb2) {
        return self.arr2.count;
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
    if (tableView == self.tb1) {
        cell.textLabel.text = [NSString stringWithFormat: @"%@", [self.arr1 objectAtIndex:indexPath.row]];
    } else if (tableView == self.tb2) {
        cell.textLabel.text = [NSString stringWithFormat: @"%@", [self.arr2 objectAtIndex:indexPath.row]];
    }
    return cell;
}
@end
