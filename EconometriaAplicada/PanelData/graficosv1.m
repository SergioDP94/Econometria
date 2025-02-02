% Ruta del directorio
ruta = 'J:\Mi unidad\TalleresEGlobal\250130_Taller_panel';
cd(ruta);

% Leer hoja del archivo Excel
filename = 'InformalidadDatos.xlsx';
df_prov = readtable(filename, 'Sheet', 'departamento');

% Convertir la columna year a categórica
df_prov.year = categorical(df_prov.year);

% Nombre del GIF de salida
gif_filename = 'Evolucion_Informalidad.gif';

% Animación y exportación
years = unique(df_prov.year);

% Inicializar la animación
for i = 1:length(years)
    current_year = years(i);
    
    % Filtrar datos del año actual
    data_year = df_prov(df_prov.year == current_year, :);
    
    % Limpiar el gráfico antes de dibujar nuevos puntos
    clf;
    hold on;
    
    title('Evolución de la Tasa de Informalidad vs Ingreso por Provincia');
    xlabel('Tasa de Informalidad (%)');
    ylabel('Ingreso Promedio');
    grid on;
    xlim([40 100]);  % Ajusta los límites si es necesario
    ylim([0 max(df_prov.ingreso) + 500]);

    % Diagrama de dispersión del año actual (actualización de puntos)
    scatter(data_year.tasa_informalidad * 100, data_year.ingreso, ...
        50, 'filled', 'DisplayName', char(current_year), 'MarkerFaceColor', 'b');
    
    % Crear variables para la regresión
    p = polyfit(data_year.tasa_informalidad * 100, data_year.ingreso, 1);  % Ajuste lineal
    
    % Crear una línea de regresión
    x_line = linspace(0, 100, 100);
    y_line = polyval(p, x_line);

    % Añadir la línea de regresión (constante)
    plot(x_line, y_line, 'r-', 'LineWidth', 2);
    
    % Añadir leyenda y título dinámico
    legend show;
    title(['Año: ', char(current_year)]);
    
    % Capturar cuadro
    frame = getframe(gcf);
    img = frame2im(frame);
    [img_ind, colormap_gif] = rgb2ind(img, 256);
    
    % Escribir el GIF
    if i == 1.5
        imwrite(img_ind, colormap_gif, gif_filename, 'gif', 'LoopCount', Inf, 'DelayTime', 1);
    else
        imwrite(img_ind, colormap_gif, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 1);
    end
    
    pause(1);  % Pausa para visualizar en tiempo real
end

hold off;
disp(['Animación exportada como GIF en: ' gif_filename]);
