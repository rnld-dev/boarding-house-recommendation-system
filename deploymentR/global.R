library(shiny)
library(cluster)
library(DT)
library(dplyr)
library(leaflet)
library(shinydashboard)

# Load dataset
df <- readRDS("production.rds")
pam_fit2 <- readRDS("pam_fit2.rds")
df_withcolor <- readRDS("production_withcolor.rds")

# Calculate mean and standard deviation for scaling
mean_harga <- mean(df$Harga, na.rm = TRUE)
mean_luaskamar <- mean(df$Luas.Kamar, na.rm = TRUE)
mean_jarakupn <- mean(df$UPN, na.rm = TRUE)

sd_harga <- sd(df$Harga, na.rm = TRUE)
sd_luaskamar <- sd(df$Luas.Kamar, na.rm = TRUE)
sd_jarakupn <- sd(df$UPN, na.rm = TRUE)

# Scale function
scale_data <- function(data) {
  data <- data %>%
    mutate(
      Harga.Scale = (Harga - mean_harga) / sd_harga,
      Luas.Kamar.Scale = (Luas.Kamar - mean_luaskamar) / sd_luaskamar,
      UPN.Scale = (UPN - mean_jarakupn) / sd_jarakupn,
      Jenis = as.factor(Jenis),
      Listrik = as.factor(Listrik),
      K.Mandi.Dalam = as.factor(K.Mandi.Dalam),
      AC = as.factor(AC)
    )
  return(data)
}

# Scale the original data
df_scaled <- scale_data(df)

# Lokasi UPN Jawa Timur (contoh koordinat)
upn_lat <- -7.332784   # Latitude UPN Jawa Timur
upn_lng <- 112.788624  # Longitude UPN Jawa Timur

# Statistik Deskriptif
total_kos <- nrow(df)
ekslusif <- df[df["cluster"]=="2",]
kos_ekslusif <- round(((nrow(ekslusif)/total_kos)*100))
median_harga <- median(df$Harga)
