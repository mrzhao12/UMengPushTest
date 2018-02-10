//
//  AppDelegate.m
//  UMengPushTest
//
//  Created by sjhz on 2018/2/8.
//  Copyright © 2018年 yjs. All rights reserved.
//

#import "AppDelegate.h"
#import <UMCommon/UMCommon.h>   //  // 公共组件是所有友盟产品的基础组件，必选
#import <UMPush/UMessage.h>    // // Push组件
#import <UserNotifications/UserNotifications.h>   //// Push组件必须的系统库 

#define UMENG_APPKEY @"****fughsfiuiuaifusgsi"
@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    // 配置友盟SDK产品并并统一初始化
     [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO.
     [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
    NSLog(@"**********************");
    [UMConfigure initWithAppkey:UMENG_APPKEY channel:@"App Store"];
    //iOS10接收消息的代理
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    
    entity.types = UMessageAuthorizationOptionBadge | UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 用户选择了接收push消息
            NSLog(@"用户选择了接收push消息");
        }else{
            
            // 用户拒绝接收Push消息
            NSLog(@"用户拒绝接收Push消息");
            
        }
    }];
//    [UMessage setLogEnabled:YES];
//    UMessage
    // optional: 若需要使用Push的高级功能，请参考如下函数实现。
//    [self setupPushAdvanceFunctionWithLaunchOptions:launchOptions];
    
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
   
//    [UMessage registerDeviceToken:deviceToken];
//    //以下代码为测试环境获取测试设备的device_token,下面会讲到
    
    
    NSLog(@" device token %@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
//    [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    
//    [NSCharacterSet charactersetWithCharactersInString:@"<>"];
    
//    NSString *tokenString = [deviceToken stringByReplacingOccurrencesOfString:@""withString:@""];
//    NSLog(@"deviceToken:%@",tokenString);
//}
}
// Push 高级功能设置，如果使用"交互式"的通知(iOS 8.0 and later)，请参考下面函数注释部分的代码。
- (void)setupPushAdvanceFunctionWithLaunchOptions:(NSDictionary *_Nullable)launchOptions
{
        UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
        //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
        entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    
        if (([[[UIDevice currentDevice] systemVersion]intValue]>=8)&&([[[UIDevice currentDevice] systemVersion]intValue]<10))
        {
            UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
            action1.identifier = @"action1_identifier";
            action1.title=@"打开应用";
            action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
            UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
            action2.identifier = @"action2_identifier";
            action2.title=@"忽略";
            action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
            action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.destructive = YES;
            UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
            actionCategory1.identifier = @"category1";//这组动作的唯一标示
            [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
            NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
            entity.categories=categories;
        }
    
        //如果要在iOS10显示交互式的通知，必须注意实现以下代码
        if ([[[UIDevice currentDevice] systemVersion]intValue]>=10)
        {
            UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
            UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
    
            //UNNotificationCategoryOptionNone
            //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
            //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
            UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
            NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
            entity.categories=categories;
        }
        [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
            }else
            {
            }
        }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}
////iOS10新增：处理前台收到通知的代理方法
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
////#ifdef UM_Swift
////        [UMessageSwiftInterface setAutoAlertWithValue:NO];
////        [UMessageSwiftInterface didReceiveRemoteNotificationWithUserInfo:userInfo];
////#else
//        //应用处于前台时的远程推送接受
//        //关闭友盟自带的弹出框
//        [UMessage setAutoAlert:NO];
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
////#endif
//        
//    }else{
//        //应用处于前台时的本地推送接受
//    }
//    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
//}
//
//
//
//
////iOS10新增：处理后台点击通知的代理方法
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
////#ifdef UM_Swift
////        [UMessageSwiftInterface didReceiveRemoteNotificationWithUserInfo:userInfo];
////#else
//        //应用处于后台时的远程推送接受
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
////#endif
//        
//    }else{
//        //应用处于后台时的本地推送接受
//    }
//}
@end
