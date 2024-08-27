# Instalando e carregando as bibliotecas necessárias
if (!requireNamespace("tidygeocoder", quietly = TRUE)) {
  install.packages("tidygeocoder")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("readxl", quietly = TRUE)) {
  install.packages("readxl")
}
if (!requireNamespace("sf", quietly = TRUE)) {
  install.packages("sf")
}

library(tidygeocoder)
library(dplyr)
library(readxl)
library(sf)

# Especificar o caminho da planilha
caminho_planilha <- "C:/Users/Thiago Wallace/VScode/GISdescomplica/enderecos.xlsx"

# Ler a planilha
enderecos <- read_excel(caminho_planilha)

# Verificar se a coluna 'Address' existe no dataframe
if (!"Address" %in% colnames(enderecos)) {
  stop("A coluna 'Address' não foi encontrada no dataframe.")
}

# Utilizando a função geocode para obter as coordenadas
resultados <- enderecos %>%
  geocode(address = Address, method = 'osm')

# Verificar a estrutura dos resultados para assegurar que as colunas corretas foram geradas
str(resultados)

# Garantir que não há valores NA em lat ou long
resultados <- resultados %>%
  filter(!is.na(lat) & !is.na(long))

# Converter o data frame para um objeto sf (Simple Features)
# Especificando a geometria com base nas colunas de latitude e longitude
sf_obj <- st_as_sf(resultados, coords = c("long", "lat"), crs = 4326)

# Exibindo o objeto sf para verificar se tudo está conforme
print(sf_obj)

# Salvando o objeto sf como um Shapefile
# O Shapefile será salvo no diretório de trabalho atual
st_write(sf_obj, "resultados_geocodificacao.shp", "C:/Users/Thiago Wallace/VScode/GISdescomplica/enderecos.xlsx", delete_layer = TRUE)

getwd()

