//
//  XYZ.swift
//  Point Cloud
//
//  Created by Robert-Hein Hooijmans on 21/12/16.
//  Copyright © 2016 Robert-Hein Hooijmans. All rights reserved.
//

import Foundation
import UIKit

struct XYZPoint {
    let x: Float
    let y: Float
    let z: Float
}

struct XYZFrame {
    let points: [XYZPoint]
    let length: Int
}

struct XYZAnimation {
    let frames: [XYZFrame]
    let length: Int
}

enum XYZDelimiter {
    static let Frame = "XYZ"
    static let Point = ","
}

open class XYZ {
    
    fileprivate var animation: XYZAnimation!
    
    func measureOperation(_ description: String, operation: (() -> Void)?) {
        
        let began = Date()
        
        if let operation = operation {
            operation()
        }
        
        print("\(description): \(Float(Int(Date().timeIntervalSince(began) * 100)) / 100)s")
        
    }
    
    init(fromFile file: String) {
        
        measureOperation("XYZ Parsing") { () -> Void in
            do {
                let fileContent = try String(contentsOfFile: file)
                self.animation = self.parseAnimation(fromFileContent: fileContent)
            } catch {
                assertionFailure("Could not parse file content\(error)")
            }
        }
    }
    
    func parseAnimation(fromFileContent fileContent: String) -> XYZAnimation {
        
        let frames = fileContent.components(separatedBy: XYZDelimiter.Frame).map({ (frame) -> XYZFrame in
            var points: [XYZPoint] = []
            frame.trimmingCharacters(in: CharacterSet.newlines).enumerateLines { line, stop in
                let values = line.components(separatedBy: CharacterSet(charactersIn: XYZDelimiter.Point))
                
                if let x = Float(values[0]), let y = Float(values[1]), let z = Float(values[2]) {
                    points.append(XYZPoint(
                        x: Float(Int(x * 100)) / 100,
                        y: Float(Int(y * 100)) / 100,
                        z: Float(Int(z * 100)) / 100))
                }
                
                if points.count >= 4_096 {
                    stop = true
                }
            }
            
            return XYZFrame(points: points, length: points.count)
        })
        
        return XYZAnimation(frames: frames, length: frames.count)
    }
    
    func x(frameIndex: Int, pointIndex: Int) -> Float {
        return animation.frames[frameIndex].points[pointIndex].x
    }
    
    func y(frameIndex: Int, pointIndex: Int) -> Float {
        return animation.frames[frameIndex].points[pointIndex].y
    }
    
    func z(frameIndex: Int, pointIndex: Int) -> Float {
        return animation.frames[frameIndex].points[pointIndex].z
    }
    
    func point(frameIndex: Int, pointIndex: Int) -> XYZPoint {
        return animation.frames[frameIndex].points[pointIndex]
    }
}
