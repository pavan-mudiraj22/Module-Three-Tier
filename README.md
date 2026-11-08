# Module-Three-Tier apply flow

```bash
terraform apply -target=module.vpc
terraform apply -target=module.bastion
terraform apply -target=module.frontend-ec2
terraform apply -target=module.backend-ec2
terraform apply -target=module.frontend_alb
terraform apply -target=module.backend_alb
terraform apply -target=module.rds
```

Deploy the frontend and backend applications to their EC2 instances. Configure the frontend with the backend load balancer URL and configure the backend with the RDS connection details. Keep credentials out of source control.

Apply the remaining modules:

```bash
terraform apply -target=module.frontend_launchtemplate
terraform apply -target=module.backend_launchtemplate
terraform apply -target=module.asg-backend
terraform apply -target=module.asg-frontend
```

## Sample full-stack application

`fullstack-app/` contains a small task manager with a **Java Spring Boot REST backend** and a **Python Flask frontend**. The frontend server calls the Java API; it does not require browser-side CORS configuration. Data is held in memory, so tasks reset when the backend restarts.

### Run locally (no Docker)

Requirements: Java 17+, Maven, and Python 3.10+.

Terminal 1 — backend:

```bash
cd fullstack-app/backend-java
mvn spring-boot:run
```

Terminal 2 — frontend:

```bash
cd fullstack-app/frontend-python
python3 -m venv .venv
. .venv/bin/activate  # Windows: .venv\\Scripts\\activate
pip install -r requirements.txt
python app.py
```

Open <http://localhost:5000>. The Java API listens on port 8080. To point the Python frontend at another API host, set `BACKEND_API_URL`, for example `http://localhost:8080`.

### Jenkins

The root `Jenkinsfile` builds and tests the Java backend and Python frontend. Configure a Jenkins agent with Java 17, Maven, and Python 3; this pipeline does not use Docker or deploy to AWS.
