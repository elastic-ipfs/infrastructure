FROM node:16

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
# ENV AWS_SDK_LOAD_CONFIG=1
EXPOSE 8080
CMD [ "node", "index.js" ]
