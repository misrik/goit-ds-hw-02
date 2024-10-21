-- Table: users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname VARCHAR(100) NOT NULL,  
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Table: status
DROP TABLE IF EXISTS status;
CREATE TABLE status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO status (name) VALUES 
('new'),
('in progress'),
('completed');

-- Table: tasks
DROP TABLE IF EXISTS tasks;
CREATE TABLE tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    status_id INTEGER,
    user_id INTEGER,
    FOREIGN KEY (status_id) REFERENCES status (id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

/*
1. Отримати всі завдання певного користувача. 
Використайте SELECT для отримання завдань 
конкретного користувача за його user_id.
*/
SELECT t.*
FROM tasks AS t
JOIN users AS u ON t.user_id = u.id
WHERE u.id = ?;

/*
2. Вибрати завдання за певним статусом.
   Використайте підзапит для вибору завдань з конкретним статусом, 
   наприклад, 'new'.
*/
SELECT id, title, description 
FROM tasks 
WHERE status_id = (SELECT id FROM status WHERE name = 'new');

/*
3.1. Оновити статус конкретного завдання.
   Змініть статус конкретного завдання на 
   'in progress' або інший статус.
*/
UPDATE tasks
SET status_id = (
    SELECT id FROM status WHERE name = 'in progress'
)
WHERE status_id = (SELECT id FROM status WHERE name = 'new')
AND id = ?;  

/*
3.2. Оновити статус конкретного завдання.
   Змініть статус конкретного завдання на 
   'completed'.
*/
UPDATE tasks
SET status_id = (
    SELECT id FROM status WHERE name = 'completed'
)
WHERE status_id = (SELECT id FROM status WHERE name = 'in progress')
AND id = ?;  

/*
4. Отримати список користувачів, які не мають жодного завдання.
   Використайте комбінацію SELECT, WHERE NOT IN і підзапит.
*/
SELECT *
FROM users
WHERE id NOT IN (
    SELECT user_id FROM tasks
);

/*
5. Додати нове завдання для конкретного користувача.
   Використайте INSERT для додавання нового завдання.
*/
INSERT INTO tasks (user_id, title, description, status_id)
VALUES (?, 'New task', 'Task description', 1);

/*
6. Отримати всі завдання, які ще не завершено.
   Виберіть завдання, чий статус не є 'завершено'.
*/
SELECT *
FROM tasks
WHERE status_id != (
    SELECT id FROM status WHERE name = 'completed'
);

/*
7. Видалити конкретне завдання.
   Використайте DELETE для видалення завдання за його id.
*/
DELETE FROM tasks
WHERE id = ?;  

/*
8. Знайти користувачів з певною електронною поштою.
   Використайте SELECT із умовою LIKE для фільтрації за електронною поштою.
*/
SELECT *
FROM users
WHERE email LIKE '%@example.com'; 

/*
9. Оновити ім'я користувача.
   Змініть ім'я користувача за допомогою UPDATE.
*/
UPDATE users
SET fullname = ? 
WHERE id = ?; 

/*
10. Отримати кількість завдань для кожного статусу.
   Використайте SELECT, COUNT, GROUP BY для групування завдань за статусами.
*/
SELECT s.name, COUNT(t.id) AS task_count
FROM status AS s
LEFT JOIN tasks AS t ON s.id = t.status_id
GROUP BY s.name;

/*
11. Отримати завдання, які призначені користувачам з певною доменною частиною електронної пошти.
    Використайте SELECT з умовою LIKE в поєднанні з JOIN, 
    щоб вибрати завдання, призначені користувачам, 
    чия електронна пошта містить певний домен (наприклад, '%@example.com').
*/
SELECT t.*
FROM tasks AS t
JOIN users AS u ON t.user_id = u.id
WHERE u.email LIKE '%@example.com'; 

/*
12. Отримати список завдань, що не мають опису.
   Виберіть завдання, у яких відсутній опис.
*/
SELECT *
FROM tasks
WHERE description IS NULL OR description = '';

/*
13. Вибрати користувачів та їхні завдання, які є у статусі 'in progress'.
   Використайте INNER JOIN для отримання списку користувачів та їхніх завдань із певним статусом.
*/
SELECT u.fullname, t.title, s.name AS status
FROM users AS u
INNER JOIN tasks AS t ON u.id = t.user_id
INNER JOIN status AS s ON t.status_id = s.id
WHERE s.name = 'in progress';

/*
14. Отримати користувачів та кількість їхніх завдань.
   Використайте LEFT JOIN та GROUP BY для вибору користувачів та підрахунку їхніх завдань.
*/
SELECT u.fullname, COUNT(t.id) AS task_count
FROM users AS u
LEFT JOIN tasks AS t ON u.id = t.user_id
GROUP BY u.fullname;
