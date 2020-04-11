//
//  ViewController.swift
//  IOS-Swift-UICollectionViewDynamicCustom
//
//  Created by Pooya on 2018-09-25.
//  Copyright © 2018 Pooya. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView : UICollectionView!
    var colectionArr : [String] = ["1","2","3","4"]
    let titlesF = [("Apple"),("Apricot"),("Banana"),("Grapes"),("Kiwi"),("Orange"),("Peach")]
    let desF = [("$5.00"), ("$25.00"), ("$50.00"), ("$7.00"), ("$13.00"), ("$25.00"), ("$10.00")]
    let imagesF = [UIImage(named: "apple"),
                   UIImage(named: "apricot"),
                   UIImage(named: "banana"),
                   UIImage(named: "grapes"),
                   UIImage(named: "kiwi"),
                   UIImage(named: "orange"),
                   UIImage(named: "peach")]
    
    
    // multiple number to creat font size based on device screen size
    let relativeFontWelcomeTitle:CGFloat = 0.045
    let relativeFontButton:CGFloat = 0.060
    let relativeFontCellTitle:CGFloat = 0.023
    let relativeFontCellDescription:CGFloat = 0.015

    
    var company : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate and dataSource
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.backgroundColor = UIColor.green
        
    }


    // UICollectionViewDelegate, UICollectionViewDataSource functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesF.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    
        //let thisElement = colectionArr[indexPath.item]
        let cellIndex = indexPath.item
        let closeFrameSize = bestFrameSize()

        
        cell.imageCell.image = imagesF[cellIndex]
        cell.labelTitle.text = titlesF[cellIndex]
        cell.labelTitle.font = cell.labelTitle.font.withSize(closeFrameSize * relativeFontCellTitle)
        cell.labelDetails.text =  desF[cellIndex]
        cell.labelDetails.font = cell.labelDetails.font.withSize(closeFrameSize * relativeFontCellDescription)
        
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 2
        
        
        cell.contentView.layer.borderColor = UIColor.white.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.lightGray

        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        
        
        return cell
    }
   
    
    func bestFrameSize() -> CGFloat {
        let frameHeight = self.view.frame.height
        let frameWidth = self.view.frame.width
        let bestFrameSize = (frameHeight > frameWidth ) ? frameHeight : frameWidth
        
        return bestFrameSize
    }
    
}



// extention for UICollectionViewDelegateFlowLayout
extension ProductViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let heightVal = self.view.frame.height
        let widthVal = self.view.frame.width
        let cellsize = (heightVal < widthVal) ?  bounds.height/2 : bounds.width/2
        
        return CGSize(width: cellsize-10 , height:  cellsize-10  )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}//end of extension  ViewController
