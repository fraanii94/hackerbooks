# hackerbooks

## Swift Project for KeepCoding Bootcamp

## ¿Dónde guardarías los datos de imágenes y pdf?


En el directorio Documents, no está implementado, pero para el futuro lo almacenaría en esa carpeta


## Favoritos

Se ha implementado almacenando los libros en NSUserDefaults para esta versión, también se podría haber implementado 
almacenando un fichero JSON con la clave "favorites" y como valor  , un array de títulos, que indican cuáles son los favoritos


## ¿Como enviar información de un Book a LibraryTableViewController?


A través de notificaciones, aunque podríamos usar el delegado.
Me parece mejor con notificaciones porque LibraryViewController ya tiene como delegado a BookViewController y habría
que estar cambiando de delegado.

## tableView.reloadData


Sólo recarga las celdas que aparecen en pantalla, entonces aunque tengamos infinitas celdas, solo recargan las que se 
están visualizando en el momento de la llamada a reloadData.


