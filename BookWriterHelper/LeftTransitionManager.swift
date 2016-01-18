//
//  TransitionManager.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/12/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class LeftTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var presenting = false
    var controller: String?
    var leftMenuViewController: AnyObject!
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // Анимация смены одного контролера на другой
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // получить ссылку на наш fromView, toView и вьюху-контейнер, в котором будет анимация
        let container = transitionContext.containerView()
        
        // создаем тупл экранов
        let screens : (from:UIViewController, to:UIViewController) = (
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!,
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        )
        
        // назначаем ссылки на наше topmenuviewcontroller и главный контроллер из тупла
        // в зависимости от переменной presenting надо переключаться между toView и fromView
        if self.controller == "note" {
            leftMenuViewController = !self.presenting ? screens.from as! LeftMenuViewController : screens.to as! LeftMenuNavViewController
        } else {
            leftMenuViewController = !self.presenting ? screens.from as! LeftMenuNavViewController : screens.to as! LeftMenuNavViewController
        }
        
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let topMenuView = (leftMenuViewController.view)!
        let bottomView = bottomViewController.view
        
        // создаем настройки для 2D преобразования, которые будут использованы в анимации
        let offScreenLeft = CGAffineTransformMakeTranslation(0, 0)
        let offScreenRight = CGAffineTransformMakeTranslation(-(container?.frame.width)!, 0)
        
        // готовим меню к появлению
        topMenuView!.transform = self.presenting ? offScreenRight : offScreenLeft
        
        // добавляем обе вьюхи в наш контроллер
        container!.addSubview(bottomView)
        container!.addSubview(topMenuView!)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: {
            topMenuView!.transform = !self.presenting ? offScreenRight : offScreenLeft
        }, completion: { finished in
            transitionContext.completeTransition(true)
            UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
        })
    }
    
    // Сколько секунд на анимацию
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // возвращает аниматора, когда ViewController появляется
    // NOTE: аниматор (или контролер анимации) это AnyObject, который наследуется от UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // возвращает аниматора, когда ViewController исчезает
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}
