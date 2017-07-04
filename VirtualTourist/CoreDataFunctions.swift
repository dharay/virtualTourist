//
//  CoreDataFunctions.swift
//  VirtualTourist
//
//  Created by dharay mistry on 25/10/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class  CDfuncs  {
	func getContext () -> NSManagedObjectContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext
	}
	
	func storePin (lat:Double,lon:Double) {
		let context = getContext()
		
		let entity =  NSEntityDescription.entity(forEntityName: "PinEntity", in: context)
		
		let Pin = NSManagedObject(entity: entity!, insertInto: context)
		Const.pinData1 = pinData.init(lat: lat,lon: lon,currentPage:0,hasImage:false,imageArray: [])
		Const.pinDataArray.append(Const.pinData1)
		
		Pin.setValue(lat, forKey: "latitude")
		Pin.setValue(lon, forKey: "longitude")
		Pin.setValue(false, forKey: "hasImage")
		Pin.setValue(0, forKey: "currentPage")
		Const.CDpins.append(Pin as! PinEntity)
		
		do {
			try context.save()
			
			print("saved!")
		} catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
		} catch {
			
		}
	}
	func deletePin(lat:Double,lon:Double){
		let context = getContext()
		var i=0
		for aPin in Const.CDpins{
			if (aPin.value(forKey: "latitude")as! Double)==lat && (aPin.value(forKey: "longitude")as! Double)==lon{
				context.delete(aPin as NSManagedObject)
				print("deleted")
				
				break
			}
			i+=1
		}
	
	
	
	}
	
	func getPins () {
		
		let fetchRequest: NSFetchRequest<PinEntity> = PinEntity.fetchRequest()
		let ifetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
		do {
			//go get the results
			Const.CDpins = try getContext().fetch(fetchRequest)
			Const.CDimages = try getContext().fetch(ifetchRequest)
			//people = searchResults
			
			print ("num of results = \(Const.CDpins.count)")
			
			//You need to convert to NSManagedObject to use 'for' loops ,maYbE
			for pin1 in Const.CDpins as [NSManagedObject]{
				let pin=pin1 as! PinEntity
				print(pin.value(forKey: "latitude") as! Double)
				Const.pinData1.lat=pin.value(forKey: "latitude") as! Double
				Const.pinData1.lon=pin.value(forKey: "longitude") as! Double
				Const.pinData1.hasImage=pin.value(forKey: "hasImage") as! Bool
				Const.pinData1.currentPage=pin.value(forKey: "currentPage") as! Int
				for im in Const.CDimages as [NSManagedObject]{
					if pin == im.value(forKey: "relOfImage") as! PinEntity{
						Const.pinData1.imageArray.append(UIImage(data: im.value(forKey: "image") as! Data)!)
					
					}
				}
				Const.pinDataArray.append(Const.pinData1)
				print("count of pin",Const.pinDataArray.count)
			}
	
			
		} catch {
			print("Error with request: \(error)")
		}
	}
	func storeImages(lat:Double,lon:Double,images:[UIImage],page:Int){
		let context = getContext()
		
		for oldpin in Const.CDpins{
		
			if oldpin.latitude==lat && oldpin.longitude==lon{
				context.delete(oldpin)
			print("about to change")
			}
			
		
		}
		
	
		let entity =  NSEntityDescription.entity(forEntityName: "PinEntity", in: context)
		
		let Pin = NSManagedObject(entity: entity!, insertInto: context)
		
		//Const.pinDataArray.append(Const.pinData1)
		
		Pin.setValue(lat, forKey: "latitude")
		Pin.setValue(lon, forKey: "longitude")
		Pin.setValue(true, forKey: "hasImage")
		Pin.setValue(page, forKey: "currentPage")
		Const.CDpins.append(Pin as! PinEntity)
		
		do {
			try context.save()
			
			print("saved changes")
		} catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
		} catch {
			
		}
		
		for image in images{
			let entity =  NSEntityDescription.entity(forEntityName: "ImageEntity", in: context)
			let im = NSManagedObject(entity: entity!, insertInto: context)
			let imageData = UIImagePNGRepresentation(image)
			im.setValue(imageData, forKey: "image")
			
			im.setValue(Pin, forKey: "relOfImage")
			Const.CDimages.append(im as! ImageEntity)
			do {
				try context.save()
				
				print("saved image")
			} catch let error as NSError  {
				print("Could not save \(error), \(error.userInfo)")
			} catch {
				
			}
		}
	
	}
	func storeEmpty(lat:Double,lon:Double){
		let context = getContext()
		for oldpin in Const.CDpins{
			
			if oldpin.latitude==lat && oldpin.longitude==lon{
				context.delete(oldpin)
				print("about to change")
			}
			
			
		}
		let entity =  NSEntityDescription.entity(forEntityName: "PinEntity", in: context)
		
		let Pin = NSManagedObject(entity: entity!, insertInto: context)
		
		//Const.pinDataArray.append(Const.pinData1)
		
		Pin.setValue(lat, forKey: "latitude")
		Pin.setValue(lon, forKey: "longitude")
		Pin.setValue(false, forKey: "hasImage")
		Pin.setValue(-1, forKey: "currentPage")
		Const.CDpins.append(Pin as! PinEntity)
		
		do {
			try context.save()
			
			print("saved changes")
		} catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
		} catch {
			
		}
	
	
	}
}
