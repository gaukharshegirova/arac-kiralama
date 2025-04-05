# Base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8000 for Gunicorn
EXPOSE 8000

# Command to run the application using Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:8000", "wsgi:app"]