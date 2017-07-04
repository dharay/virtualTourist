//
//  CollectioVC.swift
//  VirtualTourist
//
//  Created by dharay mistry on 22/10/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import UIKit
import MapKit

class CollectioVC: UIViewController ,MKMapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
	var lat:Double=0
	var lon:Double=0
	@IBOutlet weak var collectionV: UICollectionView!
	@IBOutlet weak var map: MKMapView!
	@IBOutlet weak var BaseButton: UIButton!
	
	var pinDataIndex:Int!
	var imagesState=imagesStateCases.loading
	var cellAmt:Int=12
	var sel:[Int]=[]
	
	var i = 0
	
	@IBOutlet weak var noImagesLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		BaseButton.titleLabel?.text="NewCollection"
		BaseButton.isHidden=true
		noImagesLabel.isEnabled=false
		
		collectionV.delegate=self
		collectionV.dataSource=self
		
		let annotation = MKPointAnnotation()
		annotation.coordinate.latitude=lat
		annotation.coordinate.longitude=lon
		self.map.addAnnotation(annotation)
		let latDelta: CLLocationDegrees = 0.5
		let lonDelta: CLLocationDegrees = 0.5
		let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
		let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
		let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
		self.map.setRegion(region, animated: true)


        // Do any additional setup after loading the view.
	
		changeState()
			collectionV.reloadData()
		
		
		
    }
	@IBAction func basebut(_ sender: AnyObject) {
		//Const.pinDataArray[pinDataIndex].currentPage
		if BaseButton.titleLabel?.text == "remove"{
			
			for i in 0...sel.count-1{
				print(sel)
				Const.pinDataArray[pinDataIndex].imageArray.remove(at: sel[i])
				CDfuncs().storeImages(lat:lat,lon:lon, images: Const.pinDataArray[pinDataIndex].imageArray,page:Const.pinDataArray[pinDataIndex].currentPage)
			
			}
	
			cellAmt -= sel.count
			collectionV.reloadData()
			/*for j in 0...cellAmt-1{
				(collectionV.cellForItem(at: j) as CollectionViewCell).image2show.alpha=1
			
			}*/
			
			print("buttClicked")
			
			sel=[]
			BaseButton.titleLabel?.text="new Colection"
			return
			
		}
		
		BaseButton.isHidden=true
		Const.pinDataArray[pinDataIndex].imageArray=[]
		netw().GetUrl(lat: lat, long: lon, page: Const.pinDataArray[pinDataIndex].currentPage+1,index: pinDataIndex)
		imagesState = .loading
		check4loading()
		collectionV.reloadData()
	}
	override func viewDidAppear(_ animated: Bool) {
		Const.Currentview=self
		//BaseButton.titleLabel?.text = "NewCollection"
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if(imagesState == .ready){
		
		if (collectionView.cellForItem(at: indexPath) as! CollectionViewCell).image2show.alpha==1 {
			sel.append(indexPath.row)
			print(sel)
			(collectionView.cellForItem(at: indexPath) as! CollectionViewCell).image2show.alpha=0.5
			print("selected at",indexPath.row)
			if sel.count == 1{
				BaseButton.titleLabel?.text="remove"
				
			}
		}else{
			print("deselected at",indexPath.row)
			(collectionView.cellForItem(at: indexPath) as! CollectionViewCell).image2show.alpha = 1
			for i in 0...sel.count+1{
				if sel[i] == indexPath.row{
					sel.remove(at: i)
					print(sel)
					break
				}
			
			}
			
			if sel.count==0{
				BaseButton.titleLabel?.text="new collection"
			}
		}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return cellAmt
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionViewCell
		switch imagesState {
		case .ready:
			cell.ind.stopAnimating()
			//cell.image2show.image=UIImage(named:"asd")
				cell.image2show.image=Const.pinDataArray[pinDataIndex].imageArray[indexPath.row]
			cell.image2show.alpha=1
			return cell
			
		case .loading:
			
			if Const.pinDataArray[pinDataIndex].imageArray.count>indexPath.row{
				cell.image2show.image=Const.pinDataArray[pinDataIndex].imageArray[indexPath.row]
				cell.ind.stopAnimating()
				return cell
			}
			cell.ind.startAnimating()
			cell.image2show.image=nil
			return cell
			
		case .none1:
			cell.ind.stopAnimating()
			cellAmt=0
			return cell
		
			
		}
		//cell.image2show.image=Const.pinData.imageArray[indexPath.row]
		//return cell
		
	}

	func check4loading(){
		i += 1
		collectionV.reloadData()
		if i > 60{
			imagesState = .none1
			cellAmt=0
			noImagesLabel.isEnabled=true
			collectionV.reloadData()
			collectionV.isHidden=true
			i=0
			return
		
		}
		if Const.pinDataArray[pinDataIndex].imageArray.count<12{
			
				if Const.pinDataArray[pinDataIndex].hasImage==false {
					CDfuncs().storeEmpty(lat: lat, lon: lon)
					Const.pinDataArray[pinDataIndex].currentPage = -1
					imagesState = .none1
					cellAmt=0
					noImagesLabel.isEnabled=true
					collectionV.reloadData()
					collectionV.isHidden=true
					i=0
					return
				
				}
				
			
			print(Const.pinDataArray[pinDataIndex].imageArray.count,"this much done")
			Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.check4loading), userInfo: nil, repeats: false)
		}else{
			i=0
			imagesState = .ready
			collectionV.reloadData()
			cellAmt=12
			Const.pinDataArray[pinDataIndex].currentPage += 1
			BaseButton.isHidden=false
			CDfuncs().storeImages(lat:lat,lon:lon, images: Const.pinDataArray[pinDataIndex].imageArray,page:Const.pinDataArray[pinDataIndex].currentPage)
			//cd : saveImages
		}
	}
	func changeState(){
	
		switch Const.pinDataArray[pinDataIndex].hasImage {
		case true:
			cellAmt=Const.pinDataArray[pinDataIndex].imageArray.count
			BaseButton.isHidden=false
			imagesState = .ready
			break
		case false:
			
			switch Const.pinDataArray[pinDataIndex].currentPage {
			case 0://req and load images
				Const.pinDataArray[pinDataIndex].hasImage=true
				netw().GetUrl(lat: lat, long: lon, page: 1,index: pinDataIndex)
				check4loading()
				imagesState = .loading
				break
			case -1://pin has no images
				print("no images")
				collectionV.isHidden=true
				noImagesLabel.isEnabled=true
				cellAmt=0
				imagesState = .none1
				break
			default:break
			
				
			}
		}
	}
}
