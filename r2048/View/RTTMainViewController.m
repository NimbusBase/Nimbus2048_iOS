//
// Created by Viktor Belenyesi on 29/03/14.
// Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "RTTMainViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import <NimbusBase/NimbusBase.h>

#import "RTTMatrixViewController.h"
#import "NTLSettingsViewController.h"

#import "RTTScoreView.h"
#import "UIColor+RTTFromHex.h"

#import "RTTAppDelegate.h"

#import "NBTScore.h"
#import "NSManagedObjectContext+Lazy.h"
#import "UIAlertView+Lazy.h"
#import "NMBase+NBT.h"

#import "NBTSyncButtonModel.h"
#import "NBTSyncButton.h"

static NSString *const kBestScoreKey = @"RTTBestScore";

@interface RTTMainViewController ()

@property (nonatomic) NSInteger bestScore;

@property (nonatomic, strong) RTTMatrixViewController* matrixViewController;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) RTTScoreView *scoreView;
@property (nonatomic, weak) RTTScoreView *bestView;

@property (nonatomic, weak) UIButton *settingsButton;
@property (nonatomic, weak) NBTSyncButton *syncButton;
@property (nonatomic, weak) UIButton *resetButton;
@property (nonatomic, weak) UIButton *undoButton;

@property (nonatomic, strong) NBTSyncButtonModel *syncButtonModel;

@end

@implementation RTTMainViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
    
    view.backgroundColor = [UIColor fromHex:0xfaf8ef];
    
    RTTMatrixViewController *matrixViewController = self.matrixViewController = [RTTMatrixViewController new];
    [view addSubview:matrixViewController.view];
    RTTAssert(self.matrixViewController.resetGameCommand);
    
    [self loadSubviewsOnSuperview:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Buttons
    
    [self.settingsButton addTarget:self
                            action:@selector(handleSettingsButtonClicked:)
                  forControlEvents:UIControlEventTouchUpInside];

    self.resetButton.rac_command = self.matrixViewController.resetGameCommand;
    
    // Scores
    
    RACSignal* scoreSignal = RACObserve(self.matrixViewController, score);
    RACSignal* bestScoreSignal = RACObserve(self, bestScore);
    
    RAC(self, bestScore) =
    [[[RACSignal combineLatest:@[scoreSignal, bestScoreSignal]
                        reduce:(id (^)()) ^NSNumber*(NSNumber* score, NSNumber* best)
       {
           return @(MAX([score intValue], [best intValue]));
       }] distinctUntilChanged] startWith:@([self savedBestScore])];
    
    [self rac_liftSelector:@selector(saveBestScore:) withSignals:[bestScoreSignal skip:1], nil];
    
    // UI bindings
    
    RAC(self.scoreView, score) = scoreSignal;
    RAC(self.bestView, score) = bestScoreSignal;
    NMBase *base = APP_DELEGATE.persistentStoreCoordinator.nimbusBase;
    self.syncButtonModel = [[NBTSyncButtonModel alloc] initWithSyncButton:self.syncButton base:base];
    
    // Notification
    
    NSNotificationCenter *ntfCntr = [NSNotificationCenter defaultCenter];
    [ntfCntr addObserver:self
                selector:@selector(handleDidMergeCloudChangesNotification:)
                    name:NBTDidMergeCloudChangesNotification
                  object:APP_DELEGATE.managedObjectContext];
}

- (void)dealloc {
    NSNotificationCenter *ntfCntr = [NSNotificationCenter defaultCenter];
    [ntfCntr removeObserver:self
                       name:NBTDidMergeCloudChangesNotification
                     object:APP_DELEGATE.managedObjectContext];
}

#pragma mark - Model

- (void)saveBestScore:(NSInteger)score {
    NSManagedObjectContext *moc = APP_DELEGATE.managedObjectContext;
    [NBTScore deleteAllInMOC:moc];
    NBTScore *newBest = [NBTScore insertNewBestInMOC:moc value:@(score)];
    [moc save];
    NSLog(@"DB: \nRecorded new best score: %@", newBest.value);
}

- (NSInteger)savedBestScore {
    NSManagedObjectContext *moc = APP_DELEGATE.managedObjectContext;
    NBTScore *best = [NBTScore fetchBestInMOC:moc];
    return best.value.integerValue;
}

#pragma mark - Events

