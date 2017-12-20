//
//  ViewController.swift
//  MapView
//
//  Created by Seobin Nam on 12/20/17.
//  Copyright © 2017 Seobin Nam. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var lblLocationInfo1: UILabel!
    @IBOutlet weak var lblLocationInfo2: UILabel!
    
    //Declare CLLocationManaget to show map
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lblLocationInfo1.text = "" //location info
        lblLocationInfo2.text = "" //location info
        locationManager.delegate = self 
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        myMap.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //get latitude and longitude
    func goLocation(latitude latitudeValue: CLLocationDegrees, longitide longitudeValue: CLLocationDegrees, delata span :Double){
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpanMake(span, span)
        let pRegion = MKCoordinateRegionMake(pLocation, spanValue)
        myMap.setRegion(pRegion, animated: true)
    }
    //install pin
    func setAnnotation(latitude latitudeValue: CLLocationDegrees, longitude longitudeValue: CLLocationDegrees, delta span:Double, title strTitle:String, subtitle strSubtitle:String) {
        
    }
    //shows location in text
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let pLocation = locations.last
        //100 times
        goLocation(latitude: (pLocation?.coordinate.latitude)!,longitide: (pLocation?.coordinate.longitude)!,delata: 0.01)
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address:String = country!
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo1.text = "Current Location"
            self.lblLocationInfo2.text = address
        })
        //stop updating location at the end
        locationManager.stopUpdatingLocation()
    }
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
    }
    
    
}

