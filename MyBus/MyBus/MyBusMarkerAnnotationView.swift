//
//  MyBusMarkerAnnotationView.swift
//  MyBus
//
//  Created by Lisandro Falconi on 10/26/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Mapbox

class MyBusMarkerAnnotationView: MGLAnnotationView {
    init(reuseIdentifier: String, size: CGFloat? = 30.0) {
        super.init(reuseIdentifier: reuseIdentifier)
        draggable = true
        scalesWithViewingDistance = false
        var image = UIImage(named: reuseIdentifier)
        image =  image!.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image!.size.height/2, 0))
        let imageView = UIImageView(image: image)
        self.frame = imageView.frame
        self.backgroundColor = .clearColor()
        self.addSubview(imageView)
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
            print("Starting", terminator: "")
            startDragging()
        case .Dragging:
            print(".", terminator: "")
        case .Ending, .Canceling:
            print("Ending")
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
    }
}
