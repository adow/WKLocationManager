//
//  WKLocationUtilities.h
//  WKLocationManager
//
//  Created by 秦 道平 on 14-4-8.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "AFJSONUtilities.h"
#import "JSONKit.h"
#import "GTMBase64.h"
@interface WKLocationUtilities : NSObject{
}
///把baidu地图gps转换工具返回的base64编码解码
+(NSString*)decodeBase64:(NSString*)base64Encode;
///把google地址转换到baidu地址,由于是http请求后的，所以需要进行异步操作 http://api.map.baidu.com/ag/coord/convert?from=0&to=4&x=%f&y=%f
+(void)convertGoogleLng:(double)lng
                    lat:(double)lat
  toBaiduLngLatCallback:(void(^)(double baiduLng, double baiduLat,CLLocationCoordinate2D coordinate))baiduLngLatCallback;
///gps转google
+(void)convertBaiduLng:(double)lng
                   lat:(double)lat
toGoogleLngLatCallback:(void(^)(double googleLng,double googleLat,CLLocationCoordinate2D coordinate))googleLngLatCallback;
///把baidu转换到google地址，其实还是用baidu转换来实现的，非精确的方法 http://blog.csdn.net/donhao/article/details/7903702
+(void)convertGpsLng:(double)lng lat:(double)lat toGoogleLngLatCallback:(void(^)(double googleLng,double googleLat, CLLocationCoordinate2D coordinate))googleLngLatCallback;
///创建一个无效的坐标使得,CLLocationCoordinate2DIsValid 可以用来判断
+(CLLocationCoordinate2D)makeInvalidLocation;
@end
