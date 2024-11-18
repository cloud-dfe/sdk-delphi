# SDK em Delphi para Integração com API

O SDK-Delphi foi desenvolvido para facilitar a integração do seu sistema com nossa API. Ele oferece classes e métodos predefinidos que simplificam a comunicação com as rotas da API, eliminando a necessidade de desenvolver essa interação manualmente.

## Funcionalidades do SDK

- **Integração rápida** com a API
- **Classes e métodos otimizados** para operações comuns
- **Redução de esforço** com implementação manual de comunicação HTTP

---

## Como baixar e configurar o SDK-Delphi

### 1. Baixar o SDK
1. Acesse o repositório no GitHub, na pasta [SDK-Units](https://github.com/cloud-dfe/sdk-delphi/tree/master/SDK-Units).
2. Faça o download de todos os arquivos presentes nessa pasta clicando no botão **"Code"** e selecionando a opção **"Download ZIP"** ou baixando os arquivos individualmente.
3. Extraia os arquivos do ZIP (se aplicável) e adicione-os ao seu projeto Delphi.

### 2. Configurar bibliotecas necessárias para HTTPS

Se ao executar o SDK você encontrar o erro **"Could not load SSL library"**, siga os passos abaixo para resolver o problema:

1. **Baixe as bibliotecas necessárias (DLLs):**  
   Acesse este link para fazer o download das DLLs necessárias: [Baixar DLLs](link).

2. **Adicione as DLLs ao sistema:**  
   Coloque os arquivos baixados nas seguintes pastas do seu sistema operacional:
   - `C:\Windows\System32` (para sistemas 32 bits ou 64 bits)
   - `C:\Windows\SysWOW64` (se o sistema for 64 bits)

3. **Por que essas DLLs são necessárias?**  
   As bibliotecas SSL (como `libeay32.dll` e `ssleay32.dll`) são fundamentais para que o Delphi realize requisições HTTPS. Sem essas bibliotecas, o SDK não conseguirá estabelecer comunicação com a API.

---

## Exemplos de Uso

Estamos trabalhando para disponibilizar exemplos práticos de utilização do SDK em breve. Fique atento à seção de [exemplos no repositório](link_para_exemplos).