//
//  AuthorizatTableViewCell.m
//  AuthorizatView
//
//  Created by https://github.com/orzzh on 2018/1/22.
//  Copyright © 2018年 wl. All rights reserved.
//

#import "AuthorizatTableViewCell.h"
#import "AuthorizatModel.h"
#import "UIView+GradientBgColor.h"

@interface AuthorizatTableViewCell()

@property (nonatomic,strong)UIButton *openBtn;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *subTitle;
@property (nonatomic,strong)AuthorizatModel *model;
@end
@implementation AuthorizatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setModel:(AuthorizatModel *)model{
    _model = model;
    self.img.image = [UIImage imageNamed:model.imageName];
    self.title.text = [NSString stringWithFormat:@"%@",model.titleStr];
    self.subTitle.text = [NSString stringWithFormat:@"%@",model.subtitleStr];
    self.openBtn.selected = model.isOpen;
    if(model.isOpen){
        [self selected];
    }else{
        [self noSelect];
    }
}

- (void)layoutSubviews{
    [self addSubview:self.img];
    [self addSubview:self.title];
    [self addSubview:self.subTitle];
    [self addSubview:self.openBtn];
}

- (void)selected{
    [_model checkAuthorizat];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.openBtn.layer.borderWidth = 0;
        self.openBtn.backgroundColor = [UIColor orangeColor];
        [self.openBtn setTitle:@"已开启" forState:UIControlStateNormal];
        [self.openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.openBtn setGradientBgColorWithColors:@[RGB_COLOR(181,229,98),RGB_COLOR(137, 218, 104)] locations:@[@0.,@1.0] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    });
}

- (void)noSelect{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.openBtn.layer.borderWidth = 1;
        self.openBtn.backgroundColor = [UIColor clearColor];
        [self.openBtn setTitle:@"开启" forState:UIControlStateNormal];
        [self.openBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        for (CALayer *layer in self.openBtn.layer.sublayers) {
            if ([layer isKindOfClass:[CAGradientLayer class]]) {
                [layer removeFromSuperlayer];
            }
        }
    });
}

- (void)btnAction{
    if(_model.isOpen){return;}
    __weak typeof(self) weaskSelf = self;
    [_model openAuthorizatWithBlock:^(BOOL open) {
        
        NSLog(@"选择了啊啊啊啊");
        weaskSelf.model.isOpen = open;
        if (open) {
            [weaskSelf selected];
        }else{
            NSLog(@"未打开");
        }
        if (weaskSelf.delegate) {
            [weaskSelf.delegate end];
        }
    }];
}

#pragma mark - lazyload

- (UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openBtn.frame = CGRectMake((self.frame.size.width-80)*5/4-80, 25, 60, 25);
        _openBtn.layer.cornerRadius = 25/2;
        _openBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _openBtn.layer.masksToBounds = YES;
        _openBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self noSelect];
        [_openBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _img.center = CGPointMake(50, 40);
    }
    return _img;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(90, self.img.frame.origin.y+5, 150, 20)];
        _title.font = [UIFont systemFontOfSize:16];
        _title.textColor = [UIColor blackColor];
    }
    return _title;
}

- (UILabel *)subTitle{
    if (!_subTitle) {
        _subTitle = [[UILabel alloc]initWithFrame:CGRectMake(90, self.img.frame.origin.y+25, 150, 20)];
        _subTitle.font = [UIFont systemFontOfSize:14];
        _subTitle.textColor = [UIColor grayColor];
    }
    return _subTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
