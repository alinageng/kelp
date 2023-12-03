from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

menu = Blueprint('menu', __name__)

@menu.route('/restaurants/<restaurant_id>/menu', methods=['GET'])
def get_menus(restaurant_id):
    cursor = db.get_db().cursor()
    query = ('SELECT *' +
        'FROM Menu' +
        'WHERE Menu.restaurant_id =' + str(restaurant_id))

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


@menu.route('/restaurants/<restaurant_id>/menu', methods=['POST'])
def add_new_menu():

    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    menu_id = the_data['menu_id']
    restaurant_id = the_data['restaurant_id']
    menu_type = the_data['menu_type']

    # Constructing the query
    query = 'insert into Menu (menu_id, restaurant_id, menu_type) values ("'
    query += menu_id + '", "'
    query += restaurant_id + '", '
    query += menu_type + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'
    
### TODO HAVEN'T tested these yet. waiting for data. also restaurant_id doesn't get used.
@menu.route('/restaurants/<restaurant_id>/menu/<menu_item_id>', methods=['PUT'])
def update_restaurant(restaurant_id, menu_item_id):
    the_data = request.json
    current_app.logger.info(the_data)
    # address
    name = the_data['name']
    price = the_data['price']


    query = ("UPDATE MenuItem " +
             "SET name = '" + name + "'," + "price = '" + price + "' " +
             "WHERE menu_item_id = " + str(menu_item_id))
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'

@menu.route('/restaurants/<restaurant_id>/menu/<menu_item_id>', methods=['DELETE'])
def delete_restaurant(menu_item_id):
    query = 'DELETE FROM MenuItem WHERE menu_item_id = ' + str(menu_item_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'