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
        locationManager.delegate = self //
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //set the accuracy to best
        locationManager.requestWhenInUseAuthorization() //request users authorization to use access
        locationManager.startUpdatingLocation() //start updating location
        myMap.showsUserLocation = true //set to true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //get latitude,longitude,span to indicate those on map
    func goLocation(latitude latitudeValue: CLLocationDegrees, longitide longitudeValue: CLLocationDegrees, delta span :Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpanMake(span, span)
        let pRegion = MKCoordinateRegionMake(pLocation, spanValue)
        myMap.setRegion(pRegion, animated: true)
        return pLocation
    }
    //install pin on specific latitude and longitude and add titles onto pin
    func setAnnotation(latitude latitudeValue: CLLocationDegrees, longitude longitudeValue: CLLocationDegrees, delta span:Double, title strTitle:String, subtitle strSubtitle:String) {
        let annotation = MKPointAnnotation() //specific point on map
        annotation.coordinate = goLocation(latitude: latitudeValue, longitide: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }
    //shows location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let pLocation = locations.last
        //100 times
        goLocation(latitude: (pLocation?.coordinate.latitude)!,longitide: (pLocation?.coordinate.longitude)!,delta: 0.01)
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
        if sender.selectedSegmentIndex == 0 {
            //current location
            self.lblLocationInfo1.text = ""
            self.lblLocationInfo2.text = ""
            locationManager.startUpdatingLocation()
        }
        else if sender.selectedSegmentIndex == 1 {
            //foodland
            //call setAnnotation function
            setAnnotation(latitude: 21.647257, longitude: -157.922554, delta: 0.015, title: "Foodland", subtitle: "Laie")
            self.lblLocationInfo1.text = "Looking at"
            self.lblLocationInfo2.text = "Foodland in Laie"
            
        }
        else if sender.selectedSegmentIndex == 2 {
            //pandaexpress
            setAnnotation(latitude: 21.422223, longitude: -157.803559, delta: 0.015, title: "Panda Express", subtitle: "Kaneohe")
            self.lblLocationInfo1.text = "Looking at"
            self.lblLocationInfo2.text = "Panda Express in Kaneohe"
        }
        else {
            setAnnotation(latitude: 35.230860, longitude: 129.155264, delta: 1, title: "My Home", subtitle: "한국집")
            self.lblLocationInfo1.text = "Looking at"
            self.lblLocationInfo2.text = "My home in South Korea"
        }
    }
    
    
}

