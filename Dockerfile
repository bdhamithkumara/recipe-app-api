# Use an official Python 3.9 image based on Alpine Linux (lightweight)
FROM python:3.9-alpine3.13

# Add a maintainer label (optional but good practice)
LABEL maintainer="bdhamithkumara"

# Ensures Python output is sent straight to terminal (no buffering)
ENV PYTHONUNBUFFERED 1

# Copy requirements file from host to image's /tmp directory
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy your application code into the /app directory in the image
COPY ./app /app

# Set /app as the working directory (all commands run from here)
WORKDIR /app

# Expose port 8000 (so container listens on this port)
EXPOSE 8000

# Create a virtual environment in /py, upgrade pip,
# install requirements, clean up temp files, and add a non-root user

ARG DEV=false

# create virtual env in /py 33
# upgrade pip inside venv 34
# install dependencies from requirements 35
# remove temp files to reduce image size 36
# add a new user (non-root) 37
# user cannot log in with password 38
# do not create a home directory 39
# name of the user 40
RUN python -m venv /py && \                                
    /py/bin/pip install --upgrade pip && \                   
    /py/bin/pip install -r /tmp/requirements.txt && \  
    if [$DEV = "true"]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \     
    rm -rf /tmp && \                                         
    adduser \                                                
        --disabled-password \                                
        --no-create-home \                                  
        django-user                                          

# Add venv’s bin directory to PATH so python & pip are found globally
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user (best practice for security)
USER django-user
