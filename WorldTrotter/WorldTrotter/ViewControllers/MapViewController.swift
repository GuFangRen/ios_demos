//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by cx on 2021/12/18.
//

import UIKit
import MapKit
class MapViewController:UIViewController,MKMapViewDelegate{
    var mapView: MKMapView!
    var TrackUsrButton:UIButton!
    var UnTrackUsrButton:UIButton!
    var originRegion:MKCoordinateRegion!
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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // originRegion=mapView.region//记录初始视角,为什么不一致啊？因为在view 显示之后又重新定位了
        print("MapViewController loaded it's view")
    }
    override func viewDidAppear(_ animated: Bool) {
        originRegion=mapView.region//放这里才能正确记录！
    }
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
    //  MARK: MKMapViewDelegate
    func mapViewWillStartLocatingUser(_ mapView: MKMapView){//showsUserLocation=true 的时候调用
        //originRegion=mapView.region // 放在这里才能正确记录
        let usrlocation=CLLocationCoordinate2D(latitude: 39.56, longitude: 116.20)
        let region = MKCoordinateRegion(center: usrlocation, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        print(region)
        mapView.region=region
    }
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        mapView.region=originRegion
    }
}
