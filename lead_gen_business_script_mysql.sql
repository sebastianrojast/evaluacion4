-- Evaluación n° 4 correspondiente a módulo My SQL

-- 1. ¿Qué consulta ejecutaría para obtener los ingresos totales para marzo de 2012?
SELECT MONTHNAME(billing.charged_datetime) AS mes, SUM(billing.amount) AS ingreso_total
FROM billing
WHERE billing.charged_datetime >= '2012/03/01' AND billing.charged_datetime <= '2012/03/31';

-- 2. ¿Qué consulta ejecutaría para obtener los ingresos totales recaudados del cliente con una
-- identificación de 2?
SELECT clients.client_id, SUM(amount) as ingreso_total FROM billing 
LEFT JOIN clients ON billing.client_id = clients.client_id
WHERE clients.client_id = 2;

-- 3. ¿Qué consulta ejecutaría para obtener todos los sitios que posee client = 10?
SELECT sites.client_id, sites.domain_name as sitios_web FROM sites 
LEFT JOIN clients ON sites.client_id = clients.client_id
WHERE clients.client_id = 10;

-- 4. ¿Qué consulta ejecutaría para obtener el número total de sitios creados por mes por año 
-- para el cliente con una identificación de 1? ¿Qué pasa con el cliente = 20?
SELECT sites.client_id AS id_cliente, COUNT(sites.site_id) AS sitios_creados, MONTHNAME(sites.created_datetime) AS mes, YEAR(sites.created_datetime) AS año
FROM sites
JOIN clients ON clients.client_id = sites.client_id AND clients.client_id =20 -- Acá cambiar el clients.client_id a 20 para chequear el cliente con ID 20
GROUP BY MONTH(sites.created_datetime), YEAR(sites.created_datetime)
ORDER BY YEAR(sites.created_datetime) ASC;

-- 5. ¿Qué consulta ejecutaría para obtener el número total de clientes potenciales generados 
-- para cada uno de los sitios entre el 1 de enero de 2011 y el 15 de febrero de 2011?
SELECT COUNT(leads.leads_id) AS 'número de leads', sites.domain_name AS 'nombre sitio web', leads.registered_datetime
FROM sites
JOIN leads ON sites.site_id = leads.site_id
AND leads.registered_datetime >= '2011-01-01'
AND leads.registered_datetime <= '2011-02-15'
GROUP BY sites.domain_name;

-- 6. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total 
-- de clientes potenciales que hemos generado para cada uno de nuestros clientes entre el 
-- 1 de enero de 2011 y el 31 de diciembre de 2011?
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS 'nombre del cliente', COUNT(leads.leads_id) AS 'número de leads', leads.registered_datetime
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime >= '2011-01-01'
AND leads.registered_datetime <= '2011-12-31'
GROUP BY clients.client_id
ORDER BY 'número de leads' DESC; 

-- 7. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total 
-- de clientes potenciales que hemos generado para cada cliente cada mes entre los meses 
-- 1 y 6 del año 2011?
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS 'nombre del cliente', COUNT(leads.leads_id) AS 'número de leads', MONTHNAME(leads.registered_datetime) AS 'Creado en mes de'
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime >= '2011-01-01'
AND leads.registered_datetime <= '2011-06-30'
GROUP BY clients.client_id, MONTH(leads.registered_datetime)
ORDER BY 'número de leads' DESC; 

-- 8. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total 
-- de clientes potenciales que hemos generado para cada uno de los sitios de nuestros clientes 
-- entre el 1 de enero de 2011 y el 31 de diciembre de 2011? Solicite esta consulta por ID de 
-- cliente. Presente una segunda consulta que muestre todos los clientes, los nombres del sitio 
-- y el número total de clientes potenciales generados en cada sitio en todo momento.

-- Primera consulta
SELECT clients.client_id, CONCAT(clients.first_name, ' ', clients.last_name) AS 'nombre cliente', sites.domain_name AS 'página web', COUNT(leads.leads_id) AS 'número de leads', leads.registered_datetime AS 'fecha de registro' 
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime >= '2011-01-01'
AND leads.registered_datetime <= '2011-12-31'
GROUP BY sites.domain_name
ORDER BY clients.client_id ASC;

-- Segunda consulta
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS 'clients', sites.domain_name, COUNT(leads.leads_id) AS '# of leads'
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
JOIN leads ON sites.site_id = leads.site_id
GROUP BY sites.domain_name
ORDER BY clients.client_id;

-- 9. Escriba una sola consulta que recupere los ingresos totales recaudados de cada cliente 
-- para cada mes del año. Pídalo por ID de cliente.

SELECT clients.client_id, CONCAT(clients.first_name, ' ', clients.last_name) AS 'nombre_cliente', SUM(billing.amount) AS 'monto total', MONTHNAME(billing.charged_datetime) AS 'mes', YEAR(billing.charged_datetime) AS 'año'
FROM clients
JOIN billing ON clients.client_id = billing.client_id
GROUP BY clients.client_id , MONTH(billing.charged_datetime)
ORDER BY clients.client_id ASC , MONTH(billing.charged_datetime) ASC , YEAR(billing.charged_datetime) ASC;

-- 10. Escriba una sola consulta que recupere todos los sitios que posee cada cliente. Agrupe 
-- los resultados para que cada fila muestre un nuevo cliente. Se volverá más claro cuando 
-- agregue un nuevo campo llamado 'sitios' que tiene todos los sitios que posee el cliente. 
-- (SUGERENCIA: use GROUP_CONCAT)

SELECT clients.client_id, CONCAT(clients.first_name, ' ', clients.last_name) AS 'nombre del cliente', GROUP_CONCAT(' ', sites.domain_name) AS 'sitios'
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
GROUP BY clients.client_id










