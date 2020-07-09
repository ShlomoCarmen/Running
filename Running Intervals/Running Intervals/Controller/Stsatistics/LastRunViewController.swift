//
//  LastRunViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 08/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import MapKit

class LastRunViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var informationTitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var averageTimeLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    var locationList: [CLLocation] = []
    var totalDistance = Measurement(value: 0, unit: UnitLength.meters)
    var run: Run?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = UserDefaultsProvider.shared.user
        self.mapView.delegate = self
        self.loadMap()
        self.setText()
    }
    
    func loadMap() {
        guard let run = self.run else { return }
        if self.locationList.count > 1 {
            let centerLocation = locationList[locationList.count / 2]
            let region = MKCoordinateRegion(center: centerLocation.coordinate, latitudinalMeters: 50 +  run.distance, longitudinalMeters: 50 + run.distance)
            self.mapView.setRegion(region, animated: true)
            var locations: [CLLocationCoordinate2D] = []
            for location in self.locationList {
                locations.append(location.coordinate)
            }
            
            let polyLine = MKGeodesicPolyline(coordinates: locations, count: locationList.count)
            self.mapView.addOverlay(polyLine)
        }
    }
    
    func setText() {
        guard let run = self.run else { return }
        if self.locationList.count > 0 {
            
            let seconds = Int(run.duration)
            let formattedTime = FormatDisplay.time(seconds)
            let formattedPace = FormatDisplay.pace(distance: totalDistance, seconds: seconds, outputUnit: UnitSpeed.kilometersPerHour)

            self.informationTitleLabel.text = "Your Last Run"
            self.distanceLabel.text = "Total Dictance: \(Int(self.totalDistance.value)) Meter"
            self.speedLabel.text = "Total Duration: \(formattedTime)"
            self.averageTimeLabel.text = "Average Speed: \(formattedPace)"
            self.caloriesLabel.text = "Calories: \(self.getCalories(duration: Double(seconds) / 60.0))"
        }
    }
    
    func getCalories(duration: Double) -> String {
        guard let user = self.user else { return "No Info"}
        let met = Double(duration) * 6.0 * (3.5 * Double(user.weight))
        let calories = "\(met / 200)"
        return calories
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension LastRunViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRender = MKPolylineRenderer(overlay: overlay)
        polylineRender.strokeColor = UIColor.blue.withAlphaComponent(0.8)
        polylineRender.lineWidth = 3

        return polylineRender
    }
}
