pipeline {
	agent any
	stages {
		stage('build') {
			steps {
				withMaven(jdk: '1.8', maven: '3.5.2') {
					sh "mvn package"
				}
			}
		}
		stage('packer') {
			environment {
				PACKER_HOME = tool name: 'packer-1.1.3', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
				PACKER_SUBSCRIPTION_ID = "fcc1ad01-b8a5-471c-812d-4a42ff3d6074"
				PACKER_CLIENT_ID = "262d2df5-a043-458a-9d0d-27a734962cd9"
				PACKER_CLIENT_SECRET = credentials('23145a41-bd15-40a0-9972-ed486ab077b8')
				PACKER_LOCATION="westeurope"
				PACKER_TENANT_ID="787717a7-1bf4-4466-8e52-8ef7780c6c42"
				PACKER_OBJECT_ID="56e89fa0-e748-49f4-9ff0-0d8b9e3d4057"
			}
			steps {
				wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
					sh "${PACKER_HOME}/packer validate packer/packer.json"
					sh "${PACKER_HOME}/packer build packer/packer.json"
				}
			}
		}
	}
}