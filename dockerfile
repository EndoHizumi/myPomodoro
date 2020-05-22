FROM node
COPY ./mypomodoro /mypomodoro
WORKDIR /mypomodoro
RUN npm install && npm update && npm run build
RUN npm install -g http-server
WORKDIR /mypomodoro/dist
CMD [ "http-server" ] 