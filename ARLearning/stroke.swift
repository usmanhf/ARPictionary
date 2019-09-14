//
//  stroke.swift
//  ARLearning
//
//  Created by Usman Farooqi on 9/14/19.
//  Copyright © 2019 Usman Farooqi. All rights reserved.
//

import Foundation
import ARKit

class Stroke{
    
    var nodeStack = [SCNNode]()
    
    var startingPositionNode = SCNNode()
    
    
    func addToStroke(arView : ARSCNView, cameraRelativePosition : SCNVector3){
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.002))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        addChildNode(node: sphere, toNode: arView.scene.rootNode, inView: arView, cameraRelativePostion: cameraRelativePosition)
        startingPositionNode = sphere
    }
    
    func removeStroke(){
        for node in nodeStack{
            node.removeFromParentNode()
        }
    }
    
    func endStroke(){
        
    }
    
    func addChildNode(node: SCNNode, toNode: SCNNode, inView: ARSCNView, cameraRelativePostion:SCNVector3) {
        
        guard let currentFrame = inView.session.currentFrame else {return}
        let camera = currentFrame.camera
        let transform = camera.transform
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.x = cameraRelativePostion.x
        translationMatrix.columns.3.y = cameraRelativePostion.y
        translationMatrix.columns.3.z = cameraRelativePostion.z
        let modifiedMatrix = simd_mul(transform,translationMatrix)
        node.simdTransform = modifiedMatrix
        toNode.addChildNode(node)
        nodeStack.append(node)
    }
}
