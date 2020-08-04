//
//  MemeDetailViewController.swift
//  MemeMe1
//
//  Created by Jonathan Glaser on 2/23/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeDetail: MemeStruct.Meme!
    
    @IBOutlet weak var savedMemeImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.savedMemeImage!.image = memeDetail.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
}
