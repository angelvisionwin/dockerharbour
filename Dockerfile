FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar herramientas y dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    build-essential \
    libcurl4-gnutls-dev \
    vim \
    ca-certificates

# Crear enlace simb�lico para curl en /usr/include
RUN ln -s x86_64-linux-gnu/curl /usr/include/curl

# Clonar Harbour y compilar con soporte libcurl
WORKDIR /src
RUN git clone https://github.com/harbour/core harbour && \
    cd harbour && \
    export HB_WITH_CURL=/usr/include && \
    make > result.log && \
    rm -rf /usr/local/share/harbour /usr/local/lib/harbour /usr/local/include/harbour && \
    make install

# Configurar librer�as din�micas
RUN echo "/usr/local/lib/harbour" > /etc/ld.so.conf.d/harbour.conf && \
    ldconfig

# Corregir enlaces simb�licos de libharbour
WORKDIR /src/harbour/lib
RUN ln -s libharbour.so.3.2.0 libharbour.so && \
    ln -s libharbour.so.3.2.0 libharbour.so.3.2

# Crear directorio de trabajo
WORKDIR /app
