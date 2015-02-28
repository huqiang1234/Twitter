//
//  ProfileCell.m
//  Twitter
//
//  Created by Charlie Hu on 2/27/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "ProfileCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;


@end

@implementation ProfileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
  [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
  self.nameLabel.text = user.name;
  self.taglineLabel.text = user.tagline;
}

@end
