//
//  FullColorViewController.swift
//  Dunro sample
//
//  Created by Mohammad Khakpaki on 1/15/18.
//  Copyright © 2018 MKH. All rights reserved.
//

import UIKit

class FullColorViewController: UIViewController {
    var BGColor:UIColor=UIColor.blue
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor=BGColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
