//
//  MemeDetilesView.swift
//  MeMe1
//
//  Created by Ghaidaa Alfayez on 20/02/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit


class MemeDetilesView: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let meme = meme else {
            let alert = UIAlertController(title: "Error", message: "Meme is nil", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        imageView.image = meme.memedImage
    }
    
}
