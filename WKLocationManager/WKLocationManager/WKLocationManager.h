//
//  WKLocationManager.h
//  WKLocationManager
//
//  Created by 秦 道平 on 14-4-8.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
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
///位置超出无锡市范围
#define WKLocationManagerNotificationLocationOutOfRange @"WKLocationManagerNotificationLocationOutOfRange"
typedef enum WKLocationManagerGpsType:NSUInteger{
    WKLocationManagerGpsTypeGPS=0,
    WKLocationManagerGpsTypeBGPS=1,
} WKLocationManagerGpsType;
@interface WKCoordinate2D : NSObject{
    double _max_latitude,_max_longitude,_min_latitude,_min_longitude;
}
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,assign) WKLocationManagerGpsType gpsType;
@property (nonatomic,copy) NSString* address;
///是否在无锡范围内
@property (nonatomic,readonly) BOOL isOutOfRange;
///追踪用来定位的参数
@property (nonatomic,readonly) NSString* traceQueryLatLng;
///默认坐标，广电附近
-(void)makeDefaultCoordinate;
///指定一个默认坐标
-(void)makeDefaultCoordinate:(CLLocationCoordinate2D)coordinate address:(NSString*)address;
///无效的坐标
-(void)makeInvalidCoordinate;
///当前坐标是否有效
-(BOOL)isCoordinateValid;
///设定一个检查范围的区域
-(void)setMaxLatitude:(double)max_latitude
         maxLongitude:(double)max_longitude
          minLatitude:(double)min_latitude
         minLongitude:(double)min_longitude;
@end
///定位结束时的结果
typedef enum WKLocationManagerStopLocationResult:NSUInteger{
    WKLocationManagerStopLocationResultSucceed=0,
    WKLocationManagerStopLocationResultFailed=1,
    WKLocationManagerStopLocationResultTimeout=2,
    WKLocationManagerStopLocationResultCanceled=3,
}WKLocationManagerStopLocationResult;
@interface WKLocationManager : NSObject{
    NSDate* _lastUpdateDate;
    WKCoordinate2D* _currentCoordinate;
}
@property (nonatomic,readonly) WKCoordinate2D *currentCoordinate;
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
@end
