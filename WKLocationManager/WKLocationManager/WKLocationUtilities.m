//
//  WKLocationUtilities.m
//  WKLocationManager
//
//  Created by 秦 道平 on 14-4-8.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "WKLocationUtilities.h"

@implementation WKLocationUtilities

+(NSString*)decodeBase64:(NSString *)base64Encode{
    NSData *data=[GTMBase64 decodeString:base64Encode];
    NSString *decode=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return [decode autorelease];
}

+(void)convertGoogleLng:(double)lng
                    lat:(double)lat
  toBaiduLngLatCallback:(void(^)(double baiduLng, double baiduLat,CLLocationCoordinate2D coordinate))baiduLngLatCallback{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://api.map.baidu.com/ag/coord/convert?from=2&to=4&x=%f&y=%f", lng,lat]];
    //    WLog(url.absoluteString);
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation=[[[AFHTTPRequestOperation alloc]initWithRequest:request] autorelease];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData* data=(NSData*)responseObject;
        NSString* str=[[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary* dict=[str objectFromJSONString];
        NSString *encodeX=[dict objectForKey:@"x"];
        NSString *encodeY=[dict objectForKey:@"y"];
        NSString *x=[WKLocationUtilities decodeBase64:encodeX];
        NSString *y=[WKLocationUtilities decodeBase64:encodeY];
        CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake([y doubleValue], [x doubleValue]);
        baiduLngLatCallback([x doubleValue],[y doubleValue],coordinate);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
    
}

+(void)convertGpsLng:(double)lng lat:(double)lat toGoogleLngLatCallback:(void (^)(double, double, CLLocationCoordinate2D))googleLngLatCallback{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://api.map.baidu.com/ag/coord/convert?from=0&to=2&x=%f&y=%f", lng,lat]];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation=[[[AFHTTPRequestOperation alloc]initWithRequest:request] autorelease];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData* data=(NSData*)responseObject;
        NSString* str=[[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        //WLog(str);
        //        NSRange rangeStart=[str rangeOfString:@"{"];
        //        NSRange rangeEnd=[str rangeOfString:@"}"];
        //        NSRange rangeJson=NSMakeRange(rangeStart.location, rangeEnd.location-rangeStart.location+1);
        //        NSString* strJson=[str substringWithRange:rangeJson];
        //        WLog(strJson);
        NSDictionary* dict=[str objectFromJSONString];
        //WLog_Dictionary(@"dict", dict);
        NSString *encodeX=[dict objectForKey:@"x"];
        NSString *encodeY=[dict objectForKey:@"y"];
        NSString *x=[WKLocationUtilities decodeBase64:encodeX];
        NSString *y=[WKLocationUtilities decodeBase64:encodeY];
        //        WLog(x);
        //        WLog(y);
        CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake([y doubleValue], [x doubleValue]);
        googleLngLatCallback([x doubleValue],[y doubleValue],coordinate);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        WLog(error.description);
    }];
    [operation start];
}

+(void)convertBaiduLng:(double)lng lat:(double)lat toGoogleLngLatCallback:(void(^)(double googleLng,double googleLat,CLLocationCoordinate2D coordinate))googleLngLatCallback{
    [WKLocationUtilities convertGoogleLng:lng lat:lat toBaiduLngLatCallback:^(double baiduLng, double baiduLat,CLLocationCoordinate2D coordinate) {
        double outputLng=lng*2-baiduLng;
        double outputLat=lat*2-baiduLat;
        CLLocationCoordinate2D googleCoordinate=CLLocationCoordinate2DMake(outputLat, outputLng);
        googleLngLatCallback(outputLng,outputLat,googleCoordinate);
    }];
}
+(CLLocationCoordinate2D)makeInvalidLocation{
    
    return CLLocationCoordinate2DMake(10000, 10000);
}
@end
