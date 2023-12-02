from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

restaurants = Blueprint('restaurants', __name__)

# Get all restaurants from the DB
@restaurants.route('/restaurants', methods=['GET'])
def get_restaurants():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT restaurant_name, description, hours, street, address_line_2, city, state \
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
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
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
    address_id = cursor.fetchall()
    print("LOOK HERE")
    print(address_id)

    query = ("UPDATE Address " +
             "SET street = '" + street + "'," + "address_line_2 = '" + address_line_2 + "'," + "city = '" + city +
             "'," + "state = '" + state + '" ' +
             "WHERE address_id = " + str(address_id))
    # current_app.logger.info(query)
    print("CHECK: " + query)


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