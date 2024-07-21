library(shiny)
library(cluster)
library(DT)
library(dplyr)
library(leaflet)
library(shinydashboard)
library(scales)

# Server function
shinyServer(function(input, output) {
  
  # Definisi data default berdasarkan nilai-nilai awal
  default_data <- df  # Menggunakan seluruh data dari dataframe `df` sebagai data default
  
  # Render Leaflet map
  output$map <- renderLeaflet({
    leaflet(df_withcolor) %>%
      addTiles() %>%
      setView(lng = upn_lng, lat = upn_lat, zoom = 13.47) %>%
      addCircleMarkers(
        ~Longitude, ~Latitude,
        color = ~color,
        fillColor = ~color,
        popup = ~paste(
          Nama, "<br><br>",
          "<b>Jenis Kos:</b>", Jenis, "<br>",
          "<b>Lokasi:</b>", Lokasi, "<br>",
          "<b>Harga:</b>", Harga, "<br>",
          "<b>Luas Kamar:</b>", Luas.Kamar, "<br>",
          "<b>Jarak ke UPN:</b>", format(round(UPN, 2), nsmall = 2), "km<br>",
          "<b>Listrik:</b>", Listrik, "<br>",
          "<b>Kamar Mandi Dalam:</b>", K.Mandi.Dalam, "<br>",
          "<b>AC:</b>", AC, "<br>",
          "<a href='", Link, "' target='_blank' style='color:blue; text-decoration:underline;'>Klik untuk melihat</a>"
        ),
        radius = 6.3,
        fillOpacity = 0.3,
        opacity = 1,
        stroke = TRUE,
        weight = 1,
        label = ~Nama,
        labelOptions = labelOptions(
          noHide = FALSE,
          direction = 'auto'
        )
      ) %>%
      addCircleMarkers(
        lng = upn_lng, lat = upn_lat,
        color = "black",
        fillColor = "#e5dec9",
        radius = 8,
        fillOpacity = 2,
        opacity = 0.8,
        stroke = TRUE,
        label = "UPN",
        popup = "Universitas Pembangunan Nasional",
        labelOptions = labelOptions(
          noHide = TRUE,
          direction = 'auto'
        )
      ) %>%
      addLegend(
        "bottomright",
        colors = c("#d03f2c", "#004af9"),
        labels = c("Kos Standar", "Kos Eksklusif"),
        title = "Klaster"
      )
  })
  
  # Render infoboxes
  output$totalKos <- renderValueBox({
    valueBox(total_kos, "Total Kos")
  })
  
  output$kosEksklusif <- renderValueBox({
    valueBox(paste0(kos_ekslusif, "%"), "Kos Eksklusif")
  })
  
  output$medianHarga <- renderValueBox({
    formatted_median_harga <- number(median_harga / 1e6, accuracy = 0.1)  
    valueBox(paste0(formatted_median_harga, "jt"), "Median Harga")
  })
  
  # Render default table
  output$rekomendasi_output <- DT::renderDataTable({
    # Create clickable links 
    default_data$Link <- paste0('<a href="', default_data$Link, '" target="_blank">Open</a>')
    default_data$Nama <- paste0('<span class="truncate" title="', default_data$Nama, '">', default_data$Nama, '</span>')
    
    results <- default_data %>%
      mutate(
        Cluster = ifelse(cluster == 1, "Kos Standar", "Kos Eksklusif"),
        `Jarak UPN` = paste0(round(UPN, 2), " km")
      ) %>%
      select(Link, Nama, Cluster, Jenis, Lokasi, Harga, Luas.Kamar, `Jarak UPN`,
             Listrik, K.Mandi.Dalam, AC, WiFi, Kasur, Akses.24.Jam)
    
    DT::datatable(results, escape = FALSE, options = list(pageLength = 6, searching = TRUE),
                  callback = JS('table.columns.adjust().draw();'))
  })
  
  observeEvent(input$submit, {
    new_data <- data.frame(Harga = input$harga,
                           Luas.Kamar = input$luas_kamar,
                           UPN = input$upn,
                           Jenis = input$jenis,
                           Listrik = input$listrik,
                           K.Mandi.Dalam = input$k_mandi_dalam,
                           AC = input$ac)
    
    new_data_scaled <- scale_data(new_data)
    
    df_combined <- bind_rows(df_scaled, new_data_scaled)
    selected_col <- c("Harga.Scale", "Luas.Kamar.Scale", "UPN.Scale", "Jenis", "Listrik", "K.Mandi.Dalam", "AC")
    
    df_gower_combined <- daisy(df_combined[, selected_col], metric = "gower")
    df_gower_combined_matrix <- as.matrix(df_gower_combined)
    
    gower_distance_new <- df_gower_combined_matrix[nrow(df_combined), 1:nrow(df_scaled)]
    
    cluster_new_data <- pam_fit2$clustering[which.min(gower_distance_new)]
    
    same_cluster_indices <- which(pam_fit2$clustering == cluster_new_data)
    gower_distance_same_cluster <- gower_distance_new[same_cluster_indices]
    
    nearest_kos_indices <- same_cluster_indices[order(gower_distance_same_cluster)[1:20]]
    nearest_kos <- df[nearest_kos_indices, ]
    
    # Create clickable links 
    nearest_kos$Link <- paste0('<a href="', nearest_kos$Link, '" target="_blank">Open</a>')
    nearest_kos$Nama <- paste0('<span class="truncate" title="', nearest_kos$Nama, '">', nearest_kos$Nama, '</span>')
    
    results <- nearest_kos %>%
      mutate(
        `Dissimilarity` = round(gower_distance_same_cluster[order(gower_distance_same_cluster)[1:20]], 3),
        `Jarak UPN` = paste0(round(UPN, 2), " km")
      ) %>%
      select(Link, Nama, `Dissimilarity`, Jenis, Lokasi, Harga, Luas.Kamar, `Jarak UPN`,
             Listrik, K.Mandi.Dalam, AC, WiFi, Kasur, Akses.24.Jam)
    
    output$klaster_output <- renderText({
      paste("Klaster data baru:", cluster_new_data)
    })
    
    output$rekomendasi_output <- DT::renderDataTable({
      DT::datatable(results, escape = FALSE, options = list(pageLength = 7, searching = TRUE),
                    callback = JS('table.columns.adjust().draw();'))
    })
    
  })
  
})
