//
//  LastRunViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 08/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class LastRunViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var informationTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var averageTimeLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var screenshotButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var repitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var run: Run?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = UserDefaultsProvider.shared.user
        self.mapView.delegate = self
        self.loadMap()
        self.setText()
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard let run = self.run else { return nil }
        guard let locations = run.locations, locations.count > 0
            else { return nil }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 2,
                                    longitudeDelta: (maxLong - minLong) * 2)
        return MKCoordinateRegion(center: center, span: span)
    }

    private func loadMap() {
        guard let run = self.run else { return }
        guard let locations = run.locations, locations.count > 0, let region = mapRegion() else { return }
        
        mapView.setRegion(region, animated: true)
        
        mapView.addOverlay(polyLine())
    }
    
    private func polyLine() -> MKPolyline {
        guard let run = self.run else { return MKPolyline() }
        guard let locations = run.locations else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    func setText() {
        guard let run = self.run else { return }
        let distance = Measurement(value: run.distance, unit: UnitLength.meters)
        
        let seconds = Int(run.duration)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.kilometersPerHour)
        let formattedDate = FormatDisplay.date(run.timestamp)
        
        self.informationTitleLabel.text = "Your Last Run"
        self.dateLabel.text = formattedDate
        self.distanceLabel.text = "Total Dictance: \(Int(distance.value)) Meter"
        self.speedLabel.text = "Total Duration: \(formattedTime)"
        self.averageTimeLabel.text = "Average Speed: \(formattedPace)"
        self.caloriesLabel.text = "Calories: \(run.calories ?? "No Info")"
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func screenshotButtonPressed(_ sender: Any) {
        self.takeScreenshot(true)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {

    }

    @IBAction func repitButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
    }
    
    func takeScreenshot(_ shouldSave: Bool = true) {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.windows[0].layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else { return }
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

}

extension LastRunViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
          return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blue.withAlphaComponent(0.8)
        renderer.lineWidth = 3

        return renderer
    }
}
