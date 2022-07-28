FROM python:3.8-slim

WORKDIR /app

# Install & use pipenv
COPY Pipfile Pipfile.lock  /app/

RUN python -m pip install --upgrade pip && pip install pipenv && pipenv install

COPY app.py config.py run_app.sh /app/

CMD [ "./run_app.sh" ]