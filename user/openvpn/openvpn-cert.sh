#!/bin/sh

if [ ! -x /usr/bin/openssl ] && [ ! -x /opt/bin/openssl ]; then
	echo "Unable to find the 'openssl' executable!"
	echo "Please install 'openssl-util' package from Entware."
	exit 1
fi

################################################################################
##
indir=$(pwd)
ssldir=/etc/ssl
keydir=/etc/ssl/keys
dstdir=/etc/storage/openvpn

[ -d ${ssldir} ] || mkdir -p ${ssldir}
[ -d ${keydir} ] || mkdir -p -m 700 ${keydir}
[ -d ${dstdir} ] || mkdir -p -m 700 ${dstdir}

################################################################################
## Checks if the openssl configuration file exists and directory structure is 
## correct.
do_check_cfg()
{
if [ ! -f ${ssldir}/openssl.cnf ] ; then
cat > ${ssldir}/openssl.cnf << EOF

oid_section		= new_oids
[ new_oids ]

################################################################################
[ ca ]
default_ca	= CA_default		# The default ca section

################################################################################
[ CA_default ]
dir		= ${keydir}		# Where everything is kept
certs		= \$dir/certs		# Where the issued certs are kept
crl_dir		= \$dir/crl		# Where the issued crl are kept
database	= \$dir/index		# database index file.
new_certs_dir	= \$dir/newcerts	# default place for new certs.
certificate	= \$dir/ca.crt		# The CA certificate
serial		= \$dir/serial 		# The current serial number
crl		= \$dir/crl.pem 	# The current CRL
private_key	= \$dir/ca.key 		# The private key
RANDFILE	= \$dir/private/.rand	# private random number file
x509_extensions	= usr_cert		# The extentions to add to the cert
unique_subject	= no			# Set to 'no' to allow creation of
					# several certificates with same subject.

name_opt 	= ca_default		# Subject Name options
cert_opt 	= ca_default		# Certificate field options

default_days	= 365			# how long to certify for
default_crl_days= 30			# how long before next CRL
default_md	= md5			# which md to use.
preserve	= no			# keep passed DN ordering

policy		= policy_match

# For the CA policy
[ policy_match ]
countryName		= match
stateOrProvinceName	= optional
organizationName	= match
organizationalUnitName	= optional
commonName		= supplied
emailAddress		= match

# For the 'anything' policy
# At this point in time, you must list all acceptable 'object'
# types.
[ policy_anything ]
countryName		= optional
stateOrProvinceName	= optional
localityName		= optional
organizationName	= optional
organizationalUnitName	= optional
commonName		= supplied
emailAddress		= optional

####################################################################
[ req ]
default_bits		= 1024
default_keyfile 	= ca.key
distinguished_name	= req_distinguished_name
attributes		= req_attributes
x509_extensions		= v3_ca	 # The extentions to add to the self signed cert

string_mask = nombstr

[ req_distinguished_name ]
countryName			= Country Name (2 letter code)
countryName_default		= RU
countryName_min			= 2
countryName_max			= 2
stateOrProvinceName		= State or Province Name (full name)
stateOrProvinceName_default	= Some-State
localityName			= Locality Name (eg, city)
0.organizationName		= Organization Name (eg, company)
0.organizationName_default	= My RT-N56U Ltd
organizationalUnitName		= Organizational Unit Name (eg, section)
commonName			= Common Name (eg, YOUR name)
commonName_max			= 64
commonName_default		= $(nvram get http_username)
emailAddress			= Email Address
emailAddress_max		= 64
emailAddress_default		= $(nvram get http_username)@$(nvram get computer_name)
# SET-ex3			= SET extension number 3
[ req_attributes ]
challengePassword		= A challenge password
challengePassword_min		= 4
challengePassword_max		= 20
unstructuredName		= An optional company name
[ usr_cert ]
basicConstraints=CA:FALSE
nsComment			= "OpenSSL Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer:always
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer:always
basicConstraints = CA:true
[ crl_ext ]
authorityKeyIdentifier=keyid:always,issuer:always
[ proxy_cert_ext ]
basicConstraints=CA:FALSE
nsComment			= "OpenSSL Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer:always
proxyCertInfo=critical,language:id-ppl-anyLanguage,pathlen:3,policy:foo
EOF
else
sed -i '/^commonName_max/ a \commonName_default  = '$(nvram get http_username) "${ssldir}/openssl.cnf"
sed -i '/^emailAddress_max/ a \emailAddress_default = '$(nvram get http_username)@$(nvram get computer_name) "${ssldir}/openssl.cnf"
fi

## Create default directory structure according to config
[ -d ./private ]     || { mkdir ./private; chmod 700 ./private; }
[ -d ./crl ]         ||   mkdir ./crl
[ -d ./certs ]       ||   mkdir ./certs
[ -d ./newcerts ]    ||   mkdir ./newcerts
[ -f ./index ]       ||   touch ./index
[ -f ./serial ]      || { touch ./serial ; echo 01 > ./serial ; }
} ## end do_change_cfg()


