# from flask import Blueprint, request, jsonify, make_response, current_app
# import json
# from .. import db
#
# menu = Blueprint('menu', __name__)
#
# ### TODO HAVEN'T tested these yet. waiting for data. also restaurant_id doesn't get used.
#
# @menu.route('/menuItems', methods=['GET'])
# def get_all_menu_items():
#     cursor = db.get_db().cursor()
#     cursor.execute('SELECT name, menu_item_id FROM MenuItem')
#     row_headers = [x[0] for x in cursor.description]
#     json_data = []
#     theData = cursor.fetchall()
#     for row in theData:
#         json_data.append(dict(zip(row_headers, row)))
#     the_response = make_response(jsonify(json_data))
#     the_response.status_code = 200
#     the_response.mimetype = 'application/json'
#     return the_response
#
# @menu.route('/restaurants/<restaurant_id>/menu/<menu_item_id>', methods=['PUT'])
# def update_restaurant(restaurant_id, menu_item_id):
#     the_data = request.json
#     current_app.logger.info(the_data)
#     # address
#     name = the_data['name']
#     price = the_data['price']
#
#
#     query = ("UPDATE MenuItem " +
#              "SET name = '" + name + "'," + "price = '" + price + "' " +
#              "WHERE menu_item_id = " + str(menu_item_id))
#     current_app.logger.info(query)
#
#     cursor = db.get_db().cursor()
#     cursor.execute(query)
#     db.get_db().commit()
#
#     return 'Success!'
#
# @menu.route('/restaurants/<restaurant_id>/menu/<menu_item_id>', methods=['DELETE'])
# def delete_restaurant(menu_item_id):
#     query = 'DELETE FROM MenuItem WHERE menu_item_id = ' + str(menu_item_id)
#     current_app.logger.info(query)
#
#     cursor = db.get_db().cursor()
#     cursor.execute(query)
#     db.get_db().commit()
#
#     return 'Success!'