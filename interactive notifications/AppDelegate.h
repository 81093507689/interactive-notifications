//
//  AppDelegate.h
//  interactive notifications
//
//  Created by Nishant on 13/06/17.
//  Copyright © 2017 Chandni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "ViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly) ViewController *rootViewController;

@end

