//
//  LeftMenuNavViewController.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 12/19/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class LeftMenuNavViewController: UINavigationController {
    
    let transitionManager = LeftTransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self.transitionManager
        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
