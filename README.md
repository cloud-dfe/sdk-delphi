# SDK em Delphi para Integração com API

O SDK-Delphi foi desenvolvido para facilitar a integração do seu sistema com nossa API. Ele oferece classes e métodos predefinidos que simplificam a comunicação com as rotas da API, eliminando a necessidade de desenvolver essa interação manualmente.

## Funcionalidades do SDK

- Integração rápida com a API
- Redução de esforço com implementação manual de comunicação HTTP
- Impedir erros de preenchimento de URLS ou métodos

---

## Como baixar e configurar o SDK-Delphi

### Baixando o SDK
   Para simplificar o processo, disponibilizamos um arquivo ZIP com todo o código do SDK. Você pode encontrar o ZIP na pasta SDK-Units ou no link abaixo:

   ### [**DOWNLOAD**](https://github.com/cloud-dfe/sdk-delphi/raw/refs/heads/master/SDK-Units/SDKUnits.zip)

1. Após baixar o arquivo ZIP: 
   - Extraia seu conteúdo para uma pasta local de sua preferência.
   - Copie os arquivos .pas (as Units do SDK) para o diretório do seu projeto Delphi.

2. Após incluir os arquivos .pas no seu projeto, eles já estarão prontos para uso. Basta testa-lo para ver se estão inserido corretamentes em seu projeto.

---

### Configurando Dlls caso ocorra o erro

   Se ao executar o código utilizando o SDK e ocorreu o erro **"Could not load SSL library"**, siga os passos abaixo para resolver o problema:

1. Baixe as DLLs:  
   Clicando no link abaixo você estava fazendo o download de um arquivo ZIP das DLLs: 
   
   ### [**Baixar DLLs**](https://github.com/cloud-dfe/sdk-delphi/raw/refs/heads/master/utils/Dlls.zip).

2. Após baixar o arquivo ZIP:
   - Extraia seu conteúdo para uma pasta local de sua preferência.
   - Copie os arquivos .dll para os seguintes diretórios de seu computador
      - `C:\Windows\System32` (para sistemas 32 bits ou 64 bits)
      - `C:\Windows\SysWOW64` (se o sistema for 64 bits)

**Por que essas DLLs são necessárias?**  
   As bibliotecas SSL (como `libeay32.dll` e `ssleay32.dll`) são fundamentais para que o Delphi realize requisições HTTPS. Sem essas bibliotecas, o SDK não conseguirá estabelecer comunicação com a API.

---

## Exemplos de Uso

Estamos trabalhando para disponibilizar exemplos práticos de utilização do SDK em breve.