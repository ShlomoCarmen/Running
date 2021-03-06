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

protocol LastRunDelegate {
    func canclePressed()
}

class LastRunViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var averageTimeLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var repitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var run: Run?
    var user: User?
    var delegate: LastRunDelegate?
    
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
        
        self.headerLabel.text = Strings.trainingResults
        self.dateLabel.text = formattedDate
        self.distanceLabel.text = "\(Strings.totalDistance): \(Int(distance.value)) \(Strings.meter)"
        self.speedLabel.text = "\(Strings.totalDuration): \(formattedTime)"
        self.averageTimeLabel.text = "\(Strings.avrerageSpeed): \(formattedPace)"
        self.caloriesLabel.text = "\(Strings.calories): \(run.calories ?? "---")"
        
        self.cancelButton.setTitle(Strings.cancel, for: .normal)
        self.repitButton.setTitle(Strings.repit, for: .normal)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        self.shareResults()
    }

    @IBAction func repitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.delegate?.canclePressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    func shareResults() {
        
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)

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
