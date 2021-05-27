//
//  NewTaskViewController.swift
//  TaskListCoreData
//
//  Created by Marat Shagiakhmetov on 26.05.2021.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var taskTextField: UITextField = {//ленивое свойство (lazy) - позволяет осуществить отложенную инициализацию свойств. отложено - это значит, что свойство будет инициализировано в тот момент когда мы к нему обратимся впервые при создании экземпляра класса. данное свойство не будет инициализировано, а впервые будет инициализировано, когда обратимся к нему в методе viewDidLoad
        let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 200/255,
            alpha: 1
        )
        
        button.setTitle("Save Task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(
            red: 255/255,
            green: 200/255,
            blue: 200/255,
            alpha: 1
        )
        setupSubviews()//вызов метода setupSubview и обращаемся к текстовому полю и именно в этот момент происходит первичная инициализация taskTextField
        setConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(taskTextField)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
    }
    
    private func setConstraints() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false //translatesAutoresizingMaskIntoConstraints переводится как автоматическая растановка автоизменений. короче, даем размещение элементов интерфейса. true - означает будем размещать при помощи констрейнтов, в другом случае false - отключаем автосайзинг. когда мы работаем со сторибордом, там для любого элемента интерфейса можно открыть пару в сториборде из проводящей панели атрибутов вкладку с названием says и в этой вкладке есть такой параметр, который называется авто... и этот паораментр по умолчанию включен почему-то. поэтому, мы программно должны его отключать
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    @objc private func save() {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return } //описание сущности, которая содержит все информацию о всех моделях, которые хранятся
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return } //на основе созданного нами объекта уже создаются конкретный экземпляр модели и все экземпляры моделей имеют типа Int
        task.name = taskTextField.text //через этот экземпляр происходит значение свойства name, конкретное внесенное значение, которое пользователь внес в текстовое поле taskTextField
        dismiss(animated: true) //дальше на основе entityDescription создаем конкретный экземпляр модели, task по умолчанию принимает NSManagedObject до нашего нужного типа класса Task и после этого обращаемся к экземпляру модели передаем в свойства модели task.name необходимое значение. любой объект сущности живет в конкретном определенном контексте
        if context.hasChanges { //если произошли изменения в контекте, то вызываем метод сейв
            do {
                try context.save() //все методы, которые связаны с базами данных, сетевыми запросами они выкидывают с try, потому что никто ничего гарантировать никогда не может. поэтому данный метод нужно вызывать через try.
            } catch let error { //объект ошибки и вывод на консоль, если вдруг возникнет ошибка
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
}
