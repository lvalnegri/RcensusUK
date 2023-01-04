# This is only a template based on a simple sidebar layout with a leaflet thematic map 

Rfuns::load_pkgs(dmp = FALSE, 'data.table', 'leaflet', 'leaflet.extras', 'sf', 'shiny', 'shinyjs', 'shinyWidgets')
apath <- file.path(app_path, 'XXXXXX')

ui <- fluidPage(

    useShinyjs(),
    faPlugin,
    tags$head(
        tags$title('Insert a title here for the browser window. @2022 datamaps'),
        tags$style("@import url('https://datamaps.uk/assets/datamaps/icons/fontawesome/all.css;')"),
        tags$style(HTML("
            #out_map { height: calc(100vh - 80px) !important; }
            .well { 
                padding: 10px;
                height: 90vh; 
                overflow-y: auto; 
                border: 10px;
                background-color: #EAF0F4; 
            }
            .col-sm-3 { padding-right: 0; }
        "))
    ),
    # includeCSS(file.path(app_path, 'styles.css')),
    
    titlePanel('Insert a title here'),

    fluidRow(
        column(3,
            wellPanel(
                pickerInput('cbo_', 'XXX:', some.lst),
                virtualSelectInput(
                    'cbo_', 'XXX:', some.lst, character(0), search = TRUE, 
                    placeholder = 'Select ...', 
                    searchPlaceholderText = 'Search...', 
                    noSearchResultsText = 'No XXX found!'
                ),
                h5(id = 'txt_XXX', ''),
                br(),
                awesomeRadio('rdo_XXX', 'VISUALIZE AS:', c('Dots', 'Voronoi')),
                prettySwitch('swt_XXX', 'ADD LABELS', TRUE, 'success', fill = TRUE),
                br(),
                selectInput('cbo_tls', 'MAPTILES:', tiles.lst, tiles.lst[[2]]),
                dd_Palette('col_pop', 'PALETTE:', 'Reds'),
                prettySwitch('swt_rvc', 'REVERSE COLOURS', FALSE, 'success', fill = TRUE),
                conditionalPanel("input.rdo_tpe == 'Dots'",
                    sliderInput('sld_pop', 'DOTS RADIUS:', 4, 12, 6, 1)
                ),
                dd_Colour('col_zne', 'BORDER COLOUR:', 'black'), 
                sliderInput('sld_zne', 'BORDER WEIGHT:', 2, 20, 6, 1),
            )
        ),
        column(9, leafletOutput('out_map', width = '100%'))
    )
    
)

server <- function(input, output) {

    output$out_map <- renderLeaflet({ mps})

    dts <- reactive({
            req(input$cbo_tpp)
            req(input$cbo_cmn %in% yc$CMN)
            
            ycx <- yc[CMN == input$cbo_cmn]
            ybx <- yb |> subset(CMN == input$cbo_cmn) |> st_cast('MULTILINESTRING') |> merge(ycx)
            fbx <- read_fst_idx(file.path(apath, input$cbo_tpp), input$cbo_cmn)
            dn <- gsub(' .*', '', names(fb_pop.lst)[which(fb_pop.lst == input$cbo_tpp)])
            bbx <- as.numeric(sf::st_bbox(ybx))
            
            html('txt_num', paste('Estratti', formatCit(nrow(fbx)), 'punti'))
            list('ycx' = ycx, 'ybx' = ybx, 'fbx' = fbx, 'dn' = dn, 'bbx' = bbx)
    })
    
    # UPDATE MAP BASED ON ZONE OR POPULATION CHOICE
    observeEvent(
        {
            input$cbo_tpp 
            input$cbo_cmn
        }, 
        {
            req(dts)
            pal <- colorNumeric(liste[grepl('palette', lista) & nome == input$col_pop, elemento], dts()$fbx$pop, reverse = input$swt_rvc)
            
            y <- leafletProxy('out_map') |>
                    removeShape(layerId = 'spinnerMarker') |>
                    clearShapes() |> clearControls() |> 
                    fitBounds(dts()$bbx[1], dts()$bbx[2], dts()$bbx[3], dts()$bbx[4]) |> 
                    addPolylines(
                        data = dts()$ybx,
                        group = 'comune',
                        color = input$col_com, 
                        weight = input$sld_com,
                        opacity = 1,
                        fillOpacity = 0, 
                        label = paste0('Popolazione ', dts()$dn, ' ', dts()$ycx$CMNd, ': ', formatCit(round(sum(dts()$fbx$pop)))),
                        highlightOptions = hlt.options
                    ) |>
                    addCircles(
                        data = dts()$fbx, lng = ~x_lon, lat = ~y_lat, 
                        group = 'gridpop',
                        radius = input$sld_pop,
                        stroke = FALSE, 
                        fillColor = ~pal(pop), fillOpacity = 1, 
                        label = if(input$swt_lbl) { ~formatCit(pop, 2) } else { NULL }
                    )
            grps <- NULL
            for(idx in 1:nrow(tipi_centroidi)){
                tx <- tipi_centroidi[idx]
                grp <- paste0(
                        '<span style="color: ', tx$fColore,'">
                            &nbsp<i class="fa fa-', tx$icon, '"></i>&nbsp',
                        '</span>', tx$descrizione
                )
                grps <- c(grps, grp)
                y <- y |> 
                        addAwesomeMarkers(
                            data = dts()$ycx, lng = ~get(paste0(tx$sigla, 'x_lon')), lat = ~get(paste0(tx$sigla, 'y_lat')),
                            group = grp,
                            icon = makeAwesomeIcon(icon = tx$icona, library = "fa", markerColor = tx$fColore, iconColor = tx$colore),
                            label = tx$descrizione
                        )
            }
        
            y |> 
                addLegend(
                    position = 'bottomright',
                    layerId = 'legenda',
                    pal = pal, values = dts()$fbx$pop, 
                    opacity = 1, 
                    title = dts()$dn
                )  |> 
                addLayersControl( overlayGroups = grps, options = layersControlOptions(collapsed = FALSE) ) |>  
                # TITOLO? 
                # addControl() |> 
                addCircles( lng = mean(bbox.uk[1,]), lat = mean(bbox.uk[2,]), radius = 0, opacity = 0, layerId = 'spinnerMarker' )

        }
    )
    
    # UPDATE MAPTILES
    observe({
        leafletProxy('out_map') |> clearTiles() |> aggiungi_tessera(input$cbo_tls)
    })
    
    # UPDATE MAP BASED ON DOTS STYLES
    observeEvent(
        {
            input$rdo_tpe 
            input$swt_lbl 
            input$col_pop 
            input$swt_rvc 
            input$sld_pop
        },
        {
            req(dts())
            pal <- colorNumeric(liste[grepl('palette', lista) & nome == input$col_pop, elemento], dts()$fbx$pop, reverse = input$swt_rvc)
            y <- leafletProxy('out_map') |>
                    removeShape(layerId = 'spinnerMarker') |>
                    clearGroup('gridpop') |> removeControl('legend') |> clearMarkers() |> 
                    addCircles(
                        data = dts()$fbx, lng = ~x_lon, lat = ~y_lat,
                        group = 'gridpop',
                        radius = input$sld_pop,
                        stroke = FALSE,
                        fillColor = ~pal(pop), fillOpacity = 1,
                        label = if(input$swt_lbl) { ~formatC(pop, 2) } else { NULL }
                    )
            grps <- NULL
            for(idx in 1:nrow(tipi_centroidi)){
                tx <- tipi_centroidi[idx]
                grp <- paste0(
                        '<span style="color: ', tx$fColore,'">
                            &nbsp<i class="fa fa-', tx$icon, '"></i>&nbsp',
                        '</span>', tx$descrizione
                )
                grps <- c(grps, grp)
                y <- y |>
                        addAwesomeMarkers(
                            data = dts()$ycx, lng = ~get(paste0(tx$sigla, 'x_lon')), lat = ~get(paste0(tx$sigla, 'y_lat')),
                            group = grp,
                            icon = makeAwesomeIcon(icon = tx$icona, library = "fa", markerColor = tx$fColore, iconColor = tx$colore),
                            label = tx$descrizione
                        )
            }
            y |>
                addLegend(
                    position = 'bottomright',
                    layerId = 'legend',
                    pal = pal, values = dts()$fbx$pop,
                    opacity = 1,
                    title = dts()$dn
                ) |> 
                addCircles( lng = mean(bbox.uk[1,]), lat = mean(bbox.uk[2,]), radius = 0, opacity = 0, layerId = 'spinnerMarker' )
        }
        
    )

    # UPDATE MAP BASED ON BORDER STYLES
    observeEvent(
        {
            input$col_com
            input$sld_com
        },
        {
            req(dts())
            leafletProxy('out_map') |>
                removeShape(layerId = 'spinnerMarker') |>
                clearGroup('zone') |> 
                addPolylines(
                    data = dts()$ybx,
                    group = 'zone',
                    color = input$col_com, 
                    weight = input$sld_com,
                    opacity = 1,
                    fillOpacity = 0, 
                    label = paste0('Population ', dts()$dn, ' ', dts()$ycx$CMNd, ': ', formatC(round(sum(dts()$fbx$pop)))),
                    highlightOptions = hlt.options
                ) |> 
                addCircles( lng = mean(bbox.uk[1,]), lat = mean(bbox.uk[2,]), radius = 0, opacity = 0, layerId = 'spinnerMarker' )
        }
        
    )

}

shinyApp(ui = ui, server = server)
