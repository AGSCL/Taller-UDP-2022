rm(list=ls());gc() #Siempre es necesario borrar la memoria de 0 antes de correr un proyecto. 
#Lo anterior para chequear que no hayan objetos (información como bases de datos, 
#nombres de columnas, etiquetas, etc.) anidados que no estamos llamando, 
unlink('*_cache', recursive = TRUE) #También limpiamos la memoria caché de cualquier otro elemento 
#que esté alojado en nuestra memoria. Recuerde que quien abra su proyecto no 
#contará con otro objeto que los que llame conforme a las instrucciones que escriba en el documento.

#Veo desde donde consigo los datos, desde que servidor de R
# Esta es una de las direcciones del CRAN (Comprehensive R Archive Network) correspondiente a Chile. 
#Es recomendable definir por defecto un CRAN cercano. 
options(repos=structure(c(CRAN="https://cran.dcc.uchile.cl/"))) 


if(!require(tidyverse)){install.packages("tidyverse")}
if(!require(Amelia)){install.packages("Amelia")}

require(Amelia)
data(africa)

plot<-africa%>% 
  ggplot()+ 
  geom_line(aes(x=year, y=gdp_pc, color=country, group=country))+
  xlab("Fecha")+ 
  theme_grey()+ 
  theme(legend.position="bottom")+
  ggtitle("Producto interno bruto per cápita, naciones Africanas")

