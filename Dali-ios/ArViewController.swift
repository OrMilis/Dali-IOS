//
//  ViewController.swift
//  Dali-ios
//
//  Created by Or Milis on 17/07/2019.
//  Copyright © 2019 Or Milis. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ArViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {
    
    public static let identifier: String = "ARView"

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var rotateRecognizer: UIRotationGestureRecognizer!
    @IBOutlet var pinchRecognizer: UIPinchGestureRecognizer!
    
    var artworks: [Artwork] = [Artwork]()
    var likedArtworks: [Artwork] = [Artwork]()
    var downloadedArtworks = [Bool]()
    var selectedArtwork: Int = 0
    var isShowingArt = false
    var centerOfScreen: CGPoint = CGPoint()
    
    var selectedNode: SCNNode?
    var latestTranslatePos: SCNVector3 = SCNVector3()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotateRecognizer.delegate = self
        pinchRecognizer.delegate = self
        
        self.collectionView.isPagingEnabled = true
        self.collectionView.alwaysBounceHorizontal = false
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        //sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        clearTempArtFiles()
        
        if artworks.count > 0 {
            loadSelectedArtwork()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        centerOfScreen = self.view.center
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        clearTempArtFiles()
    }
    
    func setDataForView(artworks: [Artwork], likedArtworks: [Artwork]) {
        self.artworks = artworks
        self.likedArtworks = likedArtworks
        self.downloadedArtworks = Array(repeating: false, count: artworks.count)
    }
    
    func loadSelectedArtwork() {
        isShowingArt = false
        if !downloadedArtworks[selectedArtwork] {
            getArtworkFiles(artworks[selectedArtwork])
        } else {
            print("In cache")
        }
    }
    
    func resetSceneNodes() {
        selectedNode = nil
        sceneView.scene.rootNode.childNodes.forEach({node in
            if node.name != nil {
                node.removeFromParentNode()
            }
        })
    }
    
    @IBAction func onPageValueChanged(_ sender: UIPageControl) {
        self.collectionView
            .scrollRectToVisible(CGRect(
                x: Int(self.collectionView.frame.size.width) * self.pageControl.currentPage,
                y: 0,
                width:Int(self.collectionView.frame.size.width),
                height: Int(self.collectionView.frame.size.height)), animated: true)
        
        self.selectedArtwork = self.pageControl.currentPage
        loadSelectedArtwork()
        resetSceneNodes()
    }
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let node = selectedNode else { return }
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        let state = recognizer.state
        let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
        guard let hit = hitTestResult.first else { return }
        
        if state == .began {
            latestTranslatePos = hit.worldCoordinates
        }
        
        if state == .changed {
            let touchWorldVector = hit.worldCoordinates
            
            // Translate virtual object. ** Y_UP world **
            let deltaX = Float(touchWorldVector.x - latestTranslatePos.x)
            let deltaZ = Float(touchWorldVector.z - latestTranslatePos.z)
            
            node.worldPosition.x += deltaX
            node.worldPosition.z += deltaZ
            
            latestTranslatePos = touchWorldVector
        }
        
    }
    
    @IBAction func handleRotation(_ recognizer: UIRotationGestureRecognizer){
        guard let node = selectedNode else { return }
        let sensitivity = 0.075
        let rotationY = CGFloat(Double(recognizer.rotation) * -sensitivity) //Minus so it will rotate as the gesture
        let action = SCNAction.rotateBy(x: 0.0, y: rotationY, z: 0.0, duration: 0.1) //We want to rotate only on Y axis
        node.runAction(action)

    }
    
    @IBAction func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        guard let node = selectedNode else { return }
        
        let action = SCNAction.scale(by: recognizer.scale, duration: 0.1)
        node.runAction(action)
        recognizer.scale = 1
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - ARSCNViewDelegate
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
        plane.materials.first?.diffuse.contents = UIImage(named: "crissxcross")/*UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)*/
        
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
        //Must be in different thread. SCNScene can't be called in renderer callback.
        DispatchQueue.main.async {
            if !self.isShowingArt {
                self.isShowingArt = true
                addArtworkToSceneView()
            }
            
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
        
        func addArtworkToSceneView(/*withGestureRecognizer recognizer: UIGestureRecognizer*/) {
            //let tapLocation = recognizer.location(in: sceneView)
            print("In ADD ART")
            let hitTestResults = sceneView.hitTest(centerOfScreen, types: .existingPlaneUsingExtent)
            
            guard let hitTestResult = hitTestResults.first else {
                print("NO HIT PLANE")
                isShowingArt = false
                return
            }
            
            let translation = hitTestResult.worldTransform.columns.3
            let x = translation.x
            let y = translation.y
            let z = translation.z
            
            resetSceneNodes()
            
            let tempArtworksPath = FileManager.default.temporaryDirectory.appendingPathComponent("tempArtworks")
            let destinationDirectoryURL = tempArtworksPath.appendingPathComponent(artworks[selectedArtwork].name)
            let files = try? FileManager.default.contentsOfDirectory(atPath: destinationDirectoryURL.path)
            guard let sceneFile = files?.first(where: { $0.hasSuffix(".scn") }) else {
                isShowingArt = false
                return
            }
            let destinationFileUrl = destinationDirectoryURL.appendingPathComponent(sceneFile)
            
            guard let artworkScene = try? SCNScene(url: destinationFileUrl, options: nil) else {
                isShowingArt = false
                return
            }
            print("CHECK TRY?")
            let artworkNode = artworkScene.rootNode.childNodes[0]
            
            artworkNode.position = SCNVector3(x,y,z)

            sceneView.scene.rootNode.addChildNode(artworkNode)
            selectedNode = artworkNode
        }
    }
    
    /*func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ArViewController.addArtworkToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }*/
    
    func getArtworkFiles(_ artwork: Artwork) {
        guard let url = URL(string: "http://" + artwork.path) else { return }
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let fileUrl = localURL {
                let tempArtworksPath = FileManager.default.temporaryDirectory.appendingPathComponent("tempArtworks")
                let destinationDirectoryURL = tempArtworksPath.appendingPathComponent(artwork.name)
                let destinationFileUrl = destinationDirectoryURL.appendingPathComponent(urlResponse?.suggestedFilename ?? fileUrl.lastPathComponent)
                
                try? FileManager.default.removeItem(at: destinationDirectoryURL)
                
                do {
                    try FileManager.default.createDirectory(at: destinationDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                    try FileManager.default.copyItem(at: fileUrl, to: destinationFileUrl)
                    try FileManager.default.unzipItem(at: destinationFileUrl, to: destinationDirectoryURL)
                    self.downloadedArtworks[self.selectedArtwork] = true
                    dump(self.downloadedArtworks)
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

extension ArViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.numberOfPages = self.artworks.count
        return self.artworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = self.artworks[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtworkPage", for: indexPath) as! ArtworkInfoCell
        
        cell.artworkName.text = cellData.name
        cell.artistName.text = cellData.artistName
        if let artistPicUrl = cellData.artistPicture {
            cell.artistPicture.loadFromUrl(urlString: artistPicUrl)
            cell.artistPicture.setRoundedImage()
        }
        
        cell.artworkId = cellData.id
        let isLiked = self.likedArtworks.filter({$0.id == cellData.id}).count > 0
        cell.isLiked = isLiked
        cell.likeBtn.tintColor = isLiked ? UIColor.red : UIColor.white
        
        return cell
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = false;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
        let selectedIndex = Int(round(scrollView.contentOffset.x/view.frame.width))
        if self.pageControl.currentPage != selectedIndex {
            self.pageControl.currentPage = selectedIndex
            self.selectedArtwork = selectedIndex
            loadSelectedArtwork()
            resetSceneNodes()
        }
    }
    
}
