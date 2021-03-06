//
//  MainTabBarViewController.m
//  CCIP
//
//  Created by Sars on 7/16/16.
//  Copyright © 2016 CPRTeam. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "GatewayWebService/GatewayWebService.h"
#import "NSInvocation+addition.h"
#import "UIImage+addition.h"
#import "ScheduleViewController.h"
#import "MoreTableViewController.h"
#import "AppDelegate.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *titleHighlightedColor = [UIColor colorWithRed:65/255.0 green:117/255.0 blue:5/255.0 alpha:1.0];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleHighlightedColor, NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateSelected];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    // setting selected image color from original image with replace custom color filter
    for(UITabBarItem *item in self.tabBar.items) {
        UIImage *image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        image = [image imageWithColor:titleHighlightedColor];
        [item setSelectedImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self handleShortcutItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self handleShortcutItem];
}

- (void)appplicationDidBecomeActive:(NSNotification *)notification {
    NSLog(@"Application Did Become Active");
    [self handleShortcutItem];
}

- (void)handleShortcutItem {
    NSObject *mainTabBarViewIndexObj = [[NSUserDefaults standardUserDefaults] objectForKey:@"MainTabBarViewIndex"];
    if (mainTabBarViewIndexObj) {
        NSInteger index = [(NSNumber*)mainTabBarViewIndexObj integerValue];
        [self setSelectedIndex:index];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MainTabBarViewIndex"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
