//
//  ViewController.swift
//  Mesa
//
//  Created by Vibes on 4/25/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit
import Contentful
import Interstellar

var tooltipOpacity : CGFloat = 0

class ViewController: UIViewController, UIScrollViewDelegate, ItemViewDelegate, CartViewDelegate {
    
    var cart = Cart()
    
    @IBOutlet weak var orderButtonView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tapTooltip: UIImageView!
    
    @IBOutlet weak var orderCount: UILabel!
    
    @IBOutlet weak var catLabel: UILabel!
    
    @IBAction func orderTap(_ sender: Any) {
    
    }
    
    var sections = [Section]()
    var categories = [Category] ()
    var categoryText = ""
    var spaces = "            "
    var floater : CGFloat = 0
    var temp : CGFloat = 0
    var spaceCount : Int {
        return spaces.characters.count
    }
    var count = 0
    var currentDifference : CGFloat = 0.5
    
    var stringAttributed = NSMutableAttributedString.init(string: "")
    
    var spaceWidth : CGFloat {
        let myString: NSString = spaces as NSString
        let size: CGSize = myString.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18.0)])
        let width = size.width
        return width
    }
    
    @IBOutlet weak var categoryConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
                
        self.orderCount.text = "\(self.cart.items.count)"
        
        if !UserDefaults.standard.bool(forKey: "tooltipHasAppeared") {
            
            self.tapTooltip.alpha = 1
            UserDefaults.standard.set(true, forKey: "tooltipHasAppeared")
            
        }
        
        floater = self.view.frame.width/2
        
        self.catLabel.text = ""
        
        scrollView.delegate = self
        
        super.viewDidLoad()
        
        getCategories { (sections) in
            
            self.sections = sections
            
            DispatchQueue.main.async {
                
                let itemViews:[ItemView] = self.createItemViews()
                
                self.categoryConstraint.constant = self.floater - (self.categories[0].width/2)
                
                self.catLabel.text = self.categoryText
                
                self.stringAttributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.white.withAlphaComponent(1), range: NSRange.init(location: 0, length: self.categories[0].count))
                
                self.catLabel.attributedText = self.stringAttributed
                
                self.setupScrollView(itemViews: itemViews)
            }
            
        }
        
    }
    
    func createItemViews() -> [ItemView] {
        
        var itemViews : [ItemView] = []
        
        for x in 0..<sections.count {
            
            let section = sections[x]
            
            createCategoryLabel(name: section.name, x : x)
            
            let item:ItemView = Bundle.main.loadNibNamed("ItemView", owner: self, options: nil)?.first as! ItemView
            
            item.delegate = self
            
            for dish in section.items {
                
                item.ids.append(dish.id)
                item.names.append(dish.name)
                item.availables.append(dish.available)
                item.details.append(dish.details)
                item.imageURLs.append(dish.imageURL)
                item.prices.append(dish.price)
                item.items.append(dish)
            }
            
            item.currentItemCount = 1
            item.displayItem()
            
            itemViews.append(item)
            
        }
        
        self.stringAttributed = NSMutableAttributedString.init(string: categoryText)
        
        return itemViews
    }
    
    func setupScrollView( itemViews : [ItemView]) {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(itemViews.count), height: view.frame.height)
        
        scrollView.isPagingEnabled = true
        
        for i in 0..<itemViews.count {
            
            itemViews[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            
            scrollView.addSubview(itemViews[i])
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let relativePosition = scrollView.contentOffset.x/view.frame.width
        let primitivePosition = Int(relativePosition)
        let difference = Double(relativePosition) - Double(primitivePosition)
        let newDifference = CGFloat(difference/2 + 0.50)
        
        self.orderButtonView.alpha = 0
        
        if difference == 0 {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.orderButtonView.alpha = 1
            })
            
        }
        /*
         
         
         //        let diffDifference = 1.5 - newDifference
         
         //        var higher: CGFloat = newDifference
         //        var lower: CGFloat = diffDifference
         
         //        if newDifference > diffDifference {
         //            higher = newDifference
         //            lower = diffDifference } else {
         //            higher = diffDifference
         //            lower = newDifference
         //        }
         
         
         //        if newDifference > currentDifference {
         //
         //            higher = newDifference
         //            lower = diffDifference
         //
         //        } else {
         //
         //            higher = diffDifference
         //            lower = newDifference
         //        }
         //
         //        currentDifference = newDifference
         
         //        self.stringAttributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.white.withAlphaComponent(1), range: NSRange.init(location: 0, length: categoryText.characters.count ))
         //
         //        self.catLabel.attributedText = self.stringAttributed
         
         */
        
        if difference != 0 && primitivePosition < categories.count-1 {
            
            /*
             //            print(primitivePosition)
             
             // TRANSLUCENT PART BEFORE CURRENT CATEGORY
             //            self.stringAttributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.white.withAlphaComponent(diffDifference), range: NSRange.init(location: 0, length: self.categories[primitivePosition+1].startX ))
             
             //TRANSLUCENT PART POST CURRENT CATEGORY
             
             //let remaining = self.categoryText.characters.count - categories[primitivePosition].endX
             
             //  self.stringAttributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.white.withAlphaComponent(lower), range: NSRange.init(location: self.categories[primitivePosition].endX, length: remaining))
             */
            
            ////CURRENT CATEGORY
            self.stringAttributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.white.withAlphaComponent(newDifference), range: NSRange.init(location: self.categories[primitivePosition+1].startX, length: self.categories[primitivePosition+1].count ))
            
            self.catLabel.attributedText = self.stringAttributed
        }
        
        // MOVING THE LABEL'S X POSITION TO THE RIGHT CATEGORY
        
        if primitivePosition >= 0 && primitivePosition <= categories.count-2 {
            
            self.categoryConstraint.constant = self.categories[primitivePosition].centerX + (( self.categories[primitivePosition + 1].centerX - self.categories[primitivePosition].centerX) * CGFloat(relativePosition-CGFloat(primitivePosition)) )
            
        }
        
    }

    
    func createCategoryLabel( name : String, x : Int ) {
        
        let originalString: String = name
        let count = name.characters.count
        let myString: NSString = originalString as NSString
        let size: CGSize = myString.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18.0)])
        let width = size.width
        
        let startX = self.count
        let endX = self.count+count
        
        if x > 0 {
            
            self.temp += self.categories[x-1].width
        }
        
        let centerX =  self.floater - width/2 - (self.spaceWidth*CGFloat(x)) - self.temp
        
        let category = Category(name: name, count: count, width: width, centerX : centerX, startX : startX, endX : endX)
        categories.append(category)
        
        categoryText += name + spaces
        self.count += spaceCount + count
        
    }
    
    func removeTooltip() {
        
        UIView.animate(withDuration: 0.3) {
            self.tapTooltip.alpha = 0
        }
    }
    
    func updateItemCount() {
        
        self.orderCount.text = "\(Cart.shared.items.count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CartViewController {
            destination.delegate = self
        }
    }
    
}
