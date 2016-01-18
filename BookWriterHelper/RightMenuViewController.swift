//
//  RightMenuViewController.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/12/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController {
    
    let transitionManager = RightTransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self.transitionManager
    }
}
