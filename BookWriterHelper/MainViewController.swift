//
//  ViewController.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/10/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextViewDelegate {
    
    var project: Project?
    var oldProject: Project?
    var note: Note? {
        didSet {
            mainTextView.text = note?.content
        }
    }
    var isInEditingMode: Bool? = false
    var selectedIndexPath = NSIndexPath?()
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var mainTextView: UITextView!
    
    @IBAction func doneButton(sender: UIButton) {
        mainTextView.resignFirstResponder()
        topButton.hidden = false
        leftButton.hidden = false
        rightButton.hidden = false
        
        doneButton.hidden = true
        if mainTextView.text.isEmpty {
            mainTextView.text = "Press to begin typing"
            mainTextView.textColor = UIColor.whiteColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
        
        // обработка текстового поля через delegate callbacks
        mainTextView.delegate = self
        
        /*
        // настраиваем вьюхи для корректного редактирования существующего проекта
        if let note = note {
            mainTextView.text = note.content
        }
        */
        
        doneButton.hidden = true
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset: UIEdgeInsets = self.mainTextView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        self.mainTextView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        let contentInset: UIEdgeInsets = UIEdgeInsetsZero
        self.mainTextView.contentInset = contentInset
    }
    
    @IBAction func unwindSegueToMainViewController(sender: UIStoryboardSegue) {
        // bug? exit segue doesn't dismiss so we do it manually...
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindToNoteContent(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? NoteTableViewController {
//             let selectedIndexPath = sourceViewController.noteTableView.indexPathForSelectedRow
            selectedIndexPath = sourceViewController.noteTableView.indexPathForSelectedRow
            project = sourceViewController.project
            if selectedIndexPath != nil {
                note = sourceViewController.notes[selectedIndexPath!.row]
                mainTextView.text = note!.content
            }
        } else if let sourceViewController = sender.sourceViewController as? NoteViewController {
            note = sourceViewController.note; project = sourceViewController.project
            oldProject = sourceViewController.oldProject; selectedIndexPath = sourceViewController.selectedIndexPath
            
            /*
                если selectedIndexPath != nil, то заметка была отредактирована
                если selectedIndexPath == nil, то была создана новая заметка
            */
            if selectedIndexPath != nil {
                if oldProject != nil {
                    // проект заметки изменился
                    project?.notes.append(note!)
                    oldProject?.notes.removeAtIndex(selectedIndexPath!.row)
                } else {
                    // проект заметки не изменился
                    project?.notes[selectedIndexPath!.row] = note!
                }
            } else {
                project?.notes.append(note!)
            }
            
            if let projects = Project.loadProjects() {
                let editedProjects = projects.map({ originalProject -> Project in
                    if originalProject.uuid == self.project?.uuid {
                        // если произошло изменение в текующем проекте, перезаписываем его
                        return self.project!
                    } else if oldProject != nil {
                        // если у заметки изменился проект, перезаписиваем заодно и старый
                        return oldProject!
                    } else {
                        return originalProject
                    }
                })
                
                Project.saveProjects(editedProjects)
            }
            
            mainTextView.text = note!.content
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        isInEditingMode = true
        topButton.hidden = true
        leftButton.hidden = true
        rightButton.hidden = true
        
        doneButton.hidden = false
        
        if mainTextView.textColor == UIColor.lightGrayColor() {
            mainTextView.text = nil
            mainTextView.textColor = UIColor.whiteColor()
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        mainTextView.resignFirstResponder()
        return true
    }
    
    /*func textFieldDidEndEditing(textField: UITextField) {
        topButton.hidden = false
        leftButton.hidden = false
        rightButton.hidden = false
    }*/
    
    var timer: NSTimer? = nil
    
    func textViewDidChange(textView: UITextView) {
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("saveNoteContent:"), userInfo: mainTextView, repeats: false)
    }
    
    func saveNoteContent(timer: NSTimer) {
        let content = mainTextView.text
        print(content)
        print(selectedIndexPath!.row)
        print(project?.name)
        print(project?.notes[selectedIndexPath!.row])
        project?.notes[selectedIndexPath!.row].content = content
        print(project?.notes[selectedIndexPath!.row].content)
        if let projects = Project.loadProjects() {
            print(project?.notes[selectedIndexPath!.row].content)
            let editedProjects = projects.map({ $0.uuid == self.project?.uuid ? self.project! : $0 })
            Project.saveProjects(editedProjects)
            print("сохранилось!")
        }
    }
    
    func getHints(timer: NSTimer) {
    print("Hints for textField: \(timer.userInfo!)")
    }
    

}
