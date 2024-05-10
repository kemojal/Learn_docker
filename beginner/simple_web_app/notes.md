run

```bash
docker build .
```

(referenc)[https://peihsinsu.gitbooks.io/docker-note-book/content/docker-build.html]

docker run -p 8000:5000 simple_web_app

1.  build the docker container, replace `simple_web_app` with the project name

```bash
 docker build -t simple_web_app .
```

2.  run the docker container

```bash
docker run -p 8000:5000 simple_web_app
```

3.  access the server

```bash
http://localhost:8000/

```
