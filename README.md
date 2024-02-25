# Buscador de Máquinas HTB

Este es mi primer proyecto utilizando Bash Scripting, inspirado en el curso de S4vitar en la academia Hack4u. El propósito de este script es facilitar la búsqueda de máquinas en Hack The Box según diversos criterios como el nombre de la máquina, dirección IP, sistema operativo, nivel de dificultad, entre otros.

![image](https://github.com/briancgx/BuscadorMaquinasHTB/assets/118696146/2b827a21-139c-4b08-889f-f25c0a3405d0)

## Instalación

Para utilizar el buscador de máquinas HTB, primero debes clonar el repositorio a tu máquina local usando el siguiente comando:

```bash
git clone https://github.com/briancgx/BuscadorMaquinasHTB.git
```
Asegúrate de tener git instalado en tu sistema para poder ejecutar el comando de clonación.

## Ejecución

Una vez clonado el repositorio, navega al directorio del script y dale permisos de ejecución al archivo .sh:

```bash
cd BuscadorMaquinasHTB
chmod +x htbmachines.sh
```
Para ejecutar el script, utiliza el siguiente comando:

```bash
./htbmachines.sh
```

## Uso
El script ofrece varias opciones para buscar máquinas de HTB resueltas por S4vitar:
- u - Actualizar archivos
- n - Buscar por nombre de máquina
- i - Buscar por dirección IP
- o - Buscar por sistema operativo
- s - Buscar por habilidad
- c - Buscar por certificación
- y - Obtener enlace a la solución de la máquina
- d - Buscar por dificultad (Fácil, Media, Difícil, Insane)
- h - Mostrar este panel de ayuda

