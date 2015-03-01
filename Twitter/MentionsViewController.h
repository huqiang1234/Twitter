//
//  MentionsViewController.h
//  Twitter
//
//  Created by Charlie Hu on 2/28/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class MentionsViewController;

@protocol MentionsViewControllerDelegate <NSObject>

- (void)mentionsViewController:(MentionsViewController *)vc shouldShowMenu:(BOOL)shouldShowMenu;
- (void)mentionsViewController:(MentionsViewController *)vc showProfileWithUser:(User *)user;

@end

@interface MentionsViewController : UIViewController

@property (nonatomic, weak) id<MentionsViewControllerDelegate> delegate;

@end
