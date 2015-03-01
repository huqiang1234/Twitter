//
//  Tweet.m
//  Twitter
//
//  Created by Charlie Hu on 2/16/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [super init];
  if (self) {
    //NSLog(@"tweet: %@", dictionary);

    id retweetedTweet = dictionary[@"retweeted_status"];
    if (retweetedTweet != nil) {
      self.isRetweet = YES;
      User *user = [[User alloc] initWithDictionary:dictionary[@"user"]];
      self.retweetUserName = user.name;
      dictionary = retweetedTweet;
    } else {
      self.isRetweet = NO;
    }

    self.text = dictionary[@"text"];
    [self.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];

    NSString *createdAtString = dictionary[@"created_at"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";

    self.createdAt = [formatter dateFromString:createdAtString];
    self.idString = dictionary[@"id_str"];

    self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
    self.retweetCount = [dictionary[@"retweet_count"] integerValue];

    self.retweeted = [dictionary[@"retweeted"] boolValue];
    self.favorited = [dictionary[@"favorited"] boolValue];
  }

  return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
  NSMutableArray *tweets = [NSMutableArray array];

  for (NSDictionary *dictionary in array) {
    [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
  }

  return tweets;
}

@end
