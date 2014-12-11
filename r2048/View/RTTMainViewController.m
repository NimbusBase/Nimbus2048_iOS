//
// Created by Viktor Belenyesi on 29/03/14.
// Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "RTTMainViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RTTMatrixViewController.h"
#import "RTTScoreView.h"
#import "UIColor+RTTFromHex.h"

#import "RTTAppDelegate.h"

#import "NBTScore.h"
#import "NSManagedObjectContext+Lazy.h"

static NSString *const kBestScoreKey = @"RTTBestScore";

@interface RTTMainViewController ()
@property (nonatomic) NSInteger bestScore;
@end

@implementation RTTMainViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor fromHex:0xfaf8ef];
    
    RTTMatrixViewController* matrixViewController = [RTTMatrixViewController new];
    matrixViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y + 60.0f);
    [self.view addSubview:matrixViewController.view];
    
    RTTAssert(matrixViewController.resetGameCommand);
    
    float buttonY = CGRectGetMinY(matrixViewController.view.frame) - kButtonHeight - 20.0f;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.view.bounds.size.width, 80.0f)];
    titleLabel.textColor = [UIColor fromHex:0x776e65];
    titleLabel.font = [UIFont boldSystemFontOfSize:40.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    titleLabel.text = @"Reactive2048";
    [self.view addSubview:titleLabel];
    
    RTTScoreView* scoreView = [[RTTScoreView alloc] initWithFrame:CGRectMake(CGRectGetMinX(matrixViewController.view.frame),
                                                                             buttonY,
                                                                             kButtonWidth,
                                                                             kButtonHeight)
                                                         andTitle:@"SCORE"];
    scoreView.animateChange = YES;
    [self.view addSubview:scoreView];
    
    RTTScoreView* bestView = [[RTTScoreView alloc] initWithFrame:CGRectMake(CGRectGetMidX(matrixViewController.view.frame) - kButtonWidth * 0.5f,
                                                                            buttonY,
                                                                            kButtonWidth,
                                                                            kButtonHeight)
                                                        andTitle:@"BEST"];
    [self.view addSubview:bestView];
    
    UIButton* resetGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetGameButton setTitle:@"New Game" forState:UIControlStateNormal];
    [resetGameButton setTitleColor:[UIColor fromHex:0xf9f6f2] forState:UIControlStateNormal];
    resetGameButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    resetGameButton.backgroundColor = [UIColor fromHex:0x8f7a66];
    resetGameButton.frame = CGRectMake(CGRectGetMaxX(matrixViewController.view.frame) - kButtonWidth,
                                       buttonY,
                                       kButtonWidth,
                                       kButtonHeight);
    resetGameButton.layer.cornerRadius = 3.0f;
    resetGameButton.rac_command = matrixViewController.resetGameCommand;
    resetGameButton.showsTouchWhenHighlighted = YES;
    [self.view addSubview:resetGameButton];
    
    UIButton* settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    [settingsButton setTitleColor:[UIColor fromHex:0xf9f6f2] forState:UIControlStateNormal];
    settingsButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    settingsButton.backgroundColor = [UIColor fromHex:0x8f7a66];
    settingsButton.showsTouchWhenHighlighted = YES;
    settingsButton.layer.cornerRadius = 3.0f;
    settingsButton.frame = CGRectMake(CGRectGetMaxX(matrixViewController.view.frame) - kButtonWidth,
                                       buttonY - 50,
                                       kButtonWidth,
                                       kButtonHeight);
    [self.view addSubview:settingsButton];
    [settingsButton addTarget:self action:@selector(handleSettingsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleSettingsButtonLongPressed:)];
    [settingsButton addGestureRecognizer:longPress];
    
    // Scores
    
    RACSignal* scoreSignal = RACObserve(matrixViewController, score);
    RACSignal* bestScoreSignal = RACObserve(self, bestScore);
    
    RAC(self, bestScore) =
    [[[RACSignal combineLatest:@[scoreSignal, bestScoreSignal]
                        reduce:(id (^)()) ^NSNumber*(NSNumber* score, NSNumber* best)
       {
           return @(MAX([score intValue], [best intValue]));
       }] distinctUntilChanged] startWith:@([self savedBestScore])];
    
    [self rac_liftSelector:@selector(saveBestScore:) withSignals:[bestScoreSignal skip:1], nil];
    
    // UI bindings
    RAC(scoreView, score) = scoreSignal;
    RAC(bestView, score) = bestScoreSignal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)saveBestScore:(NSInteger)score {
    NSManagedObjectContext *moc = APP_DELEGATE.managedObjectContext;
    NBTScore *newBest = [NBTScore insertNewBestInMOC:moc value:@(score)];
    [moc save];
    NSLog(@"DB: \nRecorded new best score: %@", newBest.value);
}

- (NSInteger)savedBestScore {
    NSManagedObjectContext *moc = APP_DELEGATE.managedObjectContext;
    NBTScore *best = [NBTScore fetchBestInMOC:moc];
    return best.value.integerValue;
}

- (void)handleDidMergeCloudChangesNotification:(NSNotification *)notification {
    NSManagedObjectContext *moc = notification.object;
    [NBTScore deleteAllExceptBestInMOC:moc];
    NBTScore *best = [NBTScore fetchBestInMOC:moc];
    NSInteger bestScore = best.value.integerValue;
    if (bestScore != self.bestScore) {
        self.bestScore = bestScore;
    }
}

- (void)handleSettingsButtonClicked:(UIButton *)button {
    
}

- (void)handleSettingsButtonLongPressed:(UILongPressGestureRecognizer *)button {
    
}

@end
