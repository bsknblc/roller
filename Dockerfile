name: Run Application Continuously

on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  selenium-app:
    runs-on: ubuntu-latest
    timeout-minutes: 0  # Disables the timeout (will run indefinitely until manually stopped)

    steps:
      - name: Set up JDK
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'zulu'

      - name: Set up Xvfb (for headless display)
        run: |
          echo "DISPLAY=:99.0" >> $GITHUB_ENV
          Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
      
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Build Project
        run: mvn -V -ntp install -DskipTests

      - name: Build Docker Image
        run: |
          docker build -t roller-app .

      - name: Run Application in Docker Container
        run: |
          docker run -d -p 8080:8080 roller-app
          
      # Optional: Monitor logs or perform any additional tasks if necessary
      # - name: Monitor Application Logs
      #   run: docker logs -f <container_id>
