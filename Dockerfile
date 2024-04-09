FROM node:18

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY --chown=node:node package*.json ./

USER node
RUN npm install

COPY --chown=node:node . .

ENV NEXT_TELEMETRY_DISABLED 1
RUN npm run build

EXPOSE 3000
CMD [ "npm", "run", "start" ]
