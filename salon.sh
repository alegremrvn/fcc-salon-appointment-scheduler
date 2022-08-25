#!/bin/bash

PSQL="psql --tuples-only --no-align --username=freecodecamp --dbname=salon -c "

echo -e "\n~~~~ MY SALON ~~~~\n"

echo "Welcome to My Salon, how can I help you?"

LOBBY() {
  if [[ ! -z $1 ]]
  then
    echo $1
  fi

  echo "$($PSQL "SELECT * FROM services")" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) APPOINT ;;
    2) APPOINT ;;
    3) APPOINT ;;
    *) LOBBY "I could not find that service. What would you like today?" ;;
  esac
}

APPOINT() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  PHONE_QUERY_RESULT="$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")"
  if [[ -z $PHONE_QUERY_RESULT ]]
  then
    echo -e "\nI don't have a record for that phone number, what is your name?"
    read CUSTOMER_NAME

    CUSTOMER_INSERT_RESULT="$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")"

    SERVICE="$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")"
    echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"
    read SERVICE_TIME

    CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")"
    APPOINTMENT_INSERT_RESULT="$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")"

    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    CUSTOMER_NAME="$($PSQL "SELECT name FROM customers WHERE phone = '$PHONE_QUERY_RESULT'")"

    SERVICE="$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")"
    echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"
    read SERVICE_TIME

    CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")"
    APPOINTMENT_INSERT_RESULT="$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")"

    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

LOBBY
