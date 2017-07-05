//
//  DMFloatingButton.swift
//  Danmuku Mirror
//
//  Created by ixan on 2017/6/17.
//  Copyright © 2017年 ixan. All rights reserved.
//

import Cocoa

protocol DMFloatingButtonDelegate: class {
    func didClickFloatingButton(button: DMFloatingButton)
}

class DMFloatingButton: NSView {
    
    weak var delegate: DMFloatingButtonDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        wantsLayer = true
        layer?.masksToBounds = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay

        buttonRect = NSMakeRect(frameRect.origin.x + 0, frameRect.origin.y + 0, frameRect.size.width - 0, frameRect.size.height - 0)
        setupLayers()
        setupShadows()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func updateLayer() {
        buttonLayer.backgroundColor = isPressed ? tintPressedColor.cgColor : tintColor.cgColor
    }
    
    var buttonRect: NSRect?
    
    fileprivate var buttonContainer = CALayer()
    fileprivate var buttonLayer = CALayer()
    fileprivate var arrowContainer = CALayer()
    fileprivate let arrowLayer = (body: CALayer(), leftHeader: CALayer(), rightHeader: CALayer())
    
    var isPressed = false {
        didSet {
            needsDisplay = true
        }
    }
    
    var tintColor = NSColor(calibratedHue: 0.52, saturation: 0.66, brightness: 0.75, alpha: 1)
    var tintPressedColor = NSColor(calibratedHue: 0.52, saturation: 0.66, brightness: 0.65, alpha: 1)
    var arrowColor = NSColor.white
    var action: Selector?
    
    func setupLayers() {
        
        updateArrowLayers()
        
        arrowContainer.addSublayer(arrowLayer.body)
        arrowContainer.insertSublayer(arrowLayer.leftHeader, below: arrowLayer.body)
        arrowContainer.insertSublayer(arrowLayer.rightHeader, below: arrowLayer.leftHeader)
        arrowContainer.transform = CATransform3DMakeRotation(CGFloat(45.0 / 180.0 * .pi), 0, 0, 1)
        
        updateButtonLayers()
        
        buttonContainer.addSublayer(buttonLayer)
        buttonContainer.insertSublayer(arrowContainer, above: buttonLayer)
        layer?.addSublayer(buttonContainer)
    }
    
    func setupShadows() {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.8)
        shadow.shadowOffset = NSMakeSize(0, -6)
        shadow.shadowBlurRadius = 10
        
        self.shadow = shadow
    }
    
    func updateArrowLayers() {
        arrowContainer.frame = buttonRect!
        
        let arrowRectWidth = ceil(buttonRect!.size.width * 0.42)
        let arrowHeadLength = arrowRectWidth * 0.9
        let arrowRectX = (buttonRect!.size.width - arrowRectWidth) / 2
        let arrowRectY = (buttonRect!.size.width - arrowRectWidth) / 2
        let lineWidth =  buttonRect!.size.width / 8.4
        let arrowRadius = lineWidth * 0.4
        
        let arrowBody = arrowLayer.body
        arrowBody.frame = NSMakeRect((buttonRect!.size.width - lineWidth) / 2, (buttonRect!.size.height - arrowRectWidth) / 2, lineWidth, arrowRectWidth)
        arrowBody.backgroundColor = arrowColor.cgColor
        arrowBody.cornerRadius = arrowRadius
        arrowBody.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        arrowBody.transform = CATransform3DMakeRotation(CGFloat(-45.0 / 180.0 * .pi), 0, 0, 1)
        
        let arrowLeftHeader = arrowLayer.leftHeader
        arrowLeftHeader.frame = NSMakeRect(arrowRectX, arrowRectY, lineWidth, arrowHeadLength)
        arrowLeftHeader.backgroundColor = arrowColor.cgColor
        arrowLeftHeader.cornerRadius = arrowRadius
        arrowLeftHeader.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        
        let arrowRightHeader = arrowLayer.rightHeader
        arrowRightHeader.frame = NSMakeRect(arrowRectX, arrowRectY, arrowHeadLength, lineWidth)
        arrowRightHeader.backgroundColor = arrowColor.cgColor
        arrowRightHeader.cornerRadius = arrowRadius
        arrowRightHeader.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
    }
    
    func updateButtonLayers() {
        buttonContainer.frame = buttonRect!
        
        buttonLayer.frame = buttonContainer.frame
        buttonLayer.backgroundColor = isPressed ? tintPressedColor.cgColor : tintColor.cgColor
        buttonLayer.cornerRadius = ceil(buttonLayer.frame.width / 2)
        buttonLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
    }
    
    func hide() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.2
        NSAnimationContext.current.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animator().alphaValue = 0
        NSAnimationContext.current.completionHandler = {
            self.isHidden = true
        }
        NSAnimationContext.endGrouping()
    }
    
    func show() {
        self.isHidden = false
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.2
        NSAnimationContext.current.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animator().alphaValue = 1
        NSAnimationContext.endGrouping()
    }
    
    override func mouseUp(with event: NSEvent) {
        isPressed = false
        delegate?.didClickFloatingButton(button: self)
    }
    
    override func mouseDown(with event: NSEvent) {
        isPressed = true
    }
}

fileprivate extension NSRect {
    func scale(by: CGFloat) -> NSRect {
        return NSMakeRect(self.origin.x + by, self.origin.y + by, self.size.width - by * 4, self.size.height - by * 4)
    }
}
