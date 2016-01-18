//
//  MenuViewController.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/11/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class BottomMenuViewController: UIViewController {
    
    @IBAction func unwindSegueToMainViewController(sender: UIStoryboardSegue) {
        // bug? exit segue doesn't dismiss so we do it manually...
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
