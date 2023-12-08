SELECT hi.health_inspection_id, hi.inspector_id, hi.restaurant_id, hi.date, hi.grade, r.restaurant_name
FROM HealthInspection as hi
    JOIN Restaurant as r on r.restaurant_id = hi.restaurant_id;

SELECT * FROM HealthInspection WHERE restaurant_id = 11

SELECT inspector_id, CONCAT(first_name, ' ', last_name) FROM HealthInspector

SELECT inspector_id, CONCAT(first_name, ' ', last_name) FROM HealthInspector

SELECT * FROM HealthInspection WHERE restaurant_id = 1