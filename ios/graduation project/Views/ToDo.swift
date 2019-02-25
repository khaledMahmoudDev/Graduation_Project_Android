//
//  ToDo.swift
//  graduation project
//
//  Created by farah on 2/11/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class ToDo: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var orderedViewController: [UIViewController] = {
        return [self.newVc(viewController: "toDoList"),self.newVc(viewController: "done")]
    }()
    
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        if let firstViewController = orderedViewController.first{
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        self.delegate = self
        configurePagecontrol()
        
    }
    
    
    
    func configurePagecontrol ()
    {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50 , width: UIScreen.main.bounds.width, height: 50))
        
        pageControl.numberOfPages = orderedViewController.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
        
    }
    func newVc (viewController: String)-> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier : viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewController.index(of: viewController) else{
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else{
            //return orderedViewController.last // 3shn lw 3wza l scroll yfdl ylf
            return nil
        }
        
        guard orderedViewController.count > previousIndex else{
            return nil
        }
        
        return orderedViewController[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewController.index(of: viewController) else{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewController.count != nextIndex else{
            //return orderedViewController.first    // 3shn lw 3wza l view yfdl ylf
            return nil
        }
        
        guard orderedViewController.count > nextIndex else{
            return nil
        }
        
        return orderedViewController[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController =  pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewController.index(of: pageContentViewController)!
    }
    


}
