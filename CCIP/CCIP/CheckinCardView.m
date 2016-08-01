//
//  CheckinCardView.m
//  CCIP
//
//  Created by 腹黒い茶 on 2016/07/31.
//  Copyright © 2016年 CPRTeam. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CheckinCardView.h"
#import "AppDelegate.h"
#import "UIAlertController+additional.h"
#import "GatewayWebService/GatewayWebService.h"

@interface CheckinCardView()

@end

@implementation CheckinCardView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.layer setCornerRadius:15.0f]; // set cornerRadius as you want.
    [self.layer setMasksToBounds:NO];
    [self.layer setShadowOffset:CGSizeMake(10, 15)];
    [self.layer setShadowRadius:5.0f];
    [self.layer setShadowOpacity:0.3f];
    
    [self.checkinBtn.layer setCornerRadius:10.0f];
}

- (IBAction)checkinBtnTouched:(id)sender {
    UIColor *disabledColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
    if ([self.id isEqualToString:@"day1checkin"] || [self.id isEqualToString:@"day2checkin"]) {
        GatewayWebService *ws = [[GatewayWebService alloc] initWithURL:CC_USE([AppDelegate appDelegate].accessToken, self.id)];
        [ws sendRequest:^(NSDictionary *json, NSString *jsonStr) {
            if (json != nil) {
                NSLog(@"%@", json);
                if ([[json objectForKey:@"message"] isEqual:@"invalid token"]) {
                    NSLog(@"%@", [json objectForKey:@"message"]);
                    [self.checkinBtn setBackgroundColor:[UIColor redColor]];
                } else if ([[json objectForKey:@"message"] isEqual:@"has been used"]) {
                    NSLog(@"%@", [json objectForKey:@"message"]);
                    [UIView animateWithDuration:0.25f
                                     animations:^{
                                         [self.checkinBtn setBackgroundColor:[UIColor orangeColor]];
                                     }
                                     completion:^(BOOL finished) {
                                         if (finished) {
                                             [UIView animateWithDuration:1.75f
                                                              animations:^{
                                                                  [self.checkinBtn setBackgroundColor:disabledColor];
                                                              }];
                                         }
                                     }];
                } else {
                    [self.checkinBtn setTitle:NSLocalizedString(@"CheckinViewButtonPressed", nil) forState:UIControlStateNormal];
                    [self.checkinBtn setBackgroundColor:disabledColor];
                }
            }
        }];
    } else {
        UIAlertController *ac = [UIAlertController alertOfTitle:NSLocalizedString(@"UseButton", nil)
                                                    withMessage:NSLocalizedString(@"ConfirmAlertText", nil)
                                               cancelButtonText:NSLocalizedString(@"Cancel", nil)
                                                    cancelStyle:UIAlertActionStyleCancel
                                                   cancelAction:nil];
        [ac addActionButton:NSLocalizedString(@"CONFIRM", nil)
                      style:UIAlertActionStyleDestructive
                    handler:^(UIAlertAction * _Nonnull action) {
                        GatewayWebService *ws = [[GatewayWebService alloc] initWithURL:CC_USE([AppDelegate appDelegate].accessToken, self.id)];
                        [ws sendRequest:^(NSDictionary *json, NSString *jsonStr) {
                            if (json != nil) {
                                NSLog(@"%@", json);
                                if ([[json objectForKey:@"message"] isEqual:@"invalid token"]) {
                                    NSLog(@"%@", [json objectForKey:@"message"]);
                                    [self.checkinBtn setBackgroundColor:[UIColor redColor]];
                                } else {
                                    [self.checkinBtn setTitle:NSLocalizedString(@"UseButtonPressed", nil) forState:UIControlStateNormal];
                                    [self.checkinBtn setBackgroundColor:disabledColor];
                                }
                            }
                        }];
                    }];
        [ac showAlert:nil];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
