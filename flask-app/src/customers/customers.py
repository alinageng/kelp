from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

customers = Blueprint('customers', __name__)

# Get all customers from the DB
@customers.route('/customers', methods=['GET'])
def get_customers():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Customer')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@customers.route('/customers/<id>', methods=['GET'])
def get_a_customer(id):
    cursor = db.get_db().cursor()
    cursor.execute("SELECT * FROM Customer WHERE customer_id = {}".format(id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data[0]))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# delete a customer with given customer_id
@customers.route('/customers/<customer_id>', methods=['DELETE'])
def delete_customer(customer_id):
    try:
        query = 'DELETE FROM Customer WHERE customer_id = ' + str(customer_id)

        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

        response_data = {
            'message': 'Successfully deleted customer',
            'status': 200
        }
        return jsonify(response_data), 200

    except Exception as e:
        error_message = {
            'error': str(e),
            'status': 500
        }
        return jsonify(error_message), 500

