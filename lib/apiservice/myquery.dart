class Myquery {
  // patient app
  static String notification = """
query notifications(\$id:Int!){
  notifications(where: {user_id: {_eq:\$id}}) {
    id
    title
    type
    description
  }
}
""";
  static String doc_notification = """
query notifications(\$id:Int!){
  notifications(where: {doctor_id: {_eq:\$id}}) {
    id
    title
    type
    description
  }
}
""";
  static String userprofile = """
  query userprofile(\$id:Int!){
  users_by_pk(id:\$id) {
    full_name
    date_of_birth
    email
    sex
    phone_number
    profile_image {
      url
    }
  }
}
""";
  static String specialitydoctor = """
query alldoc(\$speciallity:Int!){
  doctors(where: {is_approved: {_eq: true},is_suspended: {_eq: false},is_verified: {_eq: true},speciallity: {_eq:\$speciallity}},order_by: {rate: desc}){
    id
    full_name
    speciallities {
      speciallity_name
    }
    rate
    current_hospital
    profile_image {
      url
    }
    is_online
  }
}
""";
  static String alldoctor = """
query alldoc{
  doctors(where: {is_approved: {_eq: true},is_verified: {_eq: true},is_suspended: {_eq: false}},order_by: {rate: desc}){
   id
    full_name
    speciallities {
      speciallity_name
    }
    rate
    current_hospital
    profile_image {
      url
    }
    is_online
  }
}
""";
  static String topdoctor = """
query alldoc{
  doctors(where: {is_approved: {_eq: true},is_suspended: {_eq: false},rate: {_gte: 3}}, order_by: {rate: desc}) {
    id
    full_name
    speciallities {
      speciallity_name
    }
    profile_image {
      url
    }
    rate
    experience_year
    is_online
    reviews {
      id
    }
  }
}
""";
  static String onlinedoctor = """
query{
 doctors(where: {is_online: {_eq: true},is_suspended: {_eq: false},is_approved: {_eq: true}},order_by: {rate: desc}) {
    id
    full_name
    is_online
    profile_image {
      url
    }
    experience_year
    speciallities {
      speciallity_name
    }
    rate
    packages {
      video
      voice
      chat
    }
    reviews {
      id
    }
  }
}
""";

  static String doc_profile = """
query(\$id:Int!){
  doctors_by_pk(id:\$id) {
    id
    full_name
    is_online
    speciallities {
      speciallity_name
    }
    rate
    packages {
      video
      voice
      chat
    }
    experience_year
    bio
    experiences {
      hospital_name
      designation
      department
      end_date
      start_date
    }
    profile_image {
      url
    }
    reviews {
      id
      review
      rate
      user {
        full_name
      }
      created_at
    }
  }
  appointments {
    id
  }
}

""";
  static String allspeciality = """
query MyQuery {
  speciallities {
    speciallity_name
    id
  }
}
""";
  static String upcomming_appointment = """
  query upcomming_appointment(\$id:Int!){
  appointments(where: {user_id: {_eq:\$id},status: {_eq: confirmed}}) {
    id
    doctor {
      id
      profile_image {
        url
      }
      full_name
    }
    date
    time
    package_type
    channel
  }
}
  """;
  static String pending_appointment = """
  query pending_appointment(\$id:Int!){
  appointments(where: {user_id: {_eq:\$id},status: {_eq: pending}}) {
    id
    doctor {
      profile_image {
        url
      }
      full_name
    }
    date
    time
    package_type
    channel
  }
}
  """;
  static String complated_appointment = """
  query completed_appointment(\$id:Int!){
  appointments(where: {user_id: {_eq:\$id},status: {_eq: completed}}) {
    id
    doctor {
      profile_image {
        url
      }
      full_name
    }
    date
    time
    package_type
    channel
  }
}
  """;
  static String cancelled_appointment = """
  query cancelled_appointment(\$id:Int!){
  appointments(where: {user_id: {_eq:\$id},status: {_eq: cancelled}}) {
    id
    doctor {
      profile_image {
        url
      }
      full_name
    }
    date
    time
    package_type
    channel
  }
}
  """;

  // search doc
  static String search_doc = """
query search_doc(\$filter:String!){
  doctors(where: {full_name: {_ilike:\$filter}}) {
    id
    full_name
    rate
    speciallities {
      speciallity_name
    }
    profile_image {
      url
    }
    current_hospital
    is_online
    reviews {
      id
    }
  }
}

""";

// appointment detail
  static String appo_detail = """
query appo_detail(\$id:Int!){
  appointments_by_pk(id:\$id) {
    id
    doctor {
      id
      full_name
      rate
      speciallities {
        speciallity_name
      }
      reviews {
        id
      }
      profile_image {
        url
      }
      is_online
      experience_year
      current_hospital
      wallet
    }
    time
    price
    package_type
    date
    patient {
      problem
      full_name
      age
    }
    channel
    user {
      id
      full_name
    }
  }
}
""";
  static String doc_info = """
query docinfo(\$id:Int!){
   doctors_by_pk(id:\$id) {
    full_name
    user_name
    phone_number
    current_hospital
    experience_year
    sex
    speciallity
    date_of_birth
    bio
  }
}
""";
  static String appointment_detail = """
query(\$id:Int!){
  appointments_by_pk(id:\$id) {
    doctor {
      id
      full_name
      profile_image {
        url
      }
      
    }
    id
     patient {
      full_name
      age
      problem
    }
    user {
      sex
      id
      full_name
    }
    time
    date
    package_type
    status
    price
    doctor_id
    doctor {
      full_name
    }
    channel
  }
}
""";
  static String banners = """
query{
  banners {
    the_image {
      url
    }
  }
}
""";
  static String chat_doc_profile = """
query(\$id:Int!){
  doctors_by_pk(id:\$id) {
    profile_image {
      url
    }
    is_online
    full_name
  }
}
""";
  static String chat_user_profile = """
query(\$id:Int!){
  users_by_pk(id:\$id) {
    full_name
    profile_image {
      url
    }
  }
}
""";
  static String top_articles = """
query{
  blogs(where: {like: {_gte: 10}},limit: 4) {
    id
    created_at
    theImage {
      url
    }
    title
    sub_title
    content
    like
    doctor {
      profile_image {
        url
      }
      full_name
    }
  }
}
""";
  static String all_articles = """
query{
  blogs(order_by: {created_at: desc},limit:10) {
    id
    created_at
    theImage {
      url
    }
    title
    sub_title
    content
    like
    doctor {
      profile_image {
        url
      }
      full_name
    }
  }
}
""";
  static String fav_doctor = """
query(\$id:Int!){
  favorite(where: {user_id: {_eq:\$id}}) {
    id
    doctor {
      profile_image {
        url
      }
      full_name
      speciallities {
        speciallity_name
      }
    }
  }
}

""";
  static String get_online_doctor = """
query(\$id:Int!){
  doctors_by_pk(id:\$id) {
    is_online
  }
}
""";

// history

  static String video_history = """
query(\$id:Int!){
  appointments(where: {package_type: {_eq: "video"}, user_id: {_eq:\$id}, status: {_eq: "completed"}}) {
    id
    doctor {
      full_name
      profile_image {
        url
      }
    }
    date
  }
}

""";
  static String voice_history = """
query(\$id:Int!){
  appointments(where: {package_type: {_eq: "voice"}, user_id: {_eq:\$id}, status: {_eq: "completed"}}) {
    id
    doctor {
      full_name
      profile_image {
        url
      }
    }
    date
  }
}

""";

  // pharmacy
  static String all_pharmacy = """
query{
  pharmacies(order_by: {name: asc,rate: desc}) {
    id
    address {
      latitude
      location
      city
      longitude
    }
    logo_image {
      url
    }
    name
    open_time
    close_time
    rate
    phone_number
    owner_information {
      full_name
      image {
        url
      }
      phone_number
    }
  }

}
""";

  static String search_pharmacy = """
 query(\$name:String!){
   pharmacies(where: {name: {_ilike:\$name}},order_by: {name: asc,rate: desc}) {
    id
    address {
      latitude
      location
      city
      longitude
    }
    logo_image {
      url
    }
    name
    open_time
    close_time
    rate
    phone_number
    owner_information {
      full_name
      image {
        url
      }
      phone_number
    }
  }                       
}
 """;

  static String all_medicins = """
query{
   medicine(order_by: {name: asc}) {
     id
    medicine_image {
      url
    }
    name
    description
    price
    must_prescribed
    medicine_pharmacy {
      name
      phone_number
      address {
        location
      }
      logo_image {
        url
      }
    }
  }
}
""";

  static String search_medicin = """
query(\$name:String!){
  medicine(order_by: {name: asc}, where: {name: {_ilike:\$name}}) {
    id
    medicine_image {
      url
    }
    name
    description
    price
    description
    must_prescribed
    medicine_pharmacy {
      name
      address {
        location
      }
      phone_number
    }
  }
}
""";

  static String pharma_medicins = """
  query(\$id:Int!){
  medicine(where: {pharmacy_id: {_eq:\$id}}, order_by: {name: asc}) {
    id
    medicine_image {
      url
    }
    name
    price
  }
}
  """;

  static String medicin_detail="""
  query(\$id:Int!){
  medicine_by_pk(id:\$id) {
    id
    medicine_image {
      url
    }
    medicine_pharmacy {
      logo_image {
        url
      }
      name
      open_time
      close_time
      rate
      phone_number
      address {
        city
        location
        latitude
        longitude
      }
    }
    name
    must_prescribed
    price
    description
  }
}

  
  """;

// orders

  static String newOrder = """
  query(\$user_id:Int!){
  orders(where: {user_id: {_eq:\$user_id}, status: {_eq: pending}}, order_by: {created_at: desc}) {
    id
    order_code
    pharmacy {
      logo_image {
        url
      }
      name
      address {
        location
      }
    }
    order_address {
      location
    }
    created_at
    total_cost
    delivery_fee
    status
  }
}
""";

  static String upcomming_orders = """
  query(\$id:Int!){
  orders(where: {user_id: {_eq:\$id}, status: {_eq: confirmed}}) {
    id
    order_code
    pharmacy {
      name
      logo_image {
        url
      }
      address {
        location
      }
      phone_number
    }
    created_at
    status
  }
}
""";

  static String completed_order = """
  query(\$user_id:Int!){
     orders(where: {user_id: {_eq:\$user_id}, status: {_eq: delivered}}, order_by: {created_at: asc}) {
    id
    order_code
    pharmacy {
      logo_image {
        url
      }
      name
      address {
        location
      }
    }
  }
  }

""";

  static String near_pharmacys = """
query(\$latitude:Float!,\$longitude:Float!,\$radius:Int!){
  nearByPharmacy(latitude:\$latitude,longitude:\$longitude, radius:\$radius) {
    id
    name
    open_time
    close_time
    phone_number
    owner_information {
      full_name
      phone_number
      image {
        url
      }
    }
    logo_image {
      url
    }
    address {
      city
      latitude
      location
      longitude
    }
  }
}
""";

// order detail medicin list
  static String order_medicins = """
    query(\$id:Int!){
  medicine_order_detail(where: {order_id: {_eq:\$id}}) {
    medicine_name
    medicine_description
    medicine_price
    image {
      url
    }
  }
}

""";

  // order_noti
  static String not_order = """
  query(\$id:Int!){
  orders(where: {user_id: {_eq:\$id}, status: {_eq: pending}}) {
    id
  }
}

  
  """;
}
