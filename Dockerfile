FROM node:18

ENV KUBECTL_VERSION="1.29"

# install packages that are nice to have
RUN apt-get -qy update && apt-get install -qy \
apt-transport-https \
    awscli \
    btop \
    ca-certificates \
    fish \
    htop \
    jq \
    less \
    neovim

# install kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v${KUBECTL_VERSION}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${KUBECTL_VERSION}/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list \
    && chmod 644 /etc/apt/sources.list.d/kubernetes.list \
    && apt-get -qy update && apt-get install -qy \
    kubectl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY --chown=node:node package*.json ./

USER node
RUN npm install

COPY --chown=node:node . .

ENV NEXT_TELEMETRY_DISABLED 1
ENV NEXT_PUBLIC_REPLICACHE_LICENSE_KEY "l58fc6ef579d4419c9d6dcd16a9ddc283"
ENV NEXT_PUBLIC_PUSHER_APP_ID "1784843"
ENV NEXT_PUBLIC_PUSHER_KEY "562b86292016fd884410"
ENV NEXT_PUBLIC_PUSHER_SECRET "52e3ce87598bdf249a5c"
ENV NEXT_PUBLIC_PUSHER_CLUSTER "us3"
RUN npm run build

EXPOSE 3000
CMD [ "npm", "run", "start" ]
