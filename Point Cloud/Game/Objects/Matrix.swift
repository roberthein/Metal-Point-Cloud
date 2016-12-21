//
//  Matrix.swift
//  Point Cloud
//
//  Created by Robert-Hein Hooijmans on 21/12/16.
//  Copyright © 2016 Robert-Hein Hooijmans. All rights reserved.
//

import Foundation

struct Matrix4 {
    var matrix: [Float] = [
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    ]
    
    static func perspectiveMatrix(fov: Float, aspect: Float, near: Float, far: Float) -> Matrix4 {
        var matrix = Matrix4()
        let f = 1.0 / tanf(fov / 2.0)
        
        matrix.matrix[0] = f / aspect
        matrix.matrix[5] = f
        matrix.matrix[10] = (far + near) / (near - far)
        matrix.matrix[11] = -1.0
        matrix.matrix[14] = (2.0 * far * near) / (near - far)
        matrix.matrix[15] = 0.0
        
        return matrix
    }
    
    static func translationMatrix(x: Float, y: Float, z: Float) -> Matrix4 {
        var matrix = Matrix4()
        
        matrix.matrix[12] = x
        matrix.matrix[13] = y
        matrix.matrix[14] = z
        
        return matrix
    }
    
    static func rotationMatrix(angle: Float, x: Float, y: Float, z: Float) -> Matrix4 {
        var matrix = Matrix4()
        
        let c = cosf(angle)
        let ci = 1.0 - c
        let s = sinf(angle)
        
        let xy = x * y * ci
        let xz = x * z * ci
        let yz = y * z * ci
        let xs = x * s
        let ys = y * s
        let zs = z * s
        
        matrix.matrix[0] = x * x * ci + c
        matrix.matrix[1] = xy + zs
        matrix.matrix[2] = xz - ys
        matrix.matrix[4] = xy - xz
        matrix.matrix[5] = y * y * ci + c
        matrix.matrix[6] = yz + xs
        matrix.matrix[8] = xz + ys
        matrix.matrix[9] = yz - xs
        matrix.matrix[10] = z * z * ci + c
        
        return matrix
    }
}

func * (left: Matrix4, right: Matrix4) -> Matrix4 {
    let m1 = left.matrix
    let m2 = right.matrix
    var m = [Float](repeating: 0.0, count: 16)
    
    m[ 0] = m1[ 0]*m2[ 0] + m1[ 1]*m2[ 4] + m1[ 2]*m2[ 8] + m1[ 3]*m2[12]
    m[ 1] = m1[ 0]*m2[ 1] + m1[ 1]*m2[ 5] + m1[ 2]*m2[ 9] + m1[ 3]*m2[13]
    m[ 2] = m1[ 0]*m2[ 2] + m1[ 1]*m2[ 6] + m1[ 2]*m2[10] + m1[ 3]*m2[14]
    m[ 3] = m1[ 0]*m2[ 3] + m1[ 1]*m2[ 7] + m1[ 2]*m2[11] + m1[ 3]*m2[15]
    m[ 4] = m1[ 4]*m2[ 0] + m1[ 5]*m2[ 4] + m1[ 6]*m2[ 8] + m1[ 7]*m2[12]
    m[ 5] = m1[ 4]*m2[ 1] + m1[ 5]*m2[ 5] + m1[ 6]*m2[ 9] + m1[ 7]*m2[13]
    m[ 6] = m1[ 4]*m2[ 2] + m1[ 5]*m2[ 6] + m1[ 6]*m2[10] + m1[ 7]*m2[14]
    m[ 7] = m1[ 4]*m2[ 3] + m1[ 5]*m2[ 7] + m1[ 6]*m2[11] + m1[ 7]*m2[15]
    m[ 8] = m1[ 8]*m2[ 0] + m1[ 9]*m2[ 4] + m1[10]*m2[ 8] + m1[11]*m2[12]
    m[ 9] = m1[ 8]*m2[ 1] + m1[ 9]*m2[ 5] + m1[10]*m2[ 9] + m1[11]*m2[13]
    m[10] = m1[ 8]*m2[ 2] + m1[ 9]*m2[ 6] + m1[10]*m2[10] + m1[11]*m2[14]
    m[11] = m1[ 8]*m2[ 3] + m1[ 9]*m2[ 7] + m1[10]*m2[11] + m1[11]*m2[15]
    m[12] = m1[12]*m2[ 0] + m1[13]*m2[ 4] + m1[14]*m2[ 8] + m1[15]*m2[12]
    m[13] = m1[12]*m2[ 1] + m1[13]*m2[ 5] + m1[14]*m2[ 9] + m1[15]*m2[13]
    m[14] = m1[12]*m2[ 2] + m1[13]*m2[ 6] + m1[14]*m2[10] + m1[15]*m2[14]
    m[15] = m1[12]*m2[ 3] + m1[13]*m2[ 7] + m1[14]*m2[11] + m1[15]*m2[15]
    
    return Matrix4(matrix: m)
}
