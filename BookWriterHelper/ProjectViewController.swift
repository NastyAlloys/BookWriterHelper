//
//  ProjectViewController.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/30/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    
    var project: Project?
    
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
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
        
        // обработка текстового поля через delegate callbacks
        projectNameTextField.delegate = self
        
        // настраиваем вьюхи для корректного редактирования существующего проекта
        if let project = project {
            projectNameTextField.text = project.name
            navigationItem.title = project.name
        }
        
        // включаем сейв только, если валидация поля успешна
        checkValidProjectName()
    }
    
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
        let text = projectNameTextField.text ?? ""
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
            let name = projectNameTextField.text ?? ""
            let uuid = Project.getUUID()
            
            project = Project(name: name, notes: [], uuid: uuid)
        }
    }

}
