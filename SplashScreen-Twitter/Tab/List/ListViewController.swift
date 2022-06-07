//
//  ListViewController.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 25/5/22.
//

import UIKit
import RealmSwift
import Lightbox
import AVFoundation
import RxSwift

class ListViewController: UIViewController {
    @IBOutlet weak var listCollection: UICollectionView!

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnDeleteAll: UIButton!
    var btnSelectAll: UIBarButtonItem?
    var btnSelect = UIBarButtonItem()
    var btnCancel = UIBarButtonItem()
    var isPreview = true
    let titleSelectall = "Select All"
    let titleDiselectAll = "Diselect All"
    let refreshAlert = UIAlertController(title: "Are You Sure?", message: "Data will be permanently delete and cannot be recover.", preferredStyle: UIAlertController.Style.actionSheet)
    
    var viewModel = DocumentViewModel()
    var disposeBag = DisposeBag()
    var arrSelectedIndex = [IndexPath]()
    var idToDeletes: [UUID] = []
    var imageList: [LightboxImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gallery"
        setup()
        initCollectionViewConfig()
        subscribeEvent()
    }
    
    func subscribeEvent() {
        viewModel
            .items
            .skip(1)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self]  item in
                guard let self = self else{return}
                self.listCollection.reloadData()
                if self.viewModel.items.value.count == 0 {
                    self.btnDeleteAll.isEnabled = false
                    self.btnDelete.isEnabled = false
                } else {
                    self.btnDeleteAll.isEnabled = true
                    self.btnDelete.isEnabled = false
                }
                
                self.imageList = []
                
