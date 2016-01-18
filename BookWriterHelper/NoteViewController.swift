//
//  NoteViewController.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 12/22/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class NoteViewController: UITableViewController , UITextFieldDelegate {
    
    // MARK: Properties
    
    var note: Note?
    var project: Project? {
        didSet {
            projectDetailLabel?.text = project!.name
        }
    }
    var oldProject: Project? = nil
    var selectedIndexPath = NSIndexPath?()
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var noteNameField: UITextField!
    @IBOutlet weak var projectLabel: UILabel!
    
    @IBOutlet weak var projectDetailLabel: UILabel!
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        let isPresentingInAddProjectMode = presentingViewController is UINavigationController
        
        if isPresentingInAddProjectMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = note {
            noteNameField.text = note.name
            navigationItem.title = note.name
        }
        
        if let project = project {
            projectDetailLabel.text = project.name
        }
        
        // включаем сейв только, если валидация поля успешна
//        checkValidProjectName()
    }
    
//    // MARK: UITableViewDelegate
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("projectPicker", forIndexPath: indexPath)
//        
//        
//        
//        return cell
//    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidProjectName()
        navigationItem.title = textField.text
    }
    
    func checkValidProjectName() {
        // отключаем сейв во время редактирования
        let text = noteNameField.text ?? ""
        saveBtn.enabled = !text.isEmpty
    }
    
    func checkValidNoteName() {
        let text = noteNameField.text ?? ""
        saveBtn.enabled = !text.isEmpty
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBtn === sender {
            if let note = note {
                note.name = noteNameField.text!
                note.project = project!
            } else {
                let name = noteNameField.text ?? ""
                note = Note(name: name, content: "", project: project!)
            }
        } else if segue.identifier == "showProjectDetail" {
            if let projectsPickerController = segue.destinationViewController as? ProjectsPickerTableViewController, let project = project {
                projectsPickerController.selectedProject = project
            }
        }
    }
    
    @IBAction func unwindWithSelectedProject(segue: UIStoryboardSegue) {
        if let projectsPickerController = segue.sourceViewController as? ProjectsPickerTableViewController,
            selectedProject = projectsPickerController.selectedProject {
                if project?.uuid != selectedProject.uuid {
                    oldProject = project
                }
                
                project = selectedProject
        }
    }
        
}
    

