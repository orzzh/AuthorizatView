//
//  AuthorizatTableViewCell.h
//  AuthorizatView
//
//  Created by https://github.com/orzzh on 2018/1/22.
//  Copyright © 2018年 wl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuthorizatModel;

@protocol AuthorizatTableViewCellDelegate
- (void)end;
@end
@interface AuthorizatTableViewCell : UITableViewCell

@property (weak)id<AuthorizatTableViewCellDelegate> delegate;

- (void)setModel:(AuthorizatModel *)model;
- (void)btnAction;

@end
