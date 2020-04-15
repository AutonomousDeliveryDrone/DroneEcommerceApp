//
//  ProgressScreenViewController.swift
//  DeliveryDroneEcommerce
//
//  Created by Michael Peng on 4/15/20.
//  Copyright © 2020 Michael Peng. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import CoreLocation
import MapKit


class ProgressScreenViewController: UIViewController {
    
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var droneMap: MKMapView!
    
    var productName : String = ""
    var company : String = ""
    var price : Int = 0
    var address : String = ""
    var timeOrdered : String = ""
    var index : Int = 0
    @IBOutlet weak var time: UILabel!
//    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var comp: UILabel!
    //    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        name.text = productName
        comp.text = company
        time.text = timeOrdered
        
        
        let address = "New York, NY"
        
        let address2 = "1063 Oaktree Drive, San Jose, CA "
        
        
        var initialLat : CLLocationDegrees = 1
        var initialLon : CLLocationDegrees = 1
        var finalLat : CLLocationDegrees = 1
        var finalLon : CLLocationDegrees = 1
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            
            initialLat = lat!
            initialLon = lon!
            print("Boat: Lat: \(lat), Lon: \(lon)")
            print(type(of: lat))
//            let oahuCenter = CLLocation(latitude: lat!, longitude: lon!)
//            let region = MKCoordinateRegion(center: oahuCenter.coordinate, latitudinalMeters: 50000, longitudinalMeters: 60000)
//            self.droneMap.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
//
//            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
//            self.droneMap.setCameraZoomRange(zoomRange, animated: true)
            
            var yote = CLGeocoder()
            yote.geocodeAddressString(address2) {
                placemarks, error in
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                finalLat = lat!
                finalLon = lon!
                print("Yote: Lat: \(lat), Lon: \(lon)")
                
//                let region = MKCoordinateRegion(center: oahuCenter.coordinate, latitudinalMeters: 50000, longitudinalMeters: 60000)
//                self.droneMap.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
//
//                let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
//                self.droneMap.setCameraZoomRange(zoomRange, animated: true)
                
                
                print("\(initialLat) + \(initialLon) + \(finalLat) + \(finalLon)" )
                let diffLat : Double = Double(initialLat)-Double(finalLat)
                let diffLon : Double = Double(initialLon)-Double(finalLon)
                print("\(diffLat) + \(diffLon)")
                let ind = 4
                
                self.progressBar.progressAngle = CGFloat(ind/10)
                var arrLat : [Double] = []
                var arrLon : [Double] = []
                for i in stride(from: 1, to: 11, by: 1) {
                    let stepLat = 0.1 * diffLat
                    let stepLon = 0.1 * diffLon
                    
                    arrLat.append(Double(initialLat) - (Double(i) * stepLat))
                    arrLon.append(Double(initialLon) - (Double(i) * stepLon))
                    print(Double(initialLat) - (Double(i) * stepLat))
                    print(Double(initialLon) - (Double(i) * stepLon))
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: arrLat[ind], longitude: arrLon[ind])
                let annotation2 = MKPointAnnotation()
                     annotation.coordinate = CLLocationCoordinate2D(latitude: finalLat, longitude: finalLon)
                
                let oahuCenter = CLLocation(latitude: arrLat[ind], longitude: arrLon[ind])
                let region = MKCoordinateRegion(center: oahuCenter.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
//                  self.droneMap.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)

                 
                  let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
//                  self.droneMap.setCameraZoomRange(zoomRange, animated: true)
                
                self.droneMap.addAnnotation(annotation)
                self.droneMap.addAnnotation(annotation2)
                
                
            }
        }
        
        
        
        
        
        
        
        //        print(geoCoder.)
        
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
