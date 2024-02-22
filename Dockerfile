FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Install dependencies
RUN apk --no-cache add g++ gcc libgcc libstdc++ linux-headers make python3 tini
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN npm install --quiet node-gyp -g
# Add Tini
ENTRYPOINT ["/sbin/tini", "--"]

# Install app dependencies
COPY package.json .
COPY package-lock.json .
RUN npm ci --only=production

# Make sure to get latest
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache

# Bundle app source
COPY . .

EXPOSE 80 8080
WORKDIR "platform"
ENV NODE_ENV=production
CMD ["node", "serve.js"]
