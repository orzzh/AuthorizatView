//
//  AuthorizatModel.m
//  AuthorizatView
//
//  Created by https://github.com/orzzh on 2018/1/22.
//  Copyright © 2018年 wl. All rights reserved.
//

#import "AuthorizatModel.h"
#import "AuthorizatTool.h"
@interface AuthorizatModel()
@property (nonatomic,strong)AuthorizatTool *tool;
@end
@implementation AuthorizatModel

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)imgName type:(AuthorizatType)type{
    self = [super init];
    if (self) {
        _titleStr = [NSString stringWithFormat:@"%@",title];
        _subtitleStr = [NSString stringWithFormat:@"%@",subTitle];
        _imageName = [NSString stringWithFormat:@"%@",imgName];
        _type = type;
        [self checkAuthorizat];
    }
    return self;
}

- (void)checkAuthorizat{
    switch (_type) {
        case AuthorizatTypePhoto:{    //判断相册权限
            _isOpen = [AuthorizatTool isOpenPhoto];
        }break;
        case AuthorizatTypeCamera:{   //相机权限
            _isOpen = [AuthorizatTool isOpenCamera];
        }break;
        case AuthorizatTypeAudio:{    //麦克风权限
            _isOpen = [AuthorizatTool isOpenAudio];
        }break;
        case AuthorizatTypeReminder:{ //备忘录
            _isOpen = [AuthorizatTool isOpenReminder];
        }break;
        case AuthorizatTypeRessBook:{ //通讯录
            _isOpen = [AuthorizatTool isOpenRessBook];
        }break;
        case AuthorizatTypeEvent:{    //日历
            _isOpen = [AuthorizatTool isOpenEvent];
        }break;
        case AuthorizatTypeNotication:{//通知
            _isOpen = [AuthorizatTool isOpenNotificat];
        }break;
        case AuthorizatTypeLocation:{  //地理位置
            _isOpen = [AuthorizatTool isOpenLocation];
        }break;
        default:
            break;
    }
}

- (void)openAuthorizatWithBlock:(void(^)(BOOL open))block{
    switch (_type) {
        case AuthorizatTypePhoto:{    //打开相册权限
            [AuthorizatTool openPhotoWithBlock:block];
        }break;
        case AuthorizatTypeCamera:{   //打开相机权限
            [AuthorizatTool openVideoWithBlock:block];
        }break;
        case AuthorizatTypeAudio:{    //打开麦克风权限
            [AuthorizatTool openAudioWithBlock:block];
        }break;
        case AuthorizatTypeReminder:{ //打开备忘录权限
            [AuthorizatTool openReminderWithBlock:block];
        }break;
        case AuthorizatTypeRessBook:{ //打开通讯录权限
            [AuthorizatTool openRessBookWithBlock:block];
        }break;
        case AuthorizatTypeEvent:{    //打开日历权限
            [AuthorizatTool openEventWithBlock:block];
        }break;
        case AuthorizatTypeNotication:{//打开通知权限
            [AuthorizatTool openNotificatWithBlock:block];
        }break;
        case AuthorizatTypeLocation:{  //打开地理位置权限
            _tool = [[AuthorizatTool alloc]init];
            [_tool openLocationWithBlock:block];
        }break;
        default:
            break;
    }
}

@end
