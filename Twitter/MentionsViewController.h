//
//  MentionsViewController.h
//  Twitter
//
//  Created by Charlie Hu on 2/28/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MentionsViewController;

@protocol MentionsViewControllerDelegate <NSObject>

- (void)mentionsViewController:(MentionsViewController *)vc shouldShowMenu:(BOOL)shouldShowMenu;

@end

@interface MentionsViewController : UIViewController

@property (nonatomic, weak) id<MentionsViewControllerDelegate> delegate;

@end
