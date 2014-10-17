#
#/*=========================================================================+
#|  Copyright (c) 2014 Entrustca, San Salvador, El Salvador                 |
#|                         ALL rights reserved.                             |
#+==========================================================================+
#|                                                                          |
#| FILENAME                                                                 |
#|     XXSV_FA001_00007.sh                                                  |
#|                                                                          |
#| DESCRIPTION                                                              |
#|    Shell Script para la instalacion de parches - Proyecto TIGO           |
#|                                                                          |
#| SOURCE CONTROL                                                           |
#|    Version: %I%                                                          |
#|    Fecha  : %E% %U%                                                      |
#|                                                                          |
#| HISTORY                                                                  |
#|    13-06-2014  jonathan Ulloa   Created   Entrustca                      |
#|    22-09-2014  Carlos Torres    Modify    Entrustca                      |
#|    30-09-2014  jonathan ulloa   Modify    Entrustca                      |
#|    06-10-2014  jonathan Ulloa   Modify    Entrustca                      |
#+==========================================================================*/


echo ''
echo '                          Oracle LAD eStudio                          '
echo '           Copyright (c) 2012 Entrust San Salvador, El Salvador        '
echo '                        All rights reserved.                          '
echo 'Starting installation process for patch XXSV_FA001_00007'
echo

# FUNCIONES
read_db_pwd ()
{
    stty -echo # Deshabilito el ECO del Tecladof

    PASSWORD_OK="No"

    while [ "${PASSWORD_OK}" != "Yes" ]
    do
        # Leo la contrasea del usuario de BD
        DB_PASS='' # Inicializo la Variable de Retorno

        while [ -z "${DB_PASS}" ]
        do
            echo -n "Please enter password for $1 user: "
            read DB_PASS
            echo
        
            if [ -z "${DB_PASS}" ]
            then
                echo "The password entered is null."
            fi

        done

        sqlplus -S /nolog <<EOF
whenever sqlerror exit 1
whenever oserror exit 1
conn $1/$DB_PASS
EOF

        if [ "$?" != "0" ]
        then
            echo "The $1 password entered is incorrect."
        else
            PASSWORD_OK="Yes"
        fi
    done

    stty echo # Rehabilito el ECO del Teclado
}

copy_file ()
{
    if [ -f $1/$3 ]
    then
        if [ -f $2/$3 ]
        then
            mv $2/$3 $2/$3_bak$(date +%Y%m%d%H%M%S)
        fi

        cp $1/$3 $2/
    else
        echo "File $1/$3 does not exist"
    fi
}

# COMIENZO DE INSTALACION DEL PARCHE



# Ingreso de la contrasea para el usuario APPS. Usar funcion read_db_pwd $user
read_db_pwd "APPS"
APPS_PASS=$DB_PASS

# Ingreso de la contrasea para el usuario BOLINF. Usar funcion read_db_pwd $user
read_db_pwd "BOLINF"
BOLINF_PASS=$DB_PASS

# Copia de los Objetos. Usar funcion copy_file $origen $destino $file
#echo 'Copying objects SQL to $XBOL_TOP'


# Copia de los Imports
#echo 'Copying objects LDT to $XBOL_TOP'

#copy_file xbol/admin/import $XBOL_TOP/admin/import XX_AR_REPCAJ_RES.ldt
#copy_file xbol/admin/import $XBOL_TOP/admin/import Receivables_All.ldt
#copy_file xbol/admin/import $XBOL_TOP/admin/import XX_AR_REPCAJ_RES_TMPL.ldt
#copia los  rdfs

#copy_file au/reports $XBOL_TOP/reports/ESA  XX_AP002F930.rdf

# Compilacion de Scripts
#echo 'Compiling Scripts'
#sqlplus bolinf/$BOLINF_PASS @xbol/sql/XX_AH_GET_CCID_USES.sql

echo '------------------------------------------------------------'
echo 'Compiling package spec XXSV_PO_REPORT_UTL.pks'
sqlplus bolinf/$BOLINF_PASS @xbol/sql/XXSV_PO_REPORT_UTL.pks
echo '------------------------------------------------------------'
echo 'Compiling package body XXSV_PO_REPORT_UTL.pkb'
sqlplus bolinf/$BOLINF_PASS @xbol/sql/XXSV_PO_REPORT_UTL.pkb
echo '------------------------------------------------------------'
echo 'Creating View XXSV_P2P_V.pkb'
sqlplus bolinf/$BOLINF_PASS @xbol/sql/XXSV_P2P_V.sql
echo '------------------------------------------------------------'
echo 'Grants from Bolinf grant_bolinf.sql'
sqlplus bolinf/$BOLINF_PASS @xbol/sql/grant_bolinf.sql
echo '------------------------------------------------------------'
echo 'Public synonyms synonym_apps.sql'
sqlplus apps/$APPS_PASS @xbol/sql/synonym_apps.sql


#sqlplus bolinf/$BOLINF_PASS @xbol/sql/grants.sql
# En apps
#sqlplus apps/$APPS_PASS @xbol/sql/indexs.sql
#sqlplus apps/$APPS_PASS @xbol/sql/synonyms.sql

    
cd ..
cd ..
echo '+----------------------------------------------------------+'
echo '|                                                          |'
echo '|      Installation Complete. Please check log files       |'
echo '|                                                          |'
echo '+----------------------------------------------------------+'

