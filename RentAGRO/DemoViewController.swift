//
//  DemoViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import expanding_collection
import SwiftSpinner
import Alamofire
import AlamofireImage
import GoogleMaps
import GooglePlaces

class DemoViewController: ExpandingViewController {
    
    fileprivate var streets = [String]()
    fileprivate var countries = [String]()
    var countryString = String()
    var streetString = String()
    var id = Int()
    
    
    fileprivate var cellsIsOpen = [Bool]()
    
    fileprivate var items = [Users]()
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleImageViewXConstraint: NSLayoutConstraint!
    
}

// MARK: - Lifecycle 🌎
extension DemoViewController {
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 256, height: 335)
        super.viewDidLoad()
        
        self.collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        getAllShops()
        
        registerCell()
        fillCellIsOpenArray()
        addGesture(to: collectionView!)
        configureNavBar()
        collectionView?.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        getAllShops()
        
    }
    
    func getAllShops()  {
        SwiftSpinner.show("Loading Shops")
        ProfileServices.getAllShops { (success, error, users) in
            if let users = users {
                
                self.items = users
                
                self.collectionView?.reloadData()
            }
        }
        SwiftSpinner.hide()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let titleView = navigationItem.titleView else { return }
        let center = UIScreen.main.bounds.midX
        let diff = center - titleView.frame.midX
        titleImageViewXConstraint.constant = diff
    }
    
    
    
}

// MARK: Helpers
extension DemoViewController {
    
    fileprivate func registerCell() {
        
        let nib = UINib(nibName: String(describing: DemoCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
    }
    
    fileprivate func fillCellIsOpenArray() {
        print(items.count)
        cellsIsOpen = Array(repeating: false, count: items.count)
    }
    
    fileprivate func getViewController(country: String,street: String,id: Int) -> ExpandingTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toViewController = storyboard.instantiateViewController(withIdentifier: "DemoTableViewController") as! DemoTableViewController
        toViewController.id = id
        toViewController.countryString = country
        toViewController.streetString = street
        return toViewController
    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
}

/// MARK: Gesture
extension DemoViewController {
    
    fileprivate func addGesture(to view: UIView) {
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))
        upGesture.direction = .up
        
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))
        downGesture.direction = .down
        
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? DemoCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController(country: self.countryString,street: self.streetString,id: self.id))
            
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        //cellsIsOpen[indexPath.row] = cell.isOpened
    }
    
}

// MARK: UIScrollViewDelegate
extension DemoViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageLabel.text = "\(currentIndex +  1)/\(items.count)"
    }
    
}

// MARK: UICollectionViewDataSource
extension DemoViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? DemoCollectionViewCell else { return }
        
        print(items.count)
        print(indexPath.row + 1)
        let index = indexPath.row % items.count
        print(index)
        
        let longitude: CLLocationDegrees = Double(items[indexPath.row].longitude!)!
        let latitude: CLLocationDegrees = Double(items[indexPath.row].latitude!)!
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            //        // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            let locationName = placeMark?.locality ?? "Could not find city"
            
            cell.lblStreet.text = locationName
            self.streetString = locationName
            
            // Country
            guard let country = placeMark?.addressDictionary?["Country"] as? String else {
                cell.lblCountry.text = "could not find country"
                return
            }
            print(country, terminator: "")
            cell.lblCountry.text = country
            self.countryString = country
            
        })
        
        
        let url = URLS.GETURL+"images/premium/"+"/"+self.items[indexPath.row].username!+"/"+self.items[indexPath.row].username!+".jpeg"
        if let imageURL = URL(string: url.replacingOccurrences(of: " ", with: "%20") ), let placeholder = UIImage(named: "default-placeholder-300x300") {
            cell.backgroundImageView.af_setImage(withURL: imageURL, placeholderImage: placeholder)
        }
        print(self.streets.count)
        
        
        cell.customName.text = self.items[indexPath.row].nom
        cell.customLastName.text = self.items[indexPath.row].prenom
        cell.customTitle.text = self.items[indexPath.row].username
        self.id = self.items[indexPath.row].id ?? 0
        //cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DemoCollectionViewCell
            , currentIndex == indexPath.row else { return }
        
        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            pushToViewController(getViewController(country: self.countryString,street: self.streetString,id: self.id))
            
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension DemoViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath) as! DemoCollectionViewCell
        pageLabel.text = "\(currentIndex +  1)/\(items.count)"
        cell.customTitle.text = self.items[indexPath.row].username
        cell.customName.text = self.items[indexPath.row].nom
        cell.customLastName.text = self.items[indexPath.row].prenom
        return cell
    }
    
}
