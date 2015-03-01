//
//  ProfileViewController.h
//  Twitter
//
//  Created by Charlie Hu on 2/28/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class ProfileViewController;

@protocol ProfileViewControllerDelegate <NSObject>

- (void)profileViewController:(ProfileViewController *)vc shouldShowMenu:(BOOL)shouldShowMenu;
- (void)profileViewController:(ProfileViewController *)vc shouldShowHomeTimeline:(BOOL)shouldShowHomeTimeline;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic, weak) id<ProfileViewControllerDelegate> delegate;
@property (nonatomic, strong) User *user;

- (void)setUser:(User *)user;

@end
