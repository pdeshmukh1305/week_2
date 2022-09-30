# Set up the container with a specific version of python
# As of 9/29/2022, 3.10.7 is the latest version of python
FROM python:3.10.7

# To make sure we run the below commands as root
USER root 

# Install Jupyter and wget
RUN pip3 install jupyter
RUN apt-get update
RUN apt-get install wget

# Create user with bash access
ENV JUPYTER_USER our_user
RUN useradd -ms /bin/bash $JUPYTER_USER

# Entrypoint has to be specified and exposed
EXPOSE 8888

# Make new directory
RUN mkdir -p /home/${JUPYTER_USER}/notebooks

#Download Jupyter Notebook and the 2 csv files it needs to run in "notebooks" folder for github
WORKDIR /home/${JUPYTER_USER}/notebooks
RUN wget https://raw.githubusercontent.com/pdeshmukh1305/week_2/main/timeseries.ipynb
RUN wget https://raw.githubusercontent.com/pdeshmukh1305/week_2/main/GOOGL.csv
RUN wget https://raw.githubusercontent.com/pdeshmukh1305/week_2/main/santaclara_sfh.csv

# All the needed requirements for the Jupyter Notebook are in the requirements.txt file
COPY requirements.txt ./

# Installing the requirements
RUN pip install --no-cache-dir -r requirements.txt

# Start the installed Jupyter as the user
USER $JUPYTER_USER
CMD jupyter notebook --ip=0.0.0.0 --port 8888  