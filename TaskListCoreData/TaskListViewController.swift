//
//  ViewController.swift
//  TaskListCoreData
//
//  Created by Marat Shagiakhmetov on 26.05.2021.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let cellID = "cell"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID) //зарегистрировать и указать идентификатор для ячейки
        setupNavigationBar()
        fetchData()
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation Bar Appearence
        let navBarAppearence = UINavigationBarAppearance()
        navBarAppearence.configureWithOpaqueBackground()//отвечает за прозрачность, но мы его не увидим из-за белого фона
        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.white]//цвет фона для маленького текста, который будет отображаться в навигейшн баре
        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]//цвет фона для большого текста
        
        navBarAppearence.backgroundColor = UIColor(
            red: 240/255,
            green: 51/255,
            blue: 60/255,
            alpha: 190/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearence
        //при прокрутки мы можем увидеть, что навигейшн бар сохраняет свой цвет. то есть, как бы сливается при прокрутке вверх или вниз
        
        //Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        //target определяет в каком месте будет вызываться метод, который мы передадим в параметр
        //action - метод, который мы должны здесь определить через селектор
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert(with: "New task", and: "What do you want to do?")
    }
    
    private func fetchData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            taskList = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    } //для восстановления данных нужен метод fetchData, это значит чтобы восстановить данные из базы и нам нужно создать запрос к этой базе. нам надо создать запрос fetchRequest для объектов с типом task, поэтому, мы должны указать тип, который нам нужен. можно настраивать различные параметры сортировки или фильтрации данных для извлечения
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return } //описание сущности, которая содержит все информацию о всех моделях, которые хранятся
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return } //на основе созданного нами объекта уже создаются конкретный экземпляр модели и все экземпляры моделей имеют типа Int
        task.name = taskName //через этот экземпляр происходит значение свойства name, конкретное внесенное значение, которое пользователь внес в текстовое поле taskTextField
        taskList.append(task)
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        //чтобы добавить ячейку нам нужно знать по какому индексу добавить. чтобы определить индекс и за индекс у нас отвечает соответствующий тип данных, который так называется IndexPath. он определяет инжекс ячеек
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        //дальше на основе entityDescription создаем конкретный экземпляр модели, task по умолчанию принимает NSManagedObject до нашего нужного типа класса Task и после этого обращаемся к экземпляру модели передаем в свойства модели task.name необходимое значение. любой объект сущности живет в конкретном определенном контексте
        if context.hasChanges { //если произошли изменения в контекте, то вызываем метод сейв
            do {
                try context.save() //все методы, которые связаны с базами данных, сетевыми запросами они выкидывают с try, потому что никто ничего гарантировать никогда не может. поэтому данный метод нужно вызывать через try.
            } catch let error { //объект ошибки и вывод на консоль, если вдруг возникнет ошибка
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Table View Data Source
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = taskList[indexPath.row]
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
}
