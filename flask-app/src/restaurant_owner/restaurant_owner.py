from flask import Blueprint, request, jsonify, make_response, current_app
from .. import db

restaurant_owner = Blueprint('restaurant_owner', __name__)

@restaurant_owner.route('/restaurant_owners', methods=['GET'])
def get_all_restaurant_owners():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * \
                    FROM RestaurantOwnerAccount')
    json_data = []
    row_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@restaurant_owner.route('/restaurant_owners/<id>', methods=['GET'])
def get_restaurant_owner_by_id(id):
    cursor = db.get_db().cursor()
    cursor.execute("SELECT * FROM RestaurantOwnerAccount WHERE restaurant_owner_id={}".format(id))
    json_data = {}
    row_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    for row_header, row_data in zip(row_headers, theData[0]):
        json_data[row_header] = row_data
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@restaurant_owner.route('/restaurant_owners/<id>', methods=['DELETE'])
def delete_restaurant_owner(id):
    query = 'DELETE FROM RestaurantOwnerAccount WHERE restaurant_owner_id = ' + str(id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'

@restaurant_owner.route('/restaurant_owners/<id>', methods=['PUT'])
def update_restaurant_owner(id):
    the_data = request.json
    current_app.logger.info(the_data)

    first_name = the_data['first_name']
    last_name = the_data['last_name']
    email = the_data['email']
    restaurant_id = the_data['restaurant_id']

    query = ("UPDATE RestaurantOwnerAccount SET restaurant_id = {}, first_name = '{}' , last_name = '{}', email = '{}' \
            WHERE restaurant_owner_id = {}".format(restaurant_id, first_name, last_name, email))
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    the_response = make_response(jsonify(the_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

    return 'Success!'