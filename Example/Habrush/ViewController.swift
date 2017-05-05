//
//  ViewController.swift
//  Habrush
//
//  Created by git on 05/05/2017.
//  Copyright (c) 2017 git. All rights reserved.
//

import UIKit
import Habrush

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func onDrawButton(_ sender: Any) {
        let brush = Habrush()
        brush.color = UIColor.red
        brush.size = 20
        brush.softness = 0.7
        
        let stroke = HabrushTrail(from: CGPoint(x: 50, y: 50))
        stroke.add(point: CGPoint(x: 20, y: 20))
        
        imageView.image = UIImage(cgImage: HabrushTrailRenderer(size: imageView.frame.size).render(trail: stroke, brush: brush))
    }

}

