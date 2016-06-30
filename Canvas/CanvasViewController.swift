//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Héctor J. Vázquez on 6/30/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    
    @IBOutlet weak var arrowView: UIImageView!
    var trayOriginalCenter: CGPoint!
    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    
    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        if sender.state == UIGestureRecognizerState.Began{
            trayOriginalCenter = trayView.center
        }else if sender.state == UIGestureRecognizerState.Changed{
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
            
            
        }else if sender.state == UIGestureRecognizerState.Ended{
            var velocity = sender.velocityInView(view)
            if velocity.y > 0 {
                UIView.animateWithDuration(0.4, animations: { 
                    self.trayView.center = self.trayDown
                })
                let rotation = 3.14
                arrowView.transform = CGAffineTransformRotate(arrowView.transform, 3.14)
                
            } else {
                self.trayView.center = self.trayUp
                arrowView.transform = CGAffineTransformRotate(arrowView.transform, 3.14)
            }
        }
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @IBAction func didPanFace(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        if sender.state == UIGestureRecognizerState.Began{
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            self.newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        
            newlyCreatedFace.transform = CGAffineTransformScale(newlyCreatedFace.transform, 1.2, 1.2)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CanvasViewController.onCustomPan(_:)))
            newlyCreatedFace.userInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(CanvasViewController.onCustomPinch(_:)))
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            pinchGestureRecognizer.delegate = self
//            gestureRecognizer(panGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer: pinchGestureRecognizer)
            let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(CanvasViewController.onCustomRotate(_:)))
            newlyCreatedFace.addGestureRecognizer(rotationGestureRecognizer)
            rotationGestureRecognizer.delegate = self
            
            
        } else if sender.state == UIGestureRecognizerState.Changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }else if sender.state == UIGestureRecognizerState.Ended{
            
        }
        
    }
    
    func onCustomRotate(sender: UIRotationGestureRecognizer){
        let rotation = sender.rotation
        let newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.transform = CGAffineTransformRotate(newlyCreatedFace.transform, rotation)
        sender.rotation = 0
    }
    
    func onCustomPinch(sender: UIPinchGestureRecognizer){
        let scale = sender.scale
        newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.transform = CGAffineTransformScale(newlyCreatedFace.transform, scale, scale)
         sender.scale = 1

       
    }
    
    func onCustomPan(sender: UIPanGestureRecognizer){
        let translation = sender.translationInView(view)
        if sender.state == UIGestureRecognizerState.Began{
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            
        }else if sender.state == UIGestureRecognizerState.Changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }else if sender.state == UIGestureRecognizerState.Ended{
            
        }
    }
    

    override func viewDidLoad(){
        super.viewDidLoad()
        
        trayDownOffset = 160
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)
        
    }
    
    
}
