//
//  TweetCell.m
//  Twitter
//
//  Created by Charlie Hu on 2/20/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "EditTweetViewController.h"
#import "TwitterClient.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinceWhenLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topRetweetImageView;
@property (weak, nonatomic) IBOutlet UILabel *topRetweetUserLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewToRetweetIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetToTopContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetToNameContraint;


@property (nonatomic, strong) NSString *userScreenName;
@property (nonatomic, strong) NSString *idString;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *countFavoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *countRetweetLabel;
@property (nonatomic, assign) NSInteger retweetedCount;
@property (nonatomic, assign) NSInteger favoritedCount;

@property (nonatomic, strong) User *user;

- (void)updateElementConstaint:(id)view attribute:(NSLayoutAttribute)attribute relatedBy:(NSLayoutRelation)relatedBy constant:(CGFloat)constant;
- (void)setRetweet:(BOOL)isRetweet username:(NSString *)username;

- (void)setRetweeted:(BOOL)retweeted;
- (void)setFavorited:(BOOL)favorited;
- (void)updateRetweetCount:(BOOL)retweeted;
- (void)updateFavoriteCount:(BOOL)favorited;


-(void)updateDurationLabel:(NSDate *)date;

- (void)handleTapGesture:(UITapGestureRecognizer *)sender;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
  self.profileImageView.layer.cornerRadius = 3;
  self.profileImageView.clipsToBounds = YES;

  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
  tapGesture.numberOfTapsRequired = 1;
  [self.profileImageView addGestureRecognizer:tapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
  [self setRetweet:tweet.isRetweet username:tweet.retweetUserName];
  [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
  self.nameLabel.text = tweet.user.name;
  self.userScreenName = tweet.user.screenname;
  self.idString = tweet.idString;
  self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.userScreenName];

  self.tweetTextLabel.text = tweet.text;
  [self updateDurationLabel:tweet.createdAt];

  [self setRetweeted:tweet.retweeted];
  [self setFavorited:tweet.favorited];
  self.retweetedCount = tweet.retweetCount;
  self.favoritedCount = tweet.favoriteCount;
  self.countRetweetLabel.text = [NSString stringWithFormat:@"%ld", (long)self.retweetedCount];
  self.countFavoriteLabel.text = [NSString stringWithFormat:@"%ld", (long)self.favoritedCount];

  self.user = tweet.user;
}

- (void)updateElementConstaint:(id)view attribute:(NSLayoutAttribute)attribute relatedBy:(NSLayoutRelation)relatedBy constant:(CGFloat)constant {
  [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:relatedBy toItem:self attribute:attribute multiplier:1 constant:constant]];
}

- (void)setRetweet:(BOOL)isRetweet username:(NSString *)username {
  if (isRetweet == NO) {
    [self removeConstraint:self.imageViewToRetweetIconConstraint];
    [self removeConstraint:self.retweetToTopContraint];
    [self removeConstraint:self.retweetToNameContraint];
    self.topRetweetImageView.hidden = YES;
    self.topRetweetUserLabel.hidden = YES;
    [self updateElementConstaint:self.profileImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual constant:12];
    [self updateElementConstaint:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual constant:10];
  } else {
    self.topRetweetImageView.hidden = NO;
    self.topRetweetUserLabel.hidden = NO;
    self.topRetweetUserLabel.text = [NSString stringWithFormat:@"%@ retweeted", username];
  }
}

-(void)updateDurationLabel:(NSDate *)date {
  //Which calendar
  NSString *durationString;
  NSCalendar *calendar = [NSCalendar currentCalendar];

  //Gets the componentized interval from the most recent time an activity was tapped until now

  NSDateComponents *components= [calendar components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date toDate:[NSDate date] options:0];
  NSInteger days = [components day];
  NSInteger hours = [components hour];
  NSInteger minutes = [components minute];
  NSInteger seconds =[components second];

  // Converts the components to a string and displays it in the duration label, updated via the timer

  if (days > 0) {
    durationString = [NSString stringWithFormat:@"%ldd", (long)days];
  } else if (hours > 0) {
    durationString = [NSString stringWithFormat:@"%ldh", (long)hours];
  } else if (minutes > 0) {
    durationString = [NSString stringWithFormat:@"%ldm", (long)minutes];
  } else if (seconds > 0) {
    durationString = [NSString stringWithFormat:@"%lds", (long)seconds];
  }

  self.sinceWhenLabel.text = durationString;
}

- (IBAction)onReply:(id)sender {
  [self.delegate tweetCell:self replyTo:self.userScreenName];
}

- (IBAction)onRetweet:(id)sender {
  [[TwitterClient sharedInstance] postReTweet:self.idString completion:^(NSError *error) {
    if (error == nil) {
      NSLog(@"Retweeted, %@", self.idString);
    } else {
      NSLog(@"error posting tweet, %@", error);
    }
  }];
  [self setRetweeted:YES];
  [self updateRetweetCount:YES];
}

- (IBAction)onFavorite:(id)sender {
  NSDictionary *params = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:self.idString, nil] forKeys:[NSArray arrayWithObjects:@"id", nil]];
  [[TwitterClient sharedInstance] favoriteTweet:params completion:^(NSError *error) {
    if (error == nil) {
      NSLog(@"Favorited tweet, %@", self.idString);
    } else {
      NSLog(@"error posting tweet, %@", error);
    }
  }];
  [self setFavorited:YES];
  [self updateFavoriteCount:YES];
}

- (void)setRetweeted:(BOOL)retweeted {
  if (retweeted) {
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on.png"] forState:UIControlStateNormal];
  } else {
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
  }
}

- (void)setFavorited:(BOOL)favorited {
  if (favorited) {
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on.png"] forState:UIControlStateNormal];
  } else {
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
  }
}

- (void)updateRetweetCount:(BOOL)retweeted {
  if (retweeted) {
    self.retweetedCount += 1;
  } else {
    self.retweetedCount -= 1;
  }
  self.countRetweetLabel.text = [NSString stringWithFormat:@"%ld", (long)self.retweetedCount];
}

- (void)updateFavoriteCount:(BOOL)favorited {
  if (favorited) {
    self.favoritedCount += 1;
  } else {
    self.favoritedCount -= 1;
  }
  self.countFavoriteLabel.text = [NSString stringWithFormat:@"%ld", (long)self.favoritedCount];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    NSLog(@"Profile Image tapped");
    [self.delegate tweetCell:self showProfileWithUser:self.user];
}

@end