- (void)handleSettingsButtonClicked:(UIButton *)button {
    NTLSettingsViewController *viewController = [[NTLSettingsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(handleModelViewControllerCancelButtonClicked:)];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)handleSyncButtonClicked:(UIButton *)button {
    NMBase *base = APP_DELEGATE.persistentStoreCoordinator.nimbusBase;
    [base syncDefaultServer];
}

- (void)handleModelViewControllerCancelButtonClicked:(UIBarButtonItem *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NimbusBase

- (void)handleDidMergeCloudChangesNotification:(NSNotification *)notification {
    NSManagedObjectContext *moc = notification.object;
    [NBTScore deleteAllExceptBestInMOC:moc];
    NBTScore *best = [NBTScore fetchBestInMOC:moc];
    [moc save];
    
    NSInteger bestScore = best.value.integerValue;
    if (best != nil && bestScore > self.bestScore) {
        self.bestScore = bestScore;
    }
}

#pragma mark - UI

- (void)loadSubviewsOnSuperview:(UIView *)superview {
    UIView
    *matrixView = self.matrixViewController.view,
    *titleLabel = [self titleLabel],
    *scoreView = [self scoreView],
    *bestView = [self bestView],
    *settingsButton = [self settingsButton],
    *syncButton = [self syncButton],
    *resetButton = [self resetButton],
    *undoButton = [self undoButton];
    
    for (UIView *view in @[titleLabel, scoreView, bestView, settingsButton, syncButton, resetButton, undoButton]) {
        [superview addSubview:view];
    }
    
    CGFloat
    buttonHeight = kButtonHeight,
    gapV = 10.0f,
    marginH = 0.5 * (CGRectGetWidth(superview.bounds) - CGRectGetWidth(matrixView.frame)),
    gapH = 10.0f;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scoreView.mas_left);
        make.right.equalTo(bestView.mas_right);
        
        make.top.equalTo(superview.mas_top).offset(50.0f);
        make.height.mas_equalTo(buttonHeight);
    }];
    
    [syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(gapH);
        make.width.equalTo(undoButton.mas_width);
        
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.height.equalTo(titleLabel.mas_height);
    }];
    
    [settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(syncButton.mas_right).offset(gapH);
        make.right.equalTo(superview.mas_right).offset(-marginH);
        make.width.equalTo(resetButton.mas_width);

        make.centerY.equalTo(titleLabel.mas_centerY);
        make.height.equalTo(titleLabel.mas_height);
    }];
    
    
    [scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left).offset(marginH);
        
        make.top.equalTo(titleLabel.mas_bottom).offset(gapV);
        make.height.equalTo(titleLabel.mas_height);
    }];
    
    [bestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scoreView.mas_right).offset(gapH);
        make.width.equalTo(scoreView.mas_width);
        
        make.centerY.equalTo(scoreView.mas_centerY);
        make.height.equalTo(scoreView.mas_height);
    }];
    
    [undoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bestView.mas_right).offset(gapH);
        make.width.equalTo(scoreView.mas_width);
        
        make.centerY.equalTo(scoreView.mas_centerY);
        make.height.equalTo(scoreView.mas_height);
    }];
    
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(undoButton.mas_right).offset(gapH);
        make.right.equalTo(superview.mas_right).offset(-marginH);
        make.width.equalTo(scoreView.mas_width);
        
        make.centerY.equalTo(scoreView.mas_centerY);
        make.height.equalTo(scoreView.mas_height);
    }];
    
    matrixView.center = CGPointMake(self.view.center.x, self.view.center.y + 60.0f);
}

- (RTTScoreView *)scoreView {
    if (_scoreView != nil) return _scoreView;
    
    RTTScoreView* scoreView =
    [[RTTScoreView alloc] initWithFrame:CGRectMake(0.0f,
                                                   0.0f,
                                                   30.0f,
                                                   kButtonHeight)
                               andTitle:@"SCORE"];
    scoreView.animateChange = YES;
    
    return _scoreView = scoreView;
}

- (RTTScoreView *)bestView {
    if (_bestView != nil) return _bestView;
    
    RTTScoreView* bestView =
    [[RTTScoreView alloc] initWithFrame:CGRectMake(0.0f,
                                                   0.0f,
                                                   kButtonWidth,
                                                   kButtonHeight)
                               andTitle:@"BEST"];
    
    return _bestView = bestView;
}

- (UIButton *)settingsButton {
    if (_settingsButton != nil) return _settingsButton;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"button_settings"] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor fromHex:0x8f7a66];
    button.showsTouchWhenHighlighted = YES;
    button.layer.cornerRadius = 3.0f;

    return _settingsButton = button;
}

- (UIButton *)resetButton {
    if (_resetButton != nil) return _resetButton;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"button_reset"] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor fromHex:0x8f7a66];
    button.layer.cornerRadius = 3.0f;
    button.showsTouchWhenHighlighted = YES;
    
    return _resetButton = button;
}

- (NBTSyncButton *)syncButton {
    if (_syncButton != nil) return _syncButton;
    
    NBTSyncButton* button = [NBTSyncButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor fromHex:0x8f7a66];
    button.layer.cornerRadius = 3.0f;
    button.showsTouchWhenHighlighted = YES;
    
    return _syncButton = button;
}

- (UILabel *)titleLabel {
    if (_titleLabel != nil) return _titleLabel;
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor fromHex:0x776e65];
    titleLabel.font = [UIFont boldSystemFontOfSize:40.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    titleLabel.text = @"2048";
    
    return _titleLabel = titleLabel;
}

- (UIButton *)undoButton {
    if (_undoButton != nil) return _undoButton;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Undo" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor fromHex:0xf9f6f2] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    button.backgroundColor = [UIColor fromHex:0x8f7a66];
    button.layer.cornerRadius = 3.0f;
    button.showsTouchWhenHighlighted = YES;
    
    button.hidden = YES;
    
    return _undoButton = button;
}

@end
