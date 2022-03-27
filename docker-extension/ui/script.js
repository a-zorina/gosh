async function command(cmd, args, callbacks) {
   return window.ddClient.extension.vm.cli.exec("/command/" + cmd, args, callbacks);
}
async function init() {
  await command("docker-ps.sh", [], {
    stream: {
      onOutput: (data) => {
        document.getElementById("docker-ps").innerHTML += `
        ${JSON.stringify(data)}
`;
      },
      onError: (error) => {
        docker.getElementById("docker-ps").innerHTML = "Error: " + error;
      },
      onClose: (exitCode) => {
        console.log("OnClose exit code " + exitCode);
      }
    }
  });
/*
  const containers = await window.ddClient.docker.listContainers();
  document.getElementById("docker-ps").innerHTML = `
        Running containers:
        ${JSON.stringify(containers)}
`;
*/
/*
  window.ddClient.docker.cli
    .exec("info", ["--format", '"{{json .}}"'])
    .then((res) => {
      document.getElementById("size-info").innerHTML = `
      Allocated CPUs: ${res.parseJsonObject().NCPU}
      Allocated Memory: ${res.parseJsonObject().MemTotal}
`;
    });
*/
 /*
  await window.ddClient.extension.vm.cli.exec("/command/docker-ps.sh", [], {
    stream: {
      onOutput: (data) => {
        document.getElementById("docker-ps").innerHTML = `
        docker ps:
        ${JSON.stringify(data)}
`;
      },
      onError: (error) => {
        docker.getElementById("docker-ps").innerHTML = "Error: " + error;
      },
      onClose: (exitCode) => {
        console.log("OnClose exit code " + exitCode);
      }
    }
  });
*/
}

(async() => {
  await init();
})();
