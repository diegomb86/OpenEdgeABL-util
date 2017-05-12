USING Progress.Lang.*.    

CLASS erp.util.ArrayList.
    
    DEFINE PRIVATE PROPERTY iQt AS INTEGER NO-UNDO
        PRIVATE GET.
        PRIVATE SET.
    
    DEFINE PRIVATE PROPERTY lastSeq AS INTEGER NO-UNDO
        PRIVATE GET.
        PRIVATE SET.

    DEFINE PRIVATE TEMP-TABLE ttObj
        FIELD ref AS CHARACTER
        FIELD idx AS INTEGER
        FIELD obj AS Object
        INDEX idxPrim AS PRIMARY UNIQUE idx
        INDEX idxRef ref.

    CONSTRUCTOR PUBLIC ArrayList ():

    END CONSTRUCTOR.
    
    CONSTRUCTOR PUBLIC ArrayList (INPUT obj_ AS Object):
        THIS-OBJECT:add(obj_).
    END CONSTRUCTOR.

    METHOD PUBLIC LOGICAL add (INPUT obj_ AS Object):

        CREATE ttObj.
        ASSIGN 
            THIS-OBJECT:iQt     = THIS-OBJECT:iQt + 1
            ttObj.idx           = lastSeq + 1
            THIS-OBJECT:lastSeq = ttObj.idx
            ttObj.obj           = obj_.

        RETURN TRUE.

    END METHOD.

    METHOD PUBLIC LOGICAL add (INPUT referencia AS CHAR, INPUT obj_ AS Object):

        THIS-OBJECT:add(obj_).
        ASSIGN ttObj.ref = referencia.    
        
        RETURN TRUE.

    END METHOD.

    METHOD PUBLIC LOGICAL add (INPUT idx_ AS INTEGER ,INPUT obj_ AS Object):

        IF  CAN-FIND( FIRST ttObj WHERE
            ttObj.idx = idx_ ) THEN
            RETURN FALSE.

        CREATE ttObj.
        ASSIGN 
            THIS-OBJECT:iQt     = THIS-OBJECT:iQt + 1
            ttObj.idx           = idx_
            THIS-OBJECT:lastSeq = ttObj.idx
            ttObj.obj           = obj_.

        RETURN TRUE.

    END METHOD.

    METHOD PUBLIC LOGICAL addAll (objList AS Object):
        /*Appends all of the elements in the specified collection to
          the end of this list, in the order that they are returned
          by the specified collection's Iterator. */

        DEF VAR idx_ AS INTEGER NO-UNDO.    
        
        DO ON ERROR UNDO, LEAVE:
        
            REPEAT idx_ = 1 TO CAST(objList,"erp.util.ArrayList"):size():
    
                CREATE ttObj.
                ASSIGN
                    THIS-OBJECT:iQt     = THIS-OBJECT:iQt + 1
                    ttObj.idx           = THIS-OBJECT:lastSeq + 1
                    THIS-OBJECT:lastSeq = ttObj.idx
                    ttObj.obj           = CAST(objList,"erp.util.ArrayList"):get(idx_).
    
            END.
    
            CATCH oneError AS Progress.Lang.ProError:    
                UNDO, RETURN FALSE.
            END CATCH.

        END.

        RETURN TRUE.

    END METHOD.
    
    METHOD PUBLIC VOID clear ():
        
        /* Elimina todas as eferencias de objetos */
        FOR EACH ttObj.
            IF VALID-OBJECT(ttObj.obj) THEN
                DELETE OBJECT ttObj.obj.
            DELETE ttObj.
        END.

        /*EMPTY TEMP-TABLE ttObj.*/
        THIS-OBJECT:iQt = 0.

    END METHOD.
    
    METHOD PUBLIC LOGICAL contains (ref_ AS CHAR):
        RETURN CAN-FIND(FIRST ttObj WHERE ttObj.ref = ref_).
    END METHOD.

    METHOD PUBLIC LOGICAL contains (obj_ AS Object):
        RETURN CAN-FIND(FIRST ttObj WHERE ttObj.obj = obj_).
    END METHOD.

    METHOD PUBLIC LOGICAL contains (idx_ AS INTEGER):
        RETURN CAN-FIND(FIRST ttObj WHERE ttObj.idx = idx_).
    END METHOD.

    METHOD PUBLIC Object get (idx_ AS INTEGER):

        FIND FIRST ttObj WHERE
            ttObj.idx = idx_ NO-ERROR.
        IF AVAIL ttObj THEN
            RETURN ttObj.obj.
        
    END METHOD.

    METHOD PUBLIC INTEGER indexOf (obj_ AS Object):
        FOR FIRST ttObj WHERE
            ttObj.obj = obj_.
            RETURN ttObj.idx.
        END.
    END METHOD.

    METHOD PUBLIC LOGICAL isEmpty ():
        
        RETURN NOT CAN-FIND(FIRST ttObj).

    END METHOD.

    METHOD PUBLIC VOID remove (idx_ AS INTEGER):
        FOR FIRST ttObj WHERE
            ttObj.idx = idx_.
            DELETE ttObj.
            THIS-OBJECT:iQt = THIS-OBJECT:iQt - 1.
        END.
    END METHOD.

    METHOD PUBLIC VOID remove (obj_ AS Object):
        FOR FIRST ttObj WHERE
            ttObj.obj = obj_.
            DELETE ttObj.
            THIS-OBJECT:iQt = THIS-OBJECT:iQt - 1.
        END.
    END METHOD.

    METHOD PUBLIC INT size ():
        RETURN THIS-OBJECT:iQt.
    END METHOD.

    DESTRUCTOR PUBLIC ArrayList ().
        THIS-OBJECT:clear().
    END DESTRUCTOR.

END CLASS.
