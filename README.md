WKLocationManager
=================

* 单实例全局定位，只有一个当前的位置;
* 使用GPS或者Baidu地图坐标;
* 达到精度后就不再继续定位并发出完成的通知;
* 设定默认位置和一个区域范围，当超出位置时发出通知并将默认位置作为当前位置;
* 每次定位都有超时时间;
* 确定位置后就会反向获取地址；
* 可以手工去指定一个位置(比如指定一个Baidu地图坐标的位置);
* 通过NSNotification完成各个状态的通知;

## 依赖库

* AFNetworking;
* JSONKit;
* CTMBase64;

## 使用
* 包含和配置AFNetworking;
* 包含JSONKit;
* 包含CTMBase64;
* 包含WKLocationManager 目录;
* AppDelegate中启动时进行配置范围和默认位置

		WKCoordinate2D* coordinate=[[[WKCoordinate2D alloc]initWithLatitude:31.565137 longitude:120.288553 address:@"无锡广电附近"] autorelease];
		[WKLocationManager sharedLocationManager].defaultCoordinateWhenOutOfRange=coordinate;
		[[WKLocationManager sharedLocationManager] setRangeMaxLatitude:31.754038 maxLongitude:120.581790 minLatitude:31.417765 minLongitude:120.070390];

* 在需要的地方获得状态通知的地方注册NSNotification,一般在viewCotnroller的init中

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationStartNotification:) name:WKLocationManagerNotificationUpdateLocationStart object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationCompletedNotification:) name:WKLocationManagerNotificationUpdateLocationCompleted object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationCancelledNotification:) name:WKLocationManagerNotificationUpdateLocationCanceled object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationFailedNotification:) name:WKLocationManagerNotificationUpdateLocationFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationTimeoutNotification:) name:WKLocationManagerNotificationUpdateLocationTimeout object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationOutOfRangeNotification:) name:WKLocationManagerNotificationLocationOutOfRange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reverseAddressCompletedNotification:) name:WKLocationManagerNotificationReverseAddressCompleted object:nil];
        
* 在所有的通知中，通过WKLocationManager获取当前位置数据
     	
	     WKCoordinate2D* location=[WKLocationManager sharedLocationManager].currentCoordinate;
	     
	WKCoordinate2D包括了具体坐标，地址和坐标类型
	  
		@interface WKCoordinate2D : NSObject{
		    
		}
		@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
		@property (nonatomic,assign) WKLocationManagerGpsType gpsType;
		@property (nonatomic,copy) NSString* address;
		@end
        
* 在需要的地方开始更新定位;

		[[WKLocationManager sharedLocationManager] startUpdatingLocation];
		
* 在适当的地方删除这些Notification;

		-(void)dealloc{
		    NSLog(@"%@ dealloc",[self class]);
		    [[NSNotificationCenter defaultCenter] removeObserver:self];
		    [super dealloc];
		}


## Notification

	
* WKLocationManagerNotificationUpdateLocationStart ///定位开始时
* WKLocationManagerNotificationUpdateLocationCompleted ///定位完成
* WKLocationManagerNotificationUpdateLocationTimeout ///定位超时
* WKLocationManagerNotificationUpdateLocationFailed ///定位失败
* WKLocationManagerNotificationReverseAddressCompleted ///获取地址
* WKLocationManagerNotificationLocationOutOfRange ///位置超出设定的范围