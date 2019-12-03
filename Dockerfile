ARG NODE_TAG=12
ARG NGINX_TAG=alpine
ARG APP_HOME=/usr/src/app

# build stage
FROM node:${NODE_TAG} as build
ARG NODE_TAG
ARG APP_HOME

WORKDIR ${APP_HOME}
COPY package*.json yarn.lock ./
RUN yarn

COPY . ./
RUN yarn build

# deploy stage
FROM nginx:${NGINX_TAG}
ARG NGINX_TAG
ARG APP_HOME
RUN echo "nginx:${NGINX_TAG}" > /docker-image-tag && cat /docker-image-tag
COPY --from=build ${APP_HOME}/build /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]