//
//  TwitterClient.m
//  Twitter
//
//  Created by Charlie Hu on 2/16/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"6u70Em8zppqsSDPIvUVkIsvvK";
NSString * const kTwitterConsumerSecret = @"FAnHgN3avlgzFQCrs4PP2qpJleEL55JwJg0jFj31VEcuF8Lw5X";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient ()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
  static TwitterClient *instance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (instance == nil) {
      instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
    }
  });

  return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
  self.loginCompletion = completion;

  [self.requestSerializer removeAccessToken];
  [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
    NSLog(@"Got the request token");

    NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];

    [[UIApplication sharedApplication] openURL:authURL];
  } failure:^(NSError *error) {
    NSLog(@"error logging in, %@", error);
    self.loginCompletion(nil, error);
  }];
}

- (void)openURL:(NSURL *)url {
  [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
    NSLog(@"got the access token");

    [self.requestSerializer saveAccessToken:accessToken];

    [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSLog(@"Verify credentials: %@", responseObject);
      User *user = [[User alloc] initWithDictionary:responseObject];
      [User setCurrentUser:user];
      NSLog(@"current user: %@", user.name);
      self.loginCompletion(user, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"error");
      self.loginCompletion(nil, error);
    }];

  } failure:^(NSError *error) {
    NSLog(@"error");
  }];
}

- (void)homeTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
  [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSArray *tweets = [Tweet tweetsWithArray:responseObject];
    completion(tweets, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    completion(nil, error);
  }];
}

- (void)postTweet:(NSDictionary *)params completion:(void (^)(NSError *error))completion {
  [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"%@", responseObject);
    completion(nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    completion(error);
  }];
}

- (void)postReTweet:(NSString *)idString completion:(void (^)(NSError *error))completion {
  [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", idString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"%@", responseObject);
    completion(nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    completion(error);
  }];
}

- (void)favoriteTweet:(NSDictionary *)params completion:(void (^)(NSError *error))completion {
  [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"%@", responseObject);
    completion(nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    completion(error);
  }];
}

- (void)userTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
  [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSArray *tweets = [Tweet tweetsWithArray:responseObject];
    completion(tweets, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    completion(nil, error);
  }];
}

- (void)mentionsTimeLineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
  [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSArray *tweets = [Tweet tweetsWithArray:responseObject];
    completion(tweets, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    completion(nil, error);
  }];
}

@end
