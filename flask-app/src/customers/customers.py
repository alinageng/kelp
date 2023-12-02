from flask import Blueprint, request, jsonify, make_response
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

# Get customer detail for customer with particular customerID
@customers.route('/customers/<customer_id>', methods=['GET'])
def get_customer(customerID):
    query =
        'SELECT *' +
        'FROM RestaurantReview' +
        'WHERE RestaurantReview.customer_id =' + str(customer_id) +
        'GROUP BY restaurant_id'
        'UNION' +
        'SELECT *' +
        'FROM MenuItemReview' +
        'WHERE MenuItemReview.customer_id =' + str(customer_id) +
        'GROUP BY menu_item_id'

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

# delete a customer with given customer_id
@customers.route('/customers/<customer_id>', methods=['DELETE'])
def delete_customer(customer_id):
    try:
        query =
            'DELETE FROM Customer' +
            'WHERE customer_id = ' + str(customer_id)

        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

        response_data = {
            'message': f'Successfully deleted customer with customer_id {customer_id}',
            'status': 200
        }
        return jsonify(response_data), 200

    except Exception as e:
        error_message = {
            'error': str(e),
            'status': 500
        }
        return jsonify(error_message), 500