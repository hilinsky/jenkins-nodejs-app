# Stage 1: Build the application
FROM node:14.4.0-alpine AS build

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./

USER node

RUN npm install

COPY --chown=node:node . .

RUN npm run build

# Stage 2: Create the final image
FROM node:14.4.0-alpine AS runtime

USER node

WORKDIR /home/node/app

COPY --chown=node:node --from=build /home/node/app/dist .

COPY --chown=node:node --from=build /home/node/app/node_modules ./node_modules

EXPOSE 8080

CMD [ "node", "app.js" ]
