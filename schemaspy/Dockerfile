FROM java:8u111-jre-alpine
LABEL maintainer="Benoit Mazière <benoit.maziere@ekino.com>"

ARG CI_HELPER_VERSION
ARG MYSQL_CONNECTOR_VERSION
ARG POSTGRESQL_CONNECTOR_VERSION
ARG SCHEMASPY_VERSION

ENV LC_ALL=C

ADD open-sans.tar.gz /usr/share/fonts/

RUN apk add --update curl graphviz \
    && fc-cache -fv \
    && echo "Install Mysql connector" \
    && curl -sSL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz | tar -xz \
    && ln -s mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar mysql-connector-java.jar \
    && echo "Install Postgresql connector" \
    && curl -sSL "https://jdbc.postgresql.org/download/postgresql-${POSTGRESQL_CONNECTOR_VERSION}.jar" -o "postgresql-connector-java.jar" \
    && chmod 755 /postgresql-connector-java.jar \
    && echo "Install Schemaspy" \
    && curl -sSL https://github.com/schemaspy/schemaspy/releases/download/v${SCHEMASPY_VERSION}/schemaspy-${SCHEMASPY_VERSION}.jar -o /schemaspy.jar \
    && echo "Install CI Helper" \
    && curl -sSL https://github.com/rande/gitlab-ci-helper/releases/download/${CI_HELPER_VERSION}/alpine-amd64-gitlab-ci-helper -o /usr/bin/ci-helper \
    && chmod 755 /usr/bin/ci-helper \
    && echo "Done install CI Helper" \

CMD ["tail", "-f", "/dev/null"]
