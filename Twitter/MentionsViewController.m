//
//  MentionsViewController.m
//  Twitter
//
//  Created by Charlie Hu on 2/28/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "MentionsViewController.h"
#import "TwitterClient.h"
#import "EditTweetViewController.h"
#import "TweetCell.h"
#import "TweetDetailsViewController.h"

@interface MentionsViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


- (IBAction)OnPanGesture:(UIPanGestureRecognizer *)sender;
- (void)onLogout;
- (void)onNew;
- (void)onRefresh;
- (void)onLeftMenu;

@end

@implementation MentionsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
  [self.tableView insertSubview:self.refreshControl atIndex:0];

  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  self.title = @"Mentions";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];

  //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onLeftMenu)];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNew)];

  [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

  self.tableView.estimatedRowHeight = 120;
  self.tableView.rowHeight = UITableViewAutomaticDimension;

  [[TwitterClient sharedInstance] mentionsTimeLineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
    self.tweets = tweets;
    [self.tableView reloadData];
  }];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onLeftMenu {
  [self.delegate mentionsViewController:self shouldShowMenu:YES];
}

- (IBAction)OnPanGesture:(UIPanGestureRecognizer *)sender {
  CGPoint velocity = [sender velocityInView:self.view];
  switch (sender.state) {
    case UIGestureRecognizerStateBegan:
      break;
    case UIGestureRecognizerStateChanged:
      break;
    case UIGestureRecognizerStateEnded:
      if (velocity.x > 0) {
        [self.delegate mentionsViewController:self shouldShowMenu:YES];
      } else {
        [self.delegate mentionsViewController:self shouldShowMenu:NO];
      }

      break;
    default:
      break;
  }
}

- (void)onLogout {
  [User logout];
}

- (void)onNew {
  EditTweetViewController *evc = [[EditTweetViewController alloc] init];
  [self.navigationController pushViewController:evc animated:YES];
}

#pragma mark - Table view methods

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  TweetDetailsViewController *vc = [[TweetDetailsViewController alloc] init];
  [vc setTweet:self.tweets[indexPath.row]];
  [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark - UIRefreshControl

- (void)onRefresh {
  [[TwitterClient sharedInstance] mentionsTimeLineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
    self.tweets = tweets;
    //for (Tweet *tweet in self.tweets) {
    //  NSLog(@"image url: %@", tweet.user.profileImageUrl);
    //}
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
  }];
}

- (void)tweetCell:(TweetCell *)cell replyTo:(NSString *)screenName {
  EditTweetViewController *evc = [[EditTweetViewController alloc] init];
  [evc setText:[NSString stringWithFormat:@"@%@ ", screenName]];
  [self.navigationController pushViewController:evc animated:YES];
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
