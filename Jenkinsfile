project = "streaming-data-types"

def failure_function(exception_obj, failureMessage) {
    def toEmails = [[$class: 'DevelopersRecipientProvider']]
    emailext body: '${DEFAULT_CONTENT}\n\"' + failureMessage + '\"\n\nCheck console output at $BUILD_URL to view the results.', recipientProviders: toEmails, subject: '${DEFAULT_SUBJECT}'
    throw exception_obj
}

images = [
  'centos7': [
    'name': 'essdmscdm/centos7-build-node:3.0.0',
    'sh': '/usr/bin/scl enable devtoolset-6 -- /bin/bash -e'
  ],
]

base_container_name = "${project}-${env.BRANCH_NAME}-${env.BUILD_NUMBER}"

def get_pipeline(image_key) {
  return {
    node('docker') {
      def container_name = "${base_container_name}-${image_key}"
      try {
        def image = docker.image(images[image_key]['name'])
        def custom_sh = images[image_key]['sh']
        def container = image.run("\
          --name ${container_name} \
          --tty \
          --cpus=2 \
          --memory=4GB \
          --network=host \
          --env http_proxy=${env.http_proxy} \
          --env https_proxy=${env.https_proxy} \
          --env local_conan_server=${env.local_conan_server} \
        ")

        stage("${image_key}: Checkout") {
          sh """docker exec ${container_name} ${custom_sh} -c \"
            git clone \
              --branch ${env.BRANCH_NAME} \
              https://github.com/ess-dmsc/${project}.git
          \""""
        }  // stage

        stage("${image_key}: Dependencies") {
          def conan_remote = "ess-dmsc-local"
          sh """docker exec ${container_name} sh -c \"
            mkdir build
            cd build
            conan --version
            conan remote add \
              --insert 0 \
              ${conan_remote} ${local_conan_server}
            conan install \
              --generator virtualrunenv \
              FlatBuffers/1.8.0@ess-dmsc/stable
          \""""
        }  // stage

        stage("${image_key}: Test") {
          sh """docker exec ${container_name} ${custom_sh} -c \"
            source build/activate_run.sh
            cd ${project}
            jenkins/done.bash
          \""""
        }  // stage
      } catch(e) {
        failure_function(e, 'Build failed')
      } finally {
        sh "docker stop ${container_name}"
        sh "docker rm -f ${container_name}"
      }  // finally
    }  // node
  }  // return
}  // def

node {
  checkout scm

  def builders = [:]
  for (x in images.keySet()) {
   def image_key = x
   builders[image_key] = get_pipeline(image_key)
  }
  parallel builders

  // Delete workspace when build is done.
  cleanWs()
}
