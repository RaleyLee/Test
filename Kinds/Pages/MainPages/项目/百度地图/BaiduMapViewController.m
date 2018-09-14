//
//  BaiduMapViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BaiduMapViewController.h"
#import "BDToolView.h"
#import "BDLayerView.h"
#import "BDManager.h"



typedef void(^getAddressBlock)(NSString *title,NSString *subTitle);

@interface BaiduMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>

@property(nonatomic,strong)BMKMapManager *mapManger;
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)BMKLocationService *locateService;
@property(nonatomic,strong)BMKLocationViewDisplayParam *circleDis;

@property(nonatomic,strong)BMKLocationManager *locationManager;
@property(nonatomic,strong)BMKGeoCodeSearch *geoCodeSearch;

@property(nonatomic,strong)NSMutableDictionary *layDictionary;

@property(nonatomic,strong)BDToolView *bdView;

@property(nonatomic,copy)getAddressBlock addressBlock;

@end

@implementation BaiduMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.layDictionary = [BDManager getLayerContent];
    
    __weak typeof (self) weakSelf = self;
    
    self.mapManger = [[BMKMapManager alloc] init];
    BOOL ret = [self.mapManger start:BDMAP_AK generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!!!");
    }else{
        self.mapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.mapView.mapType = [self.layDictionary[@"mapKind"] isEqualToString:@"1"] ? MKMapTypeHybrid : MKMapTypeSatellite;
        self.mapView.showMapScaleBar = YES;
        self.mapView.showsUserLocation = YES; //显示定位图层
        self.mapView.userTrackingMode = BMKUserTrackingModeNone; //这是定位的状态为普通定位模式
        [self.mapView setZoomLevel:18];
        self.mapView.scrollEnabled = YES;

//        [self.mapView setMapPadding:UIEdgeInsetsMake(0, 50, 0, 0)];
//        [self.mapView setLogoPosition:BMKLogoPositionRightTop];
        [self.view addSubview:self.mapView];
        
        [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
        
        
        
        
        [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BDMAP_AK authDelegate:self];
        
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
//        _locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
        [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            if (error)
            {
                NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            }
            if (location) {//得到定位信息，添加annotation
                
                if (location.location) {
                    NSLog(@"LOC = %@",location.location);
//                    [weakSelf.mapView setCenterCoordinate:location.location.coordinate animated:YES];
//                    [weakSelf.mapView updateLocationData:location.location];
                    
                }
                if (location.rgcData) {
                    NSLog(@"rgc = %@",[location.rgcData description]);
                }
            }
            NSLog(@"netstate = %d",state);
        }];
        
        
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        _geoCodeSearch.delegate = self;
        [self startLocation];
        
        //精度圈
        self.circleDis = [[BMKLocationViewDisplayParam alloc] init];
        self.circleDis.accuracyCircleFillColor = [[UIColor redColor] colorWithAlphaComponent:0.2f];//填充颜色
        self.circleDis.accuracyCircleStrokeColor = [UIColor blackColor];//边框颜色
        [self.mapView updateLocationViewWithParam:self.circleDis];
    }
    
    
    self.mapView.trafficEnabled = [[self.layDictionary objectForKey:@"road-open"] isEqualToString:@"1"];
  
    
    self.bdView = [[BDToolView alloc] initWithDataSource:@[
                                                           @{@"image":[[self.layDictionary objectForKey:@"road-open"] isEqualToString:@"0"] ? @"traffic-default" : @"traffic-selected",@"title":@"路况"},
                                                           @{@"image":@"layer",@"title":@"图层"},
                                                           @{@"image":[[self.layDictionary objectForKey:@"RealScene"] isEqualToString:@"0"] ? @"panorama-default" : @"panorama-selected",@"title":@"全景"},
                                                           @{@"image":@"report",@"title":@"上报"}
                                                           ]];
    self.bdView.clickBlock = ^(NSInteger index,BOOL state) {
        if (index == 0) {
            weakSelf.mapView.trafficEnabled = state;
            [weakSelf.layDictionary setObject:state ? @"1" : @"0" forKey:@"road-open"];
            [BDManager writeLayerContentWithDictionary:weakSelf.layDictionary];
        }else if (index == 1) {
            BDLayerView *layerView = [BDLayerView popLayerView];
            layerView.mapkindBlock = ^(NSInteger index) {
                if (index == 1) {
                    weakSelf.mapView.mapType = MKMapTypeHybrid;
                }else if (index == 2) {
                    weakSelf.mapView.mapType = MKMapTypeSatellite;
                }else if (index == 3) {
//                    weakSelf.mapView.mapType = MKMapTypeMutedStandard;
                }
            };
            [layerView show];
        }else if (index == 2) {
            [weakSelf.layDictionary setObject:state ? @"1" : @"0" forKey:@"RealScene"];
            [BDManager writeLayerContentWithDictionary:weakSelf.layDictionary];
        }else if (index == 3) {
            
        }
    };
    [self.view addSubview:self.bdView];
    [self.bdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(40, 200));
    }];
    
    
}

