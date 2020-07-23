//
//  HistoryCardsViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 21/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import iCarousel

class HistoryCardsViewController: UIViewController, CardViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cardView: iCarousel!
    
    var allRuns: [Run] = []
    var currentRun: Int = 0
    var views: [CardView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCarousel()
        self.setText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.cardView.reloadData()
        self.setCurrentCard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.cardView.reloadData()
        self.view.layoutIfNeeded()
        self.cardView.currentItemIndex = self.currentRun
    }
    
    func setText() {
        self.backButton.setTitle(Strings.back, for: .normal)
    }
    
    func setCarousel() {
        self.cardView.delegate = self
        self.cardView.dataSource = self
        self.cardView.type = .custom
        self.cardView.isPagingEnabled = true
        self.cardView.reloadData()
    }
    
    func setCardView(_ run: Run) {
        let view = CardView()
        view.mapView.delegate = self
        view.mapView.clipsToBounds = true
        view.delegate = self
        self.loadMap(run, view.mapView)
        let seconds = Int(run.duration)
        let formattedTime = FormatDisplay.time(seconds)
        let distance = Measurement(value: run.distance, unit: UnitLength.meters)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.kilometersPerHour)
         
        view.timeLabel.text = "\(Strings.totalDuration): \(formattedTime)"
        view.distanceLabel.text = "\(Strings.totalDistance): \(Int(distance.value)) \(Strings.meter)"
        view.speedLabel.text = "\(Strings.avrerageSpeed): \(formattedPace)"
        view.caloriesLabel.text = "\(Strings.calories): \(run.calories ?? "---")"
        view.setCornerRadius()
        
        self.views.append(view)
    }
    
    func setCurrentCard() {
        for run in allRuns {
            self.setCardView(run)
        }
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

    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func mapRegion(_ run: Run) -> MKCoordinateRegion? {

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

    private func loadMap(_ run: Run, _ mapView: MKMapView) {
        guard let locations = run.locations, locations.count > 0, let region = mapRegion(run) else { return }
        
        mapView.setRegion(region, animated: true)
        
        mapView.addOverlay(polyLine(run))
    }
    
    private func polyLine(_ run: Run) -> MKPolyline {
        guard let locations = run.locations else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
}

//--------------------------------------------------
// MARK: - MKMapView section
//--------------------------------------------------


extension HistoryCardsViewController: MKMapViewDelegate {
    
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

//--------------------------------------------------
// MARK: - iCarousel section
//--------------------------------------------------


extension HistoryCardsViewController: iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.views.count
    }
    
    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return carousel.bounds.width * 0.75
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let width = carousel.itemWidth
        let height = carousel.bounds.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)

        let view = self.views[index]
        view.frame = frame
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        var value = value
        if option == .wrap {
            value = 0.0
        }
        if option == .spacing {
            value = value * 1.15
        }
        
        return value
    }
    
    func carousel(_ carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        let distance: CGFloat = 50.0
        //number of pixels to move the items away from camera
        let spacing: CGFloat = 0.15
        //extra spacing for center item
        let clampedOffset: CGFloat = min(1.0, max(-1.0, offset))
        let z: CGFloat = -abs(clampedOffset) * distance
        var offset = offset
        offset += clampedOffset * spacing
        return CATransform3DTranslate(transform, offset * carousel.itemWidth, 0.0, z)

    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        if carousel.currentItemIndex >= 0 {
            let run = self.allRuns[carousel.currentItemIndex]
            let formattedDate = FormatDisplay.date(run.timestamp)
            self.titleLabel.text = formattedDate
        }
    }
}
