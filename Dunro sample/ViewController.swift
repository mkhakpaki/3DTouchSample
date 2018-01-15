//
//  ViewController.swift
//  Dunro sample
//
//  Created by Mohammad Khakpaki on 1/14/18.
//  Copyright © 2018 MKH. All rights reserved.
//

import UIKit

class ColorFullCell: UICollectionViewCell {
    
}
class tableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    func setCollectionViewTag(indexPath:IndexPath)
    {
        self.collectionView.tag=indexPath.row
        self.collectionView.reloadData()
    }
}
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UIViewControllerPreviewingDelegate {
    @IBOutlet weak var containerTableView: UITableView!
    var alertController: UIAlertController?
    //array for colors of rows and columns
     var colors = [[UIColor]](repeating: [UIColor](repeating: UIColor.blue, count: 50), count: 100)
    override func loadView() {
        super.loadView()
        // initing array of colors with random colors
        for i in 0 ..< 100 {
            for j in 0..<50 {
                colors[i][j] = UIColor(red: randomColorNumber(), green:  randomColorNumber(), blue:  randomColorNumber(),alpha:1)
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            // register UIViewControllerPreviewingDelegate to enable Peek & Pop
            registerForPreviewing(with: self, sourceView: view)
        }else {
            // 3DTouch Unavailable : present alertController
            print( "3DTouch Unavailable")
        }
    }
    
    //previewing cell
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
                //converting location to be can used in our containertableview system
        let pointForTableView = self.view.convert(location, to: containerTableView)
        //finding tableviewindex path for our converted location
        guard let tableViewindexPath = self.containerTableView?.indexPathForRow(at: pointForTableView) else {return nil}
        //finding tableview cell at founded indexpath
       guard let tableViewCell = self.containerTableView.cellForRow(at: tableViewindexPath)
        else{return nil}
        //casting tableview cell as our custom class
        let ourCell = tableViewCell as! tableViewCell
        //finding point that can be used in cells collectionview
        let pointForCollectionViewCell = self.containerTableView.convert(pointForTableView, to: ourCell.collectionView)
        //finding indexpath for collectionview from founded point
        guard let collectionViewIndexPath = ourCell.collectionView?.indexPathForItem(at: pointForCollectionViewCell) else {return nil }
        //finding collectionview cell from collectionview indexpath
        guard let cell = ourCell.collectionView.cellForItem(at: collectionViewIndexPath) else {return nil}
        //collection view cell attributes
        guard let cellAttributes = ourCell.collectionView.layoutAttributesForItem(at: collectionViewIndexPath) else {return nil}
        //casting view controller and setting background color
        guard let fullColorViewController = storyboard?.instantiateViewController(withIdentifier: "fullColorViewController") as? FullColorViewController else {return nil }
        fullColorViewController.BGColor=cell.contentView.backgroundColor!
        //setting previewingContext.sourceRect by converting cell attribute can be work in main view
        previewingContext.sourceRect = self.view.convert(cellAttributes.frame, from: ourCell.collectionView)
        return fullColorViewController
        }
    //popping cell
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
          self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
       //start tableview functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "tableViewCell",
            for: indexPath) as! tableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let our_cell=cell as! tableViewCell
        our_cell.setCollectionViewTag(indexPath: indexPath)
        
    }
    //start collection view functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorFullCell
        cell.contentView.backgroundColor = colors[collectionView.tag][indexPath.row]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFullColorSegue", sender: colors[collectionView.tag][indexPath.row])
       collectionView.deselectItem(at: indexPath, animated: false)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height:75)
    }
    //preparing for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //setting background color at secondViewController
        if segue.identifier=="showFullColorSegue"
        {
            let secondVC = segue.destination as? FullColorViewController
            let BGColor = sender as! UIColor // we know sender is UIColor here
            secondVC?.BGColor=BGColor
            
        }

    }
    //generating random number
    func randomColorNumber() -> CGFloat{
            let randomNum:UInt32 = arc4random_uniform(255)
            let _:TimeInterval = TimeInterval(randomNum)
            let randomInt:Int = Int(randomNum)
            let colorNum:CGFloat=CGFloat(randomInt)/255
            return colorNum
    }
}

