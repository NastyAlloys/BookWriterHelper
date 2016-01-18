//
//  TopTransitionManager.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/14/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class TopTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var presenting = false
    
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
        let topMenuViewController = !self.presenting ? screens.from as! TopMenuViewController : screens.to as! TopMenuViewController
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController

        
        let topMenuView = topMenuViewController.view
        let bottomView = bottomViewController.view
        
        // создаем настройки для 2D преобразования, которые будут использованы в анимации
        let offScreenTop = CGAffineTransformMakeTranslation(0, 0)
        let offScreenBottom = CGAffineTransformMakeTranslation(0, -(container?.frame.height)!)
        
        // готовим меню к появлению
        topMenuView.transform = self.presenting ? offScreenBottom : offScreenTop
        
        // добавляем обе вьюхи в наш контроллер
        container!.addSubview(bottomView)
        container!.addSubview(topMenuView)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: {
            
                topMenuView.transform = self.presenting ? offScreenTop : offScreenBottom
            
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
