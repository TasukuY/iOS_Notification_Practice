//
//  ViewController.swift
//  Notification_Test
//
//  Created by Tasuku Yamamoto on 4/20/22.
//

import UIKit

class ViewController: UIViewController {

    let notificationManager = NotificationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("localNotificationFired"), object: nil, queue: OperationQueue.main) { [weak self] (note) in
            guard let userInfo = note.userInfo,
                  let message = userInfo["message"] as? String else { return }
            
            let alert = UIAlertController(title: "Local Notification", message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancel)
            
            DispatchQueue.main.async {
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func requestPermission(_ sender: Any) {
        notificationManager.requestPermission()
    }
    
    @IBAction func sendNotification(_ sender: Any) {
        notificationManager.fireNotification()
    }
    
    
}

