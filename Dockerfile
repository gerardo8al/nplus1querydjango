FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN ls -la /usr/src/app/

EXPOSE 8000

CMD ["python", "mysite/manage.py", "runserver", "0.0.0.0:8000"]
