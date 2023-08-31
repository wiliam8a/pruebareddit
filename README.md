# pruebareddit
prueba tecnica iOS

Este proyecto es una aplicación SwiftUI que permite al usuario consultar títulos de Reddit en diferentes categorías. También proporciona la funcionalidad de administrar categorías, como agregar, editar y eliminar categorías.

## Características

- Consulta títulos de Reddit en categorías seleccionadas.
- Administra categorías: agregar, editar y eliminar.
- Interfaz de usuario intuitiva y fácil de usar.
- Integración con una base de datos local para almacenar categorías.

## Requisitos del Sistema

- iOS 14.0 o superior.
- Xcode 12.0 o superior (para desarrollo).

## Uso

1. Clona o descarga el repositorio en tu máquina local.
2. Abre el proyecto en Xcode.
3. Compila y ejecuta la aplicación en el simulador de iOS.

## Capturas de Pantalla

![Home](screenshots/SS1.png)
*Descripción de la captura de pantalla 1.*

![View Lista Categor](screenshots/SS2.png)
*Descripción de la captura de pantalla 2.*
![View Lista Categorías](screenshots/SS3.png)![View Lista Categorías](screenshots/SS4.png)![View Lista Categorías](screenshots/SS5.png)

## Arquitectura y Sistema

Este proyecto sigue una arquitectura básica Modelo-Vista-ViewModel (MVVM) y utiliza las siguientes tecnologías y componentes clave:

### MVVM (Model-View-ViewModel)

El patrón MVVM se utiliza para separar claramente la lógica de presentación de la vista y el modelo de datos. La estructura general del proyecto es la siguiente:

- **Model**: Los modelos de datos que representan las categorías y los títulos de Reddit se encuentran en la carpeta `Models`.

- **View**: Las vistas de la aplicación se definen en `ContentView.swift`, `CategoriesView.swift`, `AddCategoryView.swift` y `EditCategoryView.swift`. Estas vistas muestran la interfaz de usuario y responden a las interacciones del usuario.

- **ViewModel**: El ViewModel principal se encuentra en `ListViewModel.swift`. Controla la obtención de datos de Reddit y la gestión de errores. También proporciona datos observables para las vistas.

### Base de Datos Local

Para almacenar y administrar las categorías, se utiliza una base de datos SQLite local. La gestión de la base de datos se encuentra en `DBManager.swift`. Esto permite al usuario agregar, editar y eliminar categorías de manera persistente.

### Comunicación de Red

La comunicación con la API de Reddit se maneja en `ListViewModel.swift`. Se utiliza la clase `URLSession` para realizar solicitudes HTTP y recibir datos JSON que se decodifican en modelos de datos utilizables.

## Estructura del Proyecto

- `ContentView.swift`: La vista principal de la aplicación que muestra los títulos de Reddit.
- `CategoriesView.swift`: Vista para administrar categorías.
- `AddCategoryView.swift`: Vista para agregar una nueva categoría.
- `EditCategoryView.swift`: Vista para editar una categoría existente.
- `DBManager.swift`: Gestión de la base de datos local.
- `ListViewModel.swift`: ViewModel para obtener datos de Reddit.
- `Models`: Carpeta que contiene los modelos de datos utilizados.
