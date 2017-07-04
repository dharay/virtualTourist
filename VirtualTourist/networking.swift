//
//  networking.swift
//  VirtualTourist
//
//  Created by dharay mistry on 22/10/16.
//  Copyright © 2016 forever knights. All rights reserved.
//
import UIKit
import Foundation

class netw{

	func GetUrl(lat:Double,long:Double,page:Int,index:Int) -> Void {
		Const.currentLocation[0]=lat
		Const.currentLocation[1]=long
		//	Const.pinData = pinData.init(lat: lat,lon: long,currentPage:nil,totalPages: nil,imageArray: nil)
		print(Const.currentLocation,"currentloc")
		let perPage=12
		let radiusInKM=10
		var imgUrls:[String]=[]
		let url2flickr="https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Const.flickrKey)&lat=\(lat)&lon=\(long)&radius=\(radiusInKM)&radius_units=km&extras=url_m&per_page=\(perPage)&page=\(page)&format=json&nojsoncallback=1"
		let url = NSURL(string: url2flickr)
		let request = NSURLRequest(url: url! as URL)
		let session = URLSession.shared
		
		let task = session.dataTask(with: request as URLRequest) { data, response, error in
			if error != nil { // Handle error…
				performUIUpdatesOnMain {
					if error?.localizedDescription == "The Internet connection appears to be offline."{
						globalFuncs().Launch4quit()
						
						return
					}
					globalFuncs().LaunchAlert(s: "error while gettingInfo!")
					
				}
				return
			}
			do {
				let tempd = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
				guard let temp = tempd as? [String: Any]
					else {
						globalFuncs().LaunchAlert(s: "invalidStudentInfo")
						
						return
				}
				print(temp)
				let tempRes=temp["photos"] as! [String : Any]
				let total=(tempRes["total"] as! NSString).intValue
				//let pages=tempRes["pages"] as! Int
				if total<12{
					Const.pinDataArray[index].hasImage=false
					Const.pinDataArray[index].currentPage = -1
					globalFuncs().LaunchAlert(s: "no images for recently marked pin");
					return
				
				}
				let temprs2=tempRes["photo"] as! [[String : Any]]
				for i in temprs2{
					imgUrls.append(i["url_m"] as! String)
				
				}
				print(imgUrls)
				Const.imageUrls=imgUrls
				self.storeImages(urls: imgUrls,index: index)
				
			}
			catch {
		
				performUIUpdatesOnMain {
					globalFuncs().LaunchAlert(s: "cant parse JSON")
					
					return
				}
			}
		}
		task.resume()
	}
	func storeImages(urls:[String],index:Int){
		for i in urls
		{
		let imageURL = NSURL(string: i)!
		
		// create network request
		let task = URLSession.shared.dataTask(with: imageURL as URL) { (data, response, error) in
			
			if error != nil{ // Handle error…
				performUIUpdatesOnMain {
					if error?.localizedDescription == "The Internet connection appears to be offline."{
						globalFuncs().Launch4quit()
						
						return
					}
					globalFuncs().LaunchAlert(s: "error while gettingInfo!")
					
				}
				return
			}else {
				let downloadedImage = UIImage(data: data!)
				
				Const.pinDataArray[index].imageArray.append(downloadedImage!)
				print(Const.pinData1.imageArray.count,"images downloded")
			}
		}
		
		// start network request
			task.resume()}
	
	
	
	}
}
