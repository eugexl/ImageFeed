//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 11.09.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        
        print("Profile View Load")
        
    }
    
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        
        print("Exiting ...")
    }
}
