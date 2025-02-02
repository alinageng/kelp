from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

health_inspections = Blueprint('health_inspections', __name__)


@health_inspections.route('/health_inspectors', methods=['GET'])
def get_health_inspectors():

    query = "SELECT inspector_id, CONCAT(first_name, ' ', last_name) FROM HealthInspector"

    cursor = db.get_db().cursor()
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()


    print("the data", flush=True)
    print(theData, flush=True)
    for row in theData:
        json_data.append(dict(zip(["value","label"], row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get all health inspections from the DB
@health_inspections.route('/health_inspections_asc', methods=['GET'])
def get_health_inspections_asc():
    query = 'SELECT hi.health_inspection_id, hi.inspector_id, hi.restaurant_id, hi.date, hi.grade, r.restaurant_name FROM HealthInspection as hi JOIN Restaurant as r on r.restaurant_id = hi.restaurant_id order by hi.grade asc'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all health inspections from the DB
@health_inspections.route('/health_inspections_desc', methods=['GET'])
def get_health_inspections_desc():

    query = 'SELECT hi.health_inspection_id, hi.inspector_id, hi.restaurant_id, hi.date, hi.grade, r.restaurant_name FROM HealthInspection as hi JOIN Restaurant as r on r.restaurant_id = hi.restaurant_id order by hi.grade desc'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get health inspection detail for a restaurant with particular restaurant_id
@health_inspections.route('/health_inspections/<restaurant_id>', methods=['GET'])
def get_health_inspection_by_restaurant(restaurant_id):
    query = "SELECT * FROM HealthInspection h \
             JOIN HealthInspector i ON h.inspector_id = i.inspector_id \
             WHERE restaurant_id =" + str(restaurant_id)


    cursor = db.get_db().cursor()
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    print("LOOK HERE",flush=True)
    print(theData,flush=True)
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# post a health inspection for a restaurant
@health_inspections.route('/health_inspections', methods=['POST'])
def add_new_health_inspection():

    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    inspector_id = the_data['health_inspector_id']
    restaurant_id = the_data['restaurant_id']
    grade = the_data['grade']

    # Constructing the query
    query = "insert into HealthInspection (inspector_id, restaurant_id, grade) values ("
    query += str(inspector_id) + ","
    query += str(restaurant_id) + ",'"
    query += str(grade) + "')"
    print(query)

    current_app.logger.info(query)

    # executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'

# update the grade of the given health inspection.
@health_inspections.route('/health_inspections/<health_inspection_id>', methods=['PUT'])
def update_health_inspection(health_inspection_id):
    the_data = request.json
    current_app.logger.info(the_data)

    grade = the_data['grade']

    query = ("UPDATE HealthInspection SET grade = '{}' WHERE health_inspection_id = {}".format(grade, health_inspection_id))
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    the_response = make_response(jsonify(the_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

    return 'Success!'

@health_inspections.route('/health_inspections/<health_inspection_id>', methods=['DELETE'])
def delete_health_inspection(health_inspection_id):
    query = 'DELETE FROM HealthInspection WHERE health_inspection_id = ' + str(health_inspection_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'
