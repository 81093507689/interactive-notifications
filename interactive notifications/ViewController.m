//
//  ViewController.m
//  interactive notifications
//
//  Created by Nishant on 13/06/17.
//  Copyright © 2017 Chandni. All rights reserved.
//

#import "ViewController.h"
#import "NotificationDispatch.h"
#import "NotificationDispatch+Actions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods

- (void)showReplyAlertWithMessage:(NSString *)message completion:(void(^)())completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reply" message:[NSString stringWithFormat:@"You have replied: %@", message] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:completion];
}

- (void)showReplyPromptForNotification:(UILocalNotification *)notification {
    __weak UIAlertController *weakAlert;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:notification.alertTitle message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    
    weakAlert = alert;
    
    UIAlertAction *ignore = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *reply = [UIAlertAction actionWithTitle:@"Reply" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = weakAlert.textFields[0];
        
        [self showReplyAlertWithMessage:textField.text completion:nil];
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Type in your reply...";
    }];
    
    [alert addAction:ignore];
    [alert addAction:reply];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)showNotification:(id)sender {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.category = NotificationCategoryIdent;
    notification.alertBody = @"Pull down to reply.";
    notification.alertTitle = @"Incoming message";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
@end
