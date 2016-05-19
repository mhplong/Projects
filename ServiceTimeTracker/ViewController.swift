//
//  ViewController.swift
//  ServiceTimeTracker
//
//  Created by Mark Long on 5/11/16.
//  Copyright © 2016 Mark Long. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ViewController: UIViewController, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    //MARK: Variables
    
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var momentTimeLabel : UILabel!
    @IBOutlet var momentTable : MomentTableView!
    
    var timer = NSTimer()
    var lastStart = NSTimeInterval()
    var lastMoment = NSTimeInterval()
    var inSession = false
    var sessionNumber = 1
    var sessionNamePrefix = "Session"
    var sessionId = "Session 1"
    
    //MARK: Class Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDefaults()
        setupNotifications()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupDefaults() {
        let prefs = NSUserDefaults.standardUserDefaults()
        let resetDatabase = prefs.boolForKey("reset_data_pref")
        let namePrefix = prefs.stringForKey("session_name_prefix_pref")
        if resetDatabase {
            databaseDeleteSessions()
            saveDatabase()
            prefs.setBool(false, forKey: "reset_data_pref")
        }
        if namePrefix != nil {
            sessionNamePrefix = namePrefix!
        }
    }
    
    func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveState), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func saveState() {
        saveDatabase()
    }
    
    //MARK: IBActions
    
    @IBAction func start(sender: UIButton) {
        if !inSession {
            beginSession()
            startTimer()
        }
    }
    
    @IBAction func newMoment(sender: UIButton) {
        if inSession {
            stopTimer()
            beginNewMoment()
            startTimer()
        }
    }
    
    @IBAction func stop(sender: UIButton) {
        if inSession {
            stopTimer()
            beginNewMoment()
            momentTable.reloadData()
            endSession()
        }
    }
    
    @IBAction func export(sender: UIButton) {
        if let sessions = getSessions() {
            var bodyMessage = ""
            for session in sessions {
                
                let lastMent = session.moments?.lastObject as! Moment
                let lastInterval = lastMent.end_time!.timeIntervalSinceDate(session.date!)
                let elapsedDate = NSDate(timeIntervalSinceReferenceDate: lastInterval)
                bodyMessage += "\n\(session.name!):\t\(dateToString(elapsedDate, elapsed: true))\n"
                bodyMessage += "-----------------------------------------------------------------------\n"
                bodyMessage += "Start\tEnd\tElapsed\tName\n"
                bodyMessage += "-----------------------------------------------------------------------\n"
                
                for elem in session.moments! {
                    let ment = elem as! Moment
                    let start = ment.start_time!
                    let end = ment.end_time!
                    let startText = dateToString(dateToElapsedDate(session.date!, end: start), elapsed: true)
                    let stopText = dateToString(dateToElapsedDate(session.date!, end: end), elapsed: true)
                    let elapsed = dateToString(dateToElapsedDate(start, end: end), elapsed: true)
                    bodyMessage += "\(startText)\t\(stopText)\t\(elapsed)\t\(ment.name!)\n"
                }
            }
            
            let mailCompose = MFMailComposeViewController()
            mailCompose.setSubject("ServiceTimeTracker Report")
            mailCompose.setMessageBody(bodyMessage, isHTML: false)
            mailCompose.mailComposeDelegate = self
            self.presentViewController(mailCompose, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: NSTimer methods
    
    func update() {
        timeLabel.text = elapsedTime(fromInterval: lastStart)
        momentTimeLabel.text = elapsedTime(fromInterval: lastMoment)
    }
    
    func startTimer() {
        if !timer.valid {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    //MARK: Session/Moment Methds
    
    func beginSession() {
        inSession = true
        lastStart = NSDate.timeIntervalSinceReferenceDate()
        lastMoment = NSDate.timeIntervalSinceReferenceDate()
        self.databaseBeginSession()
    }
    
    func endSession() {
        inSession = false
        saveDatabase()
    }
    
    func beginNewMoment() {
        insertMoment()
        momentTable.reloadData()
        lastMoment = NSDate.timeIntervalSinceReferenceDate()
    }
    
    //MARK: momentTableView Methods
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(12.0)
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = UIFont.systemFontOfSize(12)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let dbContext = getDatabaseContext() {
            do {
                let sessionFetch = NSFetchRequest(entityName: "Session")
                let sortDescripter = NSSortDescriptor(key: "id", ascending: false)
                sessionFetch.sortDescriptors = [sortDescripter]
                
                if let modelSessions = try dbContext.executeFetchRequest(sessionFetch) as? [Session] {
                    if var momentsArray = modelSessions[indexPath.section].moments?.array as? [Moment] {
                        momentsArray = momentsArray.reverse()
                        let moment = momentsArray[indexPath.row]
                        askForMomentName(moment)
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func askForMomentName(moment: Moment) {
        
        let alert = UIAlertController(title: "Moment", message: "Enter Name", preferredStyle: .Alert)
        let changeNameAction = UIAlertAction(title: "Ok", style: .Destructive) {
            action in
            if alert.textFields!.first!.text! != "" {
                moment.name = alert.textFields!.first!.text!
                self.momentTable.reloadData()
            }
        }
        
        alert.addAction(changeNameAction)
        alert.addTextFieldWithConfigurationHandler(nil)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Change Session Name
    
    func askForSessionName() {
        let alert = UIAlertController(title: "Session", message: "Enter Name", preferredStyle: .Alert)
        let changeNameAction = UIAlertAction(title: "Ok", style: .Destructive) {
            action in
            if alert.textFields!.first!.text! != "" {
                self.sessionId = alert.textFields!.first!.text!
            }
        }
        
        alert.addAction(changeNameAction)
        alert.addTextFieldWithConfigurationHandler(nil)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Database methods
    
    func setSessionId() {
        if let dbContext = getDatabaseContext() {
            do {
                let sessionFetch = NSFetchRequest(entityName: "Session")
                
                let results = try dbContext.executeFetchRequest(sessionFetch)
                sessionNumber = results.count
                sessionId = "\(sessionNamePrefix) \(sessionNumber)"
            } catch {
                print("Error accessing database: \(error)")
            }
        }
    }
    
    func databaseBeginSession() {
        if let dbContext = getDatabaseContext() {
            if let session1 = Session(insertIntoManagedObjectContext: dbContext) {
                setSessionId()
                askForSessionName()
                session1.id = NSNumber(integer: sessionNumber)
                session1.date = NSDate(timeIntervalSinceReferenceDate: lastStart)
            }
        }
    }
    
    func databaseDeleteSessions() {
        if let dbContext = getDatabaseContext() {
            if let sessions = getSessions() {
                for session in sessions {
                    dbContext.deleteObject(session)
                }
            }
        }
    }
    
    func getDatabaseContext() -> NSManagedObjectContext? {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            return delegate.managedObjectContext
        } else {
            return nil
        }
    }
    
    func insertMoment() {
        if let dbContext = getDatabaseContext() {
            
            let sessionFetch = NSFetchRequest(entityName: "Session")
            sessionFetch.predicate = NSPredicate(format: "id == %i", sessionNumber)
            
            let results = getSessions(sessionFetch)
            
            if let session = results!.first {
                session.name = sessionId
                
                if let ment = Moment(insertIntoManagedObjectContext: dbContext) {
                    ment.name = "initial"
                    ment.start_time = NSDate(timeIntervalSinceReferenceDate: lastMoment)
                    ment.end_time = NSDate()
                    session.addMoment(ment)
                }
            }
        }
    }
    
    func getSessions(fetchRequest: NSFetchRequest? = nil) -> [Session]? {
        if let dbContext = getDatabaseContext() {
            do {
                var request = fetchRequest
                if request == nil {
                    request = NSFetchRequest(entityName: "Session")
                }
                
                let results = try dbContext.executeFetchRequest(request!)
                if let sessions = results as? [Session] {
                    return sessions
                }
            } catch {
                print("Error: \(error)")
            }
        }
        return nil
    }
    
    func saveDatabase() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.saveContext()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

