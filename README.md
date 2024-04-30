# QualyfiReactWebApp

Note: SRC folder from https://github.com/Azure-Samples/todo-csharp-sql-swa-func

The following prerequisites are required to use this application. Please ensure that you have them all installed locally.

- [Azure Developer CLI](https://aka.ms/azd-install) - winget install microsoft.azd
- [.NET SDK 8.0](https://dotnet.microsoft.com/download/dotnet/8.0) - for the API backend
- [Azure Functions Core Tools (4+)](https://docs.microsoft.com/azure/azure-functions/functions-run-local)
- [Node.js with npm (18.17.1+)](https://nodejs.org/) - for the Web frontend

Deploy to East US 2

Log in to azd. Only required once per-install.

```bash
azd auth login
```

First-time project setup. Initialize a project in the current directory, using this template.

```bash
azd init --template js-magar/QualyfiReactWebApp
```

Provision and deploy to Azure

```bash
azd up
```

Install NPM

```
npm install -g @azure/static-web-apps-cli
```

[Install NPM](https://azure.github.io/static-web-apps-cli/docs/use/install/)

