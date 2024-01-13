# Django n+1 query problem

This repository contains the companion code for the post at [N+1 Query Problem](https://notgerardo.com/n1-query-problem). It's a very simple Django application designed to be run only on localhost to show using two simple models and a sqlite database the n+1 queries problem, and the solution using the _related functions.

## Building and running
To build the Docker image:
```
docker build -t django-app .
```

To run the container:
```
docker run -p 8000:8000 django-app
```

## Populating the sqlite database
Use the django shell to populate the database. To do this, enter the container using:
```
docker exec -it <container_id> python mysite/manage.py shell
```
You can get the container id by running `docker ps`.

Once inside the shell, type the following:

```
from nplusone.models import Author, Book
import random

for i in range(1000):
    author_name = f"Author {i}"
    author = Author.objects.create(name=author_name)

    # Create a Book for each Author
    book_title = f"Book of {author_name}"
    Book.objects.create(title=book_title, author=author)
```

This will populate the database in a naive way. Make sure to type this code. If you copy/paste it you might get an error. Note that this is not persistent storage, so if you stop your container you will need to repopulate the database.

## The n+1 query problem
To show the n+1 queries, in the Django shell, enter the following: 
```
books = Book.objects.all()[:10] # fetch 10 books

for book in books:
    print(f"{book.title} by {book.author.name}")
```

In your screen you will now see 11 queries being printed in the logs, 1 query to fetch the 10 books and 10 additional queries to fetch each author.

## The n+1 query solution
Now type the following:
```
books = Book.objects.select_related()[:10] # fetch 10 books

for book in books:
    print(f"{book.title} by {book.author.name}")
```

You will now see only 1 query with a join.
