//
//  MyBusMarkerAnnotationView.swift
//  MyBus
//
//  Created by Lisandro Falconi on 10/26/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Mapbox

enum MyBusEndpointNotificationKey: String {
    case originChanged = "markerOriginEndDragged"
    case destinationChanged = "markerDestinationEndDragged"
}

class MyBusMarkerAnnotationView: MGLAnnotationView {

    static let kPropertyChangedDescriptor: String = "MapPropertyChanged"

    init(reuseIdentifier: String, size: CGFloat? = 30.0) {
        super.init(reuseIdentifier: reuseIdentifier)
        draggable = true
        scalesWithViewingDistance = false
        if var image = UIImage(named: reuseIdentifier) {
            image =  image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            let imageView = UIImageView(image: image)
            self.frame = imageView.frame
            self.backgroundColor = .clearColor()
            self.addSubview(imageView)
        }
    }

    // These two initializers are forced upon us by Swift.
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Custom handler for changes in the annotation’s drag state.
    override func setDragState(dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)

        switch dragState {
        case .Starting:
            startDragging()
        case .Dragging:
            print(".", terminator: "")
        case .Ending, .Canceling:
            endDragging()
        case .None:
            return
        }
    }

    // When the user interacts with an annotation, animate opacity and scale changes.
    func startDragging() {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 0.8
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5)
            }, completion: nil)
    }

    func endDragging() {
        transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5)
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 1
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
            }, completion: nil)

        if let annotation = self.annotation {
            let newCoordinate = annotation.coordinate
            Connectivity.sharedInstance.getAddressFromCoordinate(newCoordinate.latitude, longitude: newCoordinate.longitude) { (routePoint, error) in
                if let newPoint = routePoint {
                    print(newPoint.address)
                    if annotation is MyBusMarkerOriginPoint {
                        self.notifyPropertyChanged(MyBusEndpointNotificationKey.originChanged, object: newPoint)
                    } else if annotation is MyBusMarkerDestinationPoint {
                        self.notifyPropertyChanged(MyBusEndpointNotificationKey.destinationChanged, object: newPoint)
                    }
                }
            }
        }
    }

    private func notifyPropertyChanged(propertyKey: MyBusEndpointNotificationKey, object: AnyObject?){
        if object == nil {
            // Don't send the notification if the property has been set to nil
            NSLog("\(propertyKey.rawValue) is now nil")
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(propertyKey.rawValue, object: nil, userInfo: [MyBusMarkerAnnotationView.kPropertyChangedDescriptor
                :object!])
        }
    }
}
