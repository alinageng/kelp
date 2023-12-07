from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

health_inspectors = Blueprint('health_inspectors', __name__)

# Get all health inspectors from the DB
@health_inspectors.route('/health_inspectors', methods=['GET'])
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
