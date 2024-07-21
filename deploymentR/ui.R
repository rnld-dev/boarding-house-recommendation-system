library(shiny)
library(DT)
library(leaflet)
library(shinydashboard)

navbarPage("CARI KOS!",
           tabPanel("Home", 
                    div(
                      tags$img(src = "Indekos.png", style = "display: block; margin-left: auto; margin-right: auto; width: 30%; height: auto;"),
                      style = "text-align: center; margin-top: 5px; margin-bottom: 0px;"  # Adjust margins for spacing
                    ),
                    fluidPage(
                      column(width = 12, style = "margin: 1 auto;",
                             h3(style = "text-align: center; font-style: italic;",
                                "Sistem Rekomendasi Kos ini dikembangkan untuk kebutuhan Tugas Akhir Skripsi. ",
                                "Metode Partitioning Around Medoids (PAM) dengan modifikasi jarak Gower digunakan untuk memberikan hasil rekomendasi yang lebih relevan sesuai preferensi pengguna.",
                                br(),
                                br(),
                                a("SAHAT RENALDI. S", href = "https://www.linkedin.com/in/srenaldd/", target = "_blank", style = "font-size: 15px;"), 
                                br(),
                                span(style = "font-size: 15px;", "20083010026"), 
                                hr()
                             )
                      )
                    )
           ),
           
           
           
           tabPanel("Overview",
                    fluidPage(
                      tags$style(HTML("
                    .value-box {
                      border: 1px solid #d3d3d3; 
                      padding: 10px;
                      margin-bottom: 10px;
                      border-radius: 5px;
                      box-shadow: 2px 2px 5px rgba(0,0,0,0.1); }")),
                      column(width = 12,
                             h2(style="text-align: left", 
                                "Overview"),
                             h4(style="text-align: left",
                                "Sebaran Kos di Sekitar Kampus UPN Veteran Jawa Timur"),
                             h6("📌 Arahkan kursor ke titik dan tekan untuk melihat detail kos")
                      )
                    ),
                    
                    fluidPage(
                      column(width = 11,
                             leafletOutput("map")
                      ),
                      column(width = 1,
                             fluidRow(
                               div(class = "value-box", valueBoxOutput("totalKos"))
                             ),
                             fluidRow(
                               div(class = "value-box", valueBoxOutput("kosEksklusif"))
                             ),
                             fluidRow(
                               div(class = "value-box", valueBoxOutput("medianHarga"))
                             )
                      )
                    )
           ),
           
           
           # Tab 3 - Rekomendasi Kos
           tabPanel("Recommendation", 
                    fluidPage(
                      tags$style(HTML("
                    .value-box {
                      border: 1px solid #d3d3d3; 
                      padding: 10px;
                      margin-bottom: 10px;
                      border-radius: 5px;
                      box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
                    }
                  ")),
                      column(width = 12,
                             h2(style="text-align: left", 
                                "Recommendation"),
                             h4(style="text-align: left",
                                "Silakan Masukkan Preferensi Kos Anda : "),
                             br()
                      )
                    ),
                    
                    
                    fluidPage(
                      sidebarLayout(
                        sidebarPanel(
                          numericInput("harga", "Harga:", value = 1500000),
                          numericInput("luas_kamar", "Luas Kamar:", value = 12),
                          numericInput("upn", "Preferensi Jarak ke UPN:", value = 1),
                          selectInput("jenis", "Jenis:", choices = c("Putra", "Putri", "Campur")),
                          selectInput("listrik", "Listrik:", choices = c("Termasuk listrik", "Tidak termasuk listrik")),
                          selectInput("k_mandi_dalam", "Kamar Mandi Dalam:", choices = c("Yes", "No")),
                          selectInput("ac", "AC:", choices = c("Yes", "No")),
                          actionButton("submit", "Cari Rekomendasi")
                        ),
                        mainPanel(
                          textOutput("klaster_output"),
                          tags$head(
                            tags$style(HTML("
                              .dataTables_wrapper {
                                width: 100%;
                                overflow-x: scroll;
                              }
                              .dt-center {
                                text-align: center;
                              }
                              .truncate {
                                display: block;
                                width: 150px;  /* Set the width you want */
                                white-space: nowrap;
                                overflow: hidden;
                                text-overflow: ellipsis;
                              }
                              .truncate:hover {
                                overflow: visible;
                                white-space: normal;
                              }
                            "))
                          ),
                          DTOutput("rekomendasi_output")
                        )
                      )
                    )
           ),
)
