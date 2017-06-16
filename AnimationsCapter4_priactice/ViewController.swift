//
//  ViewController.swift
//  AnimationsCapter4_priactice
//
//  Created by 刘璐璐 on 2017/6/15.
//  Copyright © 2017年 LLL. All rights reserved.
//

import UIKit

enum AnimationDirection : Int{
    case positive = 1
    case negative = -1
}

class ViewController: UIViewController {
    
    var snowView:SnowView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var flightStatus: UILabel!
    @IBOutlet weak var arrivingTo: UILabel!
    @IBOutlet weak var departingFrom: UILabel!
    @IBOutlet weak var planeImage: UIImageView!
    @IBOutlet weak var fligntNr: UILabel!
    @IBOutlet weak var gateNr: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var summaryicon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summary.addSubview(summaryicon)
        summaryicon.center.y = summary.frame.height / 2
        
        snowView = SnowView(frame: CGRect(x: -150, y: -100, width: 300, height: 50))
        let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 70))
        snowClipView.clipsToBounds = true
        snowClipView.addSubview(snowView!)
        view.addSubview(snowClipView)
        
        changeFlight(to: londonToParis, animated: true)
          // Do any additional setup after loading the view, typically from a nib.
    }
    func fade(imageView: UIImageView, toImage: UIImage, showEffects:Bool)  {
        UIView.transition(with: imageView, duration: 1.0, options: .transitionCrossDissolve, animations: { 
            imageView.image = toImage
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: { 
            self.snowView?.alpha = showEffects ? 1.0 : 0.0
        }, completion: nil)
        
        
    }
    func changeFlight(to data:FlightData, animated: Bool = false) {
//        bgImageView.image = UIImage(named: data.weatherImageName)
//        snowView?.isHidden = !data.showWeatherEffects
        
        if animated {
            planeDepart()
            summarySwitchTo(data.summary)
            fade(imageView: bgImageView, toImage: UIImage(named: data.weatherImageName)!, showEffects: data.showWeatherEffects)
            
             let direction: AnimationDirection = data.isTakingOff ? AnimationDirection.positive : AnimationDirection.negative
            cubeTransition(label: fligntNr, text: data.flightNr, direction: direction)
            cubeTransition(label: gateNr, text: data.gateNr, direction: direction)
            cubeTransition(label: flightStatus, text: data.flightStatus, direction: direction)
            
            let offsetDeparting = CGPoint(x: CGFloat(direction.rawValue * 80), y: 0.0)
            let offsetArriving = CGPoint(x: 0.0, y: CGFloat(direction.rawValue * 50))
            
            moveLabel(departingFrom, text: data.departingFrom, offset: offsetDeparting)
            moveLabel(arrivingTo, text: data.arrivingTo, offset: offsetArriving)
            
            
            
            
        } else {
            summary.text = data.summary
            fligntNr.text = data.flightNr
            gateNr.text = data.gateNr
            departingFrom.text = data.departingFrom
            arrivingTo.text = data.arrivingTo
            flightStatus.text = data.flightStatus
            bgImageView.image = UIImage(named: data.weatherImageName)
            snowView?.isHidden = !data.showWeatherEffects
            
            snowView.isHidden = !data.showWeatherEffects
        }
        
        delay(seconds: 3.0) { 
            self.changeFlight(to: data.isTakingOff ? parisToRome : londonToParis, animated: true)
        }
        
        
    }
    func moveLabel(_ label: UILabel, text: String, offset: CGPoint) {
    
    // 11.1.自定义一个UILabel, 位置大小和传入进来的Label位置大小一致
    let auxLabel = UILabel(frame: label.frame)
    // 11.2.获取传入进来的text内容
    auxLabel.text = text
    // 11.3.获取传入进来的Label文字大小
    auxLabel.font = label.font
    // 11.4.获取传入进来的Label文字位置
    auxLabel.textAlignment = label.textAlignment
    // 11.5.获取传入进来的Label文字颜色
    auxLabel.textColor = label.textColor
    // 11.6.设置auxLabel的背景颜色
    auxLabel.backgroundColor = UIColor.clear
    // 11.7.设置auxLabel的transform属性为传入进来的offset的x轴和y轴
    auxLabel.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
    // 11.8.设置auxLabel的透明度
    auxLabel.alpha = 0
    // 11.9.把设置好的auxLabel添加到view上
    view.addSubview(auxLabel)
    
    // 11.10.自定义animateWithDuration动画, 设置开始时间, 延迟时间, 动画类型, 开始动画
    UIView.animate(withDuration: 0.5, delay: 0.0,
    options: .curveEaseIn, animations: {
    // 11.10.1.设置传入进来的Label的transform属性为传入进来的offset的x轴和y轴
    label.transform = CGAffineTransform(
    translationX: offset.x, y: offset.y)
    // 11.10.2.设置传入进来的Label透明度
    label.alpha = 0.0
    }, completion: nil)
    
    // 11.11.自定义animateWithDuration动画, 设置开始时间, 延迟时间, 动画类型, 开始动画
    UIView.animate(withDuration: 0.25, delay: 0.1,
    options: .curveEaseIn, animations: {
    // 11.11.1.设置传入进来的Label的transform属性为传入进来的offset的x轴和y轴
    auxLabel.transform = CGAffineTransform.identity
    // 11.11.2.设置传入进来的Label透明度
    auxLabel.alpha = 1.0
    
    // 11.12.完成动画之后的操作
    }, completion: {_ in
    // 11.12.1.把auxLabel从Superview中删除
    auxLabel.removeFromSuperview()
    // 11.12.2.把传入进来的text赋值给传入进来的label.text
    label.text = text
    // 11.12.3.设置传入进来的label透明度
    label.alpha = 1.0
    // 11.12.4.设置传入进来的label的transform属性为恒等转变
    label.transform = CGAffineTransform.identity
    })
    }
    //自定义飞机动画
    func planeDepart() {
        let originalCenter = planeImage.center
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                self.planeImage.center.x += 80
                self.planeImage.center.y -= 10
            })
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4, animations: { 
                self.planeImage.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 8))
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: { 
                self.planeImage.center.x += 100
                self.planeImage.center.y -= 50
                self.planeImage.alpha = 0.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01, animations: { 
                self.planeImage.transform = CGAffineTransform.identity
                self.planeImage.center = CGPoint(x: 0.0, y: originalCenter.y)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: { 
                self.planeImage.alpha = 1.0
                self.planeImage.center = originalCenter
            })
        }, completion: nil)
        
    }
    
    //9.自定义切换动画
    func summarySwitchTo(_ summaryText: String) {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [], animations: { 
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.45, animations: { 
                self.summary.center.y -= 100
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.45, animations: { 
                self.summary.center.y += 100
            })
            
        }, completion: nil)
        delay(seconds: 0.5) { 
            self.summary.text = summaryText
        }
    }
    
    //自定义动画延迟的方法
    func delay(seconds: Double, completion:@escaping () ->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) { 
            completion()
        }
        
    }
    
    func cubeTransition(label: UILabel, text: String, direction: AnimationDirection) {
        let auxLable = UILabel(frame: label.frame)
        auxLable.text = text
        auxLable.font = label.font
        auxLable.textAlignment = label.textAlignment
        auxLable.textColor = label.textColor
        auxLable.backgroundColor = UIColor.clear
        
        let auxLabelOffset = CGFloat(direction.rawValue) * label.frame.size.height / 2.0
        auxLable.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: auxLabelOffset))
        label.superview!.addSubview(auxLable)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { 
            auxLable.transform = CGAffineTransform.identity
            label.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: -auxLabelOffset))
            
        }, completion: { _ in
            label.text = auxLable.text
            label.transform = CGAffineTransform.identity
            auxLable.removeFromSuperview()
        })
        
        
    }
    


}

