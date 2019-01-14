//
//  ViewController.swift
//  Enterprise
//
//  Created by Mark Meretzky on 1/13/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit;
import SceneKit;
import ARKit;

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Set the view's delegate.
        sceneView.delegate = self;
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true;
        
        sceneView.debugOptions = [.showWorldOrigin];

        // Create a new scene
        guard let scene: SCNScene = SCNScene(named: "art.scnassets/enterprise.scn") else {
            fatalError("loadCampus could not open art.scnassets/enterprise.scn");
        }
        
        // Set the scene to the view.
        sceneView.scene = scene;
        
        //Convert 90 degrees to radians.
        
        let degrees: Double = 90;
        var measurement: Measurement = Measurement(value: degrees, unit: UnitAngle.degrees);
        measurement.convert(to: .radians);
        let rightAngle: Float = Float(measurement.value);
        
        //Create the Starship Enterprise (7 pieces).
        
        let enterprise: SCNNode = SCNNode();
        enterprise.position = SCNVector3(0.0, 0.0, 0.0);
        enterprise.scale = SCNVector3(0.0005, 0.0005, 0.0005);

        //Port and starboard propulsion units.
        
        let propulsionUnitGeometry: SCNCapsule = SCNCapsule(capRadius: 28.5, height: 504);
        
        if let firstMaterial: SCNMaterial = propulsionUnitGeometry.firstMaterial {
            firstMaterial.diffuse.contents = UIColor.gray;
            firstMaterial.isDoubleSided = true;
        } else {
            fatalError("propulsionUnitGeometry.firstMaterial == nil");
        }
        
        for i in stride(from: -1, through: 1, by: 2) { //-1 is starboard, 1 is port
            let propulsionUnit: SCNNode = SCNNode();
            propulsionUnit.geometry = propulsionUnitGeometry;
            propulsionUnit.position = SCNVector3(i * 304 / 2, 304 / 2, -504 / 2);
            propulsionUnit.eulerAngles = SCNVector3(rightAngle, 0.0, 0.0);
            enterprise.addChildNode(propulsionUnit);
        }
        
        //Port and starboard struts (supporting the propulsion units).
        
        let strutGeometry: SCNBox = SCNBox(width: 15, height: 222, length: 30, chamferRadius: 0)
        
        if let firstMaterial: SCNMaterial = strutGeometry.firstMaterial {
            firstMaterial.diffuse.contents = UIColor.gray;
            firstMaterial.isDoubleSided = true;
        } else {
            fatalError("propulsionUnitGeometry.firstMaterial == nil");
        }
        
        for i in stride(from: -1, through: 1, by: 2) { //-1 is starboard, 1 is port
            let strut: SCNNode = SCNNode();
            strut.geometry = strutGeometry;
            strut.position = SCNVector3(i * 304 / 4, 304 / 4, -370);
            strut.eulerAngles = SCNVector3(0, 0, -Float(i) * rightAngle / 2);
            enterprise.addChildNode(strut);
        }
        
        //Secondary hull (the bottom).
        
        let secondaryHullGeometry: SCNCylinder = SCNCylinder(radius: 47, height: 340);
        
        if let firstMaterial: SCNMaterial = secondaryHullGeometry.firstMaterial {
            firstMaterial.diffuse.contents = UIColor.gray;
            firstMaterial.isDoubleSided = true;
        } else {
            fatalError("secondaryHullGeometry.firstMaterial == nil");
        }
        
        let secondaryHull: SCNNode = SCNNode();
        secondaryHull.geometry = secondaryHullGeometry;
        secondaryHull.position = SCNVector3(0, 0, -443);
        secondaryHull.eulerAngles = SCNVector3(-rightAngle, 0.0, 0.0);
        enterprise.addChildNode(secondaryHull);
        
        //Primary hull (the disk).
        
        let primaryHullGeometry: SCNCylinder = SCNCylinder(radius: 417 / 2, height: 50);
        
        if let firstMaterial: SCNMaterial = primaryHullGeometry.firstMaterial {
            firstMaterial.diffuse.contents = UIColor.gray;
            firstMaterial.isDoubleSided = true;
        } else {
            fatalError("primaryHullGeometry.firstMaterial == nil");
        }
        
        let primaryHull: SCNNode = SCNNode();
        primaryHull.geometry = primaryHullGeometry;
        primaryHull.position = SCNVector3(0, 118, -739);
        enterprise.addChildNode(primaryHull);
        
        //Connector between primary and secondary hulls.
        
        let connectorGeometry: SCNBox = SCNBox(width: 15, height: 120, length: 77, chamferRadius: 0)
        
        if let firstMaterial: SCNMaterial = connectorGeometry.firstMaterial {
            firstMaterial.diffuse.contents = UIColor.gray;
            firstMaterial.isDoubleSided = true;
        } else {
            fatalError("connectorGeometry.firstMaterial == nil");
        }
        
        let connector: SCNNode = SCNNode();
        connector.geometry = connectorGeometry;
        connector.position = SCNVector3(0, 74, -615);
        connector.eulerAngles = SCNVector3(-rightAngle / 2, 0.0, 0.0);
        enterprise.addChildNode(connector);

        //Display the finished starship.
        sceneView.scene.rootNode.addChildNode(enterprise);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // Create a session configuration.
        let configuration: ARWorldTrackingConfiguration = ARWorldTrackingConfiguration();

        // Run the view's session.
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        // Pause the view's session
        sceneView.session.pause();
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
}
