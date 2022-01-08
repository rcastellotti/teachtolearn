FROM docker.io/node:17-alpine as builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

FROM docker.io/node:17-alpine 
COPY --from=builder /app/build /build
COPY --from=builder /app/package.json .
RUN npm install --only=prod
