project = "streaming-data-types"

def failure_function(exception_obj, failureMessage) {
    def toEmails = [[$class: 'DevelopersRecipientProvider']]
    emailext body: '${DEFAULT_CONTENT}\n\"' + failureMessage + '\"\n\nCheck console output at $BUILD_URL to view the results.', recipientProviders: toEmails, subject: '${DEFAULT_SUBJECT}'
    throw exception_obj
}

images = [
  'centos7': [
    'name': 'essdmscdm/centos7-build-node:3.1.0',
    'sh': '/usr/bin/scl enable devtoolset-6 -- /bin/bash -e'
  ],
]

base_container_name = "${project}-${env.BRANCH_NAME}-${env.BUILD_NUMBER}"

def docker_copy_code(image_key) {
    def custom_sh = images[image_key]['sh']
    sh "docker cp ${project} ${container_name(image_key)}:/home/jenkins/${project}"
    sh """docker exec --user root ${container_name(image_key)} ${custom_sh} -c \"
                        chown -R jenkins.jenkins /home/jenkins/${project}
                        \""""
}

def docker_dependencies(image_key) {
  def conan_remote = "ess-dmsc-local"
  def custom_sh = images[image_key]['sh']
  sh """docker exec ${container_name} ${custom_sh} -c \"
    mkdir build
    cd build
    conan --version
    conan remote add \
      --insert 0 \
      ${conan_remote} ${local_conan_server}
    conan install \
      --generator virtualrunenv \
      FlatBuffers/1.9.0@ess-dmsc/stable
  \""""
}

def docker_test(image_key) {
  def custom_sh = images[image_key]['sh']
  sh """docker exec ${container_name} ${custom_sh} -c \"
    source build/activate_run.sh
    cd ${project}
    jenkins/done.bash
  \""""
}

def get_pipeline(image_key) {
  return {
    node('docker') {
      def container_name = "${base_container_name}-${image_key}"
      try {
        def image = docker.image(images[image_key]['name'])
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

        docker_copy_code(image_key)
        docker_dependencies(image_key)
        docker_test(image_key)

      } catch(e) {
        failure_function(e, 'Build failed')
      } finally {
        sh "docker stop ${container_name}"
        sh "docker rm -f ${container_name}"
      }  // finally
    }  // node
  }  // return
}  // def

node('docker') {
  // Checkout on docker node,
  // we need to be able to copy the code into each container
  dir("${project}") {
    stage('Checkout') {
      try {
          scm_vars = checkout scm
      } catch (e) {
          failure_function(e, 'Checkout failed')
      }
    }
  }

  def builders = [:]
  for (x in images.keySet()) {
   def image_key = x
   builders[image_key] = get_pipeline(image_key)
  }
  parallel builders

  // Delete workspace when build is done.
  cleanWs()
}
