//
//  ProfileViewController.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 14/11/2017.
//  Copyright © 2017 Blouza Ouday. All rights reserved.
//

import UIKit
import RZTransitions
import RainyRefreshControl
import HidingNavigationBar
import Alamofire
import AlamofireImage
import ScrollableSegmentedControl
import SwiftSpinner
import RangeSeekSlider



class ProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,RangeSeekSliderDelegate{

    

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var TypeAnn: ScrollableSegmentedControl!
    //@IBOutlet weak var typeAnn: ScrollableSegmentedControl!
    var idCat = Int()
    var annonces = [Annonces]()
    @objc var username = ""
    @objc var hidingNavBarManager: HidingNavigationBarManager?
    fileprivate let refresh = RainyRefreshControl()
    @IBOutlet weak var myCollectionView: UICollectionView!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search.resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      self.search.delegate=self
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: myCollectionView)
        
        
        let navigationController = UINavigationController()
        navigationController.delegate = RZTransitionsManager.shared()
        
        RZTransitionsManager.shared().defaultPresentDismissAnimationController = RZZoomBlurAnimationController()
        RZTransitionsManager.shared().defaultPushPopAnimationController = RZRectZoomAnimationController()
        
        
        
        
        let itemSize = UIScreen.main.bounds.width/2 - 2
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize + 30 )
        
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        
        myCollectionView.collectionViewLayout = layout
        

        
        handleRefresh()

        // Do any additional setup after loading the view.
        navigationController.navigationBar.barTintColor = UIColor.white
        refresh.addTarget(self, action: #selector(MyAdvertsViewController.doRefresh), for: .valueChanged)
        
        
        
        TypeAnn.segmentStyle = .imageOnTop
        TypeAnn.insertSegment(withTitle: "All Adverts", image: #imageLiteral(resourceName: "megaphone-2"), at: 0)
        TypeAnn.insertSegment(withTitle: "All Offers", image: #imageLiteral(resourceName: "offer"), at: 1)
        TypeAnn.insertSegment(withTitle: "All Demands", image: #imageLiteral(resourceName: "rent-2"), at: 2)
        
        TypeAnn.underlineSelected = true
        
        TypeAnn.addTarget(self, action: #selector(ProfileViewController.segmentSelected(sender:)), for: .valueChanged)
        TypeAnn.selectedSegmentIndex = 0
        // change some colors
        self.myCollectionView.addSubview(self.refresh)
        //TypeAnn.addSubview(refresh)
        //hidingNavBarManager?.addExtensionView(TypeAnn)
        hidingNavBarManager?.addExtensionView(refresh)
        
        search.returnKeyType = UIReturnKeyType.done
        
     
    }
    
    
    
    // load data in CollectionView
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        
        if sender.selectedSegmentIndex == 0
        {
            SwiftSpinner.show("Loading...")
            self.annonces.removeAll()
            self.handleRefresh()
            self.myCollectionView.reloadData()
            SwiftSpinner.hide()
        }
        if sender.selectedSegmentIndex == 1
        {
            SwiftSpinner.show("Loading...")
            self.annonces.removeAll()
            AnnoncesService.getAllByCategoryByNature(nature: "Offre",category: self.idCat, completion: { (error: Error?, annonces: [Annonces]?) in
                if let  annonces = annonces {
                    self.annonces = annonces
                    self.myCollectionView.reloadData()
                }
            })
            self.myCollectionView.reloadData()
            SwiftSpinner.hide()
        }
        if sender.selectedSegmentIndex == 2
        {
            SwiftSpinner.show("Loading...")
            self.annonces.removeAll()
            AnnoncesService.getAllByCategoryByNature(nature: "Demande",category: self.idCat, completion: { (error: Error?, annonces: [Annonces]?) in
                if let  annonces = annonces {
                    self.annonces = annonces
                    self.myCollectionView.reloadData()
                }
            })
            self.myCollectionView.reloadData()
            SwiftSpinner.hide()
        }
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
    }
    
    //Refresh CollectionView
    @objc func doRefresh(){
        
        let popTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            SwiftSpinner.show("Loading images from server...")
            self.annonces.removeAll()
            self.handleRefresh()
            self.myCollectionView.reloadData()
            self.refresh.endRefreshing()
            SwiftSpinner.hide()
            
        }
    }
    
    private func handleRefresh(){
        
        AnnoncesService.getAllByCategory(category: self.idCat, completion: { (error: Error?, annonces: [Annonces]?) in
            if let  annonces = annonces {
                self.annonces = annonces
                self.myCollectionView.reloadData()
            }
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return annonces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  myCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        
        cell.layer.cornerRadius = 5
        let imgv = cell.contentView.viewWithTag(1) as! UIImageView
        let lbltitre = cell.contentView.viewWithTag(2) as! UILabel
        let lbldate = cell.contentView.viewWithTag(3) as! UILabel
        let lblprix = cell.contentView.viewWithTag(4) as! UILabel
        
        
        
        let urlupload = URLS.GETURL+"upload/\(annonces[indexPath.row].imagesDir!)/0.jpeg"
        if let imageURL = URL(string: urlupload), let placeholder = UIImage(named: "default-placeholder-300x300") {
            imgv.af_setImage(withURL: imageURL, placeholderImage: placeholder)
        }
        
        lbltitre.text = annonces[indexPath.row].titre

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        lbldate.text = formatter.string(from: annonces[indexPath.row].dateDebut!)

        lblprix.text = "\(annonces[indexPath.row].prix ?? 0) Dt"
        return cell

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailAnnonces")
        {
            self.transitioningDelegate = RZTransitionsManager.shared()
            
            
           
            let yourNextViewController = (segue.destination as! DetailAnnonces)
            yourNextViewController.transitioningDelegate = RZTransitionsManager.shared()
            let cell = sender as! UICollectionViewCell
            let indexPath = myCollectionView.indexPath(for: cell)
            
            yourNextViewController.annonces = annonces[(indexPath?.row)!]
            
            
        }
    
    
    }
    @IBAction func logout(_ sender: Any) {
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        return true
    }
    //search and load advert func
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if TypeAnn.selectedSegmentIndex == 1
        {
        SwiftSpinner.show("Loading...")
        self.annonces.removeAll()
            AnnoncesService.searchAction(nature: "Offre", category: self.idCat, search: searchText, completion: { (error: Error?, annonces: [Annonces]?) in
                if let  annonces = annonces {
                    self.annonces = annonces
                    self.myCollectionView.reloadData()
                }
            })
            self.myCollectionView.reloadData()
            SwiftSpinner.hide()
        }
        if TypeAnn.selectedSegmentIndex == 2
        {
            SwiftSpinner.show("Loading...")
            self.annonces.removeAll()
            AnnoncesService.searchAction(nature: "Demande", category: self.idCat, search: searchText, completion: { (error: Error?, annonces: [Annonces]?) in
                if let  annonces = annonces {
                    self.annonces = annonces
                    self.myCollectionView.reloadData()
                }
            })
            self.myCollectionView.reloadData()
            SwiftSpinner.hide()
        }
        if TypeAnn.selectedSegmentIndex == 0
        {
            SwiftSpinner.show("Loading...")
            self.annonces.removeAll()
            AnnoncesService.searchAll(category: self.idCat, search: searchText, completion: { (error: Error?, annonces: [Annonces]?) in
                if let  annonces = annonces
                {
                    self.annonces = annonces
                    self.myCollectionView.reloadData()
                }
            })
            self.myCollectionView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
    }
    
    
}
