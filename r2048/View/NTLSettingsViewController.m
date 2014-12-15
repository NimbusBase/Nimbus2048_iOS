//
//  NTLSettingsViewController.m
//  NimbusTodoList
//
//  Created by William Remaerd on 5/26/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import "NTLSettingsViewController.h"
#import "RTTAppDelegate.h"

#import "NTLSettingsSwitchCell.h"
#import "NTLServerCell.h"
#import "NTLSettingsCell.h"

#import "NSUserDefaults+NBT.h"
#import "NMBase+NBT.h"

#import <NimbusBase/NimbusBase.h>
#import <Masonry/Masonry.h>

static NSString
*const kReuseCellIDServer = @"S",
*const kReuseCellIDAutoAync = @"A";


@interface NTLSettingsViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, readonly) NMBase *base;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation NTLSettingsViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.title = NSLocalizedString(@"Settings", @"Settings");
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Subviews
    
    UIView *superview = self.view;
    
    UITableView *tableView = self.tableView = [self loadTableViewOnSuperview:superview];

    [self loadConstraintsOnSuperview:superview];
    
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Model

- (BOOL)valueOfAutoSync{
    return self.base.autoSync;
}

- (NMBase *)base {
    return APP_DELEGATE.persistentStoreCoordinator.nimbusBase;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            NTLServerCell *cell = (NTLServerCell *)[tableView cellForRowAtIndexPath:indexPath];
            NMBase *base = self.base;
            NMBServer
            *crtSlctServer = base.defaultServer,
            *newSlctServer = base.servers[indexPath.row];
            BOOL targetAuthIn = cell.authSwitch.on;
            if (targetAuthIn) {
                // Sign out currently selected server
                if (crtSlctServer && crtSlctServer.authState == NMBAuthStateIn)
                    [crtSlctServer signOut];
                
                // Sign in new server
                [newSlctServer authorizeWithController:self];
            }
            else {
                // Sign out the server
                if (newSlctServer == crtSlctServer || crtSlctServer == nil)
                    [newSlctServer signOut];
            }
        } break;
        case 1:{
            NTLSettingsSwitchCell *cell = (NTLSettingsSwitchCell *)[tableView cellForRowAtIndexPath:indexPath];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            BOOL
            currentAutoSyncValue = defaults.autoSync,
            targetAutoSyncValue = cell.stateSwitch.on;
            if (currentAutoSyncValue != targetAutoSyncValue) {
                defaults.autoSync = targetAutoSyncValue;
                [defaults synchronize];
            }
            [cell setOn:targetAutoSyncValue animated:YES];
            
        } break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = self.base.servers.count;
            break;
        case 1:
            number = 1;
            break;
        default:
            number = 0;
            break;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:{
            NTLServerCell *serverCell = [tableView dequeueReusableCellWithIdentifier:kReuseCellIDServer
                                                                        forIndexPath:indexPath];
            serverCell.server = self.base.servers[indexPath.row];
            
            cell = serverCell;
        }break;
        case 1:{
            NTLSettingsSwitchCell *autoSyncCell = [tableView dequeueReusableCellWithIdentifier:kReuseCellIDAutoAync
                                                                           forIndexPath:indexPath];
            autoSyncCell.titleLabel.text = NSLocalizedString(@"settings_auto_aync", @"Auto SyncAuto Sync");
            [autoSyncCell setOn:[self valueOfAutoSync] animated:NO];
            
            cell = autoSyncCell;
        }break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Subviews

- (UITableView *)loadTableViewOnSuperview:(UIView *)superview
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:superview.bounds
                                                          style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kNTLSettingsCellHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //tableView.backgroundColor = [UIColor tableViewBackgroundColor];
    tableView.clipsToBounds = NO;
    
    [@{
       kReuseCellIDServer: [NTLServerCell class],
       kReuseCellIDAutoAync: [NTLSettingsSwitchCell class],
       }
     enumerateKeysAndObjectsUsingBlock:^(NSString *reuseID, Class cellClass, BOOL *stop) {
         [tableView registerClass:cellClass forCellReuseIdentifier:reuseID];
     }];
    
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:tableView];
    
    return tableView;
}

- (void)loadConstraintsOnSuperview:(UIView *)superview
{
    UIView
    *tableView = self.tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview);
    }];
}

@end
