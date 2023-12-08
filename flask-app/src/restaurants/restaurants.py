from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

restaurants = Blueprint('restaurants', __name__)

# Get all restaurants from the DB
@restaurants.route('/restaurants', methods=['GET'])
def get_restaurants():
    cursor = db.get_db().cursor()
    # cursor.execute('SELECT company, last_name,\
    #     first_name, job_title, business_phone FROM customers')
    cursor.execute('SELECT * FROM Restaurant')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@restaurants.route('/restaurants', methods=['POST'])
def add_new_restaurant():
    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    # extracting the variable
    id = the_data['restaurant_id']
    name = the_data['restaurant_name']
    description = the_data['description']
    hours = the_data['hours']  #TODO what datatype is this??
    address = the_data['address']   # TODO address is a composite attribute; also need to insert into address table

    # Constructing the query into Restaurant Table
    query = 'insert into Restaurant (id, name, description, hours) values ("'
    query += id + '", "'
    query += name + '", "'
    query += description + '", '
    query += hours + ')'
    current_app.logger.info(query)

    # TODO construct query into Address Table

    # executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'