import UIKit

class WorkoutDataSource: DataSource<Workout,WorkoutLiftCell> {
    
    var isActive = false
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        setupFooterView()
    }
    
    func setupFooterView() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
        

        addLiftButton.setTitle("Add Lift", for: UIControlState())
        cancelWorkoutButton.setTitle("Cancel Workout", for: UIControlState())
        finishWorkoutButtoon.setTitle("Finish Workout", for: UIControlState())
        
        addLiftButton.setTitleColor(.black, for: UIControlState())
        cancelWorkoutButton.setTitleColor(.black, for: UIControlState())
        finishWorkoutButtoon.setTitleColor(.black, for: UIControlState())
        
        footer.backgroundColor = .white
        
        footer.addSubview(addLiftButton)
        footer.addSubview(cancelWorkoutButton)
        footer.addSubview(finishWorkoutButtoon)
        
        addLiftButton.translatesAutoresizingMaskIntoConstraints = false
        cancelWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        finishWorkoutButtoon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addLiftButton.topAnchor.constraint(equalTo: footer.topAnchor),
            addLiftButton.leftAnchor.constraint(equalTo: footer.leftAnchor),
            addLiftButton.rightAnchor.constraint(equalTo: footer.rightAnchor),
            addLiftButton.bottomAnchor.constraint(equalTo: cancelWorkoutButton.topAnchor),
            cancelWorkoutButton.bottomAnchor.constraint(equalTo: finishWorkoutButtoon.topAnchor),
            finishWorkoutButtoon.bottomAnchor.constraint(equalTo: footer.bottomAnchor)
            ])
        
        tableView.tableFooterView = footer
    }
    
    let addLiftButton = UIButton()
    let cancelWorkoutButton = UIButton()
    let finishWorkoutButtoon = UIButton()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! WorkoutLiftCell
        textFieldBehaviorHandler.setupSetConnections(for: cell)
        
        let lift = provider.object(at: indexPath.row)
        cell.lift = lift
        
        cell.addSetButton.rx.tap.subscribe(onNext: {
            self.addSet(for: lift, and: cell)
        }).addDisposableTo(cell.db)
        return cell
    }
    
    func addSet(for lift: Lift, and cell: LiftCell) {
        textFieldBehaviorHandler.currentlyEditingTextField?.resignFirstResponder()
        textFieldBehaviorHandler.currentlyEditingTextField = nil
        tableView.beginUpdates()
        let set = Set()
        RLM.write {
            if let last = lift.sets.last {
                set.weight = last.weight
                set.reps = last.reps
            } else {
                set.weight = 225
                set.reps = 5
            }
            lift.sets.append(set)
            cell.chartView.setup()
            self.textFieldBehaviorHandler.setupRowConnections(for: cell.chartView.rowViews.last as! SetRowView, cell: cell)
        }
        tableView.endUpdates()
    }
    
    lazy var textFieldBehaviorHandler: TextFieldBehaviorHandler = {
        let tfbh = TextFieldBehaviorHandler()
        tfbh.liftNeedsNewSet = { [unowned self] in
            self.addSet(for: tfbh.currentlyEditingLiftCell!.lift, and:  tfbh.currentlyEditingLiftCell!)
        }
        return tfbh
    }()
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { fatalError() }
        provider.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if provider.numberOfItems() == 0 {
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        provider.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}





























