#import "SidebarView.h"

@interface SidebarView ()
@property (nonatomic, strong) UIView *logoView;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) UIView *profileView;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIImageView *avatarImageView;
@end

@implementation SidebarView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupData];
        [self setupUI];
    }
    return self;
}

- (void)setupData {
    self.menuItems = @[
        @{@"icon": @"house.fill", @"title": @"Home"},
        @{@"icon": @"safari.fill", @"title": @"Explore"},
        @{@"icon": @"chart.bar.fill", @"title": @"Analytics"},
        @{@"icon": @"message.fill", @"title": @"Messages"},
        @{@"icon": @"folder.fill", @"title": @"Projects"},
        @{@"icon": @"bookmark.fill", @"title": @"Bookmarks"}
    ];
    self.selectedIndex = 0;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    
    // 创建毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:blurView atIndex:0];
    
    // Logo视图
    self.logoView = [[UIView alloc] init];
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage systemImageNamed:@"applelogo"];
    logoImageView.tintColor = [UIColor whiteColor];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.logoView addSubview:logoImageView];
    [self addSubview:self.logoView];
    
    logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [logoImageView.centerXAnchor constraintEqualToAnchor:self.logoView.centerXAnchor],
        [logoImageView.centerYAnchor constraintEqualToAnchor:self.logoView.centerYAnchor],
        [logoImageView.widthAnchor constraintEqualToConstant:36],
        [logoImageView.heightAnchor constraintEqualToConstant:36]
    ]];
    
    // 菜单表格视图
    self.menuTableView = [[UITableView alloc] init];
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.scrollEnabled = NO;
    [self addSubview:self.menuTableView];
    
    // 注册自定义单元格
    [self.menuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
    
    // 个人资料视图
    self.profileView = [[UIView alloc] init];
    self.profileView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.12];
    self.profileView.layer.cornerRadius = 16;
    self.profileView.layer.borderWidth = 1;
    self.profileView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.08].CGColor;
    [self addSubview:self.profileView];
    
    // 头像 - 使用网络图片
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.avatarImageView.layer.cornerRadius = 22.5;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderWidth = 2;
    self.avatarImageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.profileView addSubview:self.avatarImageView];
    
    // 加载网络头像
    [self loadAvatarImage];
    
    // 用户信息
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"Gandhi";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.profileView addSubview:nameLabel];
    
    UILabel *roleLabel = [[UILabel alloc] init];
    roleLabel.text = @"Designer";
    roleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    roleLabel.font = [UIFont systemFontOfSize:12];
    [self.profileView addSubview:roleLabel];
    
    // 设置约束
    [self setupConstraintsWithAvatar:self.avatarImageView nameLabel:nameLabel roleLabel:roleLabel];
}

- (void)loadAvatarImage {
    NSURL *imageURL = [NSURL URLWithString:@"https://s21.ax1x.com/2025/07/27/pVYitMj.jpg"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error loading avatar image: %@", error);
            // 如果加载失败，使用默认系统图标
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avatarImageView.image = [UIImage systemImageNamed:@"person.circle.fill"];
                self.avatarImageView.tintColor = [UIColor systemGrayColor];
            });
            return;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avatarImageView.image = image;
            });
        } else {
            // 如果图片数据无效，使用默认系统图标
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avatarImageView.image = [UIImage systemImageNamed:@"person.circle.fill"];
                self.avatarImageView.tintColor = [UIColor systemGrayColor];
            });
        }
    }];
    
    [dataTask resume];
}

- (void)setupConstraintsWithAvatar:(UIImageView *)avatar nameLabel:(UILabel *)nameLabel roleLabel:(UILabel *)roleLabel {
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.profileView.translatesAutoresizingMaskIntoConstraints = NO;
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    roleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // Logo约束
        [self.logoView.topAnchor constraintEqualToAnchor:self.topAnchor constant:30],
        [self.logoView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.logoView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.logoView.heightAnchor constraintEqualToConstant:60],
        
        // 菜单表格约束
        [self.menuTableView.topAnchor constraintEqualToAnchor:self.logoView.bottomAnchor constant:20],
        [self.menuTableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15],
        [self.menuTableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-15],
        
        // 个人资料约束
        [self.profileView.topAnchor constraintEqualToAnchor:self.menuTableView.bottomAnchor constant:20],
        [self.profileView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15],
        [self.profileView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-15],
        [self.profileView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-30],
        [self.profileView.heightAnchor constraintEqualToConstant:80],
        
        // 头像约束
        [avatar.leadingAnchor constraintEqualToAnchor:self.profileView.leadingAnchor constant:16],
        [avatar.centerYAnchor constraintEqualToAnchor:self.profileView.centerYAnchor],
        [avatar.widthAnchor constraintEqualToConstant:45],
        [avatar.heightAnchor constraintEqualToConstant:45],
        
        // 用户名约束
        [nameLabel.leadingAnchor constraintEqualToAnchor:avatar.trailingAnchor constant:12],
        [nameLabel.topAnchor constraintEqualToAnchor:self.profileView.topAnchor constant:20],
        
        // 角色约束
        [roleLabel.leadingAnchor constraintEqualToAnchor:nameLabel.leadingAnchor],
        [roleLabel.topAnchor constraintEqualToAnchor:nameLabel.bottomAnchor constant:2]
    ]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 清除之前的子视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSDictionary *menuItem = self.menuItems[indexPath.row];
    
    // 创建图标
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage systemImageNamed:menuItem[@"icon"]];
    iconImageView.tintColor = [UIColor whiteColor];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:iconImageView];
    
    // 创建标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = menuItem[@"title"];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [cell.contentView addSubview:titleLabel];
    
    // 设置约束
    iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [iconImageView.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16],
        [iconImageView.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
        [iconImageView.widthAnchor constraintEqualToConstant:22],
        [iconImageView.heightAnchor constraintEqualToConstant:22],
        
        [titleLabel.leadingAnchor constraintEqualToAnchor:iconImageView.trailingAnchor constant:14],
        [titleLabel.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor]
    ]];
    
    // 设置选中状态
    if (indexPath.row == self.selectedIndex) {
        cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
        cell.layer.cornerRadius = 12;
        cell.layer.masksToBounds = YES;
        
        // 添加左侧指示器
        UIView *indicator = [[UIView alloc] init];
        indicator.backgroundColor = [UIColor systemBlueColor];
        indicator.layer.cornerRadius = 2;
        [cell.contentView addSubview:indicator];
        
        indicator.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [indicator.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:-15],
            [indicator.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
            [indicator.widthAnchor constraintEqualToConstant:4],
            [indicator.heightAnchor constraintEqualToConstant:20]
        ]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
    
    // 添加点击动画
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *iconImageView = [cell.contentView.subviews firstObject];
    
    [UIView animateWithDuration:0.1 animations:^{
        iconImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            iconImageView.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end