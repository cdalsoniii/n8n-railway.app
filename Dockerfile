FROM n8nio/n8n

ARG PGPASSWORD
ARG PGHOST
ARG PGPORT
ARG PGDATABASE
ARG PGUSER

ARG USERNAME
ARG PASSWORD
ARG WEBHOOK_URL

ENV DB_TYPE=postgresdb
ENV DB_POSTGRESDB_DATABASE=$PGDATABASE
ENV DB_POSTGRESDB_HOST=$PGHOST
ENV DB_POSTGRESDB_PORT=$PGPORT
ENV DB_POSTGRESDB_USER=$PGUSER
ENV DB_POSTGRESDB_PASSWORD=$PGPASSWORD

ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=$USERNAME
ENV N8N_BASIC_AUTH_PASSWORD=$PASSWORD
ENV N8N_WEBHOOK_URL=$WEBHOOK_URL

# Set the working directory
WORKDIR /app

# Copy the entire repository into the container
COPY . /app

# Install dependencies and set up custom nodes
# Switching to root user to handle permissions
USER root

# Install dependencies and link the custom nodes
RUN npm install \
    && npm install -g n8n \
    && npm link \
    && npm list -g \
    && cd $(npm root -g)/n8n \
    && npm link /app

# Copy custom nodes to the container
COPY ./nodes /home/node/.n8n/custom/nodes
COPY ./credentials /home/node/.n8n/custom/credentials

# Copy the entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Set permissions for the entrypoint script
RUN chmod +x /docker-entrypoint.sh

# Switch back to non-root user
USER node

# Set the environment variable for custom extensions
ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/custom"

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["n8n", "start"]