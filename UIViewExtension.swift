//
//  UIviewExtension.swift
//  MultiFunctionalCard
//
//  Created by dsun on 11/1/2021.
//

import Foundation
import UIKit
import CoreGraphics


extension UIView {
//
  func createRoundedRectPath(for rect: CGRect, radius: CGFloat) -> CGMutablePath {
    //
    let path = CGMutablePath()
    //
    let midTopPoint = CGPoint(x: rect.midX, y: rect.minY)
    path.move(to: midTopPoint)
    //
    let topRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
    let bottomRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)
    let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.maxY)
    let topLeftPoint = CGPoint(x: rect.minX, y: rect.minY)
    //
    path.addArc(tangent1End: topRightPoint, tangent2End: bottomRightPoint, radius: radius)
    path.addArc(tangent1End: bottomRightPoint, tangent2End: bottomLeftPoint, radius: radius)
    path.addArc(tangent1End: bottomLeftPoint, tangent2End: topLeftPoint, radius: radius)
    path.addArc(tangent1End: topLeftPoint, tangent2End: topRightPoint, radius: radius)
    //
    path.closeSubpath()
    //
    return path
  }
  
  func drawLinearGradient(context: CGContext, rect: CGRect, startColor: CGColor, endColor: CGColor) {
    //
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let colorLocations: [CGFloat] = [0.0, 1.0]
    let colors: CFArray = [startColor, endColor] as CFArray
    //
    let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: colorLocations)!
    //
    let startPoint = CGPoint(x: rect.midX, y: rect.minY)
    let endPoint = CGPoint(x: rect.midX, y: rect.maxY)
    //
    context.saveGState()
    context.addRect(rect)
    context.clip()
    //
    context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    //
    context.restoreGState()
  }
  
  func drawGlossAndGradient(context: CGContext, rect: CGRect, startColor: CGColor, endColor: CGColor) {
    //
    drawLinearGradient(context: context, rect: rect, startColor: startColor, endColor: endColor)
    //
    let glossColor1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.35)
    let glossColor2 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
    let topHalf = CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: rect.height/2))
    //
    drawLinearGradient(context: context, rect: topHalf,startColor: glossColor1.cgColor, endColor: glossColor2.cgColor)
  }
    //
    func addWaveBackground(to view: UIView){
        //
          let leftDrop:CGFloat = 0.4
          let rightDrop: CGFloat = 0.3
          let leftInflexionX: CGFloat = 0.4
          let leftInflexionY: CGFloat = 0.47
          let rightInflexionX: CGFloat = 0.6
          let rightInflexionY: CGFloat = 0.22

          let backView = UIView(frame: view.frame)
          backView.backgroundColor = .gray
          view.addSubview(backView)
          let backLayer = CAShapeLayer()
          let path = UIBezierPath()
          path.move(to: CGPoint(x: 0, y: 0))
          path.addLine(to: CGPoint(x:0, y: view.frame.height * leftDrop))
          path.addCurve(to: CGPoint(x:view.frame.width, y: view.frame.height * rightDrop),
                        controlPoint1: CGPoint(x: view.frame.width * leftInflexionX, y: view.frame.height * leftInflexionY),
                        controlPoint2: CGPoint(x: view.frame.width * rightInflexionX, y: view.frame.height * rightInflexionY))
          path.addLine(to: CGPoint(x:view.frame.width, y: 0))
          path.close()
          backLayer.fillColor = UIColor.blue.cgColor
          backLayer.path = path.cgPath
          backView.layer.addSublayer(backLayer)
       }
    //
    func addRippleEffect(to referenceView: UIView) {
        /*! Creates a circular path around the view*/
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: referenceView.bounds.size.width, height: referenceView.bounds.size.height))
        /*! Position where the shape layer should be */
        let shapePosition = CGPoint(x: referenceView.bounds.size.width / 2.0, y: referenceView.bounds.size.height / 2.0)
        let rippleShape = CAShapeLayer()
        rippleShape.bounds = CGRect(x: 0, y: 0, width: referenceView.bounds.size.width, height: referenceView.bounds.size.height)
        rippleShape.path = path.cgPath
        rippleShape.fillColor = UIColor.clear.cgColor
        rippleShape.strokeColor = UIColor.yellow.cgColor
        rippleShape.lineWidth = 4
        rippleShape.position = shapePosition
        rippleShape.opacity = 0
        
        /*! Add the ripple layer as the sublayer of the reference view */
        referenceView.layer.addSublayer(rippleShape)
        /*! Create scale animation of the ripples */
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(2, 2, 1))
        /*! Create animation for opacity of the ripples */
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1
        opacityAnim.toValue = nil
        /*! Group the opacity and scale animations */
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnim, opacityAnim]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = CFTimeInterval(0.7)
        animation.repeatCount = 25
        animation.isRemovedOnCompletion = true
        rippleShape.add(animation, forKey: "rippleEffect")
    }
}


