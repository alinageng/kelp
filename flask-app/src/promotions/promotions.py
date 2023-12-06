from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

promotions = Blueprint('promotions', __name__)

# Get all promotions from the DB
@promotions.route('/promotions', methods=['GET'])
def get_promotions():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT *' +
        'FROM PromotionalEvent')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@promotions.route('/promotions/<restaurant_id>', methods=['GET'])
def get_promotions_by_restaurant(restaurant_id):
    cursor = db.get_db().cursor()
    query = ('SELECT * ' +
        'FROM PromotionalEvent ' +
        'WHERE PromotionalEvent.restaurant_id = ' + str(restaurant_id))

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


@promotions.route('/promotions/<restaurant_id>', methods=['POST'])
def add_new_promotion():

    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    promotional_event_id = the_data[' promotional_event_id']
    restaurant_id = the_data['restaurant_id']
    admin_id = the_data['admin_id']
    description = the_data['description']

    # Constructing the query
    query = 'insert into PromotionalEvent (promotional_event_id, restaurant_id, admin_id, description) values ("'
    query += promotional_event_id + '", "'
    query += restaurant_id + '", '
    query += admin_id + '", '
    query += description + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'   


@promotions.route('/promotions/<restaurant_id>', methods=['DELETE'])
def delete_promotion(promotional_event_id):
    query = 'DELETE FROM PromotionalEvent WHERE promotional_event_id = ' + str(promotional_event_id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'