//
//  GameViewController.swift
//  ARLearning
//
//  Created by Usman Farooqi on 9/7/19.
//  Copyright © 2019 Usman Farooqi. All rights reserved.
//

import Foundation
import ARKit

class GameViewController: UIViewController, ARSCNViewDelegate{
    
    var stack = [SCNNode]()
    
    let arView:ARSCNView = {
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let configuration = ARWorldTrackingConfiguration()
    
    
    var startingPositionNode = SCNNode()
    var endPositionNode = SCNNode()
    let cameraRelativePosition = SCNVector3(0,0,-0.1)
    
    
   
    
    
    
    
    lazy var plusButton: UIButton = {
        var screenSize: CGRect = UIScreen.main.bounds
        var frameSizeW: CGFloat = 0.0
        var frameSizeH: CGFloat = 0.0
        frameSizeW = screenSize.size.width
        frameSizeH = screenSize.size.height
        let plusButtonWidth = frameSizeW * 0.1
        let button   = UIButton(type: .system) as UIButton
        button.frame = CGRect(x: frameSizeW * 0.1, y: frameSizeH * 0.9, width: plusButtonWidth, height: plusButtonWidth)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        button.layer.cornerRadius = plusButtonWidth / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonAdd), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //View is constraint full screen
        setupView()
        
        configuration.planeDetection = .horizontal
        arView.session.run(configuration, options: []) //TODO come back and add tracking options
        arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        arView.autoenablesDefaultLighting = true
        arView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
        longGestureRecognizer.minimumPressDuration = 0;
        arView.addGestureRecognizer(tapGestureRecognizer)
        arView.addGestureRecognizer(longGestureRecognizer)
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    func setupView(){
        //optimize to look better less code reuse TODO
        
        //let plusButtonHeight = view.frame.size.height * 0.1
        
        //View is constraint full screen
        view.addSubview(arView)
        arView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        arView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        arView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        
        
        
        //make all these buttons one function or something TODO
        
//        let plusButton: UIButton = {
//            let plusButtonWidth = frameSizeW * 0.1
//            let button   = UIButton(type: .system) as UIButton
//            button.frame = CGRect(x: frameSizeW * 0.1, y: frameSizeH * 0.9, width: plusButtonWidth, height: plusButtonWidth)
//            button.setImage(UIImage(named: "plus"), for: .normal)
//            button.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
//            button.layer.cornerRadius = plusButtonWidth / 2
//            button.layer.masksToBounds = true
//            button.addTarget(self, action: #selector(buttonAdd), for: .touchUpInside)
//            return button
//        }()
        view.addSubview(plusButton)
        
        let undoButton: UIButton = {
            let screenSize: CGRect = UIScreen.main.bounds
            var frameSizeW: CGFloat = 0.0
            var frameSizeH: CGFloat = 0.0
            frameSizeW = screenSize.size.width
            frameSizeH = screenSize.size.height
            
            let undoButtonWidth = frameSizeW * 0.1
            let button   = UIButton(type: .system) as UIButton
            button.frame = CGRect(x: frameSizeW * 0.8, y: frameSizeH * 0.9, width: undoButtonWidth, height: undoButtonWidth)
            button.setImage(UIImage(named: "undo"), for: .normal)
            button.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
            button.layer.cornerRadius = undoButtonWidth / 2
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(buttonUndo), for: .touchUpInside)
            return button
        }()
        view.addSubview(undoButton)
        
        
        let resetButton: UIButton = {
            let screenSize: CGRect = UIScreen.main.bounds
            var frameSizeW: CGFloat = 0.0
            var frameSizeH: CGFloat = 0.0
            frameSizeW = screenSize.size.width
            frameSizeH = screenSize.size.height
            
            let resetButtonWidth = frameSizeW * 0.1
            let button   = UIButton(type: .system) as UIButton
            button.frame = CGRect(x: frameSizeW * 0.45, y: frameSizeH * 0.9, width: resetButtonWidth + 0.1 * resetButtonWidth, height: resetButtonWidth)
            button.setTitle("Reset", for: .normal)
            button.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
//            button.layer.cornerRadius = resetButtonWidth / 2
//            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(buttonReset), for: .touchUpInside)
            return button
        }()
        view.addSubview(resetButton)
        
        let centerImageView: UIImageView = {
            let screenSize: CGRect = UIScreen.main.bounds
            var frameSizeW: CGFloat = 0.0
            var frameSizeH: CGFloat = 0.0
            frameSizeW = screenSize.size.width
            frameSizeH = screenSize.size.height
            
            let view = UIImageView()
            view.image = UIImage(named: "circle")
            view.contentMode = .scaleAspectFill
            view.frame = CGRect(x: frameSizeW * 0.45, y: frameSizeH * 0.45 , width: frameSizeW * 0.1, height: frameSizeH * 0.1)
            return view
        }()
        view.addSubview(centerImageView)
        
    }
    
