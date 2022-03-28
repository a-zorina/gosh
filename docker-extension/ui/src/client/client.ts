import {
  Image,
  Container
 } from "../interfaces";

const logger = console;



declare global {
  interface Window {
    ddClient: {
      docker: {
        listContainers: () => Promise<Array<any>>
      }
    };
  }
}

export class DockerClient {

  /**
   * Get containers list
   **/
  static async getContainers(): Promise<Array<Container>> {
    logger.log(`Calling getContainers...\n`);
    const containers = await window.ddClient.docker.listContainers();
    const containersViewModel:Array<Container> = [];
    for (var i=0; i < containers.length; i++) {
      const container = containers[i];
      const containerName = container.Names.length > 0 ? container.Names[0] : container.Id;
      const buildProvider = await DockerClient.getBuildProvider(container);
      const verificationStatus = await DockerClient.getImageStatus(container);
      containersViewModel.push({
        validated: verificationStatus ? "success" : "warning",
        containerHash: container.Id,
        containerName: containerName,
        imageHash: container.ImageID,
        buildProvider: buildProvider
      });
    }
    return containersViewModel;
  }
  /**
   * Get image state
   **/
  static async getImageStatus(container: any): Promise<boolean> {
    logger.log(`Calling getImageStatus...\n`);
    return false;
  }

  static async getBuildProvider(container: any): Promise<string> {
    return "-";
  }
}

export default DockerClient;

