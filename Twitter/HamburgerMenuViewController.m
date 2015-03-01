//
//  HamburgerMenuViewController.m
//  Twitter
//
//  Created by Charlie Hu on 2/27/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "HamburgerMenuViewController.h"
#import "TweetsViewController.h"
#import "LeftViewController.h"
#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "MentionsViewController.h"

@interface HamburgerMenuViewController () <TweetsViewControllerDelegate, LeftViewControllerDelegate, ProfileViewControllerDelegate, MentionsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) UINavigationController *navTweetsViewController;
@property (nonatomic, strong) UINavigationController *navLeftViewController;
@property (nonatomic, strong) UINavigationController *navProfileViewController;
@property (nonatomic, strong) UINavigationController *navMentionsViewController;
@property (nonatomic, strong) UINavigationController *currentChildViewController;

- (void)showMenuForCurrentViewController:(UIViewController *)vc;
- (void)resumeCurrentViewController:(UIViewController *)vc;

- (void)hideChildViewController:(UIViewController *)vc;
- (void)showChildViewController:(UIViewController *)vc;

@end

@implementation HamburgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  LeftViewController *lvc = [[LeftViewController alloc] init];
  lvc.delegate = self;
  self.navLeftViewController = [[UINavigationController alloc] initWithRootViewController:lvc];

  TweetsViewController *tvc = [[TweetsViewController alloc] init];
  tvc.delegate = self;

  self.navTweetsViewController = [[UINavigationController alloc] initWithRootViewController:tvc];
  self.navTweetsViewController.view.frame = self.contentView.frame;
  [self addChildViewController:self.navLeftViewController];
  [self.contentView addSubview:self.navTweetsViewController.view];
  [self.navTweetsViewController didMoveToParentViewController:self];

  self.currentChildViewController = self.navTweetsViewController;

  ProfileViewController *pvc = [[ProfileViewController alloc] init];
  pvc.delegate = self;
  pvc.user = [User currentUser];
  self.navProfileViewController = [[UINavigationController alloc] initWithRootViewController:pvc];

  MentionsViewController *mvc = [[MentionsViewController alloc] init];
  mvc.delegate = self;
  self.navMentionsViewController = [[UINavigationController alloc] initWithRootViewController:mvc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper methods

- (void)showMenuForCurrentViewController:(UIViewController *)vc {
  [self addChildViewController:self.navLeftViewController];
  self.navLeftViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width - 100, self.view.frame.size.height);;
  [self.contentView addSubview:self.navLeftViewController.view];
  [self.navLeftViewController didMoveToParentViewController:self];

  [self.contentView sendSubviewToBack:self.navLeftViewController.view];
  [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    vc.view.frame = CGRectMake(self.contentView.frame.size.width - 100, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
  } completion:nil];
}

- (void)resumeCurrentViewController:(UIViewController *)vc {
  [self.contentView addSubview:vc.view];
  [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    vc.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
  } completion:nil];
}

- (void)hideChildViewController:(UIViewController *)vc {
  [vc willMoveToParentViewController:nil];
  [vc.view removeFromSuperview];
  [vc removeFromParentViewController];
}

- (void)showChildViewController:(UIViewController *)vc {
  [self addChildViewController:vc];
  [self.contentView addSubview:vc.view];

  [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
    vc.view.frame = self.contentView.frame;
  } completion:nil];

  [vc didMoveToParentViewController:self];
}

#pragma mark - Tweets View delegate

- (void)tweetsViewController:(TweetsViewController *)vc shouldShowMenu:(BOOL)shouldShowMenu {
  if (shouldShowMenu) {
    [self showMenuForCurrentViewController:self.navTweetsViewController];
  } else {
    [self resumeCurrentViewController:self.navTweetsViewController];
  }
}

#pragma mark - Mentions View delegate

- (void)mentionsViewController:(MentionsViewController *)vc shouldShowMenu:(BOOL)shouldShowMenu {
  if (shouldShowMenu) {
    [self showMenuForCurrentViewController:self.navMentionsViewController];
  } else {
    [self resumeCurrentViewController:self.navMentionsViewController];
  }
}

#pragma mark - Profile View delegate

- (void)profileViewController:(ProfileViewController *)vc shouldShowMenu:(BOOL)shouldShowMenu {
  if (shouldShowMenu) {
    [self showMenuForCurrentViewController:self.navProfileViewController];
  } else {
    [self resumeCurrentViewController:self.navProfileViewController];
  }
}

- (void)profileViewController:(ProfileViewController *)vc shouldShowHomeTimeline:(BOOL)shouldShowHomeTimeline {
  if (shouldShowHomeTimeline) {
    [self hideChildViewController:self.navProfileViewController];
    [self showChildViewController:self.navTweetsViewController];
    self.currentChildViewController = self.navTweetsViewController;
  }
}

#pragma mark - Left menu methods

- (void)leftViewController:(LeftViewController *)viewController didSelectMenuType:(MenuType)menuType {
  if (menuType == MenuTypeHomeTimeline) {
    [self hideChildViewController:self.currentChildViewController];
    [self showChildViewController:self.navTweetsViewController];
    self.currentChildViewController = self.navTweetsViewController;
  } else if (menuType == MenuTypeProfile) {
    [self hideChildViewController:self.currentChildViewController];
    [self showChildViewController:self.navProfileViewController];
    self.currentChildViewController = self.navProfileViewController;
  } else if (menuType == MenuTypeMentions) {
    [self hideChildViewController:self.currentChildViewController];
    [self showChildViewController:self.navMentionsViewController];
    self.currentChildViewController = self.navMentionsViewController;
  } else if (menuType == MenuTypeLogout) {
    [User logout];
  }
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
