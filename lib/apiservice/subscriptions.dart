class MySubscription {
// chat body

  static String chat_body = '''
subscription chats(\$doctor_id:Int!,\$user_id:Int!){
  chats(where: {doctor_id: {_eq:\$doctor_id}, user_id: {_eq:\$user_id}},order_by: {created_at: desc}) {
    message
    from
    updated_at
    doctor {
     profile_image {
        url
      }
    }
  }
}
''';

// user notification
  static String user_notification = """
subscription(\$id:Int!){
  notifications(where: {user_id: {_eq:\$id}}) {
    id
    title
    description
    type
  }
}

""";

// single order detail

  static String upcoming_order_detail = """
subscription(\$id:Int!){
  orders_by_pk(id:\$id) {
    deliverer {
      full_name
      phone_number
      image {
        url
      }
      address {
        latitude
        longitude
      }
    }
    pharmacy {
      name
      logo_image {
        url
      }
      phone_number
      address {
        latitude
        longitude
      }
    }
    deliverer_id
    status
  }
}
""";
}
