# Shortcut CLI

Colección de funciones Bash para interactuar con la API de Shortcut y gestionar ramas vinculadas a historias.

## Manual

Escribe `story` y se muestra las funciones disponibles, su uso y ejemplos:

![manual](https://github.com/user-attachments/assets/07244e05-3d73-4da8-9bce-ce59103d1261)

## Formato

Usamos formato ⁠`<tipo>/<id>-<nombre-tarea>` como convención ampliamente adoptada en la industria.

> En este caso, con la salvedad de usar mayúsculas y nombres abreviados para los tipos. Algo que, sin duda, puede generar inconvenientes y se puede considerar cambiar.

- El tipo categoriza el propósito de la rama.
- El ID al inicio conecta con sistemas de tickets (Jira, GitHub Issues).
- El nombre describe brevemente el cambio.

Muchas herramientas como GitHub, GitLab, Jira y en este caso Shortcut automáticamente generan nombres de rama siguiendo este patrón cuando creas una rama desde un issue.

Ejemplos

- `FEAT/sc-1234-nueva-funcion` para ramas feature
- `BF/sc-1234-arreglo-tal` para ramas bug.



## Config

### Genera tu Token

<img width="1844" height="1024" alt="image" src="https://github.com/user-attachments/assets/3196df13-82ed-41b1-b451-4a262b1e85e3" />


### Úsalo aquí

Definir variables en el entorno:
```bash
API_BASE='https://api.app.shortcut.com/api/v3'
TOKEN='<tu-shortcut-token>'
```

## Uso

### `storyb <ID>`
Gestiona la rama asociada a una historia:
1. Busca rama vinculada en Shortcut,
2. Si no existe, busca rama local `sc-ID`.
3. Si no existe, crea rama nueva: `FEAT/sc-ID-nombre` o `BF/sc-ID-nombre`.
4. Cambia automáticamente a la rama encontrada o creada.

Ejemplo:
```bash
storyb 1234
```

Tarea con rama vinculada, la encuentra también en local y se cambia a ella:

![lessons](https://github.com/user-attachments/assets/3c4218d4-e169-4208-95f5-e9dba1dfc582)

Tarea que no tienes su rama local aún, la crea y se cambia a ella:

![nueva](https://github.com/user-attachments/assets/62241264-dc54-4f5c-a070-6a0ff26548f2)



---

### `story <NOMBRE>`
Busca historias en Shortcut por nombre.
- Sin argumentos: muestra ayuda con flujo y ejemplos.
- Con nombre: devuelve lista `ID | Título`.

Ejemplo:
```bash
story focus
```

![buscar](https://github.com/user-attachments/assets/9fed318c-7bd1-49c7-94fa-9e8a42714478)



## Notas
- Requiere `jq` y `git` instalados.