################################################################################
## reads values for certificate/key and saves them to local file in order not to
## ask user each time he needs do create a certificate/key.
do_get_raw_data()
{
clear

GETVAL=1

echo -e "\033[1m"
cat <<EOF

================================================================================

 You are about to be asked to enter information that will be incorporated
 into your certificate request.

 If you'd like to choose default value, just press 'Enter' (leave field blank).
 If you want a field be blank (contain no data), type '.' and press 'Enter'

================================================================================




EOF
echo -e "\033[0m"


while [ $GETVAL -eq 1 ] ; do

chck_val=1
while [ $chck_val -eq 1 ] ; do
read -p "Enter country name ( 2 letter code ) [ `nvram get wl_country_code` ] : " COUNTRY
COUNTRY=$(echo $COUNTRY | sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/; s/[^A-Z]//g')
[ $(( `echo "$COUNTRY" | wc -m` - 1 )) -eq 2 ] && chck_val=0
[ $(( `echo "$COUNTRY" | wc -m` - 1 )) -eq 0 ] && chck_val=0
[ "$COUNTRY" == "." ] && chck_val=0
done

read -p "Enter province ( some state/region ) [ ] : " PROVINCE
PROVINCE=$(echo $PROVINCE | sed 's/[^\.a-zA-Z0-9_-]//g')

read -p "Enter city [ ] : " CITY
CITY=$(echo $CITY | sed 's/[^\.a-zA-Z0-9_-]//g')

read -p "Enter organization [ `nvram get computer_name` ] : " ORG
ORG=$(echo $ORG | sed 's/[^\.a-zA-Z0-9_-]//g')

read -p "Enter organization unit [ ] : " OU
OU=$(echo $OU | sed 's/[^\.a-zA-Z0-9_-]//g')

chck_val=1
while [ $chck_val -eq 1 ] ; do
read -p "Enter Common Name ( eg, YOUR name ) [ admin ] : " CN
CN=$(echo $CN | sed 's/[^\.a-zA-Z0-9_-]//g')
[ $(( `echo "$CN" | wc -m` - 1 )) -lt 64 ] && chck_val=0
done

chck_val=1
while [ $chck_val -eq 1 ] ; do
read -p "Enter email [ admin@my.router ] : " EMAIL
EMAIL=$(echo $EMAIL | sed 's/[^\.@a-zA-Z0-9_-]//g')
[ $(( `echo "$EMAIL" | wc -m` - 1 )) -lt 64 ] && chck_val=0
done

echo -e "\n"


## Check values
[ -z "$COUNTRY" ]  && COUNTRY="`nvram get wl_country_code`"
[ -z "$PROVINCE" ] && PROVINCE="."
[ -z "$CITY" ]     && CITY="."
[ -z "$ORG" ]      && ORG="`nvram get computer_name`"
[ -z "$OU" ]       && OU="."
[ -z "$CN" ]       && CN="admin"
[ -z "$EMAIL" ]    && EMAIL="admin@my.router"

echo -e "\v"
echo -e "\033[1m"

cat << EOF

------------------------------------------------

Country			${COUNTRY}
Province		${PROVINCE}
City			${CITY}
Organization		${ORG}
Organization unit	${OU}
Common name		${CN}
Email address		${EMAIL}

------------------------------------------------

EOF

echo -e "\033[0m"
echo -e "\n"
## Ask user if settings are correct
REPLY=""
while [ "$REPLY" != "y" -a "$REPLY" != "yes" -a \
	"$REPLY" != "n" -a "$REPLY" != "no" ]; do
        read -p "Are these settings correct? (yes/no) : " REPLY
	REPLY=`echo $REPLY | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
done

[ "$REPLY" == "yes" -o "$REPLY" == "y" ] && GETVAL=0

done

[ -f ca.raw ] || touch ca.raw

cat > ca.raw << EOF
${COUNTRY}
${PROVINCE}
${CITY}
${ORG}
${OU}
${CN}
${EMAIL}
EOF

chmod 600 ca.raw
} ## end get_user_raw_data()

do_create_CA()
{
[ -s ca.raw ] || do_get_raw_data
## Generate CA using previously saved data
echo -en "\v\033[1m [ Generating CA and private key ."
cat ca.raw | openssl req -nodes -days 1095 -x509 \
	-newkey rsa:1024 -outform PEM -out ca.crt > /dev/null 2>&1
##FIXME seems to be a bug
[ -f privkey.pem ] && mv privkey.pem ca.key
[ -f ca.key ] && chmod 600 ca.key # secret file
if [ -f ca.crt ]; then
	chmod 644 ca.crt
	cp -f ca.crt ${dstdir}
fi
echo -e ". done ] \033[0m"
} ## end do_create_CA()


################################################################################
## Creates certificate and private key pair.
do_create_x_509()
{
if [ ! -f ca.raw ] ; then
   echo -e "\v\t\033[1;37;41m It seems CA hasn't been created. \033[0m"
   echo -ne "\t\033[1;37;41m You should run with \"-ca\" or \"-ca-new\" first. "
   echo -e "\033[0m\v"
   exit 1
fi

while [ -z "$CRT_CN" ] ; do
   echo -e "\033[1m\n"
   read -p "Enter Common name (the name of Certificate owner): " CRT_CN
   CRT_CN=$(echo "${CRT_CN}" | sed 's/[ \t]*//g; s/-/_/g; s/[^a-zA-Z0-9_]//g')
   echo -e "\033[0m"
done

echo -en "\033[1m [ Generating ${CRT_CN} key ."
## Generate the private key
openssl genrsa -out ${CRT_CN}.key > /dev/null 2>&1
if [ -f ${CRT_CN}.key ]; then
	chmod 600 ${CRT_CN}.key # secret
	cp -f ${CRT_CN}.key ${dstdir}
fi
echo -e ". done ] \033[0m"

echo -en "\033[1m [ Generating ${CRT_CN} certificate ."
sed '6s/.*/'${CRT_CN}'/' "ca.raw" | sed '$ a .' | sed 8p | \
	openssl req -new -nodes -key ${CRT_CN}.key \
	-out ${CRT_CN}.csr > /dev/null 2>&1

echo -n "."
openssl ca -batch -config ${ssldir}/openssl.cnf -in ${CRT_CN}.csr \
	-out ${CRT_CN}.crt > /dev/null 2>&1
if [ -f ${CRT_CN}.crt ]; then
	chmod 644 ${CRT_CN}.crt
	cp -f ${CRT_CN}.crt ${dstdir}
fi
echo -e ". done ] \033[0m"
} ## end do_create_x_509()


################################################################################
## Extra key
do_antiflud_key()
{
echo -en "\033[1m [ Generating antiflud TLS key ."
openvpn --genkey -config ${ssldir}/openssl.cnf --secret ta.key > /dev/null 2>&1
if [ -f ta.key ]; then
	chmod 600 ta.key #secret 
	cp -f ta.key ${dstdir}
fi
echo -e ". done ] \033[0m"
} ## end do_untiflud_key()


do_DH()
{
echo -e "\033[1m [ Generating Diffie-Hellman key ] \033[0m"
echo -e "\033[1m Please, be patient. This operation requires some time... \n\033[0m"
echo -e "\033[1m -------------------------------------------------------- \n\033[0m"
openssl dhparam -out dh1024.pem 1024
if [ -f dh1024.pem ]; then
	chmod 644 dh1024.pem
	cp -f dh1024.pem ${dstdir}
fi
echo -e "\n"
} ## end do_DH()


################################################################################
## Makes all actions. Is invoked after install.
do_init()
{

[ -d ${keydir} ] && { cd ${keydir}; rm -rf ./* 2>/dev/null; }

## Change openssl config file
do_check_cfg

## Create CA
do_create_CA

## Create certificate and key for router
CRT_CN="server" ; do_create_x_509

## Create certificate and key for router
CRT_CN="client" ; do_create_x_509

unset CRT_CN

## Generate 'extra' antiflud key file
do_antiflud_key

## Generate Diffie-Hellman algorithm
do_DH

echo -e "\v"
} ## end do_init


do__CA()
{
## Change openssl config file
do_change_cfg

## Create CA
do_create_CA
echo -e "\v"
} ## do__CA()




do_help()
{
cat << EOF


Usage: $0 [ param ]

	list of params:

             -init    generates Certificate Authority (CA) and private key file.
                      Also generates certificate and private key for server
                      (eg rt-n56u) and for client.

             -ca      generates Certificate Authority (CA) and private key file.

             -ca-new  removes stored files with user data and generates new CA.

             -x509    creates new x-509 certificate.



EOF
} ## end do_help()

cd ${keydir}

case "$1" in
-init)
	do_init
	;;
-ca)
	do__CA
	;;
-ca-new)
	rm -f ca.raw 2>/dev/null
	do__CA
	;;
-x509)
	do_check_cfg
	do_create_x_509
	echo -e "\v"
	;;
*)
	do_help
	exit 1
	;;
esac

cd ${indir}

exit $?
