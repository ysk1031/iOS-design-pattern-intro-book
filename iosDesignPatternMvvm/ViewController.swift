//
//  ViewController.swift
//  iosDesignPatternMvvm
//
//  Created by Yusuke Aono on 2018/09/04.
//  Copyright © 2018 Yusuke Aono. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = Api()
        api.getUsers(success: { users in
            print(users)
        }) { error in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

