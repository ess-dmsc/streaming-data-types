@Library('ecdc-pipeline')
import ecdcpipeline.ContainerBuildNode
import ecdcpipeline.PipelineBuilder

project = "streaming-data-types"

container_build_nodes = [
  'centos7': ContainerBuildNode.getDefaultContainerBuildNode('centos7')
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
        container.sh """
            mkdir build
            cd build
            conan remote add --insert 0 ess-dmsc-local ${local_conan_server}
            conan install --generator virtualrunenv flatbuffers/1.10.0@google/stable
        """
    }  // stage
    
    pipeline_builder.stage("${container.key}: test") {
        container.sh """
            docker exec ${container_name} ${custom_sh} -c \"
            source build/activate_run.sh
            cd ${project}
            jenkins/done.bash
        """
    
    }  // stage
}  // create builders

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
