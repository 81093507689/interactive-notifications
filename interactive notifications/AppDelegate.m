//
//  AppDelegate.m
//  interactive notifications
//
//  Created by Nishant on 13/06/17.
//  Copyright © 2017 Chandni. All rights reserved.
//
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "AppDelegate.h"
#import "UIUserNotificationSettings+Extension.h"
#import "NotificationDispatch.h"
#import "NotificationDispatch+Actions.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (ViewController *)rootViewController {
    return (ViewController *)self.window.rootViewController;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self fn_push_intregate:application];
    return YES;
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
-(void)fn_push_intregate:(UIApplication *)application
{
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    
  /*  UIUserNotificationAction *openAction = [UIUserNotificationAction foregroundActionWithIdentifier:@"open_action" title:@"Open with alert 😉"];
    UIUserNotificationAction *deleteAction = [UIUserNotificationAction backgroundDestructiveActionWithIdentifier:@"delete_action" title:@"Delete 😱" authenticationRequired:YES];
    UIUserNotificationAction *okAction = [UIUserNotificationAction backgroundActionWithIdentifier:@"ok_action" title:@"Ok 👍" authenticationRequired:NO textInput:YES];
    
    UIUserNotificationCategory *userNotificationCategory = [UIUserNotificationCategory categoryWithIdentifier:@"default_category" defaultActions:@[openAction, deleteAction, okAction] minimalActions:@[okAction, deleteAction]];
    
    UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAll categoriesArray:@[userNotificationCategory]];
    
    [application registerUserNotificationSettings:userNotificationSettings];
    
    */
    
    UIUserNotificationCategory *incomingMessageCategory = [NotificationDispatch categoryForIncomingMessageNotification];
    
    NSSet *categories = [NSSet setWithObject:incomingMessageCategory];
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
    
    UIUserNotificationSettings *settings;
    settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [NotificationDispatch registerForLocalNotificationAction:NotificationActionReplyIdent handler:^(UILocalNotification *notification, NSDictionary *responseInfo, void (^completionHandler)()) {
        NSString *message = responseInfo[UIUserNotificationActionResponseTypedTextKey];
        
        [self.rootViewController showReplyAlertWithMessage:message completion:completionHandler];
    }];
    
    [NotificationDispatch registerForLocalNotificationCategory:NotificationCategoryIdent handler:^(UILocalNotification *notification) {
        [self.rootViewController showReplyPromptForNotification:notification];
    }];

    
   /* if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
    {
       
            
        UIMutableUserNotificationAction *notificationAction1 = [[UIMutableUserNotificationAction alloc] init];
        notificationAction1.identifier = @"Accept";
        notificationAction1.title = @"Accept";
        notificationAction1.activationMode = UIUserNotificationActivationModeBackground;
        notificationAction1.destructive = NO;
        notificationAction1.authenticationRequired = NO;
        
        UIMutableUserNotificationAction *notificationAction2 = [[UIMutableUserNotificationAction alloc] init];
        notificationAction2.identifier = @"Reject";
        notificationAction2.title = @"Reject";
        notificationAction2.activationMode = UIUserNotificationActivationModeBackground;
        notificationAction2.destructive = YES;
        notificationAction2.authenticationRequired = YES;
        
        UIMutableUserNotificationAction *notificationAction3 = [[UIMutableUserNotificationAction alloc] init];
        notificationAction3.identifier = @"Reply";
        notificationAction3.title = @"Reply";
        notificationAction3.activationMode = UIUserNotificationActivationModeForeground;
        notificationAction3.destructive = NO;
        notificationAction3.authenticationRequired = YES;
        
        UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
        notificationCategory.identifier = @"Email";
        [notificationCategory setActions:@[notificationAction1,notificationAction2,notificationAction3] forContext:UIUserNotificationActionContextDefault];
        [notificationCategory setActions:@[notificationAction1,notificationAction2] forContext:UIUserNotificationActionContextMinimal];
        
        NSSet *categories = [NSSet setWithObjects:notificationCategory, nil];
        
        UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        localNotification.alertBody = @"Testing";
        localNotification.category = @"Email"; //  Same as category identifier
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }
    */
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //NSLog(@"My token is: %@", deviceToken);
    NSString *dToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dToken = [dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSLog(@"%@",dToken);
    [[NSUserDefaults standardUserDefaults]setObject:dToken forKey:@"deviceToken"];
    
    
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //NSLog(@"didRegisterUserNotificationSettings: %@", notificationSettings);
}



- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    [self application:application handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:@{} completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    NSLog(@"handleActionWithIdentifier: %@ withResponseInfo: %@", identifier, responseInfo);
    
    if ([identifier isEqualToString:@"open_action"])
    {
        [[[UIAlertView alloc] initWithTitle:@"Opened!" message:@"This action only open the app... 😀" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    
    if (completionHandler)
    {
        completionHandler();
    }
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    
    
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    completionHandler();
}

@end
