# Flutter Web Execution Rules

- When running Flutter for the web in this project (`web_admin_san`), ALWAYS specify port 3000:
  ```bash
  flutter run -d chrome --web-port=3000
  ```
  or for web-server mode:
  ```bash
  flutter run -d web-server --web-port=3000 --web-hostname=localhost
  ```
