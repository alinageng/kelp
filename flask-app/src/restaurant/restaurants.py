from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

restaurants = Blueprint('restaurants', __name__)

@restaurants.route('/restaurants/<restaurant_id>/promotions', methods=['GET'])
def get_restaurants_promotions(restaurant_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM PromotionalEvent WHERE restaurant_id =' + str(restaurant_id))
    json_data = []
    theData = cursor.fetchall()
    row_headers = [x[0] for x in cursor.description]
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@restaurants.route('/menu/<menu_item_id>/', methods=['GET'])
def get_menu_item(menu_item_id):
    cursor = db.get_db().cursor()
    cursor.execute("SELECT name, price, mi.menu_item_id, menu_type, menu_id FROM Menu m \
                   JOIN MenuItem mi ON m.menu_item_id = mi.menu_item_id \
                   WHERE m.menu_id={}".format(menu_item_id))

    theData = cursor.fetchall()
    row_headers = [x[0] for x in cursor.description]
    json_data = {}
    for row_header, row_data in zip(row_headers, theData[0]):
        json_data[row_header] = row_data
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@restaurants.route('/restaurants/<restaurant_id>/menu_options', methods=['GET'])
def get_all_menu_items_for_posting_review(restaurant_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        'SELECT name, mi.menu_item_id FROM Menu m JOIN MenuItem mi ON m.menu_item_id = mi.menu_item_id WHERE restaurant_id=' + str(
            restaurant_id))
    json_data = []
    theData = cursor.fetchall()

    for row in theData:
        json_data.append(dict(zip(["label", "value"], row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@restaurants.route('/restaurants/<restaurant_id>/menu', methods=['GET'])
def get_all_menu_items(restaurant_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT name, price, mi.menu_item_id, menu_id, menu_type FROM Menu m \
                   JOIN MenuItem mi ON m.menu_item_id = mi.menu_item_id \
                   WHERE restaurant_id={} ORDER BY menu_type'.format(restaurant_id))

    json_data = []
    theData = cursor.fetchall()
    row_headers = [x[0] for x in cursor.description]
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all restaurants from the DB
@restaurants.route('/restaurants', methods=['GET'])
def get_restaurants():
    cursor = db.get_db().cursor()
    ## TODO add average rating
    cursor.execute('SELECT R.restaurant_id, Rest.restaurant_name, Rest.description, Rest.hours, A.street, A.address_line_2, A.city, A.state, AVG(RR.rating) AS average_rating \
                    FROM RestaurantReview RR \
                    JOIN Restaurant R ON RR.restaurant_id = R.restaurant_id \
                    JOIN Address A ON R.address = A.address_id \
                    JOIN Restaurant Rest ON Rest.restaurant_id = R.restaurant_id\
                    GROUP BY R.restaurant_id, Rest.restaurant_name, Rest.description, Rest.hours, A.street, A.address_line_2, A.city, A.state;')
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
    cursor.execute("SELECT R.restaurant_id, Rest.restaurant_name, Rest.description, Rest.hours, A.street, A.address_line_2, A.city, A.state, AVG(RR.rating) AS average_rating \
                       FROM RestaurantReview RR \
                       JOIN Restaurant R ON RR.restaurant_id = R.restaurant_id \
                       JOIN Address A ON R.address = A.address_id \
                       JOIN Restaurant Rest ON Rest.restaurant_id = R.restaurant_id\
                       WHERE R.restaurant_id = {} \
                       GROUP BY R.restaurant_id, Rest.restaurant_name, Rest.description, Rest.hours, A.street, A.address_line_2, A.city, A.state".format(id))

    row_headers = [x[0] for x in cursor.description]

    theData = cursor.fetchall()
    json_data = {}

    for row_header, row_data in zip(row_headers, theData[0]):
        json_data[row_header] = row_data
    the_response = make_response(jsonify(json_data))
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

@restaurants.route('/menu/<id>', methods=['PUT'])
def update_menu_item(id):
    the_data = request.json
    current_app.logger.info(the_data)

    price = the_data['price']
    menu_id = the_data['menu_id']

    query = ("UPDATE Menu SET price = '{}' WHERE menu_id = {}".format(price, menu_id))
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    the_response = make_response(jsonify(the_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

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

    query = ("UPDATE Address SET street = '{}', address_line_2 = '{}', city = '{}', state = '{}' WHERE address_id = {}".format(street, address_line_2, city, state, address_id))
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    the_response = make_response(jsonify(the_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

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

