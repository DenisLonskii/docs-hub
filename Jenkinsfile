pipeline {
    // Выполнять на любом доступном агенте
    agent any 

    stages {
        stage('1. Checkout Code') {
            steps {
                echo 'Скачиваем свежий код главного репозитория (docs-hub) из Git...'
                checkout scm
            }
        }

        stage('2. Build Docker Image') {
            steps {
                echo 'Собираем Docker-образ сборщика портала из Dockerfile...'
                sh 'docker build -t docs-hub-builder:latest .'
            }
        }

        stage('3. Generate Central Portal') {
            steps {
                echo 'Запускаем сборку единого портала со скачиванием дочерних репозиториев...'
                // Подключаем секретный токен GitHub из Jenkins (ID: github-docs-token)
                withCredentials([string(credentialsId: 'github-docs-token', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                        docker run --rm \
                            --volumes-from jenkins \
                            -w "${WORKSPACE}" \
                            -e GithubAccessToken="${GITHUB_TOKEN}" \
                            docs-hub-builder:latest mkdocs build
                    '''
                }
            }
        }

        stage('4. Archive Artifacts') {
            steps {
                echo 'Сохраняем готовую папку site как артефакт сборки...'
                archiveArtifacts artifacts: 'site/**', fingerprint: true
            }
        }
    }
}