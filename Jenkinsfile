pipeline {
  environment {
    registry = 'ibryzg/rutorrent-flood'
    registry_remove = 'lumir/remove-dockerhub-tag'
    repository = 'rutorrent-flood'
    withCredentials = 'dockerhub'
    registryCredential = 'dockerhub'

    gitbranch = ''
    base = ''
    major = ''
    minor = ''
    patch = ''
  }
  agent { label 'Alpine' }
  stages {
    stage('Clean Workspace') {
      steps {
        cleanWs()
        }
    }
    stage ('Docker prune') {
      when {
        expression {
          params.DOCKER_PRUNE == 'Yes'
          }
      }
      steps {
        sh "docker system prune -f -a"
      }
    }
    stage('Cloning Git Repository') {
      steps {
        git url: 'https://github.com/Bryzgalin/rutorrent-flood-docker.git',
            branch: '$BRANCH_NAME'
      }
    }
    stage('Building image and pushing it to the registry (develop)') {
      when{
        branch 'develop'
        }
      steps {
        script {
          setTags()
          removeDockerhubImages()
          buildImage('3.12', 'v0.9.8', 'v0.13.8')
        }
      }
    }
    stage('Building image and pushing it to the registry (master)') {
      when{
        branch 'master'
        }
      steps {
        script {
          setTags()
          removeDockerhubImages()
          buildImage('3.12', 'v0.9.8', 'v0.13.8')
        }
        script {
          withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
          docker.image('sheogorath/readme-to-dockerhub').run('-v $PWD:/data -e DOCKERHUB_USERNAME=$DOCKERHUB_USERNAME -e DOCKERHUB_PASSWORD=$DOCKERHUB_PASSWORD -e DOCKERHUB_REPO_NAME=$repository')
          }
        }
      }
    }
  }
 }

 void setTags() {
  gitbranch = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
  def version = readFile('VERSION')
  def versions = version.split('\\.')
  base = gitbranch
  major = gitbranch + '-' + versions[0]
  minor = gitbranch + '-' + versions[0] + '.' + versions[1]
  patch = gitbranch + '-' + version.trim()
}

void removeDockerhubImages() {
  withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
    docker.image("$registry_remove:latest").withRun('-v "$PWD:/data"', "--user $DOCKERHUB_USERNAME --password '$DOCKERHUB_PASSWORD' $registry:$base $registry:$major $registry:$minor $registry:$patch") { c ->
      sh "docker logs ${c.id} -f"
      }
  }
}

void buildImage(String baseImageVersion, String rtorrentVersion, String libtorrentVersion) {
docker.withRegistry('', registryCredential) {
    withCredentials([string(credentialsId: 'maxind', variable: 'MAXMIND_LICENSE_KEY')]) {
      def image = docker.build("$registry:$gitbranch",  "--build-arg BASEIMAGE_VERSION=$baseImageVersion --build-arg RTORRENT_VER=$rtorrentVersion --build-arg LIBTORRENT_VER=$libtorrentVersion --build-arg MAXMIND_LICENSE_KEY=${MAXMIND_LICENSE_KEY} -f Dockerfile .")
      image.push(patch)
    }
  }
}
