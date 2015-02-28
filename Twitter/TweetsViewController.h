//
//  TweetsViewController.h
//  Twitter
//
//  Created by Charlie Hu on 2/18/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TweetsViewController;

@protocol TweetsViewControllerDelegate <NSObject>

- (void)tweetsViewController:(TweetsViewController *)vc shouldShowMenu:(BOOL)shouldShowMenu;

@end

@interface TweetsViewController : UIViewController

@property (nonatomic, weak) id<TweetsViewControllerDelegate> delegate;

@end
