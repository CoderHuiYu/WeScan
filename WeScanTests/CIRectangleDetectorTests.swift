//
//  CIRectangleDetectorTests.swift
//  WeScanTests
//
//  Created by James Campbell on 8/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import FBSnapshotTestCase
import XCTest
@testable import WeScan

final class CIRectangleDetectorTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
        agnosticOptions = .OS
    }
    
    func testCorrectlyDetectsAndReturnsQuadilateral() {
        
        let targetSize = CGSize(width: 50, height: 50)
        
        let containerLayer = CALayer()
        containerLayer.backgroundColor = UIColor.white.cgColor
        containerLayer.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        containerLayer.masksToBounds = true
        
        let targetLayer = CALayer()
        targetLayer.backgroundColor = UIColor.black.cgColor
        targetLayer.frame = containerLayer.frame.insetBy(dx: 5, dy: 5)
        
        containerLayer.addSublayer(targetLayer)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, true, 1.0)
        
        containerLayer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let ciImage = CIImage(cgImage: image.cgImage!)
        let quad = CIRectangleDetector.rectangle(forImage: ciImage)!
        
        let resultView = UIView(frame: containerLayer.frame)
        resultView.layer.addSublayer(containerLayer)
        
        let quadView = QuadrilateralView(frame: resultView.bounds)
        quadView.drawQuadrilateral(quad: quad, animated: false)
        quadView.backgroundColor = UIColor.red
        resultView.addSubview(quadView)
        
        FBSnapshotVerifyView(resultView)
    }
    
}
