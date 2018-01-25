//
//  ViewController.m
//  AuthorizatView
//
//  Created by https://github.com/orzzh on 2018/1/22.
//  Copyright © 2018年 wl. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "WLAuthorizatView.h"
#import "AuthorizatModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
static NSString *const KVO_CONTEXT_ADDRESS_CHANGED = @"KVO_CONTEXT_ADDRESS_CHANGED";

- (IBAction)author:(id)sender {
    
    AuthorizatModel *mo1 = [[AuthorizatModel alloc]initWithTitle:@"开启地理位置" subTitle:@"麻溜利索的打开" image:@"定位" type:AuthorizatTypeLocation];
    AuthorizatModel *mo2 = [[AuthorizatModel alloc]initWithTitle:@"开启消息通知" subTitle:@"麻溜利索的打开" image:@"通知" type:AuthorizatTypeNotication];
    AuthorizatModel *mo3 = [[AuthorizatModel alloc]initWithTitle:@"开启照相机" subTitle:@"麻溜利索的打开" image:@"照片" type:AuthorizatTypeCamera];
//     AuthorizatModel *mo4 = [[AuthorizatModel alloc]initWithTitle:@"开启麦克风" subTitle:@"麻溜利索的打开" image:@"语音" type:AuthorizatTypeAudio]; //语音 模拟器不可用
    
    NSArray *ary = @[mo1,mo2,mo3];//,mo4];
    
    WLAuthorizatView *v = [[WLAuthorizatView alloc]init];
    v.data = ary;
    [v show];
    
}

- (void)sss{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
