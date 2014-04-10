//
//  WKLocationManager.m
//  WKLocationManager
//
//  Created by 秦 道平 on 14-4-8.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "WKLocationManager.h"
#import "WKLocationUtilities.h"
#define WKLOCATIONMANAGER_BEST_ACCURANCY_METERS 100.0f ///最好的精度
#define WKLOCATIONMANAGER_ORDINARY_ACCURANCY_METERS 500.0f ///一般的精度
#pragma mark - WKCoordinate2D
@implementation WKCoordinate2D
@dynamic traceQueryLatLng;
-(id)init{
    self=[super init];
    if (self){
        [self makeInvalidCoordinate];
        
    }
    return self;
}
-(id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude address:(NSString *)address{
    self=[super init];
    if (self){
        [self makeInvalidCoordinate];
        self.coordinate=CLLocationCoordinate2DMake(latitude, longitude);
        self.address=self.address;
        self.gpsType=WKLocationManagerGpsTypeGPS;
    }
    return self;
}
-(void)dealloc{
    [_address release];
    [super dealloc];
}
///空坐标
-(void)makeInvalidCoordinate{
    self.coordinate= CLLocationCoordinate2DMake(1000.0f, 1000.0f);
    self.address=@"";
    self.gpsType=WKLocationManagerGpsTypeGPS;
}
///检查当前坐标是否有用
-(BOOL)isCoordinateValid{
    return CLLocationCoordinate2DIsValid(self.coordinate);
}
///输出用来追踪位置的参数
-(NSString*)traceQueryLatLng{
    if ([self isCoordinateValid]){
        return [NSString stringWithFormat:@"_trace_lat_lng=%f_%f_%d",self.coordinate.latitude,self.coordinate.longitude,(int)self.gpsType];
    }
    else{
        return @"_trace_lat_lng=";
    }
}
@end
#pragma mark - WKLocationManager
#define WKLocationManager_Default_TimeoutSeconds 30.0f
@interface WKLocationManager()<CLLocationManagerDelegate>{
    CLLocationManager* _location;
    ///开始定位的时间
    NSDate* _startUpdatingLocationTime;
    CLGeocoder* _geocorder;
}
@end
@implementation WKLocationManager
static WKLocationManager *_sharedLocationManager;
+(WKLocationManager*)sharedLocationManager{
    if (!_sharedLocationManager){
        _sharedLocationManager=[[super allocWithZone:NULL]init];
        [_sharedLocationManager startUp];
    }
    return _sharedLocationManager;
}
-(void)startUp{
    self.timeoutSeconds=WKLocationManager_Default_TimeoutSeconds;
    _location=[[CLLocationManager alloc]init];
    _location.delegate=self;
    if ([_location respondsToSelector:@selector(pausesLocationUpdatesAutomatically)]){
        _location.pausesLocationUpdatesAutomatically=YES;
    }
    if ([_location respondsToSelector:@selector(activityType)]){
        _location.activityType=CLActivityTypeFitness;
    }
    _geocorder=[[CLGeocoder alloc]init];
    _currentCoordinate=[[WKCoordinate2D alloc]init];
}
#pragma mark - default methods
+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self sharedLocationManager] retain];
}
+(id)copyWithZone:(struct _NSZone *)zone{
    return self;
}
-(id)retain{
    return self;
}
-(NSUInteger)retainCount{
    return NSUIntegerMax;
}
-(oneway void)release{
    return;
}
-(id)autorelease{
    return self;
}
-(void)dealloc{
    _location.delegate=self;
    [_location release];
    [_geocorder cancelGeocode];
    [_geocorder release];
    [_startUpdatingLocationTime release];
    [_lastUpdateDate release];
    [_currentCoordinate release];
    [super dealloc];
}
#pragma mark - Properties
-(NSDate*)lastUpdateDate{
    return _lastUpdateDate;
}
-(WKCoordinate2D*)currentCoordinate{
    return _currentCoordinate;
}
#pragma mark range
-(void)setRangeMaxLatitude:(double)max_latitude maxLongitude:(double)max_longitude minLatitude:(double)min_latitude minLongitude:(double)min_longitude{
    _max_latitude=max_latitude;
    _max_longitude=max_longitude;
    _min_latitude=min_latitude;
    _min_longitude=min_longitude;
}
-(BOOL)isOutOfRange{
    //如果没有设置就不检查
    if (!_max_latitude && !_min_latitude && !_max_longitude && !_min_longitude){
        return NO;
    }
    if (self.currentCoordinate.coordinate.longitude>_max_longitude ||
        self.currentCoordinate.coordinate.longitude<_min_longitude ||
        self.currentCoordinate.coordinate.latitude>_max_latitude ||
        self.currentCoordinate.coordinate.latitude<_min_latitude){
        return YES;
    }
    else{
        return NO;
    }
}
#pragma mark - Actions
///开始定位
-(void)startUpdatingLocation{
    ///检查是否正在定位中
    if (_isUpdating){
        NSLog(@"still updatingLocation");
        return;
    }
    NSLog(@"start updatingLocation");
    _isUpdating=YES;
    [_startUpdatingLocationTime release];
    _startUpdatingLocationTime=[[NSDate date] retain];
    _location.delegate=self;
    [_location startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:WKLocationManagerNotificationUpdateLocationStart object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeoutSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopUpdatingLocationWithResult:WKLocationManagerStopLocationResultTimeout];
    });
}
-(void)startUpdatingLocationIfNoLocation{
    if (!self.currentCoordinate || !self.currentCoordinate.isCoordinateValid){
        [self startUpdatingLocation];
    }
    else{
        NSLog(@"location existed");
    }
}
///结束定位
-(void)stopUpdatingLocationWithResult:(WKLocationManagerStopLocationResult)result{
    //NSLog(@"result:%d",result);
    if (!_isUpdating){
        NSLog(@"location not updating");
        return;
    }
    NSLog(@"stop location");
    _isUpdating=NO;
    [_location stopUpdatingLocation];
    _location.delegate=nil;
    [_lastUpdateDate release];
    _lastUpdateDate=[[NSDate date] retain];
    switch (result) {
        case WKLocationManagerStopLocationResultSucceed:
            [[NSNotificationCenter defaultCenter] postNotificationName:WKLocationManagerNotificationUpdateLocationCompleted object:self.currentCoordinate];
            break;
        case WKLocationManagerStopLocationResultFailed:
            [[NSNotificationCenter defaultCenter] postNotificationName:WKLocationManagerNotificationUpdateLocationFailed object:self.currentCoordinate];
            break;
        case WKLocationManagerStopLocationResultTimeout:
            [[NSNotificationCenter defaultCenter] postNotificationName:WKLocationManagerNotificationUpdateLocationTimeout object:self.currentCoordinate];
            break;
        case WKLocationManagerStopLocationResultCanceled:
            [[NSNotificationCenter defaultCenter] postNotificationName:WKLocationManagerNotificationUpdateLocationCanceled object:self.currentCoordinate];
            break;
        default:
            break;
    }
}
///手动更新位置
-(void)updateLocationCoordinate:(CLLocationCoordinate2D)coordinate
                        address:(NSString *)address
                        gpsType:(WKLocationManagerGpsType)gpsType{
    _isUpdating=YES;
    self.currentCoordinate.coordinate=coordinate;
    self.currentCoordinate.address=address;
    self.currentCoordinate.gpsType=gpsType;
    ///超出位置，改为默认坐标，发出通知
    if (self.isOutOfRange){
        ///设定为默认的位置
        [_defaultCoordinateWhenOutOfRange retain];
        [_currentCoordinate release];
        _defaultCoordinateWhenOutOfRange=_currentCoordinate;
        [[NSNotificationCenter defaultCenter] postNotificationName:WKLocationManagerNotificationLocationOutOfRange object:self.currentCoordinate];
        
    }
    [self stopUpdatingLocationWithResult:WKLocationManagerStopLocationResultSucceed];
    ////发出通知更新地址
    [[NSNotificationCenter defaultCenter] postNotificationName:WKLocationManagerNotificationReverseAddressCompleted object:self.currentCoordinate];
}
#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation{
    NSLog(@"WKLocationManager, longtitude:%g,latitude:%g,accurancy:%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude,newLocation.horizontalAccuracy);
    ///cached
    if (newLocation.horizontalAccuracy < 0) return;
    ///如果精度超过100米，就返回，如果定位超过20秒，如果能获得500米的精度，也可以使用
    if (newLocation.horizontalAccuracy<=WKLOCATIONMANAGER_BEST_ACCURANCY_METERS ||
        (newLocation.horizontalAccuracy<=WKLOCATIONMANAGER_ORDINARY_ACCURANCY_METERS && abs([_startUpdatingLocationTime timeIntervalSinceNow])>=self.timeoutSeconds)
        ){
        self.currentCoordinate.coordinate=newLocation.coordinate;
        self.currentCoordinate.gpsType=WKLocationManagerGpsTypeGPS;
        ///超出无锡的范围,变成一个默认坐标
        if (self.isOutOfRange){
            ///设定为默认的坐标
            [_defaultCoordinateWhenOutOfRange retain];
            [_currentCoordinate release];
            _currentCoordinate=_defaultCoordinateWhenOutOfRange;
            ///通知位置超出无锡市
            [[NSNotificationCenter defaultCenter] postNotificationName:WKLocationManagerNotificationLocationOutOfRange object:self.currentCoordinate];
        }
        [self stopUpdatingLocationWithResult:WKLocationManagerStopLocationResultSucceed];
        
        ///反查地址
        ///GPS转换到 google 坐标
        [WKLocationUtilities convertGpsLng:self.currentCoordinate.coordinate.longitude
                                  lat:self.currentCoordinate.coordinate.latitude
               toGoogleLngLatCallback:^(double googleLng, double googleLat, CLLocationCoordinate2D coordinate) {
                   //NSLog(@"google:%f,%f",coordinate.longitude,coordinate.latitude);
                   if (_geocorder.geocoding){
                       [_geocorder cancelGeocode];
                   }
                   [_geocorder reverseGeocodeLocation:[[[CLLocation alloc] initWithLatitude:googleLat longitude:googleLng] autorelease] completionHandler:^(NSArray *placemarks, NSError *error) {
                       CLPlacemark* place=placemarks[0];
                       NSLog(@"WKLocationManager, locality:%@,subLocality:%@,name:%@,administrativeArea:%@,subAdministrativeArea:%@,throughFace:%@,subThroughFace:%@",place.locality,place.subLocality,place.name,place.administrativeArea,place.subAdministrativeArea,place.thoroughfare,place.subThoroughfare);
                       NSString* currentAddressShort=[place.name stringByReplacingOccurrencesOfString:@"中国江苏省无锡市" withString:@""];
                       NSString* currentAddressLong=place.name;
                       NSLog(@"WKLocationManager, currentAddressShort:%@",currentAddressShort);
                       NSLog(@"WKLocationManager, currentAddressLong:%@",currentAddressLong);
                       self.currentCoordinate.address=currentAddressShort;
                       ///发出通知，地址更新完成
                       [[NSNotificationCenter defaultCenter] postNotificationName:WKLocationManagerNotificationReverseAddressCompleted object:self.currentCoordinate];
                   }];
                   
               }];
        
    }
    else if ([_startUpdatingLocationTime timeIntervalSinceNow]>=30.0f){
        [self stopUpdatingLocationWithResult:WKLocationManagerStopLocationResultTimeout];///超过30秒也没有获得足够精度的定位，就返回出错
    }
    else{
        NSLog(@"need accurancy");
    }
}
-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error{
    [self stopUpdatingLocationWithResult:WKLocationManagerStopLocationResultFailed];
}
@end