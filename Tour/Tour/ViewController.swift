//
//  ViewController.swift
//  Tour
//
//  Created by Gareth on 09/09/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let tourData = [
        [
            "image": "tour1",
            "title": "This is jigglybuff, he is jiggly and BUFF"
        ],
        [
            "image": "tour2",
            "title": "Pixely puff pixelly and puff"
        ],
        [
            "image": "tour3",
            "title": "Musically puff, also from the jiggly family"
        ],
        [
            "image": "tour4",
            "title": "Overlord puff, all hail the giant puff of jiggles"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        settupPageViews()
    }
    
    func createPageView(data: [String: String]) -> PageView {
        let pageView = PageView.loadFromNib()
        pageView.configure(data)
        return pageView;
    }
    
    func settupPageViews() {
        var totalWidth: CGFloat = 0
        
        for data in tourData {
            let pageView = createPageView(data)
            pageView.frame = CGRect(origin: CGPoint(x: totalWidth, y:0), size: view.bounds.size)
            
            scrollView.addSubview(pageView)
            
            totalWidth += pageView.bounds.size.width
        }
        
        scrollView.contentSize = CGSize(width: totalWidth, height: scrollView.bounds.height)
        
    }


}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // how wide is the page
        let pageWidth = Int(scrollView.contentSize.width) / tourData.count
        
        pageControl.currentPage = Int(scrollView.contentOffset.x) / pageWidth
    }
    
}

