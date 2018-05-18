
import UIKit
import PieCharts

class DoughnutDemo: UIViewController, PieChartDelegate {
    
    @IBOutlet weak var chartView: PieChart!
    var boardName = ""
    var valTodo = 0
    var valDoing = 0
    var valDone = 0
    var valOverdue = 0
    
    fileprivate static let alpha: CGFloat = 0.5
    let colors = [
        UIColor.yellow.withAlphaComponent(alpha),
        UIColor.blue.withAlphaComponent(alpha),
        UIColor.green.withAlphaComponent(alpha),
        UIColor.purple.withAlphaComponent(alpha),
        UIColor.cyan.withAlphaComponent(alpha),
        UIColor.darkGray.withAlphaComponent(alpha),
        UIColor.red.withAlphaComponent(alpha),
        UIColor.magenta.withAlphaComponent(alpha),
        UIColor.orange.withAlphaComponent(alpha),
        UIColor.brown.withAlphaComponent(alpha),
        UIColor.lightGray.withAlphaComponent(alpha),
        UIColor.gray.withAlphaComponent(alpha),
    ]
    fileprivate var currentColorIndex = 0

    
    override func viewDidAppear(_ animated: Bool) {

        chartView.layers = [createPlainTextLayer(), createTextWithLinesLayer()]
        chartView.delegate = self
        chartView.models = createModels() // order is important - models have to be set at the end
    }
    
    // MARK: - PieChartDelegate
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
    }
    
    // MARK: - Models
    
    fileprivate func createModels() -> [PieSliceModel] {
        valTodo = Task.FetchData(sort: true, board: boardName, status: "todo").count
        valDoing = Task.FetchData(sort: true, board: boardName, status: "doing").count
        valDone = Task.FetchData(sort: true, board: boardName, status: "done").count
        valOverdue = Task.FetchData(sort: true, board: boardName, status: "overdue").count
        let PMTodo=PieSliceModel(value: Double(valTodo), color: colors[1])
        let PMDoing =  PieSliceModel(value: Double(valDoing), color: colors[0])
        let PMDone = PieSliceModel(value: Double(valDone), color: colors[2])
        let PMOverdue = PieSliceModel(value: Double(valOverdue), color: colors[6])
        var models = [PieSliceModel]()
      
        if valOverdue != 0{
            models.append(PMOverdue)
        }
        if valDone != 0{
            models.append(PMDone)
        }
        if valDoing != 0{
            models.append(PMDoing)
        }
        if valTodo != 0{
            models.append(PMTodo)
        }
       
      
        
        currentColorIndex = models.count
        print(models.count)
        return models
    }
    

    
    // MARK: - Layers
    
    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {
        
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 55
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 15)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            print(slice.data.percentage)
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 20)
        lineTextLayerSettings.label.textColor=colors[3]
        lineTextLayerSettings.label.textGenerator = {slice in
            if( self.valTodo > 0){
                self.valTodo = -1
                return "todo"
               
            }
            if( self.valDoing > 0){
                  self.valDoing = -1
                return "doing"
              
            }
            if( self.valDone > 0){
                 self.valDone = -1
                return "done"
               
            }
            if( self.valOverdue > 0){
                self.valOverdue = -1
                return "overdue"
            }
            return "nil"
        }
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
}