    @objc func buttonAdd() {
        print("ADD")
        
    }
    
    @objc func buttonUndo(){
        print("UNDO")
        removeBox()
    }
    
    @objc func buttonReset(){
        print("RESET")
        reset()
    }
    
   
    
    
    func removeBox(){
        if(stack.count>0){
            let lastBox = stack.popLast()
            lastBox?.removeFromParentNode()
        }
    }
    
    func reset(){
        arView.session.pause()
        arView.session.run(configuration, options: [.removeExistingAnchors,.resetTracking])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let anchorPlane = anchor as? ARPlaneAnchor else {return}
//        let floor = createFloor(anchor: anchorPlane)
//        node.addChildNode(floor)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let anchorPlane = anchor as? ARPlaneAnchor else {return}
//        removeFloor()
//        let floor = createFloor(anchor: anchorPlane)
//        node.addChildNode(floor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        removeFloor()
    }
    
    func createFloor(anchor: ARPlaneAnchor) -> SCNNode {
        let floor = SCNNode()
        floor.name = "floor"
        floor.eulerAngles = SCNVector3(1.5708,0,0) //90 degrees in radians
        floor.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        floor.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "floorTexture")
        floor.geometry?.firstMaterial?.isDoubleSided = true
        floor.position = SCNVector3(anchor.center.x,anchor.center.y,anchor.center.z)
        return floor
    }
    
    func removeFloor() {
        arView.scene.rootNode.enumerateChildNodes{(node, _) in
            if(node.name == "floor") {
                node.removeFromParentNode()
            }
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
//        let tappedView = sender.view as! SCNView
//        let touchLocation = sender.location(in: tappedView)
//        let hitTest = tappedView.hitTest(touchLocation, options: nil)
//        if (!hitTest.isEmpty){
//            let result = hitTest.first!
//            let name = result.node.name
//            let geometry = result.node.geometry
//            print("\(name) \(geometry)")
//        }
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.002))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        addChildNode(node: sphere, toNode: arView.scene.rootNode, inView: arView, cameraRelativePostion: cameraRelativePosition)
        startingPositionNode = sphere
    }
    
    @objc func handlePress(sender: UILongPressGestureRecognizer){
        if(sender.state.rawValue == 1){
            print("began")
        }
        else if(sender.state.rawValue == 3){
            print("end")
        }
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.002))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        addChildNode(node: sphere, toNode: arView.scene.rootNode, inView: arView, cameraRelativePostion: cameraRelativePosition)
        startingPositionNode = sphere
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
        stack.append(node)
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
//        if(plusButton.isHighlighted){
//            let sphere = SCNNode(geometry: SCNSphere(radius: 0.002))
//            sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//            addChildNode(node: sphere, toNode: arView.scene.rootNode, inView: arView, cameraRelativePostion: cameraRelativePosition)
//            startingPositionNode = sphere
//        }
//    }
    
    
}
