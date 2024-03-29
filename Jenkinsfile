@Library('ecdc-pipeline')
import ecdcpipeline.ContainerBuildNode
import ecdcpipeline.PipelineBuilder

project = "streaming-data-types"

container_build_nodes = [
  'centos7': ContainerBuildNode.getDefaultContainerBuildNode('centos7-gcc11')
]

pipeline_builder = new PipelineBuilder(this, container_build_nodes)
pipeline_builder.activateEmailFailureNotifications()

builders = pipeline_builder.createBuilders { container ->

    pipeline_builder.stage("${container.key}: checkout") {
        dir(pipeline_builder.project) {
            scm_vars = checkout scm
        }
        // Copy source code to container
        container.copyTo(pipeline_builder.project, pipeline_builder.project)
    }  // stage

    pipeline_builder.stage("${container.key}: get dependencies") {
        // Rebuild flatc otherwise package from conan center remote is built against wrong version of glibc
        container.sh """
            mkdir build
            cd build
            conan install ../${project}/conanfile.txt --build=outdated --build=flatc
        """
    }  // stage
    
    pipeline_builder.stage("${container.key}: test") {
        container.sh """
            source build/activate_run.sh
            cd ${project}
            jenkins/done.bash
        """
    
    }  // stage
}  // create builders

def failure_function(exception_obj, failureMessage) {
    def toEmails = [[$class: 'DevelopersRecipientProvider']]
    emailext body: '${DEFAULT_CONTENT}\n\"' + failureMessage + '\"\n\nCheck console output at $BUILD_URL to view the results.', recipientProviders: toEmails, subject: '${DEFAULT_SUBJECT}'
    throw exception_obj
}

node {
    cleanWs()

    stage('Checkout') {
        dir("${project}") {
            try {
                scm_vars = checkout scm
            } catch (e) {
                failure_function(e, 'Checkout failed')
            }
        }
    }

    parallel builders

    // Delete workspace when build is done
    cleanWs()
}
