FROM node
COPY ./mypomodoro /mypomodoro
WORKDIR /mypomodoro
RUN sed -i "s/UA-xxxxxxxxx-x/UA-167492815-1/" ./src/main.js
RUN npm install && npm update && npm run build
RUN npm install -g http-server
WORKDIR /mypomodoro/dist
CMD [ "http-server" ] 