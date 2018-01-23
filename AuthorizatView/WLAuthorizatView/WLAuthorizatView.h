//
//  WLAuthorizatView.h
//  AuthorizatView
//
//  Created by https://github.com/orzzh on 2018/1/22.
//  Copyright © 2018年 wl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLAuthorizatView : UIView

@property (nonatomic,strong)NSArray *data;

- (void)show;
- (void)remove;

@end
