FROM python:3.12-alpine

# Install dependencies
RUN apk add --no-cache gcc libffi-dev musl-dev

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
CMD [ "python", "./torque2mqtt.py", "-c", "/config"]
