//
//  LeftViewController.m
//  Twitter
//
//  Created by Charlie Hu on 2/27/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "LeftViewController.h"
#import "ProfileCell.h"
#import "MenuItemCell.h"
#import "User.h"

typedef NS_ENUM(NSInteger, SectionType) {
  SectionTypeProfile = 0,
  SectionTypeMenu
};

typedef NS_ENUM(NSInteger, MenuType) {
  MenuTypeHomeTimeline = 0,
  MenuTypeMentions,
  MenuTypeLogout
};

@interface LeftViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuTitles;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  [self.tableView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellReuseIdentifier:@"MenuItemCell"];

  [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];

  [self initMenuTitles];

  self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == SectionTypeProfile) {
    return 1;
  } else {
    return self.menuTitles.count;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == SectionTypeProfile) {
    ProfileCell *pCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    [pCell setUser:[User currentUser]];

    return pCell;
  } else {
    NSLog(@"%ld, %ld", indexPath.section, indexPath.row);
    MenuItemCell *mCell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell"];
    mCell.menuItemLabel.text = self.menuTitles[indexPath.row];
    return mCell;
  }
}

- (void)initMenuTitles {
  self.menuTitles = @[
                      @"Home Timeline",
                      @"Mentions",
                      @"Logout"
                      ];
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
