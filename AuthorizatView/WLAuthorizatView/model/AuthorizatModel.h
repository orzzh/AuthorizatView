//
//  AuthorizatModel.h
//  AuthorizatView
//
//  Created by https://github.com/orzzh on 2018/1/22.
//  Copyright © 2018年 wl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,AuthorizatType) {
    AuthorizatTypePhoto = 0,  //相册
    AuthorizatTypeCamera,     //照相机
    AuthorizatTypeAudio,      //麦克风
    AuthorizatTypeRessBook,   //通讯录
    AuthorizatTypeReminder,   //备忘录
    AuthorizatTypeEvent,      //日历
    AuthorizatTypeNotication, //通知
    AuthorizatTypeLocation    //地理位置
};

@interface AuthorizatModel : NSObject

@property (nonatomic,strong)NSString *titleStr;   //大标题
@property (nonatomic,strong)NSString *subtitleStr;//小标题
@property (nonatomic,strong)NSString *imageName;  //图片
@property (nonatomic,assign)BOOL     isOpen;
@property (nonatomic,assign)AuthorizatType type;


- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)imgName type:(AuthorizatType)type;

- (void)openAuthorizatWithBlock:(void(^)(BOOL open))block;
- (void)checkAuthorizat;


@end
