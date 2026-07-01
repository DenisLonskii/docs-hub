pipeline {
    agent any 

    stages {
        stage('1. Checkout Main Hub Repo') {
            steps {
                echo 'Скачиваем главный репозиторий портала...'
                checkout scm
            }
        }

        stage('2. Checkout Child Repositories') {
            steps {
                echo 'Скачиваем дочерние репозитории во временные директории...'
                
                // 1. Скачиваем репозиторий Руководств
                dir('tmp_guides') {
                    git branch: 'main',
                        credentialsId: 'git',
                        url: 'https://github.com/DenisLonskii/docs-guides.git'
                }
                
                // 2. Скачиваем репозиторий Сравнений
                dir('tmp_comparison') {
                    git branch: 'main',
                        credentialsId: 'git',
                        url: 'https://github.com/DenisLonskii/docs-comparison.git'
                }

                echo 'Копируем файлы документации из дочерних репозиториев в общую папку docs/...'
                sh '''
                    mkdir -p docs/guides docs/comparison
                    cp -r tmp_guides/docs/* docs/guides/
                    cp -r tmp_comparison/docs/* docs/comparison/
                    rm -rf tmp_guides tmp_comparison
                '''
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo 'Собираем Docker-образ сборщика...'
                sh 'docker build -t docs-hub-builder:latest .'
            }
        }

        stage('4. Generate Portal Site') {
            steps {
                echo 'Запускаем генерацию статического сайта MkDocs...'
                // Контейнеру больше не нужны токены доступа и git — все файлы уже собраны в папке docs/
                sh 'docker run --rm --volumes-from jenkins -w "${WORKSPACE}" docs-hub-builder:latest mkdocs build'
            }
        }

        stage('5. Archive Artifacts') {
            steps {
                echo 'Сохраняем готовую папку site как артефакт сборки...'
                archiveArtifacts artifacts: 'site/**', fingerprint: true
            }
        }
    }
}