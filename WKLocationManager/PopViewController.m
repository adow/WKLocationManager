//
//  PopViewController.m
//  WKLocationManager
//
//  Created by 秦 道平 on 14-4-8.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "PopViewController.h"
#import "WKLocationManager.h"

@interface PopViewController ()

@end

@implementation PopViewController

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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor lightGrayColor];
    NSLog(@"%@ viewDidLoad",[self class]);
    self.navigationItem.title=@"Pop";
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onButtonCancel:)] autorelease];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Location" style:UIBarButtonItemStylePlain target:self action:@selector(onButtonDone:)] autorelease];
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
-(IBAction)onButtonCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(IBAction)onButtonDone:(id)sender{
    [[WKLocationManager sharedLocationManager] startUpdatingLocation];
}
#pragma mark - Notification
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
