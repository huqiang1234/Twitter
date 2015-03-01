//
//  LeftViewController.h
//  Twitter
//
//  Created by Charlie Hu on 2/27/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MenuType) {
  MenuTypeProfile = 0,
  MenuTypeHomeTimeline,
  MenuTypeMentions,
  MenuTypeLogout
};

@class LeftViewController;

@protocol LeftViewControllerDelegate <NSObject>

- (void)leftViewController:(LeftViewController *)viewController didSelectMenuType:(MenuType)menuType;

@end

@interface LeftViewController : UIViewController

@property (nonatomic, weak) id<LeftViewControllerDelegate> delegate;

@end
