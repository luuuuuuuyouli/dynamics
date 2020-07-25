//
//  ViewController.swift
//  iOS碰撞
//
//  Created by syong on 2020/6/17.
//  Copyright © 2020 com.eios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var mask: UIView!
    
    var newView: UIView!

    var animator:UIDynamicAnimator?
    
    var timer:Timer?
    
    var foodsArray = [UIView]()
    
    var collisionBehavior:UICollisionBehavior!
    
    var gravity:UIGravityBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        mask = UIView.init(frame: CGRect.init(x: 30, y: 0, width: 30, height: 30))
        mask.backgroundColor = UIColor.clear
        mask.layer.cornerRadius = 15
        mask.layer.masksToBounds = true
        self.view.addSubview(mask)
        
        
        newView = UIView.init(frame: CGRect.init(x: 30, y: 500, width: 100, height: 100))
        newView.backgroundColor = UIColor.blue
       // newView.layer.cornerRadius = 50
        newView.layer.masksToBounds = true
        self.view.addSubview(newView)
        
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panMove(pan:)))
        newView.addGestureRecognizer(pan)
        
        //构造力学元素
        animator = UIDynamicAnimator.init(referenceView: self.view)
//
//        //设置重力
         gravity = UIGravityBehavior.init(items: [mask])
//        //设置角度
//      //  gravity.angle = CGFloat(Double.pi)
//        //设置重力大小
        gravity.magnitude = 1
//        animator?.addBehavior(gravity)
        
        //设置碰撞
        collisionBehavior = UICollisionBehavior.init(items: [mask])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self
        collisionBehavior.collisionMode = .everything

        collisionBehavior.addBoundary(withIdentifier: "food" as NSCopying, for: UIBezierPath.init(rect: newView.frame))
        animator?.addBehavior(collisionBehavior!)

        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(addNewMask), userInfo: nil, repeats: true)
        timer?.fireDate = Date.distantPast
        
    }
    
    @objc func addNewMask(){
        
    //    let Xnum = Int.randomIntNumber(lower: 0, upper: 300)
        
        let redView = UIView.init(frame: CGRect.init(x: 100, y: 0, width: 80, height: 30))
        redView.backgroundColor = UIColor.red
       // redView.layer.cornerRadius = 15
        redView.layer.masksToBounds = true
        self.view.addSubview(redView)
        foodsArray.append(redView)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        redView.addGestureRecognizer(tap)
        
        gravity.addItem(redView)
        animator?.addBehavior(gravity)
        collisionBehavior.addItem(redView)
       animator?.addBehavior(collisionBehavior)
    }
    
    @objc func panMove(pan:UIPanGestureRecognizer){
            
        let point = pan.translation(in: pan.view)
        pan.view?.center = CGPoint.init(x: (pan.view?.center.x ?? 0) + point.x, y: (pan.view?.center.y ?? 0) + point.y)
        pan.setTranslation(CGPoint.zero, in: pan.view)
        toBoundary()
    }
    
    func toBoundary(){
        collisionBehavior.removeBoundary(withIdentifier: "food" as NSCopying)
        collisionBehavior.addBoundary(withIdentifier: "food" as NSCopying, for: UIBezierPath.init(rect: newView.frame))
        
    }
    
    @objc func tapClick(){
        print("1111")
    }

}

extension ViewController:UICollisionBehaviorDelegate{
    
    public func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
      
        if identifier == nil{
            
        }else if identifier as! String == "food" {
//            collisionBehavior.removeItem(item)
//            behavior.removeItem(item)
//            (item as! UIView).removeFromSuperview()
//            if foodsArray.count > 0 {
//                foodsArray.removeFirst()
//            }
        }
        
    }
    
    public func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {

    }
}

public extension Int {
    /*这是一个内置函数
     lower : 内置为 0，可根据自己要获取的随机数进行修改。
     upper : 内置为 UInt32.max 的最大值，这里防止转化越界，造成的崩溃。
     返回的结果： [lower,upper) 之间的半开半闭区间的数。
     */
    static func randomIntNumber(lower: Int = 0,upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    /**
     生成某个区间的随机数
     */
     static func randomIntNumber(range: Range<Int>) -> Int {
        return randomIntNumber(lower: range.lowerBound, upper: range.upperBound)
    }
}


