async function init() {
  const containers = await window.ddClient.docker.listContainers();
  document.getElementById("docker-ps").innerHTML = `
        Running containers:
        ${JSON.stringify(containers)}
`;
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
// NOTE: Fails with 
//  docker ps: {"stderr":"Error response from daemon: Container bf209623fcdac08018079de29831d1069a58785d0bfb676fdfd5a5e2d547339e is restarting, wait until the container is running\n"}

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
