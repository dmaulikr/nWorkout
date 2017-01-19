import UIKit
import RxSwift
import RxCocoa

class WorkoutDetailVC: UIViewController {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    let workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupDateTextFields()
        
        startDatePicker.date = workout.startDate
        if let finish = workout.finishDate {
            finishDatePicker.date = finish
        }
    }
    
    let df: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .long
        return df
    }()
    
    func setupDateTextFields() {
        startDateLabel.text = df.string(from: workout.startDate)
        if let finish = workout.finishDate {
            finishDateLabel.text = df.string(from: finish)
        }
    }
    
    
    let stackView = UIStackView(axis: .vertical, spacing: 8, distribution: .fillEqually)
    let startDateLabel = UITextField()
    let finishDateLabel = UITextField()
    
    let startDatePicker = UIDatePicker()
    let finishDatePicker = UIDatePicker()
    
    func setupViews() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(startDateLabel)
        startDateLabel.inputView = startDatePicker
        stackView.addArrangedSubview(finishDateLabel)
        finishDateLabel.inputView = finishDatePicker
        
        startDatePicker.rx.controlEvent(.valueChanged).subscribe(onNext: {
            print("hi")
            RLM.write {
                self.workout.startDate = self.startDatePicker.date
            }
            
            self.startDateLabel.text = self.df.string(from: self.startDatePicker.date)
        }).addDisposableTo(db)
        
        finishDatePicker.rx.controlEvent(.valueChanged).subscribe(onNext: {
            RLM.write {
                self.workout.finishDate = self.finishDatePicker.date
            }
            self.finishDateLabel.text = self.df.string(from: self.finishDatePicker.date)
        }).addDisposableTo(db)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -80)
            ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        startDateLabel.resignFirstResponder()
        finishDateLabel.resignFirstResponder()
        super.viewWillDisappear(animated)
    }
    let db = DisposeBag()
}


