//
//  ViewController.m
//  WKLocationManager
//
//  Created by 秦 道平 on 14-4-8.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "RootViewController.h"
#import "WKLocationManager.h"
#import "PopViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController
-(id)init{
    self=[super init];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationStartNotification:) name:WKLocationManagerNotificationUpdateLocationStart object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationCompletedNotification:) name:WKLocationManagerNotificationUpdateLocationCompleted object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationCancelledNotification:) name:WKLocationManagerNotificationUpdateLocationCanceled object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationFailedNotification:) name:WKLocationManagerNotificationUpdateLocationFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationTimeoutNotification:) name:WKLocationManagerNotificationUpdateLocationTimeout object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationOutOfRangeNotification:) name:WKLocationManagerNotificationLocationOutOfRange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reverseAddressCompletedNotification:) name:WKLocationManagerNotificationReverseAddressCompleted object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@ viewDidLoad",[self class]);
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Location" style:UIBarButtonItemStylePlain target:self action:@selector(onButtonLocation:)] autorelease];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Pop" style:UIBarButtonItemStylePlain target:self action:@selector(onButtonDone:)] autorelease];
    [[WKLocationManager sharedLocationManager] startUpdatingLocation];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear",[self class]);
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@ viewDidAppear",[self class]);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%@ viewWillDisappear",[self class]);
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%@ viewDidDisappear",[self class]);
}
-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%@ didReceiveMemoryWarning",[self class]);
    if (!self.view.window){
        self.view=nil;
    }
}
#pragma mark - Action
-(IBAction)onButtonLocation:(id)sender{
    [[WKLocationManager sharedLocationManager] startUpdatingLocation];
}
-(IBAction)onButtonDone:(id)sender{
    PopViewController* popViewController=[[[PopViewController alloc]init] autorelease];
    UINavigationController* navigation=[[[UINavigationController alloc]initWithRootViewController:popViewController] autorelease];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}
#pragma mark - Notification
-(void)updateLocationStartNotification:(NSNotification*)notification{
    NSLog(@"%@ updateLocation Start",[self class]);
}
-(void)updateLocationCompletedNotification:(NSNotification*)notification{
    NSLog(@"%@ updateLocation Completed",[self class]);
}
-(void)updateLocationTimeoutNotification:(NSNotification*)notification{
    NSLog(@"%@ updateLocation Timeout",[self class]);
}
-(void)updateLocationFailedNotification:(NSNotification*)notification{
    NSLog(@"%@ updateLocation Failed",[self class]);
}
-(void)updateLocationCancelledNotification:(NSNotification*)notification{
    NSLog(@"%@ updateLocation Cancelled",[self class]);
}
-(void)reverseAddressCompletedNotification:(NSNotification*)notification{
    NSLog(@"%@ reverseAddress Completed",[self class]);
    WKCoordinate2D* coordinate=notification.object;
    NSLog(@"address:%@",coordinate.address);
    
}
-(void)locationOutOfRangeNotification:(NSNotification*)notification{
    NSLog(@"%@ locationOutOfRange",[self class]);
}
@end
