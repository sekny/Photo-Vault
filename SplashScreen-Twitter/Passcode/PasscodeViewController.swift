//
//  PasscodeViewController.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 23/5/22.
//

import UIKit
import RxSwift

class PasscodeViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var confirmPINContainerView: UIView!
    @IBOutlet weak var confirmPINStackView: UIStackView!
    @IBOutlet weak var pinContainerView: UIStackView!
    @IBOutlet weak var keyPadCollection: UICollectionView!
    var isChangePasscode: Bool = false
    var timer = Timer()
    var counter: Int = 0
    var viewModel = PassCodeViewModel()
    var disposeBag = DisposeBag()
    let confirmPINNotMatchNewPIN = "Change PIN Failed"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData()
        setup()
//        viewModel.reset()
        startTimer()
    }
    
    private func setup() {
        if isChangePasscode {
            label.text = "Old passcode"
        } else {
            label.text = "Enter your passcode"
        }
        confirmPINContainerView.isHidden = true
        logo.tintColor = UIColor.textColor()
        label.textColor = UIColor.textColor()
        confirmLabel.textColor = UIColor.textColor()
        self.view.backgroundColor = UIColor.bgColor()
        fillDotColor()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        keyPadCollection.collectionViewLayout = layout
        keyPadCollection.register(KeypadCell.cellNib, forCellWithReuseIdentifier: KeypadCell.cellIdentifier)
        keyPadCollection.delegate = self
        keyPadCollection.dataSource = self
        keyPadCollection.reloadData()
        
        
        let dialog = UIAlertController(title:"Change PIN", message:"Change PIN Failed", preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
        dialog.addAction(okAction)
    }
    
    
    
    @objc func timerAction() {
        counter -= 1
        print("Stop countdown at \(counter) seconds")
        if counter <= 0 {
            stopTimer()
            label.text = "Enter your passcode"
            label.textColor = UIColor.textColor()
            logo.tintColor = UIColor.textColor()
            viewModel.setDisable(false)
        }
    }
    
    func startTimer() {
        stopTimer()
        counter = viewModel.totalBlockAsMin * 60
        if counter <= 0 || !viewModel.isDisabled {
            return
        }
        logo.tintColor = UIColor.systemRed
        label.text = "App is disabled, try again in \(viewModel.totalBlockAsMin) minute(s)"
        label.textColor = .systemRed
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    
    private func countWrongPIN() {
        viewModel.clearPIN()
        self.pinContainerView.shake(isVibrate: true)
        viewModel.wrongPassword()
        startTimer()
    }
    
    private func validatePIN(_ PINDigit: String) {
        viewModel.setPIN(PINDigit)
        fillDotColor()
        if viewModel.PINCode.count == viewModel.PINLength * (viewModel.isHasAccount ? 1 : 2) {
            if viewModel.isHasAccount {
                if viewModel.isValidUser(String(viewModel.PINCode.prefix(4))) {
                    goToHomeScreen()
                } else {
                    countWrongPIN()
                }
            } else {
                if viewModel.isValidPIN {
                    viewModel.insert()
                    goToHomeScreen()
                } else {
                    viewModel.clearPIN()
                    self.confirmPINStackView.shake(isVibrate: true)
                }
            }
            fillDotColor()
        }
        
        if !viewModel.isHasAccount && viewModel.PINCode.count >= viewModel.PINLength {
            confirmPINContainerView.isHidden = false
        }
    }
    
    private func validateChangePIN(_ PINDigit: String) {
        if viewModel.PINCode.count < viewModel.PINLength {
            viewModel.setPIN(PINDigit)
        } else {
            viewModel.setNewPIN(PINDigit)
        }
        
        fillDotColor()
        
        if viewModel.PINCode.count <= viewModel.PINLength - 1 {
            return
        } else if viewModel.PINCode.count >= viewModel.PINLength && viewModel.isValidUser(String(viewModel.PINCode.prefix(4))) {
            confirmPINContainerView.isHidden = false
            let newPINs = viewModel.NewPINCode
            label.text = "New passcode"
            confirmLabel.text = "Confirm passcode"
            
            if newPINs.count == viewModel.PINLength * 2 {
                if viewModel.isValidUser(String(newPINs.prefix(4))) {
                    viewModel.clearPIN()
                    fillDotColor()
                    alertWrongChangePIN("Your new PIN should not the same previous PIN.")
                } else if String(newPINs.prefix(4)) != String(newPINs.suffix(4)) {
                    viewModel.clearPIN()
                    fillDotColor()
                    alertWrongChangePIN("Confirm PIN does not match to new PIN.")
                } else {
                    viewModel.changePIN(String(newPINs.suffix(4)))
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            alertWrongChangePIN("Incorrect PIN.")
            viewModel.clearPIN()
            fillDotColor()
        }
    }
    
    private func alertWrongChangePIN(_ message: String) {
        let dialog = UIAlertController(title:"Change PIN Failed", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
        dialog.addAction(okAction)
        self.present(dialog, animated:true, completion:nil)
    }
    
    private func onTapped(_ index: Int) {
        if viewModel.isDisabled {
            return
        }
        let value = viewModel.keyValues[index]
        if(value == "x") {
            if isChangePasscode && viewModel.NewPINCode.isEmpty && viewModel.isValidUser(String(viewModel.PINCode.prefix(4))) {
                 return
            }
            viewModel.deleteLastPIN()
            fillDotColor()
        } else {
            if isChangePasscode {
                validateChangePIN(value)
            } else {
                validatePIN(value)
            }
        }
    }
    
    func goToHomeScreen() {
        if viewModel.isDisabled {
            return
        }
        ScreenProtectionHelper.shared.hidePrivacyProtectionWindow()
        self.dismiss(animated: true)
        let vc = HomeViewController.instantiateVC(storyboardName: Storyboards.Home.rawValue)
        self.view.window?.rootViewController = vc
    }
    
    
    private func fillDotColor() {
        for item in 1...(viewModel.PINLength * 2) {
            let targetPIN = isChangePasscode && viewModel.PINCode.count >= viewModel.PINLength ? viewModel.NewPINCode.count : viewModel.PINCode.count
            if item < 5 {
                pinContainerView.arrangedSubviews[item - 1].backgroundColor = item <= targetPIN ?  UIColor.textColor() : UIColor.lightDark()
            } else {
                confirmPINStackView.arrangedSubviews[item - 4 - 1].backgroundColor = item <= targetPIN ?  UIColor.textColor() : UIColor.lightDark()
            }
        }
    }
}

extension PasscodeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func config(index: Int,cell:KeypadCell){
        if index == 9 {
            cell.setTitle(title: "")
            
        } else if index == 11 {
            cell.setTitle(title: "")
            cell.setImage(image: UIImage(named: "img_backspace") ?? UIImage())
        } else {
            cell.setTitle(title: viewModel.keyValues[index])
        }
        cell.btnKeypad.isUserInteractionEnabled = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.keyValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeypadCell.cellIdentifier, for: indexPath) as? KeypadCell else {
            return UICollectionViewCell()
        }
        
        config(index: indexPath.row, cell: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (keyPadCollection.frame.size.height - 5) / 4
        let width = (keyPadCollection.frame.size.width - 5) / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapped(indexPath.row)
    }
    
}
