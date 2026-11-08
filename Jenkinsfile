pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 15, unit: 'MINUTES')
    }

    stages {
        stage('Build and test Java backend') {
            steps {
                sh 'mvn -B -f fullstack-app/backend-java/pom.xml test package'
            }
            post {
                always {
                    junit testResults: 'fullstack-app/backend-java/target/surefire-reports/*.xml', allowEmptyResults: true
                }
            }
        }

        stage('Test Python frontend') {
            steps {
                dir('fullstack-app/frontend-python') {
                    sh '''
                        python3 -m venv .venv
                        . .venv/bin/activate
                        python -m pip install --upgrade pip
                        pip install -r requirements.txt
                        python -m unittest discover -s tests -v
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Java backend and Python frontend checks passed.'
        }
    }
}
