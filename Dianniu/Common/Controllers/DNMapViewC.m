//
//  DNMapViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/2/16.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNMapViewC.h"
#import "DNPhone.h"

@interface DNMapViewC ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,UISearchBarDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong)BMKMapView *mapView;
@property (nonatomic, strong)BMKLocationService *locationService;
@property (nonatomic, strong)BMKGeoCodeSearch *geocodeSearch;
@property (nonatomic, strong)BMKPoiSearch *poiSearcher;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UITextField *locationTf;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)CLLocationCoordinate2D selectCoord;

@property (nonatomic, strong)NSMutableArray *poiDatas;
@property (nonatomic, assign)  BOOL pressed;
@end

@implementation DNMapViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurSubViews];
}

- (void)dealloc{
    NSLog(@"地图页面被销毁");
    DNForgetEvent(UIKeyboardWillShowNotification, self);
    DNForgetEvent(UIKeyboardWillHideNotification, self);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.geocodeSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.geocodeSearch.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.currentCoord.latitude && self.currentCoord.longitude) {
        BMKPointAnnotation *annotation = [self creatAnnotationWithCoord:self.currentCoord];
        [self.mapView addAnnotation:annotation];
    }
}

#pragma UI Method
- (void)configurSubViews{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerNotification];
    [self.locationService startUserLocationService];
    if (self.currentCoord.latitude && self.currentCoord.longitude) {
        self.title = @"活动地点";
        [self.view addSubview:self.mapView];
        self.mapView.centerCoordinate = self.currentCoord;
    }else{
        self.title = @"选择活动地点";
        [self.view addSubview:self.searchBar];
        [self.view addSubview:self.mapView];
        [self.view addSubview:self.bottomView];
        [self.view addSubview:self.tableView];
        self.mapView.centerCoordinate = [DNPhone shared].coord;
        [self.view addGestureRecognizer:[self creatGesture]];
    }
    
}

#pragma mark - Event
- (void)registerNotification{
    DNListenEvent(UIKeyboardWillShowNotification, self, @selector(changeContentViewPosition:));
    DNListenEvent(UIKeyboardWillHideNotification, self, @selector(changeContentViewPosition:));
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gest{
    if (gest.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gest locationInView:self.view];
        CLLocationCoordinate2D coord = [self.mapView convertPoint:point toCoordinateFromView:self.view];
        self.selectCoord = coord;
        BMKPointAnnotation *annotation = [self creatAnnotationWithCoord:coord];
        [self.mapView addAnnotation:annotation];
        BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
        option.reverseGeoPoint = coord;
        [self.geocodeSearch reverseGeoCode:option];
    }
}

- (void)confirButtonAction:(UIButton *)sender{
    if (self.locationTf.text.length > 0 &&
        self.selectCoord.longitude) {
        //点击了确定
        DNWeakself
        if (self.mapViewResult) {
            weakSelf.mapViewResult(weakSelf.locationTf.text,weakSelf.selectCoord);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)changeContentViewPosition:(NSNotification *)notification{
    if ([self.locationTf isFirstResponder]) {
        NSDictionary *userInfo = [notification userInfo];
        NSValue *value         = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat keyBoardEndY   = value.CGRectValue.origin.y;
        CGFloat keyBoardHeight = value.CGRectValue.size.height;
        CGFloat viewY = 0;
        if (keyBoardEndY < ScreenHeight) {
            //键盘收起
            viewY = 64 - keyBoardHeight;
        }else{
            //键盘弹出
            viewY = 64;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.view.top = viewY;
        }];
    }
}

#pragma mark - private
- (BMKPointAnnotation *)creatAnnotationWithCoord:(CLLocationCoordinate2D)coord{
    if (self.mapView.annotations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    BMKPointAnnotation *pannotation = [[BMKPointAnnotation alloc]init];
    pannotation.coordinate = coord;
    return pannotation;
}

- (UILongPressGestureRecognizer *)creatGesture{
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    gesture.cancelsTouchesInView = NO;
    gesture.delaysTouchesEnded = NO;
    return gesture;
}

- (void)showBottomViewWithText:(NSString *)text{
    self.bottomView.hidden = NO;
    self.locationTf.text = text;
}

- (void)hiddenPoiTableView{
    [self.poiDatas removeAllObjects];
    self.searchBar.text = @"";
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
    [self.tableView reloadData];
    if (!self.tableView.isHidden) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.top = self.mapView.bottom;
        } completion:^(BOOL finished) {
            self.tableView.hidden = YES;
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.poiDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNMapPoiCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DNMapPoiCell"];
    }
    if (indexPath.row < self.poiDatas.count) {
        BMKPoiInfo *info = self.poiDatas[indexPath.row];
        cell.textLabel.text = info.name;
        cell.detailTextLabel.text = info.address;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.poiDatas.count) {
        BMKPoiInfo *info = self.poiDatas[indexPath.row];
        BMKPointAnnotation  *annotation =[self creatAnnotationWithCoord:info.pt];
        [self.mapView addAnnotation:annotation];
        self.mapView.centerCoordinate = info.pt;
        self.selectCoord = info.pt;
        [self showBottomViewWithText:info.address];
    }
    [self hiddenPoiTableView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (self.tableView.isHidden) {
        self.tableView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.top = self.mapView.top;
        }];
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length > 0) {
        BMKCitySearchOption *option = [[BMKCitySearchOption alloc] init];
        option.city = [DNPhone shared].city;
        option.keyword = searchBar.text;
        option.pageCapacity = 20;
        
        [self.poiSearcher poiSearchInCity:option];
    }else{
        [self.poiDatas removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self hiddenPoiTableView];
}

#pragma mark - mapView协议
//大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }else if (self.locationTf.isFirstResponder){
        [self.locationTf resignFirstResponder];
    }
}

