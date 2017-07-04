//
//  initialMapVC.swift
//  VirtualTourist
//
//  Created by dharay mistry on 22/10/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import UIKit
import MapKit

class initialMapVC: UIViewController,MKMapViewDelegate {
	var MyPins: MKPinAnnotationView!
	var places:[[String:Double]]=[]
	var editFlag=false
	var urlsArray:[String]=[]
	var i:Int=0
	
	@IBOutlet weak var map1: MKMapView!
	
	@IBOutlet weak var lab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
		CDfuncs().getPins()
		
		lab.isHidden=true
		navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Edit",style:.plain, target: self, action: #selector(edit))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title:"quit",style:.plain, target: self, action: #selector(quit1))
		navigationItem.title="VT"
		
		let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(gestureRecognizer:)))
		uilgr.minimumPressDuration = 0.5
		
		map1.addGestureRecognizer(uilgr)
		
    }
	override func viewDidAppear(_ animated: Bool) {
		Const.Currentview=self
		map1.delegate=self
		pinfronCD()
		
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		view.isEnabled=true //isSelected=false
		view.reloadInputViews()
		view.prepareForReuse()
		print("pintapped")
		if editFlag{
			view.removeFromSuperview()
			i=0
			for aPin in Const.pinDataArray{
				if aPin.lat==view.annotation?.coordinate.latitude&&aPin.lon==view.annotation?.coordinate.longitude{
					Const.pinDataArray.remove(at: i)
					CDfuncs().deletePin(lat: (view.annotation?.coordinate.latitude)!, lon: (view.annotation?.coordinate.longitude)!)
					//cd : remove pin
					break
				}
				i+=1
			}
			
		}
			
		else{
			
			let next = storyboard?.instantiateViewController(withIdentifier: "coll") as! CollectioVC
			next.lat=(view.annotation?.coordinate.latitude)! as Double
			next.lon=(view.annotation?.coordinate.longitude)! as Double
			next.imagesState = .loading
			i=0
			for aPin in Const.pinDataArray{
				if aPin.lat==view.annotation?.coordinate.latitude&&aPin.lon==view.annotation?.coordinate.longitude{
					next.pinDataIndex=i
					
					break
				}
				i+=1
			}
			/*i=0
			for aPin in Const.CDpins{
				if (aPin.value(forKey: "latitude")as! Double)==view.annotation?.coordinate.latitude&&(aPin.value(forKey: "longitude")as! Double)==view.annotation?.coordinate.longitude{
					next.currentCDpin=aPin
					
					break
				}
				i+=1
			}*/
			
			//netw().GetUrl(lat: (toPass?.coordinate.latitude)!, long: (toPass?.coordinate.longitude)!, page: 1)
			navigationController?.pushViewController(next, animated: true)
			print("selected")
		}
	}
	func edit(){
		if navigationItem.rightBarButtonItem?.title=="Edit"{
			lab.isHidden=false
			editFlag=true
			navigationItem.rightBarButtonItem?.title="Done"
		}else{
			lab.isHidden=true
			editFlag=false
			navigationItem.rightBarButtonItem?.title="Edit"
		}
	}
	func quit1(){
		
		exit(0)
	}
	
	func addAnnotation(gestureRecognizer:UIGestureRecognizer){
		if gestureRecognizer.state == UIGestureRecognizerState.began {
			let touchPoint = gestureRecognizer.location(in: map1)
			let newCoordinates = map1.convert(touchPoint, toCoordinateFrom: map1)
			let annotation = MKPointAnnotation()
			annotation.coordinate = newCoordinates
			//self.places.append(["name":1,"latitude":newCoordinates.latitude,"longitude":newCoordinates.longitude])
			
			self.map1.addAnnotation(annotation)
			CDfuncs().storePin(lat: newCoordinates.latitude as Double, lon: newCoordinates.longitude as Double)
			print(newCoordinates)
			//cd:add save
		}
	}
	func pinfronCD(){
		let allAnnotations = map1.annotations
		map1.removeAnnotations(allAnnotations)
		var annotations:[MKPointAnnotation]=[]
		for pin in Const.pinDataArray{
		
			let lat = CLLocationDegrees(pin.lat )
			let long = CLLocationDegrees(pin.lon )
			
			// The lat and long are used to create a CLLocationCoordinates2D instance.
			let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
			
			
			
			// Here we create the annotation 
			let annotation = MKPointAnnotation()
			annotation.coordinate = coordinate

			
			// Finally we place the annotation in an array of annotations.
			annotations.append(annotation)
			
			
		}
		
		// When the array is complete, we add the annotations to the map.
		self.map1.addAnnotations(annotations)
	
	
	}

}
