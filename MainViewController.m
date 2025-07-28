#import "MainViewController.h"
#import "SidebarView.h"
#import "ContentView.h"

@interface MainViewController ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) SidebarView *sidebarView;
@property (nonatomic, strong) ContentView *contentView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    // 设置背景渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:0.165 green:0.165 blue:0.447 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.0 green:0.624 blue:0.992 alpha:1.0].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    // 创建容器视图
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    self.containerView.layer.cornerRadius = 24;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.18].CGColor;
    
    // 添加毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.containerView.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.containerView insertSubview:blurView atIndex:0];
    
    [self.view addSubview:self.containerView];
    
    // 创建侧边栏
    self.sidebarView = [[SidebarView alloc] init];
    [self.containerView addSubview:self.sidebarView];
    
    // 创建内容视图
    self.contentView = [[ContentView alloc] init];
    [self.containerView addSubview:self.contentView];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.sidebarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // 容器视图约束
        [self.containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.containerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.containerView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.9],
        [self.containerView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.85],
        
        // 侧边栏约束
        [self.sidebarView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.sidebarView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [self.sidebarView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor],
        [self.sidebarView.widthAnchor constraintEqualToConstant:280],
        
        // 内容视图约束
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.sidebarView.trailingAnchor],
        [self.contentView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor]
    ]];
}

@end