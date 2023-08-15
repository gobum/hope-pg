FROM postgres
RUN apt update &&\
    apt install -y git
ENV POSTGRES_PASSWORD Passw0rd!
ENV PGUSER postgres