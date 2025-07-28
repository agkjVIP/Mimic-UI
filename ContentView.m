#import "ContentView.h"

@interface ContentView ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UICollectionView *cardCollectionView;
@property (nonatomic, strong) NSArray *cardData;
@end

@implementation ContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupData];
        [self setupUI];
    }
    return self;
}

- (void)setupData {
    self.cardData = @[
        @{@"icon": @"checkmark.circle.fill", @"number": @"12", @"title": @"Completed Tasks"},
        @{@"icon": @"clock.fill", @"number": @"5", @"title": @"Pending Tasks"},
        @{@"icon": @"person.3.fill", @"number": @"7", @"title": @"Active Projects"}
    ];
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 头部视图
    self.headerView = [[UIView alloc] init];
    [self addSubview:self.headerView];
    
    UILabel *welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.text = @"Welcome Back, Gandhi";
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightSemibold];
    [self.headerView addSubview:welcomeLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"Check out your project statistics for today";
    subtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    subtitleLabel.font = [UIFont systemFontOfSize:16];
    [self.headerView addSubview:subtitleLabel];
    
    // 卡片集合视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 24;
    layout.minimumLineSpacing = 24;
    layout.itemSize = CGSizeMake(240, 100);
    
    self.cardCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.cardCollectionView.backgroundColor = [UIColor clearColor];
    self.cardCollectionView.delegate = self;
    self.cardCollectionView.dataSource = self;
    self.cardCollectionView.scrollEnabled = NO;
    [self addSubview:self.cardCollectionView];
    
    // 注册自定义单元格
    [self.cardCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CardCell"];
    
    // 设置约束
    [self setupConstraintsWithWelcomeLabel:welcomeLabel subtitleLabel:subtitleLabel];
}

- (void)setupConstraintsWithWelcomeLabel:(UILabel *)welcomeLabel subtitleLabel:(UILabel *)subtitleLabel {
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // 头部视图约束
        [self.headerView.topAnchor constraintEqualToAnchor:self.topAnchor constant:40],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:40],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-40],
        [self.headerView.heightAnchor constraintEqualToConstant:80],
        
        // 欢迎标签约束
        [welcomeLabel.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [welcomeLabel.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [welcomeLabel.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        
        // 副标题约束
        [subtitleLabel.topAnchor constraintEqualToAnchor:welcomeLabel.bottomAnchor constant:8],
        [subtitleLabel.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [subtitleLabel.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        
        // 卡片集合视图约束
        [self.cardCollectionView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor constant:30],
        [self.cardCollectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:40],
        [self.cardCollectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-40],
        [self.cardCollectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-40]
    ]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cardData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    
    // 清除之前的子视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSDictionary *cardInfo = self.cardData[indexPath.item];
    
    // 设置卡片背景
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    cell.layer.cornerRadius = 20;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    
    // 添加毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = cell.contentView.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurView.layer.cornerRadius = 20;
    blurView.layer.masksToBounds = YES;
    [cell.contentView insertSubview:blurView atIndex:0];
    
    // 图标容器
    UIView *iconContainer = [[UIView alloc] init];
    iconContainer.backgroundColor = [UIColor systemBlueColor];
    iconContainer.layer.cornerRadius = 14;
    [cell.contentView addSubview:iconContainer];
    
    // 图标
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage systemImageNamed:cardInfo[@"icon"]];
    iconImageView.tintColor = [UIColor whiteColor];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [iconContainer addSubview:iconImageView];
    
    // 数字标签
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.text = cardInfo[@"number"];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    [cell.contentView addSubview:numberLabel];
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = cardInfo[@"title"];
    titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:titleLabel];
    
    // 设置约束
    iconContainer.translatesAutoresizingMaskIntoConstraints = NO;
    iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // 图标容器约束
        [iconContainer.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:24],
        [iconContainer.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
        [iconContainer.widthAnchor constraintEqualToConstant:50],
        [iconContainer.heightAnchor constraintEqualToConstant:50],
        
        // 图标约束
        [iconImageView.centerXAnchor constraintEqualToAnchor:iconContainer.centerXAnchor],
        [iconImageView.centerYAnchor constraintEqualToAnchor:iconContainer.centerYAnchor],
        [iconImageView.widthAnchor constraintEqualToConstant:22],
        [iconImageView.heightAnchor constraintEqualToConstant:22],
        
        // 数字标签约束
        [numberLabel.leadingAnchor constraintEqualToAnchor:iconContainer.trailingAnchor constant:16],
        [numberLabel.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:24],
        
        // 标题标签约束
        [titleLabel.leadingAnchor constraintEqualToAnchor:numberLabel.leadingAnchor],
        [titleLabel.topAnchor constraintEqualToAnchor:numberLabel.bottomAnchor constant:4]
    ]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    // 添加点击动画
    [UIView animateWithDuration:0.3 animations:^{
        cell.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end