                for item in self.viewModel.items.value {
                    if item.isImage {
                        let imageData = NSData(data: item.file! as Data)
                        self.imageList.append(LightboxImage(image: UIImage(data: imageData as Data)!))
                    }
                }
            }.disposed(by: disposeBag)
        
        DataNotifier.shared.isReloadable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self]  item in
                guard let self = self else{return}
                if DataNotifier.shared.isReloadable.value {
                    print("Loading data")
                    DataNotifier.shared.disableReload()
                    self.viewModel.getData()
                }
            }.disposed(by: disposeBag)
    }
    
    func setup() {
        btnSelectAll = UIBarButtonItem(title: titleSelectall, style: .plain, target: self, action: #selector(self.btnSelectAllPress(_ :)))
        btnSelect = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.btnSelectPress(_ :)))
        btnCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.btnCancelPress(_ :)))
        
        self.navigationController?.navigationBar.barTintColor = UIColor.bgColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.bgColor()
        self.view.backgroundColor = UIColor.bgColor()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.textColor()]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        viewModel.getData()
        
        self.addButtonSelectToAppBar()
        
        let actionAlertDelete = UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteFromDB()
        })
        actionAlertDelete.setValue(UIColor.red, forKey: "titleTextColor")
        refreshAlert.addAction(actionAlertDelete)

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              
        }))
        
        for item in viewModel.items.value {
            if item.isImage {
                let imageData = NSData(data: item.file! as Data)
                imageList.append(LightboxImage(image: UIImage(data: imageData as Data)!))
            }
        }
        
        setLightboxConfig()
    }
    
    func setLightboxConfig() {
        LightboxConfig.preload = 2
        LightboxConfig.InfoLabel.enabled = false
        LightboxConfig.CloseButton.enabled = true
    }
    
    func initCollectionViewConfig() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        listCollection.collectionViewLayout = layout
        listCollection.backgroundColor = .clear
        let nib = UINib(nibName: ListViewCell.className, bundle: nil)
        listCollection.register(nib, forCellWithReuseIdentifier: ListViewCell.className)
        listCollection.delegate = self
        listCollection.dataSource = self
        listCollection.reloadData()
    }
    
    func toggleButtonDelete(_ isShow: Bool) {
        if isShow {
            self.btnDelete.isHidden = false
            self.btnDelete.isEnabled = true
        } else {
            self.btnDelete.isHidden = true
            self.btnDelete.isEnabled = false
        }
    }
    

    func addButtonSelectToAppBar() {
        listCollection.allowsSelection = true
        listCollection.isMultipleTouchEnabled = false
        listCollection.allowsMultipleSelection = false
        listCollection.allowsMultipleSelectionDuringEditing = false
        
        
        self.toggleButtonDelete(false)
        self.btnDeleteAll.isHidden = true
        self.navigationItem.rightBarButtonItems = [btnSelect]
        self.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.tabBar.isHidden = false
        self.isPreview = true
    }
    
    func addButtonSelectActionToAppBar() {
        listCollection.allowsSelection = true
        listCollection.isMultipleTouchEnabled = true
        listCollection.allowsMultipleSelection = true
        listCollection.allowsMultipleSelectionDuringEditing = true
        
        self.navigationItem.rightBarButtonItems = [btnCancel]
//        self.navigationItem.leftBarButtonItems = [btnSelectAll!]
        self.tabBarController?.tabBar.isHidden = true
        self.btnDelete.isHidden = false
        self.btnDeleteAll.isHidden = false
        self.isPreview = false
    }
    
    @objc func btnSelectAllPress(_ sender: UIButton) {
        let isTick = self.btnSelectAll?.title == titleSelectall
        self.setTitleLeftButton(isTick)
        self.setTickOrUntickCell(isTick)
    }
    
    func setTitleLeftButton(_ isTick: Bool) {
        self.btnSelectAll?.title = isTick ? titleDiselectAll : titleSelectall
    }
    
    func setTickOrUntickCell(_ isTick: Bool) {
        if isTick {
            for item in listCollection.visibleCells {
                let cell = item as! ListViewCell
                cell.showTickIcon()
                self.arrSelectedIndex.append(listCollection.indexPath(for: item)!)
            }
        } else {
            let cells = arrSelectedIndex
            self.arrSelectedIndex = []
            listCollection.reloadItems(at: cells)

//            let selectedItems = listCollection.indexPathsForSelectedItems ?? []
//            print("selectedItems count: ", selectedItems.count)
//            for indexPath in selectedItems {
//                listCollection.deselectItem(at: indexPath, animated:true)
//                if let cell = listCollection.cellForItem(at: indexPath) as? ListViewCell {
//                    cell.hideTickIcon()
//                }
//            }
        }
    }
    
    @objc func btnCancelPress(_ sender: UIButton) {
        self.addButtonSelectToAppBar()
        self.setTickOrUntickCell(false)
        self.toggleButtonDelete(false)
    }
    
    @objc func btnSelectPress(_ sender: UIButton) {
        self.addButtonSelectActionToAppBar()
    }
    
    @IBAction func btnDeletePress(_ sender: Any) {
        deleteConfirm(false)
    }
    @IBAction func btnDeleteAllPress(_ sender: Any) {
        deleteConfirm(true)
    }
    
    func deleteConfirm(_ isDeleteAll: Bool) {
        present(refreshAlert, animated: true, completion: nil)
        idToDeletes = []
        
        if isDeleteAll {
            for item in viewModel.items.value {
                idToDeletes.append(item.id)
            }
        } else {
            for item in arrSelectedIndex {
                idToDeletes.append(viewModel.items.value[item.row].id)
            }
        }
    }
    
    func deleteFromDB() {
        viewModel.upateToDeleteObjects(idToDeletes)
        resetAction()
    }
    
    func resetAction() {
        arrSelectedIndex = []
        idToDeletes = []
//        imageList = []
        listCollection.reloadData()
        self.addButtonSelectToAppBar()
    }
    
    
    
    func showPreview(_ indexPath: IndexPath) {
        if !isPreview {
            let cellView = listCollection.cellForItem(at: indexPath)
            if cellView == nil {
                return
            }
            let cell = cellView as! ListViewCell
            if arrSelectedIndex.contains(indexPath) {
                cell.hideTickIcon()
                arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
            }
            else {
                cell.showTickIcon()
                arrSelectedIndex.append(indexPath)
            }
            
            self.toggleButtonDelete(arrSelectedIndex.count > 0)
        } else {
            let controller = LightboxController(images: imageList, startIndex: indexPath.row)
            controller.dynamicBackground = true
            
            present(controller, animated: true, completion: nil)
        }
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = viewModel.items.value[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListViewCell.className, for: indexPath) as! ListViewCell
        
        
        let imageSrc = UIImage(data: (model.thumnail != nil ? model.thumnail! : model.file!) as Data)
        if imageSrc != nil {
            cell.setImage(image: imageSrc!)
        }
        
        if arrSelectedIndex.contains(indexPath) {
            cell.showTickIcon()
        } else {
            cell.hideTickIcon()
        }
        
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
        print("didSelectItemAt")
        showPreview(indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        print("shouldBeginMultipleSelectionInteractionAt")
        return true
    }
    
//    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
//
//    }
//
//    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
//        print("collectionViewDidEndMultipleSelectionInteraction")
//    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("shouldSelectItemAt")
        return true
    }
}
