import UIKit

public class Habrush: NSObject, NSCoding {
    public enum BrushType: String {
        case brush, eraser
    }
    
    private static let CodingRevision = 1
    
    public var type: BrushType = .brush
    public var color: UIColor = UIColor.black
    public var size: CGFloat = CGFloat(4)
    public var softness: CGFloat = 1
    public var opacity: CGFloat = CGFloat(1)
    
    public var eraserColor: UIColor = UIColor.white
    
    var color_: CGColor {
        switch type {
        case .brush:
            return color.cgColor
        case .eraser:
            return eraserColor.cgColor
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        size = CGFloat(aDecoder.decodeFloat(forKey: "size"))
        softness = CGFloat(aDecoder.decodeFloat(forKey: "softness"))
        opacity = CGFloat(aDecoder.decodeFloat(forKey: "opacity"))
        if let colorData = aDecoder.decodeObject(forKey: "color") as? Data, let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor {
            self.color = color
        }
    }
    
    public override init() {
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(Float(size), forKey: "size")
        aCoder.encode(Float(softness), forKey: "softness")
        aCoder.encode(Float(opacity), forKey: "opacity")
        aCoder.encode(NSKeyedArchiver.archivedData(withRootObject: color), forKey: "color")
        aCoder.encode(Habrush.CodingRevision, forKey: "revision")
    }
}
