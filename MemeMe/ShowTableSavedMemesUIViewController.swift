//
//  SavedMemeUIViewController.swift
//  MemeMe
//
//  Created by Yan Zverev on 7/6/16.
//  Copyright © 2016 Yan Zverev. All rights reserved.
//

import Foundation
import UIKit

class ShowTableSavedMemesUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateMemeDelegate
{
    let savedMemesModel = SavedMemesModel.sharedInstance
    
    @IBOutlet weak var savedMemeTableView: UITableView!
    
    
    //MARK: UIViewController LifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        savedMemeTableView.delegate = self
        savedMemeTableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        if savedMemesModel.count() != savedMemeTableView.numberOfRowsInSection(0) {
            // in case memes added in collection view tab table will reload
            savedMemeTableView.reloadData()
        }
        
    }
    
    
    //MARK: SavedMemeTableView Datasource functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // this tableView will only have one section
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedMemesModel.count()
    }
    
    //MARK: SavedMemeTableView Delegate functions
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let memeCell = tableView.dequeueReusableCellWithIdentifier("memeInfoCell")
        
        let memeModel = savedMemesModel.getMemeForIndex(indexPath.row)
        memeCell?.imageView?.image = memeModel?.memeImage
        memeCell?.textLabel?.text = "\(memeModel!.topText)...\(memeModel!.bottomText)"
        
        return memeCell!
        
    }
    
    //MARK: Prepare 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
    
        if segue.identifier == "addMeme" {
            
            if let dvc = segue.destinationViewController as? MemeUIViewController {
                dvc.delegate = self
            }
        } else if segue.identifier == "showMeme" {
            if let dvc = segue.destinationViewController as? ShowMemeUIViewController {
                if let cellIndex = savedMemeTableView.indexPathForCell(sender as! UITableViewCell) {
                    savedMemeTableView.deselectRowAtIndexPath(cellIndex, animated: true)
                    if let memeModel = savedMemesModel.getMemeForIndex(cellIndex.row) {
                        dvc.memeImage = memeModel.memeImage
                    }
                }
            }
        }
    }
    
    //MARK CreateMemeDelgate
    func memeDidCreate(memeModel: MemeModel)
    {
        savedMemesModel.saveMeme(memeModel)
        dismissViewControllerAnimated(true) { 
            self.savedMemeTableView.reloadData()
        }
    }
    func memeCancelCreate()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
