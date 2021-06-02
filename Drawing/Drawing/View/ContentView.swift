import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: []) var drawings: FetchedResults<Drawing>
    @State private var showSheet = false
    
    private let title = "Drawing"
    
    var plugView: some View {
        VStack{
            Image(systemName: "scribble.variable")
                .font(.largeTitle)
            Text("No canvas has been selected")
                .font(.title)
        }
    }

    var addButtonAction: some View {
        Button {
            showSheet.toggle()
        } label: {
            HStack{
                Image(systemName: "plus")
                Text("Add Canvas")
            }
        }
        .foregroundColor(.blue)
        .sheet(isPresented: $showSheet) {
            AddNewCanvasView()
                .environment(\.managedObjectContext, viewContext)
        }
    }

    var body: some View {
        NavigationView{
            VStack{
                List {
                    ForEach(drawings) { drawing in
                        NavigationLink(destination: DrawingView(id: drawing.id, data: drawing.canvasData, title: drawing.title), label: {
                            Text(drawing.title ?? "Untitled")
                        })
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle(title)
                .toolbar { EditButton() }
            
                addButtonAction
            }
            plugView
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    func delete(at indexSet: IndexSet) {
        for index in indexSet {
            viewContext.delete(drawings[index])
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
