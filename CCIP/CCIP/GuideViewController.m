//
//  GuideViewController.m
//  CCIP
//
//  Created by 腹黒い茶 on 2016/07/09.
//  Copyright © 2016年 CPRTeam. All rights reserved.
//

#import <UICKeyChainStore/UICKeyChainStore.h>
#import "AppDelegate.h"
#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.guideMessageLabel setText:NSLocalizedString(@"GuideViewMessage", nil)];
    [self.redeemButton setTitle:NSLocalizedString(@"GuideViewButton", nil)
                       forState:UIControlStateNormal];
    [self.redeemButton setBackgroundColor:[UIColor colorWithRed:61/255.0 green:152/255.0 blue:60/255.0 alpha:1]];
    self.redeemButton.layer.cornerRadius = 8.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.originalCenter = CGPointMake(self.view.center.x, self.view.center.y);
    
    SEND_GAI(@"GuideViewController");
    
    [self.view setAutoresizingMask:UIViewAutoresizingNone];
    CGRect frame = self.view.frame;
    frame.size.height -= 100;
    self.view.frame = frame;
}

- (void)keyboardDidShow:(NSNotification *)note {
    if (self.view.frame.size.height <= 480) {
        self.view.center = CGPointMake(self.view.center.x, self.originalCenter.y - 130);
    } else if (self.view.frame.size.height <= 568) {
        self.view.center = CGPointMake(self.view.center.x, self.originalCenter.y - 30);
    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    if (self.view.frame.size.height <= 480) {
        self.view.center = CGPointMake(self.view.center.x, self.originalCenter.y + 23);
    } else if (self.view.frame.size.height <= 568) {
        self.view.center = CGPointMake(self.view.center.x, self.originalCenter.y + 60);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redeemCode:(id)sender {
    NSString *code = [self.redeemCodeText text];
    if ([code length] > 0) {
        if ([[AppDelegate appDelegate].accessToken length] > 0) {
            [UICKeyChainStore removeItemForKey:@"token"];
        }
        [AppDelegate appDelegate].accessToken = code;
        [UICKeyChainStore setString:[AppDelegate appDelegate].accessToken
                             forKey:@"token"];
        [[AppDelegate appDelegate].oneSignal sendTag:@"token" value:[AppDelegate appDelegate].accessToken];
    }
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 //TODO: refresh card data
                             }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
