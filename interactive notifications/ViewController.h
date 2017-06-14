//
//  ViewController.h
//  interactive notifications
//
//  Created by Nishant on 13/06/17.
//  Copyright © 2017 Chandni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (void)showReplyAlertWithMessage:(NSString *)message completion:(void(^)())completion;
- (void)showReplyPromptForNotification:(UILocalNotification *)notification;


@end

