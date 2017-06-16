def failure_function(exception_obj, failureMessage) {
    def toEmails = [[$class: 'DevelopersRecipientProvider']]
    emailext body: '${DEFAULT_CONTENT}\n\"' + failureMessage + '\"\n\nCheck console output at $BUILD_URL to view the results.', recipientProviders: toEmails, subject: '${DEFAULT_SUBJECT}'
    throw exception_obj
}

node {
    try {
        stage('Checkout') {
            checkout scm
        }
    } catch (e) {
        failure_function(e, 'Checkout failed')
    }
    
    try {
        stage('Test') {
            sh "jenkins/done.bash"
        }
    } catch (e) {
        failure_function(e, 'Test failed')
    }
}
