const core      = require('@actions/core');
const exec      = require('@actions/exec');
const github    = require('@actions/github');

const scan = async () => {
    const option = core.getInput('option');
   
    if (option === 'start'){
        await exec.exec('./.github/actions/sonarqube/start-sonarqube.ps1');
    } 
    
    if (option === 'stop'){
        await exec.exec('/home/runner/work/_actions/ebadusb/sonarqube-js/stop-sonarqube.ps1');
    }

}

try {
 
  scan();
 
    // Get the JSON webhook payload for the event that triggered the workflow
    //    const payload = JSON.stringify(github.context.payload, undefined, 2)
    //   console.log(`The event payload: ${payload}`);
} catch (error) {
  core.setFailed(error.message);
}