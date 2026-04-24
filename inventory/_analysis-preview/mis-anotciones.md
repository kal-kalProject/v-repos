

- Conceptos:

Provider : Api public con logica de negocio completa y agnostica, no conoce el driver
Driver : implementa a un Provider y cumple con su api, nunca se accede al driver, solo a través del provider.
Agent : micro task/service que ejecuta acciones especificas (similar a tool de un MCP, pero en cualquier contexto), puede ser invocado por Providers/drivers/hosts
Wire: api completa de comunicacion de la plataforma, opera con transports usando TransportProvider/TransportDriver
Bridge: similar a TransportDriver pero especifico, permite a un lenguaje o platafroma traducir a Wire
Host: Api de la plataforma, contiene la logica del pipeline, es wrapper de asp.net, puede ser master y/o slave
Identity: es un host construido con los elementos de la plataforma y es responzable del manejo de account/credentials, authentica, autoriza y mantiene session
Data: es un Provider/Driver/Bridge especializado en databases, es logica completa de negocio database, drivers pueden ser tipo sql/no-sql, server/serverless, permite bridge por ejemplo para msaccess netframework com interop.
Scope: es arbol de namespace, basado en nodos, nodos pueden ser solo namespace o con un context, el context no es responzabilidad del scope, pero si es referencia al context y permite resolver, funciona en conjunto con Router para resolucion typo query
Extension: sistema de plugins, pueden ser dentro del bundle o en caliente.

Base:
el uso de Provider/Driver es casi universal en la platafroma.
Wire es comunicacion, pueden implementarse host/clients en otros lenguajes y platafromas, principal es .Net, crear hosts en otros lenguajes es muy acotado y para casos especiales, pero los clients son normalmente necesarios en mas lenguages y platafromas.

ui: esto es aun debatible entre usar angular vs framework propio o ambos
en ts existe common, core que contiene utilidades compatibles node/browser, las mas destacadas son atoms y di con decoradores.

theming: existe una lib especializada en style tokens, themes y presets, no es exclusiva de angular.
layout: vscode like, no es para desarrollo, pero contiene las secciones y funcionalidades de el layout de vscode, tambien el sistema de extensions para utilizar las secciones del layout y sus funcionalidades base.


casos de uso reales:

plugin mach4 en c++ con un WireBridge + CncProvider.
aplicacion cad/cam/cnc-control.
sistema de emision de documentos tributarios sii chile
webscraping bancario para obtener movimientos
aplicacion para administracion de pymes, tipo erp especializado en pymes.
aplicaciones inteligencia artificial, Mcp server/client, rag, chat, voice. para uso con apikey y self-hosted con contextos especificos.
iot: manejo de dispositivos



## atributos/decoradores codegen

atributos .net y decoradores ts son para simplificar al usuario developer implementar providers, drivers, agents, bridges, wire, host, data, etc.
y v-gen es el sistema de templates para generar codigo, json, xml, jsonschemas, sql, etc. (universal)

Lsp y plugin vscode son para diagnsotics, y todo lo demas de un lsp, pero con una particularidad especial:
engañar al compiler y vscode para que el usuario escriba codigo que no compilaria, con el proposito de ahorrar escritura de codigo que luego se generaría correctamente para pasar la compilacion y sea integrado a la plataforma (tambien generaria los manifest, otros lenguages, etc.)
