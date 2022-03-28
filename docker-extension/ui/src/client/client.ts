import {
  Image,
  Container
 } from "../interfaces";

const logger = console;

const METADATA_KEY_BUILD_PROVIDER = "WALLET_PUBLIC";
const COMMAND_VALIDATE_IMAGE_SIGNATURE = "/command/ensure-image-signature.sh" 
const UNSIGNED_STATUS = "error";

declare global {
  interface Window {
    ddClient: {
      docker: {
        listContainers: () => Promise<Array<any>>,
        listImages: () => Promise<Array<any>>
      },
      extension: any
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
      const [isSigned, buildProvider] = await DockerClient.getBuildProvider(container);
      const verificationStatus = isSigned ? 
        await DockerClient.getImageStatus(buildProvider, container.ImageID)
        : UNSIGNED_STATUS;
      containersViewModel.push({
        validated: verificationStatus,
        containerHash: container.Id,
        containerName: containerName,
        imageHash: container.ImageID,
        buildProvider: buildProvider,
        goshRootAddress: ""
      });
    }
    return containersViewModel;
  }

  /**
   * Get containers list
   **/
  static async getImages(): Promise<Array<Image>> {
    logger.log(`Calling getImages...\n`);
    const images = await window.ddClient.docker.listImages();
    const imagesViewModel = [];
    for (var i=0; i < images.length; i++) {
      const image = images[i];
      const [isSigned, buildProvider] = await DockerClient.getBuildProvider(image);
      const verificationStatus = isSigned ? 
        await DockerClient.getImageStatus(buildProvider, image.Id)
        : UNSIGNED_STATUS;
      imagesViewModel.push({
        validated: verificationStatus,
        imageHash: image.Id,
        buildProvider: buildProvider,
        goshRootAddress: ""
      });
    }
    return imagesViewModel;
  }

  /**
   * Get image state
   **/
  static async getImageStatus(buildProviderPublicKey: string, imageHash: string): Promise<any> {
    logger.log(`Calling getImageStatus...\n`);
    try {
      const result = await window.ddClient.extension.vm.cli.exec(
        COMMAND_VALIDATE_IMAGE_SIGNATURE,
        [buildProviderPublicKey, imageHash]
      );
      const resultText = result.stdout.trim(); 
      logger.log(`Result: <${resultText}>\n`);
      // Note: 
      // There was a check for result.code == 0 that didn't work
      // For some reason it is not working as expected and returns undefined 
      const verificationStatus =  resultText == "true";
      return verificationStatus ? "success" : "error";
    } 
    catch (e) {
        console.log("image validaton failed", e); 
        return "warning";
    }
  }

  static async getBuildProvider(container: any): Promise<[boolean, string]> {
    const metadata = container.Labels || {};
    if (METADATA_KEY_BUILD_PROVIDER in metadata) {
      return [true, metadata[METADATA_KEY_BUILD_PROVIDER]];
    } else {
      return [false, "-"];
    }
  }
}

export default DockerClient;

