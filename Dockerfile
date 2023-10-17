FROM node:18-alpine as builder

WORKDIR /usr/src
COPY . /usr/src

RUN rm -rf node_modules && \
  yarn install \
  --frozen-lockfile \
  --non-interactive

RUN env && yarn build && ls -lha

FROM node:18-alpine as app

ENV NODE_ENV=production

WORKDIR /usr/src

COPY --from=builder /usr/src/.output ./.output

ENV PORT 3000
EXPOSE 3000

CMD [ "node", ".output/server/index.mjs" ]
