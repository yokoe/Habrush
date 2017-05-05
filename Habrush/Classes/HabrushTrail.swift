import UIKit

public class HabrushTrail: NSObject {
    var points = [CGPoint]()
    private var startedAt: NSDate
    
    public init(from: CGPoint) {
        startedAt = NSDate()
        points.append(from)
    }
    
    public func add(point: CGPoint) {
        points.append(point)
    }
    
    var path: UIBezierPath {
        let path = UIBezierPath()
        for (i, point) in points.enumerated() {
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        return path
    }
    
    public var timeSpent: TimeInterval {
        return -startedAt.timeIntervalSinceNow
    }
}
