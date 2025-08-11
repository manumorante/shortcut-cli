# Shortcut CLI

Colección de funciones Bash para interactuar con la API de Shortcut y gestionar ramas vinculadas a historias.

## Manual

Escribe `story` o `stories` y se muestra las funciones disponibles, su uso y ejemplos:

<img width="766" height="529" alt="Captura de pantalla 2025-08-11 a las 17 08 50" src="https://github.com/user-attachments/assets/ac99ff9b-59ac-4a88-8772-9798b71c167e" />


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


### Úsalo tu token aquí

```bash
API_BASE='https://api.app.shortcut.com/api/v3'
TOKEN='<tu-shortcut-token>'
```

## Uso

### `story <ID>`
Gestiona la rama asociada a una historia:
1. Busca rama vinculada en Shortcut,
2. Si no existe, busca rama local `sc-ID`.
3. Si no existe, crea rama nueva: `FEAT/sc-ID-nombre` o `BF/sc-ID-nombre`.
4. Cambia automáticamente a la rama encontrada o creada.

Ejemplo:
```bash
story 1234
```

Tarea con rama vinculada, la encuentra también en local y se cambia a ella:

ℹ️ TODO: actualizar GIF con nuevos nombres de funciones
![lessons](https://github.com/user-attachments/assets/3c4218d4-e169-4208-95f5-e9dba1dfc582)

Tarea que no tienes su rama local aún, la crea y se cambia a ella:

![nueva](https://github.com/user-attachments/assets/62241264-dc54-4f5c-a070-6a0ff26548f2)



---

### `stories <NOMBRE>`
Busca historias en Shortcut por nombre.
- Sin argumentos: muestra ayuda con flujo y ejemplos.
- Con nombre: devuelve lista `ID | Título`.

Ejemplo:
```bash
stories focus
```

![buscar](https://github.com/user-attachments/assets/9fed318c-7bd1-49c7-94fa-9e8a42714478)


---

## Changelog

### [1.2.0] - 2025-08-11
- Refactorización de nombres de funciones para mayor claridad y mejor alineación con el endpoint de la API (`stories`)
  - `storyb` → `story` (gestión de ramas)
  - `story` → `stories` (búsqueda de historias)

### [1.0.0] - 2025-08-09
- Initial release
- Basic story management functionality
- Branch creation, switching and simple search
