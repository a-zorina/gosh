import {
  Image,
  Container
 } from "../interfaces";

const logger = console;

declare global {
  interface Window {
    ddClient: {
      docker: {
        listContainers: () => Promise<Array<Container>>
        check_image: (id: Container) => Promise<boolean>
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
    return await window.ddClient.docker.listContainers()
  }
  /**
   * Get image state
   **/
  static async getImageStatus(id: Container): Promise<boolean> {
    logger.log(`Calling getImageStatus...\n`);
    return await window.ddClient.docker.check_image(id)
  }
}

export default DockerClient;

