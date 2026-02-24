# Security Policy

## Supported Versions

| Component | Version |
|-----------|---------|
| Django    | 4.2+    |
| Python    | 3.11+   |
| Flutter   | 3.13+   |

Please ensure you are using the latest stable versions of these technologies when running this project.

---

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it **privately** so that it can be addressed before public disclosure.

1. **Email**: Send a detailed report to `maheshshres1514@gmail.com`.
2. **Include**:
   - Project name and version
   - Steps to reproduce the issue
   - Expected vs actual behavior
   - Screenshots or logs if applicable

Please **do not create a public issue** on GitHub for security problems — this prevents malicious actors from exploiting it before it’s fixed.

---

## Security Guidelines

- Always use HTTPS for API endpoints in production.  
- Keep **SECRET_KEY** and other sensitive information in `.env` files.  
- Ensure **JWT tokens** are securely stored in mobile apps (SharedPreferences or secure storage).  
- Regularly update dependencies to patch known vulnerabilities (`pip list --outdated` for Python, `flutter pub outdated` for Flutter).  
- Avoid committing sensitive data (like `.env` files, passwords, or API keys) to the repository.  

---

## Response

- Security reports will be acknowledged within 48 hours.  
- Critical issues will be prioritized and a patch released promptly.  
- Minor issues will be tracked and fixed in future updates.

---

## Additional Resources

- [Django Security Guide](https://docs.djangoproject.com/en/4.2/topics/security/)  
- [Flutter Security Best Practices](https://flutter.dev/docs/development/data-and-backend/networking#security)  

---

*Thank you for helping keep this project safe and secure.*