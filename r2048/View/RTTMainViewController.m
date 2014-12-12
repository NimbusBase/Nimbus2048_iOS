//
// Created by Viktor Belenyesi on 29/03/14.
// Copyright (c) 2014 Viktor Belenyesi. All rights reserved.
//

#import "RTTMainViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NimbusBase/NimbusBase.h"

#import "RTTMatrixViewController.h"
#import "NTLSettingsViewController.h"

#import "RTTScoreView.h"
#import "UIColor+RTTFromHex.h"

#import "RTTAppDelegate.h"

#import "NBTScore.h"
#import "NSManagedObjectContext+Lazy.h"
#import "UIAlertView+Lazy.h"

static NSString *const kBestScoreKey = @"RTTBestScore";

@interface RTTMainViewController () <UIAlertViewDelegate>

@property (nonatomic) NSInteger bestScore;

@property (nonatomic, weak) UIAlertView *alertRefClouds;
@property (nonatomic, weak) UIAlertView *alertRefSettings;
@property (nonatomic, weak) UIAlertView *alertRefSyncError;

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
    [ntfCntr addObserver:self
                selector:@selector(handleDefaultServerDidChangeNotification:)
                    name:NMBNotiDefaultServerDidChange
                  object:APP_DELEGATE.persistentStoreCoordinator.nimbusBase];
    [ntfCntr addObserver:self
                selector:@selector(handleNMBServerSyncDidFail:)
                    name:NMBNotiSyncDidFail
                  object:nil];
    [ntfCntr addObserver:self
                selector:@selector(handleNMBServerSyncDidSuccess:)
                    name:NMBNotiSyncDidSucceed
                  object:nil];
}

- (void)dealloc {
    NSNotificationCenter *ntfCntr = [NSNotificationCenter defaultCenter];
    [ntfCntr removeObserver:self
                       name:NBTDidMergeCloudChangesNotification
                     object:APP_DELEGATE.managedObjectContext];
    [ntfCntr removeObserver:self
                       name:NMBNotiDefaultServerDidChange
                     object:APP_DELEGATE.persistentStoreCoordinator.nimbusBase];
    [ntfCntr removeObserver:self
                       name:NMBNotiSyncDidFail
                     object:nil];
    [ntfCntr removeObserver:self
                       name:NMBNotiSyncDidSucceed
                     object:nil];
}

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

- (void)handleSettingsButtonLongPressed:(UILongPressGestureRecognizer *)button {
    if (button.state == UIGestureRecognizerStateBegan) {
        NMBase *base = APP_DELEGATE.persistentStoreCoordinator.nimbusBase;
        NMBServer *server = base.defaultServer;
        if (server != nil) {
            NMBPromise *promise = [server synchronize];
            [promise success:^(NMBPromise *promise, id response) {
                
            }];
        }
    }
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

- (void)handleDefaultServerDidChangeNotification:(NSNotification *)notification {
    //light it on
}

- (void)handleNMBServerSyncDidSuccess:(NSNotification *)notification {
    //Stop rotate
}

- (void)handleNMBServerSyncDidFail:(NSNotification *)notification {
    NMBase *base = APP_DELEGATE.persistentStoreCoordinator.nimbusBase;
    if (notification.object != base) return;
    
    NSError *error = notification.userInfo[NKeyNotiError];
    
    UIAlertView *alertView = [UIAlertView alertError:error];
    [alertView show];
    
    self.alertRefSyncError = alertView;
}

#pragma mark - UI

+ (UIAlertView *)alertViewWithServers:(NSArray *)servers delegate:(id<UIAlertViewDelegate>)delegate {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.title = @"Clouds";
    alertView.message = @"Select a cloud you'd like your data to be synced to.";
    alertView.delegate = delegate;
    
    NSUInteger count = servers.count;
    for (int index = 0; index <= count; index ++) {
        if (index < count) {
            NMBServer *server = servers[index];
            [alertView addButtonWithTitle:server.cloud];
        }
        else {
            [alertView addButtonWithTitle:@"Cancel"];
            alertView.cancelButtonIndex = index;
        }
    }
    
    return alertView;
}

+ (UIAlertView *)alertViewForSettingsServer:(NMBServer *)server delegate:(id<UIAlertViewDelegate>)delegate {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.title = @"Settings";
    alertView.delegate = delegate;
    
    [alertView addButtonWithTitle:[NSString stringWithFormat:@"Sign out %@", server.cloud]];
    
    [alertView addButtonWithTitle:@"Cancel"];
    alertView.cancelButtonIndex = 1;
    
    return alertView;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NMBase *base = APP_DELEGATE.persistentStoreCoordinator.nimbusBase;
    
    if (self.alertRefClouds == alertView) {
        NSArray *servers = base.servers;
        BOOL notCanceled = buttonIndex < servers.count;
        if (notCanceled) {
            NMBServer *server = servers[buttonIndex];
            [server authorizeWithController:self];
        }
    }
    else if (self.alertRefSettings == alertView) {
        switch (buttonIndex) {
            case 0:
                [base.defaultServer signOut];
                break;
            default:
                break;
        }
    }
    
    self.alertRefClouds = nil;
    self.alertRefSettings = nil;
    self.alertRefSyncError = nil;
}

@end
