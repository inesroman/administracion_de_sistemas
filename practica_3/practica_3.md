A continuación se explican los pasos que sigue el script "practica_3.sh":
1. Verificación de privilegios de administración:
   - Si el usuario que ejecuta el script no tiene privilegios de administración (EUID != 0), 
    se muestra un mensaje de error y se finaliza la ejecución del script.

2. Verificación de parámetros:
   - Si el número de parámetros pasados al script no es igual a 2, se muestra un mensaje de 
    error indicando que el número de parámetros es incorrecto. En caso contrario, el script 
    procede a realizar las operaciones según los parámetros especificados.

3. Verificación del parámetro de operación:
  3. 1. Añadir usuarios "-a":
    - Se lee un archivo especificado como segundo parámetro, el cual contiene los campos de 
      los usuarios a añadir.
    - Para cada línea en el archivo, se verifica si los campos de nombre de usuario, 
      contraseña y nombre completo están presentes y no son nulos.
    - Si alguno de los campos es nulo o inválido, se muestra un mensaje de error indicando que 
      el campo es inválido y se finaliza la ejecución del script.
    - Se utiliza el comando "useradd" para crear un nuevo usuario con las siguientes opciones:
      - "-m": crea el directorio de inicio del usuario si no existe.
      - "-k /etc/skel": copia el contenido del directorio /etc/skel al directorio de inicio del 
        usuario.
      - "-U": crea un grupo con el mismo nombre que el usuario y lo asigna al usuario.
      - "-K UID_MIN=1815": establece el UID mínimo para la creación del usuario.
      - "-c "$fullname"": asigna el nombre completo como descripción del usuario.
    - Si el usuario se crea correctamente, se establece la contraseña utilizando el comando 
      "chpasswd" y se modifica el tiempo de expiración de la cuenta utilizando el comando 
      "usermod".
    - Se muestra un mensaje de éxito indicando que el usuario ha sido creado.
    - Si el usuario ya existe, se muestra un mensaje indicando que el usuario ya existe.

  3. 2. Borrar usuarios "-s":
    - Se verifica si el directorio de backup "/extra/backup" no existe previamente.
    - Si el directorio "/extra/backup" no existe, se crea utilizando el comando "mkdir" 
      con la opción  "-p" para crear directorios padre si es necesario.
    - Se lee un archivo especificado como segundo parámetro, el cual contiene los campos de los 
      usuarios a borrar.
    - Para cada línea en el archivo, se verifica si el campo de nombre de usuario no es nulo.
    - Si el campo de nombre de usuario es nulo, se muestra un mensaje de error indicando que el 
      campo es inválido y se finaliza la ejecución del script.
    - Se realiza una copia de seguridad del directorio principal del usuario

  3. 3. Opciones inválidas:
    Si el primer parámetro pasado al script no es ni "-a" ni "-s", se muestra un mensaje 
    de error indicando que la opción es inválida.
