//
//  ShowMemeUIViewController.swift
//  MemeMe
//
//  Created by Yan Zverev on 7/6/16.
//  Copyright © 2016 Yan Zverev. All rights reserved.
//

import UIKit

class ShowMemeUIViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    var memeImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = memeImage
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
