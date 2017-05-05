import UIKit
import Gotanda

public class HabrushTrailRenderer: NSObject {
    private var canvasSize: CGSize
    private var gotanda: Gotanda
    private var blurFilter = CIFilter(name: "CIGaussianBlur")
    private var cropFilter = CIFilter(name: "CICrop")
    
    public init(size: CGSize) {
        canvasSize = size
        gotanda = Gotanda(size: size)
    }
    
    public func render(trail: HabrushTrail, brush: Habrush) -> CGImage {
        guard let blurFilter = blurFilter else { fatalError("blurFilter not available.") }
        guard let cropFilter = cropFilter else { fatalError("cropFilter not available.") }
        
        if let cgImage = gotanda.draw({ (context) in
            context.clear(CGRect(origin: CGPoint(), size: canvasSize))
            
            context.setLineWidth(1)
            context.setStrokeColor(brush.color_)
            context.setFillColor(brush.color_)
            context.setAlpha(brush.opacity)
            
            let brushRadius = brush.size * 0.5 * brush.softness
            
            if trail.points.count >= 2 {
                for (i, current) in trail.points.enumerated() {
                    if i > 0 {
                        let previous = trail.points[i - 1]
                        
                        let diff = CGPoint(x: current.x - previous.x, y: current.y - previous.y)
                        let angle = atan2(diff.y, diff.x)
                        if diff.x * diff.x + diff.y * diff.y > 0 {
                            // Draw line
                            let path = UIBezierPath()

                            var isFirst = true
                            for j: CGFloat in stride(from: 1.57, to: CGFloat.pi * 1.5, by: 0.5) {
                                let point = CGPoint(x: previous.x + cos(angle+j) * brushRadius, y: previous.y + sin(angle+j) * brushRadius)
                                if isFirst {
                                    path.move(to: point)
                                    isFirst = false
                                } else {
                                    path.addLine(to: point)
                                }
                            }
                            
                            for j: CGFloat in stride(from: -1.57, to: 1.57, by: 0.5) {
                                path.addLine(to: CGPoint(x: current.x + cos(angle+j) * brushRadius, y: current.y + sin(angle+j) * brushRadius))
                            }
                            
                            context.addPath(path.cgPath)
                        }
                    }
                }
                context.fillPath()
            } else {
                guard let point = trail.points.first else { fatalError("No points included.") }
                context.fillEllipse(in: CGRect(x: point.x - brushRadius, y: point.y - brushRadius, width: brushRadius * 2, height: brushRadius * 2))
            }
            
        }).cgImage {
            let ciImage = CIImage(cgImage: cgImage)
            blurFilter.setValue(ciImage, forKey: "inputImage")
            blurFilter.setValue((1 - brush.softness) * brush.size * 0.5, forKey: "inputRadius")
            
            let sourceImageExtent = ciImage.extent
            cropFilter.setValue(blurFilter.outputImage, forKey: "inputImage")
            cropFilter.setValue(CIVector(x: 0, y: 0, z: sourceImageExtent.size.width, w: sourceImageExtent.size.height), forKey: "inputRectangle")
            
            if let outputImage = cropFilter.outputImage {
                let context = CIContext(options: nil)
                let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
                
                return cgImage!
            } else {
                fatalError("No outputImage.")
            }
        } else {
            fatalError("Gotanda render error.")
        }
    }
}

