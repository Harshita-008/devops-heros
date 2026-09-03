FROM node:22-alpine

WORKDIR /app

# copy package.json first so npm install is cached
COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
