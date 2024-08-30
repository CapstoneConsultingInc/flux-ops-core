# ops-jet
Welcome to ops-jet, the engine powering the ops-pilot application. Just as a jet relies on precision and power to soar through the skies, ops-jet provides the essential scripts and automation tools that allow ops-pilot to navigate and manage complex operations with ease. With an aeronautic theme at its core, this repository is where the heavy lifting happens, ensuring that the ops-pilot can fly smoothly and efficiently in any environment. Buckle up and get ready to take your operations to new heights!

This repo contains an example for the blog series <link to blog here>. As an example there is only one `src` subdirectory containing scripts to manage flux. The intent would be for this repo to contain several subdiretories, where each contains scripts for managing a particular component. i.e. k8s clusters, or the various applications deployed via flux. Each would contain a subdirectory of scripts focused on the given component.

## Testing
ops-jet uses the [bats testing framework](https://bats-core.readthedocs.io/en/stable/index.html) to provide unit testing. This is a critical piece. Historically, operational scripts were treated as one off utilities that didn't require the rigor placed on larger source bases. With the explosion of automation and large script base source bases, there is a realization that scripts have grown beyond utilities. Achieving a degree of complexity where testing has become critical to ensure a given script source base continues to behave as expected. It is no longer resonable to rely on manual testing.

