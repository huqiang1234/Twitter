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

@interface HamburgerMenuViewController () <TweetsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) UINavigationController *navTweetsViewController;
@property (nonatomic, strong) UINavigationController *navLeftViewController;

@end

@implementation HamburgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  LeftViewController *lvc = [[LeftViewController alloc] init];
  self.navLeftViewController = [[UINavigationController alloc] initWithRootViewController:lvc];


  TweetsViewController *tvc = [[TweetsViewController alloc] init];
  tvc.delegate = self;

  self.navTweetsViewController = [[UINavigationController alloc] initWithRootViewController:tvc];
  self.navTweetsViewController.view.frame = self.contentView.frame;
  [self.contentView addSubview:self.navTweetsViewController.view];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tweets View delegate

- (void)tweetsViewController:(TweetsViewController *)vc shouldShowMenu:(BOOL)shouldShowMenu {
  if (shouldShowMenu) {
    self.navLeftViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width - 100, self.view.frame.size.height);;
    [self.contentView addSubview:self.navLeftViewController.view];
    [self.contentView sendSubviewToBack:self.navLeftViewController.view];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
      self.navTweetsViewController.view.frame = CGRectMake(self.contentView.frame.size.width - 100, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:nil];
  } else {
    //self.tweetsViewController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.navTweetsViewController.view];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
      self.navTweetsViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:nil];
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
