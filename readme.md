# Gastronomic_Backend

Repositorio que contiene el backend de la aplicación web Gastronomic.

## Tabla de Contenidos

- [Instalación](#instalación)
- [Restaurar copia de seguridad](#Restaurar-copia-de-seguridad)
- [Realizar copia de seguridad](#Realizar-copia-de-seguridad)

### Instalación

> **Requires [Docker](https://docs.docker.com/get-docker/)**
> 

Clonamos el repositorio en nuestro equipo y ejecutamos el siguiente comando:
```bash
docker-compose up 
```


### Restaurar copia de seguridad
Accedemos al contenedor de la BD:
```bash
docker-compose exec database bash
```

Introducimos el archivo db_backup.sql en el contenedor de postgres para realizar la restauración de la copia de seguridad:
```bash
docker-compose cp db_backup.sql database:./
```


Para realizar la restauración de la copia de seguridad primero debemos de borrar la BD, lo hacemos con el siguiente comando:
```bash
psql -U directus template1 -c 'DROP DATABASE DIRECTUS'
```

SI EN EL PASO ANTERIOR OBTENEMOS EL SIGUIENTE ERROR:
```bash
root@ea6fb6493ba4:/# psql -U directus template1 -c 'DROP DATABASE DIRECTUS'
ERROR:  database "directus" is being accessed by other users
DETAIL:  There are 2 other sessions using the database.
```

EJECUTAMOS EL SIGUENTE COMANDO y volvemos a ejecutar el comando anterior:
```bash
psql -U directus -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'directus' AND pid <> pg_backend_pid();"
```

Recreamos la BD con el siguiente comando:
```bash
psql -U directus template1 -c 'CREATE DATABASE DIRECTUS WITH OWNER DIRECTUS';
```

Realizamos la restauración de la copia de seguridad con el siguiente comando:
```bash
psql -U directus directus < db_backup.sql
```

Con esto ya estaria la copia de seguridad restaurada. Aunque podriamos obtener un error y es que al acceder al backend de Directus e intentar visualizar nuestras tablas nos aparezca lo siguiente:
![directus_error](https://img001.prntscr.com/file/img001/q6Ll8_x7Sz6QanugZ6Kqdw.png)

Para solucionar eso, simplemente debemos acceder a "Settings -> Data Model" y crear una tabla de prueba.

### Realizar copia de seguridad

Accedemos al contenedor de la BD:
```bash
docker-compose exec database bash
```

Realizamos un backup de la BD, este backup sera necesario subirlo al repositorio siempre que añadamos datos para que todos trabajemos con los datos actualizados.
```bash
pg_dump -U directus directus > db_backup.sql
```

Sacamos el archivo de backup de dentro del contenedor con el siguiente comando:
```bash
docker-compose cp database:db_backup.sql ./
```

## Estado del Proyecto

El proyecto se encuentra actualmente en desarrollo..
