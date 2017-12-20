//
//  ViewController.swift
//  Segment
//
//  Created by Alpha on 2017/12/19.
//  Copyright © 2017年 STT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        
        let segmet = ST_Segment.init(frame: self.view.bounds)
        segmet.titleColor = UIColor.lightGray
        segmet.titleFont = UIFont.systemFont(ofSize: 20)
        segmet.space = 20
        segmet.lineShow = false
        segmet.setViewController(viewController: self, titleArray: ["全部","艺术品","珠宝","宜车贷"], viewControllers: setViewControllers()) { (index) in
            print("========= == + \(index)")
        }
        view.addSubview(segmet)
        
        
    }

    func  setViewControllers() -> [UIViewController] {
        let first = First_ViewController()
        let seconde = Second_TableViewController()
        let third = Third_ViewController()
        let forth = First_ViewController()
        return [first,seconde,third,forth]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

