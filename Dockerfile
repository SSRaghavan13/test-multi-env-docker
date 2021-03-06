FROM python:3.7-alpine

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .temp-build-deps \
    gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
RUN apk del .temp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

# RUN mkdir -p /vol/web/media
# RUN mkdir -p /vol/web/static
RUN adduser -D user
# RUN chown -R user:user /vol/
# RUN chmod -R 755 /vol/web
USER user

ENV SECRET_KEY=ck^73-xg)-c!w2=$ter%k$chbn1#%%lb++v-10_unp0fqbpx*o
ENV DEBUG=True

CMD python manage.py runserver 0.0.0.0:8000