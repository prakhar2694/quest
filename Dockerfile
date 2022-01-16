
FROM node:10
WORKDIR /opt
ADD package.json package.json
RUN npm install
ARG SECRET_WORD=TwelveFactor
ENV env_var_name=$SECRET_WORD
COPY . .
EXPOSE 3000
CMD ["node","src/000.js"]

