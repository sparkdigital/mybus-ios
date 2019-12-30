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

open class MyBusMarkerAnnotationView: MGLAnnotationView {

    static let kPropertyChangedDescriptor: String = "MapPropertyChanged"

    init(reuseIdentifier: String, size: CGFloat? = 30.0) {
        super.init(reuseIdentifier: reuseIdentifier)
        isDraggable = true
        scalesWithViewingDistance = false
        if var image = UIImage(named: reuseIdentifier) {
            image =  image.withAlignmentRectInsets(UIEdgeInsets.init(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            let imageView = UIImageView(image: image)
            self.frame = CGRect(x: 0, y: 0, width: image.size.width + 5, height: image.size.height + 5)
            self.backgroundColor = .clear
            self.addSubview(imageView)
        }
    }

    // These two initializers are forced upon us by Swift.
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Custom handler for changes in the annotation’s drag state.
    override open func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)

        switch dragState {
        case .starting:
            startDragging()
        case .dragging:
            print(".", terminator: "")
        case .ending, .canceling:
            endDragging()
        case .none:
            return
        }
    }

    // When the user interacts with an annotation, animate opacity and scale changes.
    func startDragging() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 0.8
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            }, completion: nil)
    }

    func endDragging() {
        transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 1
            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            }, completion: nil)

        if let annotation = self.annotation {
            if annotation is MyBusMarkerOriginPoint {
                self.notifyPropertyChanged(MyBusEndpointNotificationKey.originChanged, object: annotation)
            } else if annotation is MyBusMarkerDestinationPoint {
                self.notifyPropertyChanged(MyBusEndpointNotificationKey.destinationChanged, object: annotation)
            }
        }
    }

    fileprivate func notifyPropertyChanged(_ propertyKey: MyBusEndpointNotificationKey, object: AnyObject?){
        if object == nil {
            // Don't send the notification if the property has been set to nil
            NSLog("\(propertyKey.rawValue) is now nil")
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: propertyKey.rawValue), object: nil, userInfo: [MyBusMarkerAnnotationView.kPropertyChangedDescriptor
                :object!])
        }
    }
}
