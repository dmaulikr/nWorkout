import UIKit

class WorkoutFooterViewButton: UIButton {
    
    override class var requiresConstraintBasedLayout: Bool { return false }
    
    enum WorkoutFooterViewButtonType {
        case addLift
        case cancel
        case finish
        case details
    }
    static func create(title: String, type: WorkoutFooterViewButtonType) -> WorkoutFooterViewButton {
        let b = WorkoutFooterViewButton()
        b.setTitle(title)
        b.backgroundColor = Theme.Colors.dark
        
        b.setTitleColor(.white)
        
        b.setBorder(color: .black, width: 1, radius: 4)
        return b
    }
}
