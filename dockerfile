FROM node
RUN git clone -b develop https://github.com/EndoHizumi/myPomodoro.git
WORKDIR /myPomodoro/mypomodoro/

RUN npm install && npm update && npm run build
RUN npm install -g http-server
WORKDIR /myPomodoro/mypomodoro/dist
RUN http-server