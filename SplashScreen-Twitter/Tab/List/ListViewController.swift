//
//  ListViewController.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 25/5/22.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    @IBOutlet weak var listCollection: UICollectionView!
    let realm = try! Realm()
    var items = [Document]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gallery"
        setup()
        initCollectionViewConfig()
        print("List View Controller")
    }
    
    func setup() {
        let entities = realm.objects(Document.self)
        items = Array(entities)
    }
    
    
    func initCollectionViewConfig() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        listCollection.collectionViewLayout = layout
        
        let nib = UINib(nibName: ListViewCell.className, bundle: nil)
        listCollection.register(nib, forCellWithReuseIdentifier: ListViewCell.className)
        listCollection.delegate = self
        listCollection.dataSource = self
        listCollection.reloadData()
    }

}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = items[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListViewCell.className, for: indexPath) as! ListViewCell
        
        let imageSrc = UIImage(data: model.file! as Data)
        if imageSrc != nil {
            cell.setImage(image: imageSrc!)
        }
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var colItemCount: CGFloat = 3
        let bigScreenTypes = [UIDevice.ScreenType.iPhone_12ProMax, UIDevice.ScreenType.iPhone_12_12Pro, UIDevice.ScreenType.iPhone_11Pro, UIDevice.ScreenType.iPhone_12Mini]
        
        if bigScreenTypes.contains(UIDevice.current.screenType) {
            colItemCount = 4
        }
            
        
        let size = (listCollection.frame.size.width - (colItemCount - 1)) / colItemCount
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        print(item.AddedDate)
    }
}
