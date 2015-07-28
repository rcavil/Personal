//
//  ViewController.swift
//  MyMapFinderSwift
//
//  Created by Ron on 7/27/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
//


import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)

        let initialLocation = CLLocation(latitude: 44.5133, longitude: -88.0158)

        
        centerMapOnLocation(initialLocation)
    }

    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }


}

