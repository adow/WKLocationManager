//
//  WKLocationManager.h
//  WKLocationManager
//
//  Created by 秦 道平 on 14-4-8.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#pragma mark - WKLocationManagerNotification
///定位开始时
#define WKLocationManagerNotificationUpdateLocationStart @"WKLocationManagerNotificationUpdateStart"
///定位完成
#define WKLocationManagerNotificationUpdateLocationCompleted @"WKLocationManagerNotificationUpdateCompleted"
///定位超时
#define WKLocationManagerNotificationUpdateLocationTimeout @"WKLocationManagerNotificationUpdateTimeout"
///定位失败
#define WKLocationManagerNotificationUpdateLocationFailed @"WKLocationManagerNotificationUpdateLocationFailed"
///取消定位
#define WKLocationManagerNotificationUpdateLocationCanceled @"WKLocationManagerNotificationUpdateLocationCanceled"
///获取地址
#define WKLocationManagerNotificationReverseAddressCompleted @"WKLocationManagerNotificationReverseAddressCompleted"
///位置超出设定的范围
#define WKLocationManagerNotificationLocationOutOfRange @"WKLocationManagerNotificationLocationOutOfRange"
#pragma mark - WKCoordinate2D
#pragma mark WKLocationManagerGpsType
typedef enum WKLocationManagerGpsType:NSUInteger{
    WKLocationManagerGpsTypeGPS=0,
    WKLocationManagerGpsTypeBGPS=1,
} WKLocationManagerGpsType;
#pragma mark WKCoordinate2D
@interface WKCoordinate2D : NSObject{
    
}
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,assign) WKLocationManagerGpsType gpsType;
@property (nonatomic,copy) NSString* address;
///追踪用来定位的参数
@property (nonatomic,readonly) NSString* traceQueryLatLng;
-(id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude address:(NSString*)address;
///无效的坐标
-(void)makeInvalidCoordinate;
///当前坐标是否有效
-(BOOL)isCoordinateValid;
@end
#pragma mark - WKLocationManager
#pragma mark WKLocationManagerStopLocationResult
///定位结束时的结果
typedef enum WKLocationManagerStopLocationResult:NSUInteger{
    WKLocationManagerStopLocationResultSucceed=0,
    WKLocationManagerStopLocationResultFailed=1,
    WKLocationManagerStopLocationResultTimeout=2,
    WKLocationManagerStopLocationResultCanceled=3,
}WKLocationManagerStopLocationResult;
#pragma mark WKLocationManager
@interface WKLocationManager : NSObject{
    NSDate* _lastUpdateDate;
    WKCoordinate2D* _currentCoordinate;
    double _max_latitude,_max_longitude,_min_latitude,_min_longitude;
}
@property (nonatomic,readonly) WKCoordinate2D *currentCoordinate;
///当超出边界时获得的默认位置
@property (nonatomic,retain) WKCoordinate2D* defaultCoordinateWhenOutOfRange;
///最后更新位置的时间
@property (nonatomic,readonly) NSDate* lastUpdateDate;
///是否正在定位
@property (nonatomic,assign) BOOL isUpdating;
///超时时间
@property (nonatomic,assign) CGFloat timeoutSeconds;
+(WKLocationManager*)sharedLocationManager;
///开始定位
-(void)startUpdatingLocation;
///如果当前没有位置就开始定位
-(void)startUpdatingLocationIfNoLocation;
///结束定位
-(void)stopUpdatingLocationWithResult:(WKLocationManagerStopLocationResult)result;
///手动更新
-(void)updateLocationCoordinate:(CLLocationCoordinate2D)coordinate
                        address:(NSString*)address
                        gpsType:(WKLocationManagerGpsType)gpsType;
///设定范围
-(void)setRangeMaxLatitude:(double)max_latitude
              maxLongitude:(double)max_longitude
               minLatitude:(double)min_latitude
              minLongitude:(double)min_longitude;
///是否在设定范围的外面了
@property (nonatomic,readonly) BOOL isOutOfRange;
@end
