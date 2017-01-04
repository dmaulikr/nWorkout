import UIKit

class WeightAndRepsTextField: UITextField {
    init() {
        super.init(frame: CGRect.zero)
        textAlignment = .center
        inputView = Keyboard.shared
        
        setFontScaling(minimum: 6)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func setNumber(double: Double) {
        if double.remainder(dividingBy: 1) == 0 {
            setNumber(int: Int(double))
        } else {
            setNumberString("\(double)")
        }
    }
    func setNumber(int: Int) {
        setNumberString("\(int)")
    }
    private func setNumberString(_ string: String) {
        text = string
    }
}