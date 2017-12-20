//
//  ST_Segment.swift
//  ST_Segment
//
//  Created by Alpha on 2017/12/19.
//  Copyright © 2017年 STT. All rights reserved.
//

import UIKit

class ST_Segment: UIView {
    
  // MARK : 可配置参数
  public  var  titleFont : UIFont = UIFont.systemFont(ofSize: 15)
  public  var  titleColor : UIColor = UIColor.black
  public var   titleSelectColor = UIColor.red
  public  var  lineShow : Bool = true
  public  var  space : CGFloat = 10
  public  var  lineHeight : CGFloat = 1
  public  var  lineColor : UIColor = UIColor.red
    // MARK : 不可配置参数
    private var  lastIndex : Int = 0
    private var  callBack : ((_ index : Int) -> Void)?
    private var fromViewController : UIViewController?
    private  var bottomLine : UIView?
    lazy private var buttonArray :[UIButton] = {
        return [UIButton]()
    }()
   private var scrollView : UIScrollView = {
        let  myScr = UIScrollView.init()
        myScr.isPagingEnabled = true
        myScr.bounces = false
        myScr.showsVerticalScrollIndicator = false
        myScr.showsHorizontalScrollIndicator = false
        return myScr
    }()
    
   public   func setViewController(viewController: UIViewController , titleArray: [String] ,viewControllers: [UIViewController] ,callBack: @escaping (_ index : Int) -> Void){
        self.fromViewController = viewController
        viewController.navigationItem.titleView = setNavigationView(titleArray: titleArray)
        setScrollView(viewControllers: viewControllers)
        self.callBack = callBack
    }
    
    
    private  func setNavigationView(titleArray : [String]) -> UIView {
        let view =  UIView.init()
        view.frame = CGRect(x:0,y: 0,width:0,height:44)
        let frame = view.frame
        let height = frame.size.height
        var lastPointx = CGFloat(0)
        for  (index ,item) in titleArray.enumerated() {
            let titleBut = UIButton.init(type: .custom)
            view.addSubview(titleBut)
            let width = getWidthWithString(string: item)
            titleBut.titleLabel?.font = titleFont
            titleBut.frame = CGRect(x:lastPointx ,y : 0 , width:width,height:44)
            titleBut.setTitle(item, for: .normal)
            titleBut.addTarget(self, action: #selector(titleButtonAction(but:)), for: .touchUpInside)
            titleBut.setTitleColor(titleColor, for: .normal)
            titleBut.setTitleColor(titleSelectColor, for: .selected)
            titleBut.tag = 100 + index
            lastPointx = titleBut.frame.maxX +  space
            if index == 0 {
                titleBut.isSelected = true
            }
            buttonArray.append(titleBut)
        }
        bottomLine = UIView()
        guard  let bottom = bottomLine else {
            return view
        }
        let firstString = titleArray[0]
        let firstLineW = getWidthWithString(string: firstString)
        bottom.backgroundColor = lineColor
        bottom.frame =  CGRect(x: 0 ,y: height - 2,width:firstLineW,height:2)
        view.addSubview(bottom)
        view.frame.size.width = lastPointx
        if !lineShow  {
            bottom.isHidden = true
        }
        return view
    }
    
    private func getWidthWithString(string : String) -> CGFloat{
        return (string as NSString).size(withAttributes: [NSAttributedStringKey.font : titleFont]).width
    }
    
    private func setScrollView(viewControllers:[UIViewController]){
        let width = UIScreen.main.bounds.size.width
        let height = fromViewController?.view.frame.size.height
        scrollView.frame = self.bounds
        self.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.blue
        for  (index,item) in viewControllers.enumerated() {
            guard let subView =  item.view else {
                return
            }
            subView.frame = CGRect(x: width * CGFloat(index) ,y:0 ,width : width,height : scrollView.frame.size.height)
            scrollView.addSubview(subView)
            fromViewController?.addChildViewController(item)
        }
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: width * CGFloat(viewControllers.count) , height : height!)
        
    }
    
    @objc private func titleButtonAction(but :UIButton) {
        for (index ,item) in buttonArray.enumerated() {
            item.isSelected = false
        }
        but.isSelected = true
        guard let titleString = but.titleLabel?.text else {
            return
        }
        let index = but.tag - 100
        let scrW = UIScreen.main.bounds.size.width
        let width = getWidthWithString(string: titleString)
        UIView.animate(withDuration: 1.0, animations:  {
            self.bottomLine?.frame.origin.x = but.frame.origin.x
            self.bottomLine?.frame.size.width = width
            self.scrollView.contentOffset = CGPoint(x : scrW * CGFloat(index),y:0)
            if self.lastIndex != index {
                self.lastIndex = index
                if let callBack = self.callBack{
                    callBack(index)
                }
            }
        })
    }
}

extension ST_Segment : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.contentOffset.x
        let scrW = scrollView.frame.size.width
        let index = Int( width/scrW)
        let butt = buttonArray[index]
        titleButtonAction(but: butt)
    }
}

