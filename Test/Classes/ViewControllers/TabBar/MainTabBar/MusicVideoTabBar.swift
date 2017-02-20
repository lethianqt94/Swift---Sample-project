//
//  MusicVideoTabBar.swift
//  Test
//
//  Created by Le Thi An on 12/3/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import UIKit

class MusicVideoTabBar: UITabBarController, UITabBarControllerDelegate, UITextFieldDelegate {

//    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
        self.initTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: Tabbar
    
    func initTabBar() -> Void {
        self.navigationController?.navigationBarHidden = true
        
        self.tabBar.backgroundColor = UIColor.whiteColor()
        self.tabBar.barTintColor = UIColor.whiteColor()
        
        let photo = UITabBarItem(title: "", image: UIImage(named: "img_photo_tab"), tag: 0)
        let music = UITabBarItem(title: "", image: UIImage(named: "img_music_tab"), tag: 1)
        let video = UITabBarItem(title: "", image: UIImage(named: "img_video_tab"), tag: 2)
        let book = UITabBarItem(title: "", image: UIImage(named: "img_book_tab"), tag: 3)
        let more = UITabBarItem(title: "", image: UIImage(named: "img_more_tab"), tag: 4)
        
        let musicVC = MusicVC()
        let videoVC = VideoVC()
        let photoVC = PhotoVC()
        let bookVC = BookVC()
        let moreVC = MoreVC()
        
        let musicNav = UINavigationController(rootViewController: musicVC)
        let videoNav = UINavigationController(rootViewController: videoVC)
        let photoNav = UINavigationController(rootViewController: photoVC)
        let bookNav = UINavigationController(rootViewController: bookVC)
        let moreNav = UINavigationController(rootViewController: moreVC)
        
        musicNav.tabBarItem = music
        videoNav.tabBarItem = video
        photoNav.tabBarItem = photo
        bookNav.tabBarItem = book
        moreNav.tabBarItem = more
        
        music.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        video.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        photo.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        book.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        more.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = [photoNav, musicNav, videoNav, bookNav, moreNav]
        
        self.tabBar.tintColor = GREEN_4CAF50
        
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.borderColor = GRAY_E1E1E1.CGColor
        self.tabBar.layer.borderWidth = 0.5
        
        self.tabBarController?.tabBar.selectedItem = music
        self.tabBarController?.tabBar.translucent = false
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
