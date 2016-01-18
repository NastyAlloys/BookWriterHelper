//
//  NoteTableViewCell.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/30/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

protocol NoteCellDelegate {
    func didTapCell(data: Note)
}

class NoteTableViewCell: UITableViewCell {
    var delegate: NoteCellDelegate?
    var data: Note!
    
    @IBAction func didTapCell() {
        if let delegate = self.delegate {
            delegate.didTapCell(self.data)
        }
    }
    
    @IBOutlet weak var noteName: UILabel!
}
