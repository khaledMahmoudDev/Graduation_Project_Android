//
//  ToDo.swift
//  graduation project
//
//  Created by farah on 2/11/19.
//  Copyright © 2019 Ajenda. All rights reserved.
//

import UIKit

class ToDo: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    

    lazy var subViewControllers : [UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toDoList") as! ToDoList,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "done") as! DoneList ]}()
    
    
    
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)

    }
    
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex : Int = subViewControllers.index(of : viewController) ?? 0
        if (currentIndex <= 0){
                return nil
            }
        
        return subViewControllers[currentIndex - 1]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       let currentIndex : Int = subViewControllers.index(of : viewController) ?? 0
        if(currentIndex >= subViewControllers.count - 1){
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
    
}
