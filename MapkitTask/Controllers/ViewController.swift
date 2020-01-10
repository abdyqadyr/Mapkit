//
//  ViewController.swift
//  MapkitTask
//
//  Created by Abdykadyr Maksat on 02.11.19
//  Copyright © 2019 Abdykadyr Maksat. All rights reserved.
//

import UIKit
import Cartography
import MapKit
import CoreData

class ViewController: UIViewController {
    
    let types: [String] = ["Standard" , "Satellite" , "Hybrid"]
    var history: [Place] = []
    var place: LocationModel?
    var hiddenStatus : Bool = true
    var MainTitle:String?
    var MainSubtitle: String?
    
    lazy var mapkit: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.delegate = self
        return map
    }()
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: types)
        segment.frame = .zero
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .black
        segment.tintColor = .white
        segment.addTarget(self, action: #selector(changeStyle), for: .valueChanged)
        segment.layer.cornerRadius = 6
        segment.layer.masksToBounds = true
        return segment
    }()
    
    
    lazy var longGesture: UILongPressGestureRecognizer = {
        let long = UILongPressGestureRecognizer(target: self, action: #selector(addWaypoint(longGesture:)))
        return long
    }()
    
    lazy var table: UITableView = {
        let tb = UITableView(frame: .zero)
        tb.delegate = self
        tb.dataSource = self
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tb.backgroundColor = .clear
        tb.tableFooterView = UIView()
        return tb
    }()
    
    lazy var historyItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "history"), style: .plain, target: self, action: #selector(openHistory))
        return button
    }()
    
    lazy var historyView: UIView = {
        let vw = UIView(frame: .zero)
        vw.isHidden = true
        return vw
    }()
    
    lazy var blurEffect: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
        blur.frame = .zero
        return blur
    }()
    
    lazy var segmentView: UIView = {
        let vw = UIView(frame: .zero)
        vw.backgroundColor = .white
        vw.alpha = 0.8
        return vw
    }()
    
    lazy var righButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .clear
        button.setTitle("RB", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(nextLocation), for: .touchUpInside)
        return button
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(prevLocation), for: .touchUpInside)
        button.setTitle("LB", for: UIControl.State.normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        do{
            let history = try AppDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            self.history = history
            self.mapkit.removeAnnotations(self.mapkit.annotations)
            for annotation in self.history{
                let signLocation = CLLocationCoordinate2DMake(annotation.latit, annotation.long)
                let an = MKPointAnnotation()
                an.coordinate = signLocation
                an.title = annotation.title
                an.subtitle = annotation.subtitile
                self.mapkit.addAnnotation(an)
            }
        } catch{}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupConstraints(){
        constrain(mapkit, segmentView,historyView, view) { mk, sv,hv, vw in
            mk.edges == vw.edges
            sv.right == vw.right
            sv.left == vw.left
            sv.bottom == vw.bottom
            sv.height == 100
            hv.edges == vw.edges
        }
        constrain(table,blurEffect ,historyView ){ tb,be,hv in
            be.edges == hv.edges
            tb.edges == hv.edges
        }
        constrain(segmentView,segmentControl,leftButton,righButton){ sv, sc, lb ,rb in
            sc.centerX == sv.centerX
            sc.bottom == sv.bottom  - 30
            lb.height == sv.height
            rb.height == sv.height
            lb.bottom == sv.bottom
            rb.bottom == sv.bottom
            lb.right == sc.left
            lb.left == sv.left
            rb.left == sc.right
            rb.right == sv.right
        }
    }
    
    func setupViews(){
        self.view.addSubview(mapkit)
        self.view.addSubview(segmentView)
        self.view.addSubview(historyView)
        self.historyView.addSubview(blurEffect)
        self.historyView.addSubview(table)
        self.segmentView.addSubview(segmentControl)
        self.segmentView.addSubview(leftButton)
        self.segmentView.addSubview(righButton)
        self.mapkit.addGestureRecognizer(longGesture)
        self.navigationItem.rightBarButtonItem  = historyItem
        
    }
    func setupMarkers(){
        for i in 0..<self.history.count{
            let an = MKPointAnnotation()
            an.coordinate = CLLocationCoordinate2DMake(history[i].latit, history[i].long)
            an.title = history[i].title
            an.subtitle = history[i].subtitile
            self.mapkit.addAnnotation(an)
        }
    }
    
    @objc func changeStyle(segcon: UISegmentedControl){
        switch segcon.selectedSegmentIndex {
        case 0:
            mapkit.mapType = .standard
        case 1:
            mapkit.mapType = .satellite
        case 2:
            mapkit.mapType = .hybrid
        default:
            print("Error")
        }
    }
    
    @objc func addWaypoint(longGesture: UIGestureRecognizer) {
        let touchPoint = longGesture.location(in: mapkit)
        let wayCoords = mapkit.convert(touchPoint, toCoordinateFrom: mapkit)
        let wayAnnotation = MKPointAnnotation()
        
        let alert = UIAlertController(title: "Add Place", message: "Fiedl all gaps", preferredStyle: .alert)
        alert.addTextField { (city) in
            city.placeholder = "City"
        }
        alert.addTextField { (description) in
            description.placeholder = "Description"
        }
        let addAction = UIAlertAction(title: "Add place", style: .default, handler:{ (action) in
            if !((alert.textFields?[0].text?.isEmpty)! || (alert.textFields?[1].text?.isEmpty)!){
                let city = alert.textFields![0]
                let descrip = alert.textFields![1]
                wayAnnotation.coordinate = wayCoords
                wayAnnotation.title = city.text
                wayAnnotation.subtitle = descrip.text
                self.mapkit.setRegion(MKCoordinateRegion.init(center: wayCoords, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
                self.title = city.text
                
                let place = Place(context: AppDelegate.persistentContainer.viewContext)
                place.title = alert.textFields![0].text
                place.subtitile = alert.textFields![1].text
                place.latit = wayCoords.latitude
                place.long = wayCoords.longitude
                AppDelegate.saveContext()
                self.history.append(place)
                self.mapkit.removeAnnotations(self.mapkit.annotations)
                self.setupMarkers()
            }else{
                let message = UIAlertController(title: "Field all gaps", message: "this is important", preferredStyle: .alert)
                message.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(message, animated: true, completion: nil)
            }

        })

        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func openHistory(){
        setupMarkers()
        mapkit.reloadInputViews()
        table.reloadData()
        
        if hiddenStatus {
            historyView.isHidden = false
            hiddenStatus = false
        }else{
            historyView.isHidden = true
            hiddenStatus = true
        }
        
    }
    var currentIndex = 0
    
    @objc func prevLocation(){
        currentIndex = currentIndex - 1
        if(currentIndex <= -1){
            currentIndex = history.count - 1
        }
        let coordinate = CLLocationCoordinate2D(latitude: history[currentIndex].latit, longitude: history[currentIndex].long)
        mapkit.setRegion(MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        self.title = history[currentIndex].title!
    }

    @objc func nextLocation(){
        currentIndex = currentIndex + 1
        if currentIndex >= history.count {
            currentIndex = 0
        }
        let coordinate = CLLocationCoordinate2D(latitude: history[currentIndex].latit, longitude: history[currentIndex].long)
        mapkit.setRegion(MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        self.title = history[currentIndex].title!
    }
    
//    @objc func openEditView(anon: MKAnnotation){
//        let vc = EditViewController()
//        vc.my_title = MainTitle
//        vc.my_subtitle = MainSubtitle
//        self.navigationController?.pushViewController(vc, animated: true)    }

}
extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.tag = annotation.hash
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
//            rightButton.addTarget(self, action: #selector(openEditView(anon:)), for: .touchUpInside)
            return pinView
        }
        else {
            return nil
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.title = view.annotation?.title!
        MainTitle = view.annotation?.title!
        MainSubtitle = view.annotation?.subtitle!
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let destin = EditViewController()
            destin.cityTextField.text = view.annotation?.title!
            destin.descTextField.text = view.annotation?.subtitle!
            self.navigationController?.pushViewController(destin, animated: true)
            
        }
    }

    
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LocationCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "MyCell")
        let selectedIndeex = history[indexPath.row]
        cell.city.text = selectedIndeex.title
        cell.desc.text = selectedIndeex.subtitile
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           let context =  AppDelegate.persistentContainer.viewContext
            context.delete(history[indexPath.row])
            history.remove(at: indexPath.row)
            self.mapkit.removeAnnotations(self.mapkit.annotations)
            table.reloadData()
            AppDelegate.saveContext()
            setupMarkers()
            self.title = ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("asdasd")
        let coor = CLLocationCoordinate2D(latitude: history[indexPath.row].latit, longitude: history[indexPath.row].long)
        mapkit.setRegion(MKCoordinateRegion.init(center: coor, latitudinalMeters: 100000, longitudinalMeters: 100000), animated: true)
        self.title = history[indexPath.row].title!
        openHistory()
        
    }


    
}

