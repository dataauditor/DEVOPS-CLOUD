FROM postgres 
RUN mkdir -p /tmp/psql_data/
COPY ./init.sql /docker-entrypont-initdb.d/
EXPOSE 5432
