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


@customers.route('/customer/<customer_id>/reviews', methods=['GET'])
def get_customer_reviews(customer_id):
    output = []
    cursor = db.get_db().cursor()
    cursor.execute('SELECT rr.restaurant_review_id, rr.restaurant_id, rr.description, rr.rating, rr.date, c.first_name, c.last_name, rest.restaurant_name \
                    FROM RestaurantReview rr JOIN Customer c on rr.customer_id = c.customer_id \
                    JOIN Restaurant rest ON rr.restaurant_id = rest.restaurant_id \
                    WHERE rr.customer_id = ' + str(customer_id))

    review_row_headers = [x[0] for x in cursor.description]
    reviews = cursor.fetchall()
    for review_row in reviews:
        menu_item_reviews_json = []
        restaurant_review_id = review_row[0]
        cursor.execute('SELECT description, rating, menu_item_review_id, name FROM MenuItemReview NATURAL JOIN MenuItem WHERE review_id = ' + str(restaurant_review_id))

        menu_item_review_row_headers = [x[0] for x in cursor.description]
        menu_item_reviews = cursor.fetchall()
        for menu_item_review_row in menu_item_reviews:
            menu_item_reviews_json.append(dict(zip(menu_item_review_row_headers, menu_item_review_row)))

        review_row_headers.append("menu_item_reviews")
        review_row = review_row + (menu_item_reviews_json,)
        output.append(dict(zip(review_row_headers, review_row)))

    the_response = make_response(jsonify(output))
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

# update a customer
@customers.route('/customers/<customer_id>', methods=['PUT'])
def update_customer(customer_id):
    the_data = request.json
    current_app.logger.info(the_data)

    first_name = the_data['first_name']
    last_name = the_data['last_name']
    email = the_data['email']
    phone = the_data['phone']
    member_since = the_data['member_since']

    query = ("UPDATE Customer " +
             "SET first_name = '" + first_name + "'," + "last_name = '" + last_name + "'," + "email = '" + email + 
             "' " + "phone = '" + phone + "' " + "member_since = '" + member_since + "' " +
             "WHERE customer_id = " + str(customer_id))
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    the_response = make_response(jsonify(the_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

    return 'Success!'


# post a customer
@customers.route('/customers', methods=['POST'])
def add_new_customer():

    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    first_name = the_data['first_name']
    last_name = the_data['last_name']
    email = the_data['email']
    phone = the_data['phone']

    # Constructing the query
    query = "insert into Customer (first_name, last_name, email, phone) values ("
    query += str(first_name) + ","
    query += str(last_name) + ",'"
    query += str(email) + ",'"
    query += str(phone) + "')"
    print(query)

    current_app.logger.info(query)

    # executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'