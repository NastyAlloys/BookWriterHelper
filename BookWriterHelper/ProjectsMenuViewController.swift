//
//  ProjectsTableViewController.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/18/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class ProjectsMenuViewController: UITableViewController {
    
    // MARK: Properties
    
    var projects = [Project]()
    let transitionManager = LeftTransitionManager()
    
    func loadSampleProjects() {
        
//        let Note1 = Note(name: "Note1", content: "test")!
//        let Note2 = Note(name: "Note2", content: "test")!
//        let Note3 = Note(name: "Note3", content: "test")!
//        let Note4 = Note(name: "Note4", content: "test")!
        
//        let project1 = Project(name: "Project1", notes: [Note1])!
//        let project2 = Project(name: "Project2", notes: [Note2,Note3])!
//        let project3 = Project(name: "Project3", notes: [Note4])!
        
//        projects += [project1,project2,project3]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self.transitionManager
        
        // слева создаем кнопку Edit
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // загружаем любые сохраненные проекты, иначе загружаем тестовые данные
//        if let savedProjects = loadProjects() {
//            projects += savedProjects
//        } else {
            loadSampleProjects()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    let cellIdentifier = "ProjectsTableViewCell"
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ProjectsTableViewCell
        
        // Достают данные проекта для шаблона с данными
        let project = projects[indexPath.row]

        cell.projectName.text = project.name

        return cell
    }
    
    @IBAction func unwindToProjectList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ProjectViewController, project = sourceViewController.project {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // редактируем проект
                projects[selectedIndexPath.row] = project
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // сохраняем новый проект
                let newIndexPath = NSIndexPath(forRow: projects.count, inSection: 0)
                projects.append(project)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            // сохраняем проекты, если проект редактируется или добавлен новый проект
//            saveProjects()
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            projects.removeAtIndex(indexPath.row)
            // обновляем массив объектов, если какой то был удален
            saveProjects()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            
            let projectDetailViewController = segue.destinationViewController as! NoteTableViewController
            
            if let selectedProjectCell = sender as? ProjectsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedProjectCell)!
                let selectedProject = projects[indexPath.row]
                projectDetailViewController.project = selectedProject
            }
        } else if segue.identifier == "AddItem" {
            
        }
    }
    
    // MARK: NSCoding
    func saveProjects() {
        // этот метод старается архивировать массив проектов в определенной место, если успешно - return true
        let isSuccesfulSave = NSKeyedArchiver.archiveRootObject(projects, toFile: Project.ArchiveURL.path!)
        // чтобы узнать, сохранилось ли, выведем результат в консоль
        if !isSuccesfulSave {
            print("Не получилось сохранить это")
        }
    }
    
    // return type - optional Array of Project objects
    func loadProjects() -> [Project]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Project.ArchiveURL.path!) as? [Project]
    }

}
