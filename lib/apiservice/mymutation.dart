class Mymutation {
  // user signup
  static String usersignup = """ 
mutation userSignUp(\$full_name:String!,\$sex:String!,\$phone_number:String!,\$email:String!,\$password:String!,\$date_of_birth:String!) {
  userSignUp(full_name: \$full_name, sex:\$sex, phone_number:\$phone_number, email:\$email, password:\$password,date_of_birth:\$date_of_birth)
  {
    id
    token
  }
}
""";

  // login
  static String login = """
  mutation login(\$email:String!,\$password:String!){
  login(email:\$email, password:\$password) {
    id
    token
    user_name
  }
}
  """;

// upload_file
  static String uploadfile = """
mutation uploadImage(\$base64:String!){
  uploadImage(base64:\$base64) {
    id
  }
}
""";

// update appointment statuss
  static String update_appo_statuss = """
  mutation(\$id:Int!,\$status:String!){
  update_appointments_by_pk(pk_columns: {id:\$id}, _set: {status:\$status}) {
    id
  }
}
""";
// insert notificatiob for users
  static String insert_notification = """
  mutation(\$user_id:Int!,\$title:String!,\$description:String!,\$type:String!){
  insert_notifications(objects: {user_id:\$user_id, title:\$title, description:\$description, type:\$type}) {
    returning {
      id
    }
  }
}
""";
// insert notificatiob for doctor
  static String insert_notification_doc = """
  mutation(\$title:String!,\$description:String!,\$type:String!,\$doctor_id:Int!){
  insert_notifications(objects: {title:\$title, description:\$description, type:\$type,doctor_id:\$doctor_id}) {
    returning {
      id
    }
  }
}
""";

// pay
  static String pay = """
mutation(\$amount:Int!,\$doctor_id:Int!,\$user_id:Int!,\$first_name:String!,\$last_name:String!,\$email:String!){
  pay(amount:\$amount, doctor_id:\$doctor_id, user_id:\$user_id, first_name:\$first_name, last_name:\$last_name, email:\$email) {
    redirect_url
    ref_no
  }
}
""";
// verifay payment
  static String verifay_payment = """
mutation(\$ref_no:String!){
  verifyPayment(arg1: {ref_no:\$ref_no}) {
    status
  }
}
""";
// reschedule appointment
  static String reschedule_appointment = """
mutation(\$id:Int!,\$date:String!,\$time:String!){
  update_appointments_by_pk(pk_columns: {id:\$id}, _set: {date:\$date, time:\$time}) {
    id
  }
}
""";

// update user info
  static String update_user = """
mutation(\$id:Int!,\$full_name:String!,\$phone_number:String!,\$sex:String!,\$email:String!,\$date_of_birth:String!) {
  update_users_by_pk(pk_columns: {id:\$id}, _set: {full_name:\$full_name, phone_number:\$phone_number, sex:\$sex, email:\$email, date_of_birth:\$date_of_birth}) {
    id
  }
}

""";

// review
  static String review = """
mutation(\$rate:Int!,\$user_id:Int!,\$doctor_id:Int!,\$review:String!){
  insert_reviews(objects: {rate:\$rate, review:\$review, user_id:\$user_id, doctor_id:\$doctor_id}) {
    returning {
      id
    }
  }
}
""";
// delete notification
  static String delete_notification = """
  mutation(\$id:Int!){
  delete_notifications_by_pk(id:\$id) {
    id
  }
}
""";
// refund request
  static String refund_request = """
mutation(\$id:Int!){
  insert_refund(objects: {appointment_id:\$id}) {
    returning {
      id
    }
  }
}
""";

// update wallet when withdraw
  static String update_wallet_withdraw = """
mutation(\$id:Int!,\$wallet:Int!){
  update_doctors_by_pk(pk_columns: {id:\$id}, _set: {wallet:\$wallet}) {
    id
  }
}

""";

// send chat
  static String send_message = """
mutation(\$doctor_id:Int!,\$user_id:Int!,\$from:String!,\$to:String!,\$message:String!) {
  sendChat(doctor_id:\$doctor_id, user_id:\$user_id, from:\$from, to:\$to, message:\$message) {
    id
  }
}
""";

// insert appointment
  static String insert_appointment = """
  mutation(\$date:String!,\$time:String!,\$price:String!,\$user_id:Int!,\$doctor_id:Int!,\$package_type:String!,\$channel:String!,\$full_name:String!,\$age:Int!,\$problem:String!){
  insert_appointments(objects: {date:\$date, time:\$time, price:\$price, user_id:\$user_id, doctor_id:\$doctor_id, package_type:\$package_type, channel:\$channel, patient: {data: {full_name:\$full_name, age:\$age, problem:\$problem}}}) {
    returning {
      id
    }
  }
}
""";

// like blog
  static String like_blog = """
mutation(\$id:Int!) {
  update_blogs_by_pk(pk_columns: {id:\$id}, _inc: {like: 1}) {
    id
  }
}

""";

// add favorite
  static String add_favorite_doc = """
mutation(\$user_id:Int!,\$doctor_id:Int!) {
  insert_favorite(objects: {user_id:\$user_id, doctor_id:\$doctor_id}) {
    returning {
      id
    }
  }
}

""";
// delete fav doc
  static String delete_fav_doc = """
mutation(\$id:Int!) {
  delete_favorite_by_pk(id:\$id) {
    id
  }
}

""";
// forgot password
  static String forgot_password = """
mutation(\$email:String!) {
  forgotPassword(arg1: {email:\$email}) {
    id
  }
}
""";

//  delet order

  static String delete_order = """
mutation(\$id:Int!){
  delete_orders_by_pk(id:\$id) {
    id
  }
}
""";

// order medicin
  static String order_medicin = """
mutation(\$user_id:Int!,\$presc_image:Int!,\$ph_id:Int!,\$user_lat:Float!,\$user_long:Float!,\$user_loc:String!,\$del_cost:Int!,\$user_city:String!,\$distance:Int!){
  order(user_id:\$user_id, prescription_image:\$presc_image, pharmacy_id:\$ph_id, longitude:\$user_long, latitude:\$user_lat, location:\$user_loc, delivery_fee:\$del_cost, city:\$user_city,distance:\$distance) {
    id
  }
}
""";
// calculate delivery fee
  static String calc_delivery_fee = """
mutation(\$ph_lat:Float!,\$ph_long:Float!,\$user_lat:Float!,\$user_long:Float!){
  calculateDeliveryFee(pharmacy_location: {latitude:\$ph_lat, longitude:\$ph_long}, user_location: {latitude:\$user_lat, longitude:\$user_long}) {
    distance
    price
  }
}
""";

// upload image
  static String upload_image = """
mutation(\$image:String!){
  uploadImage(base64:\$image) {
    id
    url
  }
}
""";

  // confirme order
static String confirm_order="""
mutation(\$id:Int!){
  update_orders_by_pk(pk_columns: {id:\$id}, _set: {status: confirmed}) {
    id
    status
  }
}

""";

// order from prescription

  static String orderRecomendation="""
  mutation(\$city:String!,\$defee:Int!,\$totcost:Int!,\$distance:Int!,\$location:String!,\$lat:Float!,\$lon:Float!,\$uid:Int!,\$pid:Int!,\$dprecid:Int!){
  order(city:\$city, delivery_fee:\$defee, total_cost:\$totcost, distance:\$distance, location:\$location, latitude:\$lat, longitude:\$lon, user_id:\$uid, pharmacy_id:\$pid, digital_prescription_id:\$dprecid) {
    id
  }
}

  
  """;
}
