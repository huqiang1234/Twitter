//
//  TwitterClient.m
//  Twitter
//
//  Created by Charlie Hu on 2/16/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "TwitterClient.h"

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
    NSLog(@"error");
    self.loginCompletion(nil, error);
  }];
}

- (void)openURL:(NSURL *)url {
  [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
    NSLog(@"got the access token");

    [self.requestSerializer saveAccessToken:accessToken];

    [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      User *user = [[User alloc] initWithDictionary:responseObject];
      NSLog(@"current user: %@", user.name);
      self.loginCompletion(user, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"error");
    }];

  } failure:^(NSError *error) {
    NSLog(@"error");
  }];
}

@end