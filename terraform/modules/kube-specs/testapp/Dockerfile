FROM node:16

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
# Must have this file for using DynamoDB Document Client 
ENV AWS_CONFIG_FILE=/usr/src/app/credentials
ENV AWS_SDK_LOAD_CONFIG=1
EXPOSE 8080
CMD [ "node", "index.js" ]
