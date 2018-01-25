//
//  WLAuthorizatView.m
//  AuthorizatView
//
//  Created by https://github.com/orzzh on 2018/1/22.
//  Copyright © 2018年 wl. All rights reserved.
//

#import "WLAuthorizatView.h"
#import "AuthorizatTableViewCell.h"
#import "AuthorizatModel.h"
#import "UIView+GradientBgColor.h"


static NSString *CELL = @"cellid";
#define BOX_W Screen_Width-80*SCALE

@interface WLAuthorizatView()<UITableViewDelegate,UITableViewDataSource,AuthorizatTableViewCellDelegate>
{
    int i ;
    UIButton *btn;
    NSMutableArray *openItemAry;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *centerView;
@property (nonatomic,strong)UIView *bgView;


@end

@implementation WLAuthorizatView


- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        [self addSubview:self.centerView];
        [self.centerView addSubview:self.tableView];
    }
    return self;
}


- (void)openAll{
    i = 0;
    openItemAry = [[NSMutableArray alloc]init];
    for (int z=0; z<_data.count; z++) {
        AuthorizatModel *m = _data[z];
        if (m.isOpen == NO) {
            [openItemAry addObject:m];
        }
    }
    NSLog(@"open %@",openItemAry);
    if (openItemAry.count == 0) {
        [self remove];
        return;
    }
    AuthorizatModel *mo = openItemAry[i];
    NSInteger index = [_data indexOfObject:mo];
    [self openItem:index];
}

- (void)openItem:(NSInteger)index{
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    AuthorizatTableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
    cell.delegate = self;
    [cell btnAction];
}

#pragma mark - AuthorizatTableViewCellDelegate

- (void)end{
    i++;
    if (i==openItemAry.count) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self remove];
        });
        return;
    }
    
    AuthorizatModel *mo = openItemAry[i];
    NSInteger index = [_data indexOfObject:mo];
    NSLog(@"di %d",i);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self openItem:index];
    });
}

#pragma mark - 展示取消动画

- (void)show{
    [[[UIApplication sharedApplication] delegate].window addSubview:self];
    self.centerView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 1;
    }];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.centerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)remove{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0;
        self.centerView.alpha = 0;
        self.centerView.transform = CGAffineTransformScale(self.centerView.transform, 0.1 , 0.1);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AuthorizatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if (!cell) {
        cell = (AuthorizatTableViewCell*)[[AuthorizatTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setModel:self.data[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


#pragma mark - 控制滚动

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.y>=scrollView.contentSize.height-scrollView.frame.size.height) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height);
    }
}



- (void)setData:(NSArray *)data{
    _data = data;
    self.centerView.frame = CGRectMake(0, 0, BOX_W, self.data.count*80+80+50+10);
    self.centerView.center = self.center;
    self.tableView.frame = CGRectMake(0, 85, BOX_W, self.data.count*80);
    btn.frame = CGRectMake(0, self.tableView.frame.origin.y+self.tableView.frame.size.height+2, BOX_W, 50);
}

#pragma mark - lazyload

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 85, BOX_W, self.data.count*80) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, BOX_W, 80)];
        imageView.contentMode = UIViewContentModeScaleToFill;
//        imageView.image = [UIImage imageNamed:@"bg_jurisdiction_top"];
        [imageView setGradientBgColorWithColors:@[RGB_COLOR(181,229,98),RGB_COLOR(137, 218, 104)] locations:@[@0.,@1.0] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [self.centerView addSubview:imageView];
        
        UILabel *vi = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, BOX_W, 20)];
        vi.text = @"开启你的神秘之旅";
        vi.textAlignment = 1;
        vi.textColor = [UIColor whiteColor];
        vi.font = [UIFont systemFontOfSize:16];
        [imageView addSubview:vi];
        
        UILabel *vi1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, BOX_W, 20)];
        vi1.text = @"- 看看第一步要完成什么吧 -";
        vi1.textAlignment = 1;
        vi1.textColor = [UIColor whiteColor];
        vi1.font = [UIFont systemFontOfSize:14];
        [imageView addSubview:vi1];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"一键开启" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(0, _tableView.frame.origin.y+_tableView.frame.size.height, BOX_W, 50);
        [btn addTarget:self action:@selector(openAll) forControlEvents:UIControlEventTouchUpInside];
        [self.centerView addSubview:btn];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
        line.frame = CGRectMake(0, 0, btn.frame.size.width, 1);
        [btn.layer addSublayer:line];
    }
    return _tableView;
}

- (UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BOX_W, self.data.count*80+80+50+10)];
        _centerView.center = self.center;
        _centerView.backgroundColor = [UIColor whiteColor];
    }
    return _centerView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:self.bounds];
        _bgView.alpha = 0;
        _bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
        [_bgView addGestureRecognizer:ges];
    }
    return _bgView;
}


@end
