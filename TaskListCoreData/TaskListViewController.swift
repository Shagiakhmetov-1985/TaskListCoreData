//
//  ViewController.swift
//  TaskListCoreData
//
//  Created by Marat Shagiakhmetov on 26.05.2021.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
//    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let cellID = "cell"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID) //зарегистрировать и указать идентификатор для ячейки
        setupNavigationBar()
        getData()
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
        showAlert()
    }
    
    private func save(task: String) {
        StorageManager.shared.save(task) { task in
            self.taskList.append(task)
            self.tableView.insertRows(
                at: [IndexPath(row: self.taskList.count - 1, section: 0)],
                with: .automatic)
        }
    }
    
    private func getData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let tasks):
                self.taskList = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    } //в блоке замыкания объект типа result, это не какой то массив task, это именно блок. но этот тип с перечислением. в случае успеха (success), то нам вернет кейс массив задач. мы просто берем этот массив и передаем в свойства нашего класса. если будет ошибка, то мы там можем отобразить alert controller, написать пользователю, что типа простите и приходите в следующий раз
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
// MARK: - UITable View Delegate
extension TaskListViewController {
    //Edit task
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskList[indexPath.row]
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    //Delete task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        
        if editingStyle == .delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(task)
        }
    }
}

// MARK: - Alert Controller
extension TaskListViewController {
    
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        
        let title = task != nil ? "Update Task" : "New Task"
        
        let alert = AlertController(
            title: title,
            message: "What do you want to do",
            preferredStyle: .alert
        )
        
        alert.action(task: task) { taskName in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task, newName: taskName)
                completion() //нужен чтобы внутри блока обновить интерфейс
            } else {
                self.save(task: taskName)
            }
        }
        
        present(alert, animated: true)
    }
}
