//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by cx on 2021/12/18.
//

import UIKit
import MapKit
class MapViewController:UIViewController{
    var mapView: MKMapView!
    var TrackUsrButton:UIButton!
    var UnTrackUsrButton:UIButton!
    var TianAnMenButton:UIButton!
    var AirportButton:UIButton!
    
    var originRegion:MKCoordinateRegion!
    
    private var allAnnotations: [MKAnnotation]?
    
    private var displayedAnnotations: [MKAnnotation]?{
        willSet{
            if let currentAnnotations=displayedAnnotations{
                mapView.removeAnnotations(currentAnnotations)
            }
        }
        didSet{
            if let newAnnotations=displayedAnnotations{
                mapView.addAnnotations(newAnnotations)
            }
        }
    }
    
    override func loadView() {
        ///创建一个地图视图
        mapView = MKMapView()
        mapView.delegate=self
        ///设置视图控制器的视图
        view = mapView
        
        let segmentedControl=UISegmentedControl(items: ["Standard","Hybrid","Satellite"])
        segmentedControl.backgroundColor=UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex=0 //控制当前选中的是最左边的这个标签
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged )//应该有自动类型推断，在前面自动补充：UIControl.Event.valueChanged
        segmentedControl.translatesAutoresizingMaskIntoConstraints=false//第六章末尾介绍,不加就报错的
        view.addSubview(segmentedControl)
        
        ///设置约束
        let margins=view.layoutMarginsGuide
        let topConstraint=segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 8)//控制不被状态栏挡住 方法1: topLayoutGuide约束
//        let topConstraint=segmentedControl.topAnchor.constraint(equalTo: margins.topAnchor
//        )//控制不被状态栏挡住  方法2: layoutMarginsGuide约束
        let leadingConstraint=segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint=segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        ///激活约束 方法1
        topConstraint.isActive=true  //等价于view.addConstraint(topConstraint)
        leadingConstraint.isActive=true
        trailingConstraint.isActive=true
        ///激活约束 方法2
//        view.addConstraint(topConstraint)
//        view.addConstraint(leadingConstraint)
//        view.addConstraint(trailingConstraint)
        
        // TrackUsr 按钮
        TrackUsrButton=UIButton()
        view.addSubview(TrackUsrButton)
        TrackUsrButton.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        TrackUsrButton.setTitle("TrackUsr", for: .normal)
        TrackUsrButton.translatesAutoresizingMaskIntoConstraints=false//第六章末尾介绍,不加就报错的
        TrackUsrButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive=true;
        TrackUsrButton.trailingAnchor.constraint(equalTo: segmentedControl.centerXAnchor,constant: -8).isActive=true
        TrackUsrButton.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 0.25, constant: 0).isActive=true//那个布局公式：p101
        TrackUsrButton.addTarget(self, action: #selector(trackUserLocation), for: .touchDown)
       
        // unTrackUsr 按钮
        UnTrackUsrButton=UIButton()
        view.addSubview(UnTrackUsrButton)
        UnTrackUsrButton.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        UnTrackUsrButton.setTitle("UntrackUsr", for: .normal)
        UnTrackUsrButton.translatesAutoresizingMaskIntoConstraints=false//第六章末尾介绍,不加就报错的
        UnTrackUsrButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive=true;
        UnTrackUsrButton.leadingAnchor.constraint(equalTo: segmentedControl.centerXAnchor,constant: 8).isActive=true
        UnTrackUsrButton.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 0.25, constant: 0).isActive=true//那个布局公式：p101
        UnTrackUsrButton.addTarget(self, action: #selector(unTrackUserLocation), for: .touchDown)
        
        
        // 天安门大头针按钮
        TianAnMenButton=UIButton()
        view.addSubview(TianAnMenButton)
        TianAnMenButton.backgroundColor=UIColor.darkGray
        TianAnMenButton.setTitle("天安门", for: .normal)
        TianAnMenButton.translatesAutoresizingMaskIntoConstraints=false
        TianAnMenButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive=true
        TianAnMenButton.trailingAnchor.constraint(equalTo: view.centerXAnchor,constant: -8).isActive=true
        TianAnMenButton.addTarget(self, action: #selector(showOnlyTianAnMenAnnotation(_:)), for: .touchDown)
        
        // 首都机场大头针按钮
        AirportButton=UIButton()
        view.addSubview(AirportButton)
        AirportButton.backgroundColor=UIColor.darkGray
        AirportButton.setTitle("机场", for: .normal)
        AirportButton.translatesAutoresizingMaskIntoConstraints=false
        AirportButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive=true
        AirportButton.leadingAnchor.constraint(equalTo: view.centerXAnchor,constant: 8).isActive=true
        AirportButton.addTarget(self, action: #selector(showOnlyAirPortAnnotaion(_:)), for: .touchDown)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // originRegion=mapView.region//记录初始视角,为什么不一致啊？因为在view 显示之后又重新定位
        registerMapAnnotationViews() //把annotation和annotationview的类对应起来
        allAnnotations=[TianAnMenAnnotation(),AirPortAnnomation()]
        
        displayedAnnotations = allAnnotations//一开始就显示所有大头针
        
        print("MapViewController loaded it's view")
    }
    override func viewDidAppear(_ animated: Bool) {
        originRegion=mapView.region//放这里才能正确记录！
    }
    
    private func registerMapAnnotationViews(){
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(TianAnMenAnnotation.self))
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier:NSStringFromClass( AirPortAnnomation.self))
    }
    
    // MARK: -Button Actions :changeMapType & trackUsr
   @objc func mapTypeChanged(_ segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    @objc func trackUserLocation(){
        mapView.showsUserLocation=true
    }
    @objc func unTrackUserLocation(){
        mapView.showsUserLocation=false
    }
    
    // MARK: -Button Actions : show annotations
    private func displayOne(_ annotationType: AnyClass){
        //先验证传递进来的类是不是allAnnotations里面支持的
        let annotation=allAnnotations?.first{ (x)->Bool in
            return x.isKind(of: annotationType)
        }
        if let oneAnnotation = annotation{
            displayedAnnotations=[oneAnnotation]
        }else{
            displayedAnnotations=[]
        }
    }
    @objc func showOnlyTianAnMenAnnotation(_ sender:Any){
        displayOne(TianAnMenAnnotation.self)
    }
    @objc func showOnlyAirPortAnnotaion(_ sender:Any){
        displayOne(AirPortAnnomation.self)
    }
    
    
}
extension MapViewController:MKMapViewDelegate{
    
    //  MARK: MKMapViewDelegate
    func mapViewWillStartLocatingUser(_ mapView: MKMapView){//showsUserLocation=true 的时候调用
        //originRegion=mapView.region // 放在这里才能正确记录
        let usrlocation=CLLocationCoordinate2D(latitude: 39.86, longitude: 116.40)
        let region = MKCoordinateRegion(center: usrlocation, span: MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75
        ))
        print(region)
        mapView.region=region
    }
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        mapView.region=originRegion
    }
    
    /// The map view asks `mapView(_:viewFor:)` for an appropiate annotation view for a specific annotation.
    /// - Tag: CreateAnnotationViews
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        
        var annotationView: MKAnnotationView?
        //运行时检查
        if annotation is TianAnMenAnnotation{
            annotationView=mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(TianAnMenAnnotation.self))
        }else if annotation is AirPortAnnomation{
            annotationView=mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(AirPortAnnomation.self))
        }
        
        return annotationView
    }
}
