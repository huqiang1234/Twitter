//
//  ProfileViewController.m
//  Twitter
//
//  Created by Charlie Hu on 2/28/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "EditTweetViewController.h"
#import "TwitterClient.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileBannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;
@property (weak, nonatomic) IBOutlet UILabel *numTweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *tweets;

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  [self.profileBannerImageView setImageWithURL:[NSURL URLWithString:self.user.profileBannerUrl]]; //]user.profileBannerUrl]];
  [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
  self.nameLabel.text = self.user.name;
  self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
  self.taglineLabel.text = self.user.tagline;
  self.numTweetLabel.text = [NSString stringWithFormat:@"%ld Tweets", (long)self.user.numTweet];
  self.numTweetLabel.text = [NSString stringWithFormat:@"%ld Following", (long)self.user.numFollowing];
  self.numTweetLabel.text = [NSString stringWithFormat:@"%ld Followers", (long)self.user.numFOllower];

  [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

  self.tableView.estimatedRowHeight = 120;
  self.tableView.rowHeight = UITableViewAutomaticDimension;

  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.user.screenname, @"screen_name", nil];

  [[TwitterClient sharedInstance] userTimeLineWithParams:params completion:^(NSArray *tweets, NSError *error) {
    self.tweets = tweets;
    [self.tableView reloadData];
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
  //TweetCell *cell = [[TweetCell alloc] init];
  cell.delegate = self;

  Tweet *tweet = self.tweets[indexPath.row];
  // NSLog(@"%@", tweet);
  [cell setTweet:tweet];

  return cell;
}

#pragma mark - Tweet cell delegate methods

- (void)tweetCell:(TweetCell *)cell replyTo:(NSString *)screenName {
  EditTweetViewController *evc = [[EditTweetViewController alloc] init];
  [evc setText:[NSString stringWithFormat:@"@%@ ", screenName]];
  [self.navigationController pushViewController:evc animated:YES];
}

- (void)tweetCell:(TweetCell *)cell showProfileWithUser:(User *)user {
  [self.delegate profileViewController:self showProfileWithUser:user];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
  CGPoint velocity = [sender velocityInView:self.view];
  switch (sender.state) {
    case UIGestureRecognizerStateBegan:
      break;
    case UIGestureRecognizerStateChanged:
      break;
    case UIGestureRecognizerStateEnded:
      if (velocity.x > 0) {
        [self.delegate profileViewController:self shouldShowMenu:YES];
      } else {
        [self.delegate profileViewController:self shouldShowMenu:NO];
      }

      break;
    default:
      break;
  }
}

@end
