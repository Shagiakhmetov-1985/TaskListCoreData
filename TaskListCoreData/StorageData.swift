//
//  StorageData.swift
//  TaskListCoreData
//
//  Created by Marat Shagiakhmetov on 28.05.2021.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    func fetchData(completion: (Result<[Task], Error>) -> Void) { //Result<[Task], Error>) - это перечисление, которая позволяет возвращать данные асинхронно и можно вернуть сами данные в ящик. в угловых скобках помещаем в первом случае тип данных Task, который нам нужно будет вернуть. а во втором случае - ошибку и все это помещаем в комплишн и получается блок
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        //здесь должны быть реализованы все методы по управлению данными в базе: загрузка данных, удаление, редактирование и сохранение
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    } //для восстановления данных нужен метод fetchData, это значит чтобы восстановить данные из базы и нам нужно создать запрос к этой базе. нам надо создать запрос fetchRequest для объектов с типом task, поэтому, мы должны указать тип, который нам нужен. можно настраивать различные параметры сортировки или фильтрации данных для извлечения
    
    //Save data
    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.name = taskName
        
        completion(task)
        saveContext()
    }
    
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
