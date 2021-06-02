//
//  AddCanvasView.swift
//  Drawing
//
//  Created by Mark Nagibin on 02.06.2021.
//

import SwiftUI

struct AddNewCanvasView: View {
    
    @Environment (\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    @State private var canvasTitle = ""
    
    private let canvasTitlePlaceholder = "Canvas Title"
    private let title = "Add New Canvas"
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(canvasTitlePlaceholder, text: $canvasTitle)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle(title)
            .navigationBarItems(
                leading: Button(action: cancel) {
                    Image(systemName: "xmark")
                },
                trailing: Button(action: save) {
                    Text("Save")
                }
            )
        }
    }
    
    private func cancel() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func save() {
        if !canvasTitle.isEmpty {
            let drawing = Drawing(context: viewContext)
            drawing.id = UUID()
            drawing.title = canvasTitle
            
            do {
                try viewContext.save()
            } catch{
                print(error.localizedDescription)
            }
            cancel()
        }
    }

}

struct AddNewCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCanvasView()
    }
}
