//
//  LoginViewController.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/9/24.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var cookieeTypo: UIImageView!
    @IBOutlet weak var cookieeIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cookieeIcon.image = UIImage(named: "CookieeIcon.png")
        cookieeTypo.image = UIImage(named: "cookiee_typography.png")
    }


}
