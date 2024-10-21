from datetime import datetime
import faker
from random import randint, choice
import sqlite3

NUMBER_USERS = 40 
NUMBER_TASKS = 100
STATUS_LIST = ['new', 'in progress', 'completed']

def generate_fake_data(number_users, number_tasks) -> tuple:
    fake_data = faker.Faker()

    fake_users = []
    fake_tasks = []

    for _ in range(number_users):
        fullname = fake_data.name()
        email = fake_data.email()
        fake_users.append((fullname, email))
    
    for _ in range(number_tasks):
        title = fake_data.sentence(nb_words=6)
        description = fake_data.paragraph(nb_sentences=3)
        status_id = randint(1, 3)  # 1 - new, 2 - in progress, 3 - completed
        user_id = randint(1, number_users)  # Завдання для випадкового користувача
        fake_tasks.append((title, description, status_id, user_id))

    return fake_users, fake_tasks

def prepare_data(users, tasks) -> tuple:
    prepared_users = [(fullname, email) for fullname, email in users]

    prepared_tasks = [(title, description, status_id, user_id) for title, description, status_id, user_id in tasks]

    return prepared_users, prepared_tasks

def insert_data_to_db(users, tasks) -> None:
    with sqlite3.connect('tasks.db') as con:
        cur = con.cursor()

        sql_to_users = """INSERT INTO users (fullname, email)
                          VALUES (?, ?)"""
        cur.executemany(sql_to_users, users)

        sql_to_tasks = """INSERT INTO tasks (title, description, status_id, user_id)
                          VALUES (?, ?, ?, ?)"""
        cur.executemany(sql_to_tasks, tasks)

        con.commit()

if __name__ == "__main__":
    users, tasks = generate_fake_data(NUMBER_USERS, NUMBER_TASKS)

    prepared_users, prepared_tasks = prepare_data(users, tasks)

    insert_data_to_db(prepared_users, prepared_tasks)
