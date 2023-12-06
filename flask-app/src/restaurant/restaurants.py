from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

restaurants = Blueprint('restaurants', __name__)

# Get all restaurants from the DB
@restaurants.route('/restaurants', methods=['GET'])
def get_restaurants():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT restaurant_id, restaurant_name, description, hours, street, address_line_2, city, state \
            FROM Restaurant r join Address a on r.address = a.address_id')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@restaurants.route('/restaurants/<id>', methods=['GET'])
def get_restaurant_detail(id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT restaurant_name, description, hours, street, address_line_2, city, state \
            FROM Restaurant r join Address a on r.address = a.address_id WHERE restaurant_id =' + str(id))
    row_headers = [x[0] for x in cursor.description]

    theData = cursor.fetchall()
    json_data = {}
    for row_header, row_data in zip(row_headers, theData[0]):
        json_data[row_header] = row_data
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@restaurants.route('/restaurants/<restaurant_id>/reviews', methods=['GET'])
def get_restaurant_reviews(restaurant_id):
    output = []
    cursor = db.get_db().cursor()
    cursor.execute('SELECT rr.restaurant_review_id, restaurant_id, description, rating, date, first_name, last_name \
                    FROM RestaurantReview rr JOIN Customer c on rr.customer_id = c.customer_id \
                    WHERE rr.restaurant_id = ' + str(restaurant_id))

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


@restaurants.route('/restaurants/<id>', methods=['DELETE'])
def delete_restaurant(id):
    query = 'DELETE FROM Restaurant WHERE restaurant_id = ' + str(id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'

@restaurants.route('/restaurants/<id>', methods=['PUT'])
def update_restaurant(id):
    the_data = request.json
    current_app.logger.info(the_data)
    # address
    street = the_data['street']
    address_line_2 = the_data['address_line_2']
    city = the_data['city']
    state = the_data['state']
    # restaurant
    name = the_data['restaurant_name']
    description = the_data['description']
    hours = the_data['hours']

    query = ("UPDATE Restaurant " +
             "SET restaurant_name = '" + name + "'," + "description = '" + description + "'," + "hours = '" + hours + "' " +
             "WHERE restaurant_id = " + str(id))
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    cursor = db.get_db().cursor()
    cursor.execute('SELECT address FROM Restaurant WHERE restaurant_id =' + str(id))
    address_id = cursor.fetchone()[0]

    query = ("UPDATE Address " +
             "SET street = '" + street + "'," + "address_line_2 = '" + address_line_2 + "'," + "city = '" + city +
             "'," + "state = '" + state + "' " +
             "WHERE address_id = " + str(address_id))
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'

@restaurants.route('/restaurants', methods=['POST'])
def add_new_restaurant():
    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    # insert into Address
    street = the_data['street']
    address_line_2 = the_data['address_line_2']
    city = the_data['city']
    state = the_data['state']


    query = "INSERT INTO Address (street, address_line_2, city, state) VALUES ('"
    query += street + "','"
    query += address_line_2 + "','"
    query += city + "','"
    query += state + "')"

    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    # get address id
    cursor.execute("SELECT LAST_INSERT_ID()")
    address = cursor.fetchone()[0]

    name = the_data['restaurant_name']
    description = the_data['description']
    hours = the_data['hours']

    # Constructing the query into Restaurant Table
    query = "insert into Restaurant (restaurant_name, description, hours, address) values ('"
    query += name + "','"
    query += description + "','"
    query += hours + "','"
    query += str(address) + "')"
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'