FROM node:latest

WORKDIR /app
COPY . /app
RUN npm install && npm -g install typescript && tsc
ENTRYPOINT [ "node", "cli" ]
