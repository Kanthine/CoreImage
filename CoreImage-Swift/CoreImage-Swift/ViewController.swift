//
//  ViewController.swift
//  CoreImage-Swift
//
//  Created by 苏沫离 on 2017/9/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
        
    lazy var tableView : UITableView = {
        
        let aTableView = UITableView(frame: view.bounds, style: .plain)
        aTableView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        aTableView.dataSource = self
        aTableView.delegate = self
        aTableView.tableFooterView = UIView()
        aTableView.separatorStyle = .singleLine
        aTableView.separatorColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1.0)
        aTableView.rowHeight = 45
        aTableView.sectionFooterHeight = 0.1
        aTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return aTableView
    }()
    
    var dataArray : [String]! = ["扫描二维码","创建二维码",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "CoreImage-Swift"

        self.view.addSubview(tableView)
    }

    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = dataArray[indexPath.row]
        if item == "扫描二维码" {
//            let scanQRCodeVC : ScanQRCodeViewController = ScanQRCodeViewController()!
//            scanQRCodeVC.navigationItem.title = item
//            self.navigationController?.pushViewController(scanQRCodeVC, animated: true)
        }else if item == "创建二维码" {
            let creatQRCodeVC : QRCodeCreatViewController = QRCodeCreatViewController()
            creatQRCodeVC.navigationItem.title = item
            self.navigationController?.pushViewController(creatQRCodeVC, animated: true)
        }
    }
}

