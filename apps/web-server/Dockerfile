FROM node:lts-alpine3.21 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install --frozen-lockfile
COPY . .  
FROM node:lts-alpine3.21  AS production

WORKDIR /app
COPY --from=build /app/package*.json ./
RUN npm ci --only=production --frozen-lockfile
COPY --from=build /app ./
EXPOSE 3000
CMD ["npm", "start"]
