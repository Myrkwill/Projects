import SwiftUI
import CoreData
import PencilKit

struct DrawingCanvasView: UIViewControllerRepresentable {
    typealias UIViewControllerType = DrawingCanvasViewController
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var data: Data
    var id: UUID
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.drawingData = data
    }
    
    func makeUIViewController(context: Context) -> DrawingCanvasViewController {
        let viewController = UIViewControllerType()
        
        viewController.drawingData = data
        viewController.drawingChanged = { drawingChanged(data: $0) }
        
        return viewController
    }
    
    private func drawingChanged(data: Data) {
        let request: NSFetchRequest<Drawing> = Drawing.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        
        do {
            let result = try viewContext.fetch(request)
            let object = result.first
            object?.setValue(data, forKey: "canvasData")
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
