//
//  NoteeTableViewController.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 12/18/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class NoteTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties

    @IBOutlet weak var noteTableView: UITableView!
    
    let transitionManager = LeftTransitionManager()
    
    var project: Project? {
        didSet {
            notes = (project?.notes)!
        }
    }
    
    var notes = [Note]()
    var indexPathVar = NSIndexPath?()
    
    let cellIdentifier = "NoteTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteTableView.delegate = self
        self.noteTableView.dataSource = self
        self.transitionManager.controller = "note"
        self.transitioningDelegate = self.transitionManager

//        if let project = project {
//            notes = project.notes
//        }
        
        // справа создаем кнопку Edit
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    /*@IBAction func unwindToNoteList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? NoteViewController, note = sourceViewController.note {
            if let selectedIndexPath = indexPathVar {
                // редактируем проект
                notes[selectedIndexPath.row] = note
                noteTableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                indexPathVar = nil
            }
            else {
                print("shit")
                // сохраняем новый заметку
                let newIndexPath = NSIndexPath(forRow: notes.count, inSection: 0)
                notes.append(note)
                project!.notes.append(note)
                noteTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            if let projects = Project.loadProjects() {
                for p in projects {
                    if p.uuid == project?.uuid {
                        p.notes.append(note)
                        Project.saveProjects(projects)
                    }
                }
            }
        }
    }*/
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NoteTableViewCell
        let note = notes[indexPath.row]
        
        cell.noteName.text = note.name
        
        return cell
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.noteTableView.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let editNotesAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit") { action, indexPath in
            self.performSegueWithIdentifier("editNoteSegue", sender: indexPath)
        }
        
        let deleteNotesAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") { action, index in
            self.notes.removeAtIndex(indexPath.row)
            self.project?.notes.removeAtIndex(indexPath.row)
            
            if let projects = Project.loadProjects() {
                let editedProjects = projects.map({ $0.uuid == self.project?.uuid ? self.project! : $0 })
                Project.saveProjects(editedProjects)
            }
            self.noteTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        return [editNotesAction, deleteNotesAction]
    }    
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            
//            let projectDetailViewController = segue.destinationViewController as! ProjectViewController
            
        } else if segue.identifier == "AddNote" {
            
            let nav = segue.destinationViewController as! UINavigationController
            let noteViewController = nav.topViewController as! NoteViewController
            
            if project != nil {
                noteViewController.project = project
            }
        } else if segue.identifier == "editNoteSegue" {
            
            let nav = segue.destinationViewController as! UINavigationController
            let noteEditViewController = nav.topViewController as! NoteViewController
            
            if let indexPath = sender as? NSIndexPath {
                
                if project != nil {
                    noteEditViewController.project = project
                    let selectedNote = project?.notes[indexPath.row]
                    noteEditViewController.note = selectedNote
                    noteEditViewController.selectedIndexPath = indexPath
                    
                    indexPathVar = indexPath
                }
            }
        }
    }
}