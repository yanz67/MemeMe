//
//  ShowCollectionViewSavedMemesUIViewController.swift
//  MemeMe
//
//  Created by Yan Zverev on 7/6/16.
//  Copyright © 2016 Yan Zverev. All rights reserved.
//

import UIKit

class ShowCollectionViewSavedMemesUIViewController: UIViewController, CreateMemeDelegate
{
    var savedMemesModel = SavedMemesModel.sharedInstance
    
    @IBOutlet weak var savedMemeCollectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //savedMemeCollectionView.delegate = self
        //savedMemeCollectionView.dataSource = self
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        if savedMemesModel.count() != savedMemeCollectionView.numberOfItemsInSection(0){
            // in case memes added in table view tab collectionview will reload
            savedMemeCollectionView.reloadData()
        }
        
    }
    
    //MARK: CollectionView Datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMemesModel.count()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let memeModel = savedMemesModel.getMemeForIndex(indexPath.row)
        cell.memeImageView.image = memeModel?.memeImage
        
        return cell
    }
    
    //MARK: prepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "addMeme" {
            
            if let dvc = segue.destinationViewController as? MemeUIViewController {
                dvc.delegate = self
            }
        } else if segue.identifier == "showMeme" {
            if let dvc = segue.destinationViewController as? ShowMemeUIViewController {
                if let cellIndex = savedMemeCollectionView.indexPathForCell(sender as! MemeCollectionViewCell) {
                    dvc.memeImage = savedMemesModel.getMemeForIndex(cellIndex.row)?.memeImage
                }
            }
        }
    }
    
    
    //MARK: CreateMemeDelgate
    func memeDidCreate(memeModel: MemeModel)
    {
        savedMemesModel.saveMeme(memeModel)
        dismissViewControllerAnimated(true) {
            self.savedMemeCollectionView.reloadData()
        }
    }
    func memeCancelCreate()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
