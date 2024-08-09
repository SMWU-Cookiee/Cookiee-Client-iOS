//
//  LoginViewController.swift
//  Cookiee
//
//  Created by minseo Kyung on 8/9/24.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var cookieeTypo: UIImageView!
    @IBOutlet weak var cookieeIcon: UIImageView!
    
    override func viewDidLoad() {
          super.viewDidLoad()
          // Do any additional setup after loading the view.
          
          if let iconImage = UIImage(named: "CookieeIcon.png") {
              let resizedIconImage = iconImage.resize(newWidth: 184)
              cookieeIcon.image = resizedIconImage
          }

          if let typoImage = UIImage(named: "cookiee_typography.png") {
              let resizedTypoImage = typoImage.resize(newWidth: 259)
              cookieeTypo.image = resizedTypoImage
          }

            if let loginButtonImage = UIImage(named: "loginWithAppleButton.png") {
                let resizedLoginButtonImage = loginButtonImage.resize(newWidth: 265)
                appleLoginButton.setBackgroundImage(resizedLoginButtonImage, for: .normal)
            }
      }
  }

  extension UIImage {
      func resize(newWidth: CGFloat) -> UIImage {
          let scale = newWidth / self.size.width
          let newHeight = self.size.height * scale

          let size = CGSize(width: newWidth, height: newHeight)
          let render = UIGraphicsImageRenderer(size: size)
          let renderImage = render.image { context in
              self.draw(in: CGRect(origin: .zero, size: size))
          }
          
          return renderImage
      }
  }
