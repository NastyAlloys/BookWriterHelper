//
//  BottomTransitionManager.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/14/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class BottomTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // Анимация смены одного контролера на другой
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // TODO: запустить анимацию
        
        // получить ссылку на наш fromView, toView и вьюху-контейнер, в котором будет анимация
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        // создаем настройки для 2D преобразования, которые будут использованы в анимации
        let offScreenRight = CGAffineTransformMakeTranslation((container?.frame.width)!, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(0 - (container?.frame.width)!, 0)
        
        // начать анимацию toView к правой стороне экрана
        toView?.transform = offScreenRight
        
        // добавить обе вьюхи на наш viewcontroller
        container?.addSubview(toView!)
        container?.addSubview(fromView!)
        
        // получаем время анимации
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        
        // АНИМИРУЕМ!
        // также используем блок-анимацию usingSpringWithDamping для небольшого отскока
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            // fromView пихается на экран, toView - всовыввается в контэйнер
            fromView?.transform = offScreenLeft
            toView?.transform = CGAffineTransformIdentity
            }, completion: { finished in
                // говорим нашему объекту transitionContext, что мы закончили анимацию
                transitionContext.completeTransition(true)
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
        return self
    }
    
    // возвращает аниматора, когда ViewController исчезает
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

}
