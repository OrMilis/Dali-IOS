//
//  ViewController.swift
//  Dali-ios
//
//  Created by Or Milis on 17/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit
import SceneKit
import SceneKit.ModelIO
import ARKit
import ModelIO

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        addTapGestureToSceneView()
        
        clearTempArtFiles()
        getArtworkFiles(artworkPath: "project-dali.com/data/files/115528235345908255360/Beagle.zip")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // 3
        plane.materials.first?.diffuse.contents = UIColor.init(red: 0.0, green: 0.0, blue: 1, alpha: 0.2)
        
        // 4
        let planeNode = SCNNode(geometry: plane)
        
        // 5
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        // 6
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
    
    @objc func addShipToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.columns.3
        let x = translation.x
        let y = translation.y
        let z = translation.z
        
        print("Trans: ", translation)
        
        let tempArtworksPath = FileManager.default.temporaryDirectory.appendingPathComponent("tempArtworks") // FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationDirectoryURL = tempArtworksPath.appendingPathComponent("Beagle"/*artwork.name*/)
        let destinationFileUrl = destinationDirectoryURL.appendingPathComponent("Beagle.scn")
        
        //print("FileUrl: ", destinationFileUrl)
        
        /*let asset = MDLAsset(url: destinationFileUrl)
        let object = asset.object(at: 0)
        let shipNode = SCNNode(mdlObject: object)*/
        
        guard let shipScene = try? SCNScene(url: destinationFileUrl, options: nil)
            else { return }
        let shipNode = shipScene.rootNode.childNodes[0]
        
        /*guard let shipScene = SCNScene(named: "Beagle.dae", inDirectory: "art.scnassets", options: nil),
            let shipNode = shipScene.rootNode.childNode(withName: "ship", recursively: false)
            else { return }*/
        
        /*guard let shipScene = SCNScene(named: "Beagle.scn", inDirectory: "art.scnassets", options: nil)
            else { return }
        let shipNode = shipScene.rootNode.childNodes[0]*/
        
        shipNode.position = SCNVector3(x,y,z)
        sceneView.scene.rootNode.addChildNode(shipNode)
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addShipToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func getArtworkFiles(artworkPath: String /*_ artwork: Artwork*/) {
        guard let url = URL(string: "http://" + artworkPath/*artwork.path*/) else { return }
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let fileUrl = localURL {
                let tempArtworksPath = FileManager.default.temporaryDirectory.appendingPathComponent("tempArtworks") // FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let destinationDirectoryURL = tempArtworksPath.appendingPathComponent("Beagle"/*artwork.name*/)
                let destinationFileUrl = destinationDirectoryURL.appendingPathComponent(urlResponse?.suggestedFilename ?? fileUrl.lastPathComponent)
                
                try? FileManager.default.removeItem(at: destinationDirectoryURL)
                
                do {
                    try FileManager.default.createDirectory(at: destinationDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                    try FileManager.default.copyItem(at: fileUrl, to: destinationFileUrl)
                    try FileManager.default.unzipItem(at: destinationFileUrl, to: destinationDirectoryURL)
                    print("Finished Download")
                    print("Path: ", destinationFileUrl)
                } catch let error {
                    print(error)
                }
            }
        }
        
        task.resume()
    }
    
    func clearTempArtFiles() {
        let tempArtworksPath = FileManager.default.temporaryDirectory.appendingPathComponent("tempArtworks")
        do {
            let filesUrl = try FileManager.default.contentsOfDirectory(at: tempArtworksPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            filesUrl.forEach({ url in
                try? FileManager.default.removeItem(at: url)
            })
        } catch let err {
            print(err)
        }
    }
}
