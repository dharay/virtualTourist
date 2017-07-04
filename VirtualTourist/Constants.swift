//
//  Constants.swift
//  VirtualTourist
//
//  Created by dharay mistry on 22/10/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import Foundation
import UIKit



struct Const{
	static var Currentview:UIViewController!
	static let flickrKey="e8cb761dd6c7723396c647811801849f"
	static var imageUrls:[String]=[]
	static var pinDataArray:[pinData]=[]
	static var pinData1=pinData(lat:0,lon:0,currentPage:0,hasImage:false,imageArray:[])
	static var currentCells=12
	static var currentLocation:[Double]=[0,0]
	static var imageArray:[UIImage]!
	static var CDpins:[PinEntity]=[]
	static var CDimages:[ImageEntity]=[]

}

struct pinData{
	var lat:Double
	var lon:Double
	var currentPage:Int
	var hasImage=false
	//var totalPages:Int!
	var imageArray:[UIImage]=[]

}
enum imagesStateCases {
	case none1,loading,ready
}
func performUIUpdatesOnMain(updates: @escaping () -> Void) {
	DispatchQueue.main.async {
		updates()
	}
}
class globalFuncs {
	func Launch4quit(){
	let alertController = UIAlertController(title: "Something went wrong!", message: "no internet,quitting", preferredStyle: .alert)
		
		let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in exit(0)}
		alertController.addAction(OKAction)
		
		Const.Currentview.present(alertController, animated: true) {}
		
	}
	func LaunchAlert(s:String){
		
		
		let alertController = UIAlertController(title: "Something went wrong!", message: s, preferredStyle: .alert)
		
		let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in}
		alertController.addAction(OKAction)
		Const.Currentview!.present(alertController, animated: true) {}
		
		
	}
}
