pipeline {
    agent any
    tools {
        maven 'Maven3.9.0'
        jdk 'jdk11'
    }
    parameters {
        choice(
            name: 'LUCID_ENVIRONMENT',
            choices: "dev\nqa\nprod",
            description: 'Which environment do you want to deploy to?'
        )
        string(
            name: 'TAGS',
            defaultValue: 'smoke',
            description: 'Tags to run the tests against. Multiple values allowed separated by commas. Defaults to smoke.'
        )
    }
    stages {
        stage ('Initialize') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }

        stage ('Build') {
            steps {
                sh 'mvn clean install -Dtags=$TAGS'
            }
            post {
                success {
                    script {
                        // Trigger regression suite if current run was SMOKE
                        if( params.TAGS == "smoke" ) {
                            build(
                                job: "automation-tests",
                                parameters: [
                                    string(name: 'LUCID_ENVIRONMENT', value: params.LUCID_ENVIRONMENT),
                                    string(name: 'TAGS', value: ""),
                                ],
                                wait: false
                            )
                        }
                    }
                }
                always {
                    publishHTML (target : [allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'target/karate-reports',
                        reportFiles: 'karate-summary.html',
                        reportName: 'Karate',
                        reportTitles: 'Karate'
                    ])

                    script {
                        def summary = junit 'target/karate-reports/**/*.xml' 

                        def total = summary.totalCount
                        def failed = summary.failCount
                        def skipped = summary.skipCount

                        String message = "Test results ($TAGS):\n\t"
                        message = message + ('Passed: ' + (total - failed - skipped))
                        message = message + (', Failed: ' + failed)
                        message = message + (', Skipped: ' + skipped)
                        message = message + ("\n<${env.BUILD_URL}Karate/|View Results>")

                        String color = failed > 0 ? 'danger' : 'good'

                        slackSend (
                            channel: '#ci-cd',
                            color: color,
                            message: message
                        )
                    }
                }
            }
        }
    }
}
