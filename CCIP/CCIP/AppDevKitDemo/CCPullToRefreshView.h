//
//  CCPullToRefreshView.h
//  CCIP
//
//  Created by Jeff Lin on 8/20/16.
//  Copyright © 2016 CPRTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AppDevKit/UIScrollView+ADKPullToRefreshView.h>

@interface CCPullToRefreshView : UIView <ADKPullToRefreshViewProtocol>

@property (nonatomic, weak) IBOutlet UIImageView *leftAnimationView;
@property (nonatomic, weak) IBOutlet UIImageView *rightAnimationView;
@property (nonatomic, weak) IBOutlet UIImageView *topAnimationView;

@end