#pragma mark - 百度地理位置编码协议
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (result) {
        NSString *address = result.address;
        [self showBottomViewWithText:address];
    }
}

#pragma mark - 百度定位协议
//定位成功
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    if (!userLocation.updating && !self.currentCoord.latitude) {
        [self.mapView updateLocationData:userLocation];
        [DNPhone shared].coord = userLocation.location.coordinate;
        self.mapView .centerCoordinate = userLocation.location.coordinate;
        [self.locationService stopUserLocationService];
    }
}

#pragma mark - 百度poi检索协议
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_SEARCH_RESULT_NOT_FOUND) {
        [SVProgressHUD showErrorWithStatus:@"没有找到检索结果"];
    }else if (errorCode == BMK_SEARCH_NO_ERROR){
        //正常返回
        [self.poiDatas removeAllObjects];
        [self.poiDatas addObjectsFromArray:poiResult.poiInfoList];
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showErrorWithStatus:@"搜索超时，请检查网络"];
    }
}

#pragma mark - getter
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索地点关键字";
    }
    return _searchBar;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 64 - 70, ScreenWidth, 70)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.hidden = YES;
        [_bottomView addSubview:self.locationTf];
        UIButton *confirBut = [[UIButton alloc] initWithFrame:CGRectMake(0, self.locationTf.bottom, ScreenWidth, 70 - self.locationTf.bottom)];
        confirBut.backgroundColor = DNThemeColor;
        [confirBut setTitle:@"确定" forState:UIControlStateNormal];
        [confirBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirBut.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [confirBut addTarget:self action:@selector(confirButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:confirBut];
    }
    return _bottomView;
}

- (UITextField *)locationTf{
    if (!_locationTf) {
        _locationTf = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 30, 30)];
        _locationTf.delegate = self;
    }
    return _locationTf;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mapView.bottom, ScreenWidth, self.mapView.height - 35) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBColor(241, 241, 241);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)poiDatas{
    if (!_poiDatas) {
        _poiDatas = [NSMutableArray array];
    }
    return _poiDatas;
}

- (BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
        _mapView.top = _searchBar.bottom;
        _mapView.height = self.view.height - _searchBar.bottom;
        _mapView.showMapScaleBar = YES;
        _mapView.zoomLevel = 18;
        _mapView.userTrackingMode = BMKUserTrackingModeHeading;
        _mapView.showsUserLocation = YES;
    }
    return _mapView;
}

- (BMKLocationService *)locationService{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.delegate = self;
    }
    return _locationService;
}

- (BMKGeoCodeSearch *)geocodeSearch{
    if (!_geocodeSearch) {
        _geocodeSearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _geocodeSearch;
}

- (BMKPoiSearch *)poiSearcher{
    if (!_poiSearcher) {
        _poiSearcher = [[BMKPoiSearch alloc] init];
        _poiSearcher.delegate = self;
    }
    return _poiSearcher;
}

@end