class WavyView: UIView {
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil // TODO
    }

    override func draw(_ rect: CGRect) {
        // Fill the whole background with the darkest blue color
        UIColor(red: 0.329, green: 0.718, blue: 0.875, alpha: 1).set()
        let bg = UIBezierPath(rect: rect)
        bg.fill()

        // Add the first sine wave filled with a very transparent white
        let top1: CGFloat = 17.0
        let wave1 = wavyPath(rect: CGRect(x: 0, y: top1, width: frame.width, height: frame.height - top1), periods: 1.5, amplitude: 21, start: 0.55)
        UIColor(white: 1.0, alpha: 0.1).set()
        wave1.fill()

        // Add the second sine wave over the first
        let top2: CGFloat = 34.0
        let wave2 = wavyPath(rect: CGRect(x: 0, y: top2, width: frame.width, height: frame.height - top2), periods: 1.5, amplitude: 21, start: 0.9)
        UIColor(white: 1.0, alpha: 0.15).set()
        wave2.fill()

        // Add the text
        let paraAttrs = NSMutableParagraphStyle()
        paraAttrs.alignment = .center
        let textRect = CGRect(x: 0, y: frame.maxY - 64, width: frame.width, height: 24)
        let textAttrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.9), NSAttributedString.Key.paragraphStyle: paraAttrs]
        ("New user? Register here." as NSString).draw(in: textRect, withAttributes: textAttrs)
    }

    // This creates the desired sine wave bezier path
    // rect is the area to fill with the sine wave
    // periods is how may sine waves fit across the width of the frame
    // amplitude is the height in points of the sine wave
    // start is an offset in wavelengths for the left side of the sine wave
    func wavyPath(rect: CGRect, periods: Double, amplitude: Double, start: Double) -> UIBezierPath {
        let path = UIBezierPath()

        // start in the bottom left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))

        let radsPerPoint = Double(rect.width) / periods / 2.0 / Double.pi
        let radOffset = start * 2 * Double.pi
        let xOffset = Double(rect.minX)
        let yOffset = Double(rect.minY) + amplitude
        // This loops through the width of the frame and calculates and draws each point along the size wave
        // Adjust the "by" value as needed. A smaller value gives smoother curve but takes longer to draw. A larger value is quicker but gives a rougher curve.
        for x in stride(from: 0, to: Double(rect.width), by: 6) {
            let rad = Double(x) / radsPerPoint + radOffset
            let y = sin(rad) * amplitude

            path.addLine(to: CGPoint(x: x + xOffset, y: y + yOffset))
        }

        // Add the last point on the sine wave at the right edge
        let rad = Double(rect.width) / radsPerPoint + radOffset
        let y = sin(rad) * amplitude

        path.addLine(to: CGPoint(x: Double(rect.maxX), y: y + yOffset))

        // Add line from the end of the sine wave to the bottom right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Close the path
        path.close()

        return path
    }
}

// This creates the view with the same size as the image posted in the question
//let wavy = WavyView(frame: CGRect(x: 0, y: 0, width: 502, height: 172))

class Wave: UIViewController {

    private weak var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0

    /// The `CAShapeLayer` that will contain the animated path

    private let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        return shapeLayer
    }()

    // start the display link when the view appears

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layer.addSublayer(shapeLayer)
        startDisplayLink()
    }

    // Stop it when it disappears. Make sure to do this because the
    // display link maintains strong reference to its `target` and
    // we don't want strong reference cycle.

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopDisplayLink()
    }

    /// Start the display link

    private func startDisplayLink() {
        startTime = CACurrentMediaTime()
        self.displayLink?.invalidate()
        let displayLink = CADisplayLink(target: self, selector:#selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }

    /// Stop the display link

    private func stopDisplayLink() {
        displayLink?.invalidate()
    }

    /// Handle the display link timer.
    ///
    /// - Parameter displayLink: The display link.

    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        let elapsed = CACurrentMediaTime() - startTime
        shapeLayer.path = wave(at: elapsed).cgPath
    }

    /// Create the wave at a given elapsed time.
    ///
    /// You should customize this as you see fit.
    ///
    /// - Parameter elapsed: How many seconds have elapsed.
    /// - Returns: The `UIBezierPath` for a particular point of time.

    private func wave(at elapsed: Double) -> UIBezierPath {
        let elapsed = CGFloat(elapsed)
        let centerY = view.bounds.midY
        let amplitude = 50 - abs(elapsed.remainder(dividingBy: 3)) * 40

        func f(_ x: CGFloat) -> CGFloat {
            return sin((x + elapsed) * 4 * .pi) * amplitude + centerY
        }

        let path = UIBezierPath()
        let steps = Int(view.bounds.width / 10)

        path.move(to: CGPoint(x: 0, y: f(0)))
        for step in 1 ... steps {
            let x = CGFloat(step) / CGFloat(steps)
            path.addLine(to: CGPoint(x: x * view.bounds.width, y: f(x)))
        }

        return path
    }
}
