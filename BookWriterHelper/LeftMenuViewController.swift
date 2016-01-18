//
//  TestTableViewController.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 12/16/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
//class LeftMenuViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var projects = [Project]()
    var indexPathVar = NSIndexPath?()
    
    let cellIdentifier = "ProjectsTableViewCell"
    let transitionManager = LeftTransitionManager()

    func loadSampleProjects() {
        
//        let Note1 = Note(name: "Note1", content: "test")!
//        let Note2 = Note(name: "Note2", content: "test")!
//        let Note3 = Note(name: "Note3", content: "test")!
//        let Note4 = Note(name: "Note4", content: "test")!
//        
//        let project1 = Project(name: "Project1", notes: [Note1], uuid: Project.getUUID())!
//        let project2 = Project(name: "Project2", notes: [Note2,Note3], uuid: Project.getUUID())!
//        let project3 = Project(name: "Project3", notes: [Note4], uuid: Project.getUUID())!
//        
//        projects += [project1,project2,project3]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.delegate = self
        self.transitioningDelegate = self.transitionManager
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // справа создаем кнопку Edit
        navigationItem.rightBarButtonItem = editButtonItem()
        
        // загружаем любые сохраненные проекты, иначе загружаем тестовые данные
        if let savedProjects = Project.loadProjects() {
            projects += savedProjects
        } else {
            loadSampleProjects()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ProjectsTableViewCell

        // Достают данные проекта для шаблона с данными
        let project = projects[indexPath.row]
        
        cell.projectName.text = project.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }
    
    @IBAction func unwindToProjectList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ProjectViewController, project = sourceViewController.project {
            
            if let selectedIndexPath = indexPathVar {
                // редактируем проект
                projects[selectedIndexPath.row] = project
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                indexPathVar = nil
            } else {
                // сохраняем новый проект
                let newIndexPath = NSIndexPath(forRow: projects.count, inSection: 0)
                projects.append(project)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            // сохраняем проекты, если проект редактируется или добавлен новый проект
            Project.saveProjects(projects)
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            projects.removeAtIndex(indexPath.row)
            // обновляем массив объектов, если какой то был удален
            Project.saveProjects(projects)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let editNotesAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit") { action, indexPath in
            self.performSegueWithIdentifier("editProjectSegue", sender: indexPath)
            
            /*if segue.identifier == "editProjectSegue" {
                let projectEditViewController = segue.destinationViewController as! ProjectViewController
                
                if let selectedProjectCell = sender as? ProjectsTableViewCell {
                    print("shit")
                    print(selectedProjectCell)
                    let indexPath = tableView.indexPathForCell(selectedProjectCell)!
                    let selectedProject = projects[indexPath.row]
                    print(selectedProject.name)
                    projectEditViewController.project = selectedProject
                }
                
            }*/
        }
        
        let deleteNotesAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") { action, index in
            // Delete the row from the data source
            self.projects.removeAtIndex(indexPath.row)
            // обновляем массив объектов, если какой то был удален
            Project.saveProjects(self.projects)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        return [editNotesAction, deleteNotesAction]
    }
    
    // TODO рефактор кода
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let projectDetailViewController = segue.destinationViewController as! NoteTableViewController
            
            if let selectedProjectCell = sender as? ProjectsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedProjectCell)!
                let selectedProject = projects[indexPath.row]
                projectDetailViewController.project = selectedProject
            }
        } else if segue.identifier == "AddItem" {
            
        } else if segue.identifier == "editProjectSegue" {
            
            let nav = segue.destinationViewController as! UINavigationController
            let projectEditViewController = nav.topViewController as! ProjectViewController
                        
            if let indexPath = sender as? NSIndexPath {
                let selectedProject = projects[indexPath.row]
                projectEditViewController.project = selectedProject
                indexPathVar = indexPath
            }
        }
    }
}
