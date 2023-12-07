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


# # post a new review for a restaurant
# @customers.route('/customers/<customer_id>/reviews/<restaurant_id>', methods=['POST'])
# def post_a_restaurant_review(customer_id, restaurant_id):
#
#     # collecting data from the request object
#     the_data = request.json
#     current_app.logger.info(the_data)
#
#
#     #extracting the variable
#     description = the_data['description']
#     rating = the_data['rating']
#     date = the_data['date']
#
#
#     # Constructing the query
#     query = 'insert into RestaurantReview (restaurant_review_id, customer_id, restaurant_id, description, rating, date) values ('
#     query += str(customer_id) + ', '
#     query += str(restaurant_id) + ', "'
#     query += description + '", '
#     query += str(rating) + ', "'
#     query += str(date) + '")'
#     current_app.logger.info(query)
#
#     # executing and committing the insert statement
#     cursor = db.get_db().cursor()
#     cursor.execute(query)
#     db.get_db().commit()
#
#     return 'Success!'
#
#
# # delete a customer's review
# @customers.route('/customers/<customer_id>', methods=['DELETE'])
# def delete_customer(customer_id):
#     try:
#         query = 'DELETE FROM RestaurantReview WHERE customer_id = ' + str(customer_id)
#
#         cursor = db.get_db().cursor()
#         cursor.execute(query)
#         db.get_db().commit()
#
#         response_data = {
#             'message': 'Successfully deleted customer',
#             'status': 200
#         }
#         return jsonify(response_data), 200
#
#     except Exception as e:
#         error_message = {
#             'error': str(e),
#             'status': 500
#         }
#         return jsonify(error_message), 500