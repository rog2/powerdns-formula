{%- from "powerdns/map.jinja" import powerdns with context -%}

import os
basedir = os.path.abspath(os.path.dirname(__file__))

# BASIC APP CONFIG
WTF_CSRF_ENABLED = True
SECRET_KEY = '{{ powerdns.config.admin.secret_key }}'
BIND_ADDRESS = '{{ powerdns.config.admin.bind_address }}'
PORT = {{ powerdns.config.admin.port }}
LOGIN_TITLE = "PDNS"

# TIMEOUT - for large zones
TIMEOUT = 10

# LOG CONFIG
LOG_LEVEL = '{{ powerdns.config.admin.log_level }}'
LOG_FILE = 'logfile.log'
# For Docker, leave empty string
#LOG_FILE = ''

# Upload
UPLOAD_DIR = os.path.join(basedir, 'upload')

# DATABASE CONFIG
#You'll need MySQL-python
SQLA_DB_USER = '{{ powerdns.mysql.admin.admin_user }}'
SQLA_DB_PASSWORD = '{{ powerdns.mysql.admin.admin_password }}'
SQLA_DB_HOST = '{{ powerdns.mysql.admin.host }}'
SQLA_DB_NAME = '{{ powerdns.mysql.admin.database }}'
SQLALCHEMY_TRACK_MODIFICATIONS = True

#MySQL
SQLALCHEMY_DATABASE_URI = 'mysql://'+SQLA_DB_USER+':'\
    +SQLA_DB_PASSWORD+'@'+SQLA_DB_HOST+'/'+SQLA_DB_NAME
#SQLite
#SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'pdns.db')
#SQLALCHEMY_MIGRATE_REPO = os.path.join(basedir, 'db_repository')


# SAML Authnetication
SAML_ENABLED = False
SAML_DEBUG = True
SAML_PATH = os.path.join(os.path.dirname(__file__), 'saml')
##Example for ADFS Metadata-URL
SAML_METADATA_URL = 'https://<hostname>/FederationMetadata/2007-06/FederationMetadata.xml'
#Cache Lifetime in Seconds
SAML_METADATA_CACHE_LIFETIME = 1

# SAML SSO binding format to use
## Default: library default (urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect)
#SAML_IDP_SSO_BINDING = 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST'

## EntityID of the IdP to use. Only needed if more than one IdP is
##   in the SAML_METADATA_URL
### Default: First (only) IdP in the SAML_METADATA_URL
### Example: https://idp.example.edu/idp
#SAML_IDP_ENTITY_ID = 'https://idp.example.edu/idp'
## NameID format to request
### Default: The SAML NameID Format in the metadata if present,
###   otherwise urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified
### Example: urn:oid:0.9.2342.19200300.100.1.1
#SAML_NAMEID_FORMAT = 'urn:oid:0.9.2342.19200300.100.1.1'

## Attribute to use for Email address
### Default: email
### Example: urn:oid:0.9.2342.19200300.100.1.3
#SAML_ATTRIBUTE_EMAIL = 'urn:oid:0.9.2342.19200300.100.1.3'

## Attribute to use for Given name
### Default: givenname
### Example: urn:oid:2.5.4.42
#SAML_ATTRIBUTE_GIVENNAME = 'urn:oid:2.5.4.42'

## Attribute to use for Surname
### Default: surname
### Example: urn:oid:2.5.4.4
#SAML_ATTRIBUTE_SURNAME = 'urn:oid:2.5.4.4'

## Attribute to use for username
### Default: Use NameID instead
### Example: urn:oid:0.9.2342.19200300.100.1.1
#SAML_ATTRIBUTE_USERNAME = 'urn:oid:0.9.2342.19200300.100.1.1'

## Attribute to get admin status from
### Default: Don't control admin with SAML attribute
### Example: https://example.edu/pdns-admin
### If set, look for the value 'true' to set a user as an administrator
### If not included in assertion, or set to something other than 'true',
###  the user is set as a non-administrator user.
#SAML_ATTRIBUTE_ADMIN = 'https://example.edu/pdns-admin'

## Attribute to get account names from
### Default: Don't control accounts with SAML attribute
### If set, the user will be added and removed from accounts to match
###  what's in the login assertion. Accounts that don't exist will
###  be created and the user added to them.
SAML_ATTRIBUTE_ACCOUNT = 'https://example.edu/pdns-account'

SAML_SP_ENTITY_ID = 'http://<SAML SP Entity ID>'
SAML_SP_CONTACT_NAME = '<contact name>'
SAML_SP_CONTACT_MAIL = '<contact mail>'
#Cofigures if SAML tokens should be encrypted.
#If enabled a new app certificate will be generated on restart
SAML_SIGN_REQUEST = False
#Use SAML standard logout mechanism retreived from idp metadata
#If configured false don't care about SAML session on logout.
#Logout from PowerDNS-Admin only and keep SAML session authenticated.
SAML_LOGOUT = False
#Configure to redirect to a different url then PowerDNS-Admin login after SAML logout
#for example redirect to google.com after successful saml logout
#SAML_LOGOUT_URL = 'https://google.com'
