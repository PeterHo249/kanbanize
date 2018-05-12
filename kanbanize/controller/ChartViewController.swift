
import UIKit
import PieCharts
import CoreData

class ChartViewController: UIViewController, PieChartDelegate {
    // MARK - Variable
    var boardName = ""
    //---------------------------------
    
    @IBOutlet weak var chartView: PieChart!
    override func viewDidAppear(_ animated: Bool) {
        
       chartView.layers = [createCustomViewsLayer(), createTextLayer()]
       chartView.delegate = self
       chartView.models = createModels() // order is important - models have to be set at the end
        print("vao CustomView")
        print(boardName)
    }
    
    // MARK: - PieChartDelegate
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
    }
    
    // MARK: - Models
    
    fileprivate func createModels() -> [PieSliceModel] {
        let alpha: CGFloat = 0.5
        let valTodo = Task.FetchData(sort: true, board: boardName, status: "todo").count
        let valDoing = Task.FetchData(sort: true, board: boardName, status: "doing").count
        let valDone = Task.FetchData(sort: true, board: boardName, status: "done").count
        let valOverDue = Task.FetchData(sort: true, board: boardName, status: "overdue").count
        let valTotal = valTodo+valDone+valDoing+valOverDue
        return [
            PieSliceModel(value: Double(valTodo), color: UIColor.blue.withAlphaComponent(alpha)),
            PieSliceModel(value: Double(valDoing), color: UIColor.yellow.withAlphaComponent(alpha)),
            PieSliceModel(value: Double(valDone), color: UIColor.green.withAlphaComponent(alpha)),
            PieSliceModel(value: Double(valOverDue), color: UIColor.red.withAlphaComponent(alpha)),
        ]
    }
    
    // MARK: - Layers
    
    fileprivate func createCustomViewsLayer() -> PieCustomViewsLayer {
        let viewLayer = PieCustomViewsLayer()
        
        let settings = PieCustomViewsLayerSettings()
        settings.viewRadius = 135
        settings.hideOnOverflow = false
        viewLayer.settings = settings
        
        viewLayer.viewGenerator = createViewGenerator()
        
        return viewLayer
    }
    
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 60
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 12)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
        return {slice, center in
            
            let container = UIView()
            container.frame.size = CGSize(width: 100, height: 40)
            container.center = center
            let view = UIImageView()
            view.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
            container.addSubview(view)
            
           
                let specialTextLabel = UILabel()
                specialTextLabel.textAlignment = .center
                if slice.data.id == 0 {
                    specialTextLabel.text = "Todo"
                     specialTextLabel.textColor = UIColor.blue
                    specialTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
                } else if slice.data.id == 2 {
                    specialTextLabel.textColor = UIColor.blue
                    specialTextLabel.text = "Done"
                } else if slice.data.id == 3 {
                    specialTextLabel.textColor = UIColor.blue
                    specialTextLabel.text = "Overdue"
                }else if slice.data.id == 1 {
                    specialTextLabel.textColor = UIColor.blue
                    specialTextLabel.text = "Doing"
            }
                specialTextLabel.sizeToFit()
                specialTextLabel.frame = CGRect(x: 0, y: 40, width: 100, height: 20)
                container.addSubview(specialTextLabel)
                container.frame.size = CGSize(width: 100, height: 60)
            
            
            
            let imageName: String? = {
                switch slice.data.id {
                case 0: return "icons8-women-48"
                case 1: return "icons8-exercise-48"
                case 2: return "icons8-counselor-48"
                case 3: return "icons8-crying-baby-48"
                default: return nil
                }
            }()
            
            view.image = imageName.flatMap{UIImage(named: $0)}
            
            return container
        }
    }
}
