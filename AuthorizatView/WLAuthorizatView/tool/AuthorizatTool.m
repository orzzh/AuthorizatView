//
//  AuthorizatTool.m
//  AuthorizatView
//
//  Created by https://github.com/orzzh on 2018/1/22.
//  Copyright © 2018年 wl. All rights reserved.
//

#import "AuthorizatTool.h"
//相机，麦克风
#import <AVFoundation/AVFoundation.h>
//相册
#import <Photos/Photos.h>
//通讯录
#import <AddressBook/AddressBook.h>
//定位
#import <CoreLocation/CoreLocation.h>
//日历
#import <EventKit/EventKit.h>
//通知
#import <UserNotifications/UserNotifications.h>

#import <CoreLocation/CoreLocation.h>


@interface AuthorizatTool()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,copy)void(^block)(BOOL);
@end
@implementation AuthorizatTool

+ (BOOL)isOpenPhoto{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    BOOL _isOpen = status == PHAuthorizationStatusAuthorized ? YES : NO;
    return _isOpen;
}

+ (BOOL)isOpenCamera{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    BOOL _isOpen = status == AVAuthorizationStatusAuthorized ? YES : NO;
    return _isOpen;
}

+ (BOOL)isOpenAudio{
    AVAuthorizationStatus status =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    BOOL _isOpen = status == AVAuthorizationStatusAuthorized ? YES : NO;
    return _isOpen;
}

+ (BOOL)isOpenRessBook{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    BOOL _isOpen = status == kABAuthorizationStatusAuthorized ? YES : NO;
    return _isOpen;
}

+ (BOOL)isOpenReminder{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    BOOL _isOpen = status == EKAuthorizationStatusAuthorized ? YES : NO;
    return _isOpen;
}

+ (BOOL)isOpenEvent{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    BOOL _isOpen = status == EKAuthorizationStatusAuthorized ? YES : NO;
    return _isOpen;
}

+ (BOOL)isOpenNotificat{
    UIUserNotificationSettings *status = [[UIApplication sharedApplication] currentUserNotificationSettings];
    BOOL _isOpen = status.types == UIUserNotificationTypeNone ? NO : YES;
    return _isOpen;
}

+ (BOOL)isOpenLocation{
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (isLocation) {
        CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];
        if (locationStatus == kCLAuthorizationStatusAuthorizedAlways||
            locationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            return YES;
        }
    }
    return NO;
}




+ (void)openPhotoWithBlock:(void(^)(BOOL isOpen))block{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        BOOL is = status == PHAuthorizationStatusAuthorized ? YES:NO;
        block(is);
    }];
}

+ (void)openVideoWithBlock:(void(^)(BOOL isOpen))block{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        BOOL is = granted ? YES:NO;
        block(is);
    }];
}

+ (void)openAudioWithBlock:(void(^)(BOOL isOpen))block{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        BOOL is = granted ? YES:NO;
        block(is);
    }];
}

+ (void)openReminderWithBlock:(void(^)(BOOL isOpen))block{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder
                               completion:^(BOOL granted, NSError *error) {
                                   if (error) {
                                       NSLog(@"备忘录出现了错误");
                                       return;
                                   }
                                   BOOL is = granted ? YES:NO;
                                   NSLog(@"11");
                                   block(is);
                               }];
}

+ (void)openRessBookWithBlock:(void(^)(BOOL isOpen))block{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (error) {
            NSLog(@"通讯录出现了错误");
            return;
        }
        BOOL is = granted ? YES:NO;
        block(is);
    });
}

+ (void)openEventWithBlock:(void(^)(BOOL isOpen))block{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent
                               completion:^(BOOL granted, NSError *error) {
                                   if (error) {
                                       NSLog(@"日历出现了错误");
                                       return;
                                   }
                                   BOOL is = granted ? YES:NO;
                                   block(is);
                               }];
}

+ (void)openNotificatWithBlock:(void(^)(BOOL isOpen))block{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
            //注册之后的回调
            BOOL is = !error && granted ? YES:NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                block(is);
            });
        }];
    } else {
        // Fallback on earlier versions
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        block(YES);
    }
}

- (void)openLocationWithBlock:(void (^)(BOOL))block{
    _block = block;
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    [_manager requestAlwaysAuthorization];
    [_manager requestWhenInUseAuthorization];
    [_manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"授权状态改变");
    BOOL isOpen=NO;
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"未询问用户是否授权");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"未授权，例如家长控制");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"未授权，用户拒绝造成的");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"同意授权一直获取定位信息");
            isOpen = YES;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"同意授权在使用时获取定位信息");
            isOpen = YES;
            break;
            
        default:
            break;
    }
    if (status!=kCLAuthorizationStatusNotDetermined) {
        _block(isOpen);
    }
}

@end
