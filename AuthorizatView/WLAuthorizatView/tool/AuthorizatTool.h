//
//  AuthorizatTool.h
//  AuthorizatView
//
//  Created by https://github.com/orzzh on 2018/1/22.
//  Copyright © 2018年 wl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizatTool : NSObject

+ (BOOL)isOpenPhoto;       //相册
+ (BOOL)isOpenCamera;      //照相机
+ (BOOL)isOpenAudio;       //麦克风
+ (BOOL)isOpenRessBook;    //通讯录
+ (BOOL)isOpenReminder;    //备忘录
+ (BOOL)isOpenEvent;       //日历
+ (BOOL)isOpenNotificat;   //推送
+ (BOOL)isOpenLocation;    //位置

+ (void)openPhotoWithBlock:(void(^)(BOOL isOpen))block;
+ (void)openVideoWithBlock:(void(^)(BOOL isOpen))block;
+ (void)openAudioWithBlock:(void(^)(BOOL isOpen))block;
+ (void)openReminderWithBlock:(void(^)(BOOL isOpen))block;
+ (void)openNotificatWithBlock:(void(^)(BOOL isOpen))block;
+ (void)openEventWithBlock:(void(^)(BOOL isOpen))block;
+ (void)openRessBookWithBlock:(void(^)(BOOL isOpen))block;
- (void)openLocationWithBlock:(void(^)(BOOL isOpen))block;


@end
