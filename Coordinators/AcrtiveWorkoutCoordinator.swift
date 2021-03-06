import CoordinatorKit
import UIKit
import RxSwift
import RxCocoa

protocol ActiveWorkoutCoordinatorDelegate: class {
    func hideTapped(for activeWorkoutCoordinator: ActiveWorkoutCoordinator)
}

class ActiveWorkoutCoordinator: Coordinator {
    
    weak var delegate: ActiveWorkoutCoordinatorDelegate!
    
    var workout: Workout!
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    
    override func loadViewController() {
        viewController = WorkoutTVC()
        workoutTVC.delegate = self
        workoutTVC.workout = workout
        
        workoutTVC.didTapAddNewLift = {
            let ltc = LiftTypeCoordinator()
            let ltcNav = NavigationCoordinator(rootCoordinator: ltc)
            
            ltc.liftTypeTVC.navigationItem.leftBarButtonItem!.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true)
            }).addDisposableTo(self.db)
            
            ltc.liftTypeTVC.didSelectLiftName = { name in
                self.dismiss(animated: true)
                self.workoutTVC.addNewLift(name: name)
            }
            
            self.present(ltcNav, animated: true)
        }
        
    }
    
    var workoutIsNotActive: (() -> ())!
    let db = DisposeBag()
}

extension ActiveWorkoutCoordinator: WorkoutTVCDelegate {
    func showWorkoutDetailTapped(for workoutTVC: WorkoutTVC) {
        let wdc = WorkoutDetailCoordinator(workout: workoutTVC.workout)
        show(wdc, sender: self)
    }
    
    func hideTapped(for workoutTVC: WorkoutTVC) {
        self.delegate.hideTapped(for: self)
    }
    
    func workoutCancelled(for workoutTVC: WorkoutTVC) {
        DispatchQueue.main.async {
            self.workout.deleteSelf()
            self.workoutIsNotActive()
        }
        navigationCoordinator?.parent?.dismiss(animated: true)
    }
    func workoutFinished(for workoutTVC: WorkoutTVC) {
        RLM.write {
            self.workout.isComplete = true
            self.workout.finishDate = Date()
            for lift in self.workout.lifts {
                
                var strings: [String] = []
                for set in lift.sets {
                    let rem = set.completedWeight.remainder(dividingBy: 1)
                    var str: String
                    if rem == 0 {
                        str = String(Int(set.completedWeight))
                    } else {
                        str = String(set.completedWeight)
                    }
                    str = str + " x " + String(set.completedReps)
                    strings.append(str)
                }
                let joined = strings.joined(separator: ", ")
                
                
//                let string = lift.sets.map { "\(($0.completedWeight.remainder(dividingBy: 1) == 0) ? String(Int($0.completedWeight)) : String($0.completedWeight))" + " x " + "\($0.completedReps)" }.joined(separator: ",")
                UserDefaults.standard.set(joined, forKey: "last" + lift.name)
            }
        }
        workoutIsNotActive()
        navigationCoordinator?.parent?.dismiss(animated: true)
    }
}
