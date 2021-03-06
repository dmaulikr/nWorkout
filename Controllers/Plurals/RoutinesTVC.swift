import UIKit
import RxCocoa
import RxSwift
import RealmSwift
import DZNEmptyDataSet
import BonMot

class RoutinesTVC: BaseWorkoutsTVC<RoutineCell> {
    
    func setTableHeaderView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        let label = UILabel()
        label.text = "Routines"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        
        let b = UIButton()
        b.setTitle("New")
        b.setTitleColor(.white)
        
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(b)
        b.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            b.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            b.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        b.rx.tap.subscribe(onNext: {
            let alert = UIAlertController.alert(title: Lets.createNewRoutine, message: nil)
            
            alert.addAction(UIAlertAction(title: Lets.done, style: UIAlertActionStyle.default) { action in
                guard let name = alert.textFields?.first?.text else { fatalError() }
                
                let routine = Workout.new(isWorkout: false, isComplete: false, name: name)
                
                self.dataSource.provider.append(routine)
                
                guard let index = self.dataSource.provider.index(of: routine) else { fatalError() }
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                if self.dataSource.provider.numberOfItems() == 1 {
                    self.tableView.reloadData()
                }
                self.delegate!.routinesTVC(self, didSelectRoutine: routine)
            })
            alert.addAction(UIAlertAction(title: Lets.cancel, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }).addDisposableTo(db)
        
        tableView.tableHeaderView = view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        workouts = RLM.realm.objects(Workout.self).filter("isWorkout = false").sorted(byKeyPath: "name")
        
        dataSource = WorkoutsDataSource(tableView: tableView, workouts: workouts)
        dataSource.name = Lets.routine
        dataSource.displayAlert = { alert in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableHeaderView()
        
        setupDZN()
    }
    
    
    func setupDZN() {
        emptyDataSetController.imageTintColorForEmptyDataSet = .white
        emptyDataSetController.imageForEmptyDataSet = #imageLiteral(resourceName: "routine")
        let s = StringStyle(.color(.white))
        emptyDataSetController.titleForEmptyDataSet = "You do not have any routines, yet!.".styled(with: s)
        emptyDataSetController.descriptionForEmptyDataSet = "Click the + at the top to add your first routine.".styled(with: s)
        
        tableView.emptyDataSetDelegate = emptyDataSetController
        tableView.emptyDataSetSource = emptyDataSetController
    }
   
    let emptyDataSetController = EmptyDataSetController()
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routine = dataSource.provider.object(at: indexPath.row)
        delegate!.routinesTVC(self, didSelectRoutine: routine)
    }
}







