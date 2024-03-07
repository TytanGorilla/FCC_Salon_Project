#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ GitGud Hair ~~~~~\n"
echo -e "Welcome! We offer the following:\n"

SERVICE_LIST() {
  if [[ $1 ]]
  then
    echo "$1"
  fi

  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
}
SERVICE_LIST

SERVICE() {
  echo -e "\nExcellent choice!\n"
  SERVICE_ID_SELECTED=$1
  ACTUAL_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo -e "You chose service_id : $SERVICE_ID_SELECTED"
  echo -e "\nCould I have your phone number?"
  read CUSTOMER_PHONE
  CHECK_CUSTOMER=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CHECK_CUSTOMER ]]
  then
    echo -e "\nIt seems this is your 1st time with us."
    echo -e "\nCould we please have your name."
    read CUSTOMER_NAME
    echo -e "Great $CUSTOMER_NAME, what time would you like for your appointment?"
    read SERVICE_TIME
    echo -e "Awesome $CUSTOMER_NAME, we will see you at $SERVICE_TIME."
    #Insert new customer's name & phone number
    echo $($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    #Insert new customer's appointment
    echo $($PSQL "INSERT INTO appointments(time) VALUES('$SERVICE_TIME')")
    echo -e "I have put you down for a $ACTUAL_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

SELECTION_MENU() {
  echo -e "\nWhat service can we provide to you today?"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) SERVICE "1";;
    2) SERVICE "2";;
    3) SERVICE "3";;
    *) SERVICE_LIST "Please select a valid option.";;
  esac
}
SELECTION_MENU