-(void)startLocation{
    //定位服务
    _locateService = [[BMKLocationService alloc] init];
    _locateService.delegate = self;
    _locateService.distanceFilter = 10;
    [_locateService startUserLocationService];
}


//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.mapView setCenterCoordinate:location];
    [self.mapView updateLocationData:userLocation];

//    [self.locateService stopUserLocationService];
    BMKReverseGeoCodeSearchOption *searchOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    searchOption.location = userLocation.location.coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:searchOption];
    if(flag){
        __weak typeof (self) weakSelf = self;
        self.addressBlock = ^(NSString *title,NSString *subTitle) {
            userLocation.title = title;
            userLocation.subtitle = subTitle;
            [weakSelf.mapView updateLocationData:userLocation];
        };
        
        [_locateService stopUserLocationService];
    }else{
    }

}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"address:%@----%@",result.addressDetail,result.address);
    if (self.addressBlock) {
        self.addressBlock(result.address,result.sematicDescription);
    }

  
    //addressDetail:     层次化地址信息
    
    //address:    地址名称
    
    //businessCircle:  商圈名称
    
    // location:  地址坐标
    
    //  poiList:   地址周边POI信息，成员类型为BMKPoiInfo

}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    NSLog(@"%@",annotation.title);
    return nil;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    //点击标注
    NSLog(@"%@",view.annotation.title);
    
    //线路检索节点信息
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = view.annotation.coordinate;
    start.cityName = @"北京市";
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.pt = _mapView.centerCoordinate;
    end.cityName = @"北京市";
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc] init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    
    BMKRouteSearch *routesearch = [[BMKRouteSearch alloc] init];
    routesearch.delegate = self;
    BOOL flag = [routesearch drivingSearch:drivingRouteSearchOption];
    if (flag) {
    }

    
    
    
//    NSMutableArray *nodesArray = [[NSMutableArray alloc] initWithCapacity: 2];
//
//    //起点
//    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
//    startNode.pos = [[BNPosition alloc] init];
//    startNode.pos.x = 113.936392;
//    startNode.pos.y = 22.547058;
//    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    [nodesArray addObject:startNode];
//
//    //终点
//    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
//    endNode.pos = [[BNPosition alloc] init];
//    endNode.pos.x = 114.077075;
//    endNode.pos.y = 22.543634;
//    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    [nodesArray addObject:endNode];
//
//    // 发起算路
//    [BNCoreServices_RoutePlan  startNaviRoutePlan: BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self    userInfo:nil];
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    
}

-(void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi{
    NSLog(@"当前点击的地点是 = %@  id = %@",mapPoi.text,mapPoi.uid);
}
-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    //点击的没有mapPoi
    NSLog(@"点击的位置  %lf,%lf",coordinate.latitude,coordinate.longitude);
}
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    BMKPointAnnotation *item=[[BMKPointAnnotation alloc] init];
    item.coordinate=coordinate;//地理坐标
    BMKReverseGeoCodeSearchOption *searchOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    searchOption.location = coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:searchOption];
    if (flag) {
        self.addressBlock = ^(NSString *title,NSString *subTitle) {
            item.title = title;
            item.subtitle = subTitle;
        };
    }
    [_mapView addAnnotation:item];
//    _mapView.centerCoordinate=coordinate;
    
    
}
//定位失败

- (void)didFailToLocateUserWithError:(NSError *)error{
    
    NSLog(@"error:%@",error);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
