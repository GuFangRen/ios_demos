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
    override func loadView() {
        ///创建一个地图视图
        mapView = MKMapView()
        
        ///设置视图控制器的视图
        view = mapView
        
        let segmentedControl=UISegmentedControl(items: ["Standard","Hybrid","Satellite"])
        segmentedControl.backgroundColor=UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex=0 //控制当前选中的是最左边的这个标签
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged )//应该有自动类型推断，在前面自动补充：UIControl.Event.valueChanged
        segmentedControl.translatesAutoresizingMaskIntoConstraints=false//第六章末尾介绍
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
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded it's view")
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
}
