//
//  SettingViewController.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 30/5/22.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = SettingViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        initTableView()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.bgColor()
        self.tableView.backgroundColor = .clear
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.textColor()]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.tintColor = UIColor.textColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.bgColor()
    }
    
    func initTableView() {
        tableView.estimatedRowHeight = 45
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        let nib = UINib(nibName: SettingCell.className, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SettingCell.className)
    }

    func cellPress(_ indexPath: IndexPath) {
        let item = Array(viewModel.items)[indexPath.section].value[indexPath.row]
        let type = item.type
//        var vc: UIViewController? = nil
        
        switch type {
        case .About:
            let vc = AboutViewController.instantiateVC(storyboardName: Storyboards.About.rawValue)
            self.navigationController?.pushViewController(vc, animated: true)
        case .ChangePasscode:
            let vc = PasscodeViewController.instantiateVC(storyboardName: Storyboards.Passcode.rawValue)
            vc.isChangePasscode = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}



extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(viewModel.items)[section].value.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let title = Array(viewModel.items.keys)[section]
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.className, for: indexPath) as! SettingCell
        let item = Array(viewModel.items)[indexPath.section].value[indexPath.row]
        cell.selectionStyle = .none
        cell.setup(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellPress(indexPath)
    }
}
