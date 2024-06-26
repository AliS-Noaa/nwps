        SUBROUTINE METIS()
        USE PRE_GLOBAL 
C----------------------------------------------------------------------
C  INTERFACE ROUTINE FOR PADCIRC TO USE THE METIS 4.0 LIBRARY 
C  A GRAPH PARTITION TOOL, FOR DOMAIN DECOMPOSITION
C  Version 2.1  vjp  6/7/2006
C  Redimensioned CO_NODES and IDUALS and added bounds test
C  Added check that adjacency matrix is symmetric
C----------------------------------------------------------------------
C
        LOGICAL FOUND, SYMMETRIC
        INTEGER MNED, MNEDLOC, IDUMP
        INTEGER I, J, K, IEL, INODE, JNODE, NCOUNT, ITOT, NEDGETOT
        INTEGER MAXDUALS
        INTEGER  WEIGHTFLAG, NUMFLAG, NPARTS, OPTIONS(5)
        INTEGER  EDGECUT, OPTYPE, NBYTES
C
        INTEGER,ALLOCATABLE :: IDUALS(:,:),ITVECT(:),ITVECT2(:)
        INTEGER,ALLOCATABLE :: XADJ(:), ADJNCY(:)
        INTEGER,ALLOCATABLE :: VWGTS(:), EWGTS(:)
        INTEGER,ALLOCATABLE :: CO_NODES(:,:),NEDGES(:), NEDLOC(:)
        INTEGER,ALLOCATABLE :: NUMDUALS(:)
        EXTERNAL metis_partgraphkway,metis_estimatememory
C
        ALLOCATE ( ITVECT(MNP),ITVECT2(MNP) )
        ALLOCATE ( NUMDUALS(MNP) )
        ALLOCATE ( XADJ(MNP+1), VWGTS(MNP), NEDGES(MNP) ) 
        ALLOCATE ( NEDLOC(MNP) )

C
C--COMPUTE INDEX OF WEIR DUALS WHICH IS ZERO IF NOT A WEIR NODE
C
        DO INODE=1, MNP   
           NUMDUALS(INODE) = 0
        ENDDO
        DO J=1, NWEIR
           NUMDUALS(WEIR(J)) = NUMDUALS(WEIR(J))+1
           NUMDUALS(WEIRD(J)) = NUMDUALS(WEIRD(J))+1
        ENDDO

        MAXDUALS = 0
        DO J=1, MNP    
           IF (NUMDUALS(J) .ge. MAXDUALS) MAXDUALS = NUMDUALS(J)
        ENDDO

        print *, "This model has ",NWEIR," weir node pairs"
        print *, "maximum number duals for any weir node = ", maxduals

        ALLOCATE ( IDUALS(MAXDUALS,MNP) )

        DO INODE=1, MNP   
        DO K=1, MAXDUALS
           IDUALS(K,INODE) = 0
        ENDDO
        ENDDO

        DO J=1, NWEIR
        DO K=1, MAXDUALS
           IF (IDUALS(K,WEIR(J)) == 0) THEN
             IDUALS(K,WEIR(J)) = WEIRD(J)
             EXIT
           ENDIF
        ENDDO
        ENDDO

        DO J=1, NWEIR
        DO K=1, MAXDUALS
           IF (IDUALS(K,WEIRD(J)) == 0) THEN
             IDUALS(K,WEIRD(J)) = WEIR(J)
             EXIT
           ENDIF
        ENDDO
        ENDDO

C-------------------------------------------------------------
C  COMPUTES THE TOTAL NUMBER OF EDGES        -->    MNED
C  AND THE MAX NUMBER OF EDGES FOR ANY NODE  -->    MNEDLOC
C  BOTH COUNTS INCLUDE WEIR-NODE PAIRS
C-------------------------------------------------------------

        MNED = 0
        DO INODE = 1,MNP
           NEDLOC(INODE) = 0
        ENDDO

        DO J=1, 3
           DO IEL=1, MNE  
              INODE = NNEG(J,IEL)
              NCOUNT = NEDLOC(INODE) + 2
              MNED = MNED + 2
              DO K=1, MAXDUALS
                 IF (IDUALS(K,INODE).NE.0) THEN
                   NCOUNT = NCOUNT + 1
                   MNED = MNED + 1
                 ENDIF
              ENDDO
              NEDLOC(INODE) = NCOUNT
           ENDDO
        ENDDO

        MNEDLOC = 0
        DO INODE=1, MNP
           IF (NEDLOC(INODE) .ge. MNEDLOC) MNEDLOC = NEDLOC(INODE)
        ENDDO

c       print *, "total number of edges = ", MNED
        print *, "maximum co-nodes for any node = ", MNEDLOC

        ALLOCATE ( ADJNCY(MNED), EWGTS(MNED) )
        ALLOCATE ( CO_NODES(MNEDLOC,MNP) )
 
C
C--COMPUTE CO_NODES LISTS AND NUMBER OF EDGES CONTAINING A NODE
C
        DO INODE = 1,MNP
           NEDGES(INODE) = 0
        ENDDO
C
        DO IEL=1, MNE  
           INODE = NNEG(1,IEL)
           CO_NODES(NEDGES(INODE)+1,INODE) = NNEG(2,IEL)
           CO_NODES(NEDGES(INODE)+2,INODE) = NNEG(3,IEL)
           NCOUNT = NEDGES(INODE) + 2
           DO K=1, MAXDUALS
              IF (IDUALS(K,INODE).NE.0) THEN
                NCOUNT = NCOUNT + 1
                CO_NODES(NCOUNT,INODE) = IDUALS(K,INODE)
              ENDIF
           ENDDO
           NEDGES(INODE) = NCOUNT
        ENDDO
C
        DO IEL=1, MNE  
           INODE = NNEG(2,IEL)
           CO_NODES(NEDGES(INODE)+1,INODE) = NNEG(3,IEL)
           CO_NODES(NEDGES(INODE)+2,INODE) = NNEG(1,IEL)
           NCOUNT = NEDGES(INODE) + 2
           DO K=1, MAXDUALS
              IF (IDUALS(K,INODE).NE.0) THEN
                NCOUNT = NCOUNT + 1
                CO_NODES(NCOUNT,INODE) = IDUALS(K,INODE)
              ENDIF
           ENDDO
           NEDGES(INODE) = NCOUNT
        ENDDO
C
        DO IEL=1, MNE  
           INODE = NNEG(3,IEL)
           CO_NODES(NEDGES(INODE)+1,INODE) = NNEG(1,IEL)
           CO_NODES(NEDGES(INODE)+2,INODE) = NNEG(2,IEL)
           NCOUNT = NEDGES(INODE) + 2
           DO K=1, MAXDUALS
              IF (IDUALS(K,INODE).NE.0) THEN
                NCOUNT = NCOUNT + 1
                CO_NODES(NCOUNT,INODE) = IDUALS(K,INODE)
              ENDIF
           ENDDO
           NEDGES(INODE) = NCOUNT
        ENDDO
 
C
C  REMOVE REDUNDANCY IN NODE LISTS
C
        NEDGETOT = 0           !  This will be twice number of edges
        DO INODE = 1,MNP   
           DO J=1, NEDGES(INODE)
              ITVECT(J) = CO_NODES(J,INODE)
           ENDDO
           IF (NEDGES(INODE).GT.1) THEN
             NCOUNT = NEDGES(INODE)
             CALL SORT(NCOUNT,ITVECT)
             JNODE = ITVECT(1)
             CO_NODES(1,INODE) = JNODE
             NCOUNT = 1
             DO J=2, NEDGES(INODE)
                IF (ITVECT(J).NE.JNODE) THEN
                  NCOUNT = NCOUNT + 1
                  JNODE = ITVECT(J)
                  CO_NODES(NCOUNT,INODE) = JNODE
                ENDIF
             ENDDO
           ELSE
             print *, "node = ",INODE," is isolated"
             stop 'vic'
           ENDIF
           NEDGES(INODE) = NCOUNT
           NEDGETOT = NEDGETOT + NCOUNT
           if (nedges(inode) == 0) then
             print *, "inode = ", inode, " belongs to no edges"
             stop 'vic'
           endif
        ENDDO
        NEDGETOT = NEDGETOT/2
        print *, "edge count = ",nedgetot

C  check that adjacency matrix is symmetric
C
      SYMMETRIC = .true.
      DO INODE = 1, MNP
      DO J = 1, NEDGES(INODE)
         JNODE = CO_NODES(J,INODE)
         FOUND = .false.
         DO K= 1, NEDGES(JNODE)
            IF (CO_NODES(K,JNODE) == INODE) THEN
              FOUND = .true.
              EXIT
            ENDIF
         ENDDO
         IF (.not. FOUND) THEN
           SYMMETRIC = .false.
      print *, "node ",inode," adjacent to ",jnode," but not visa-versa"
         ENDIF
      ENDDO
      ENDDO
      IF (.not. SYMMETRIC) THEN
         stop 'bad adjacency matrix: not symmetric!'
      ENDIF
C
C  COMPUTE WEIGHTS OF THE GRAPH VERTICES
C
        DO INODE = 1,MNP   
           VWGTS(INODE) = NEDGES(INODE)
        ENDDO
C
C--COMPUTE ADJACENCY LIST OF GRAPH AND ITS EDGE WEIGHTS
C
        XADJ(1) = 1
        ITOT = 0
        DO INODE = 1,MNP
        DO J = 1, NEDGES(INODE)
           ITOT = ITOT + 1
           JNODE = CO_NODES(J,INODE)
           ADJNCY(ITOT) = JNODE
           EWGTS(ITOT)  = (VWGTS(JNODE)+VWGTS(INODE))
        ENDDO
        XADJ(INODE+1) = ITOT+1
        ENDDO
C
C Dump graph to a file for debugging
C
      IDUMP = 1
      IF (IDUMP.EQ.1) THEN
        OPEN(FILE='metis_graph.txt',UNIT=99)
        WRITE(99,100) MNP, NEDGETOT, 11, 1
        DO INODE=1, MNP
           WRITE(99,200) VWGTS(INODE),
     &   (CO_NODES(J,INODE), EWGTS(XADJ(INODE)+J-1),J=1,NEDGES(INODE))
        ENDDO
        CLOSE(99)
      ENDIF

C
C--CALL K-WAY METIS FOR PARTITIONING
C
        NUMFLAG  = 1
        NPARTS = MNPROC
        OPTIONS(1) = 1
        OPTIONS(2) = 3
        OPTIONS(3) = 1
        OPTIONS(4) = 3   !  minimize number of co-domains
        OPTIONS(5) = 0
c
        WEIGHTFLAG = 3   ! use weights for nodes and edges
C
        OPTYPE = 2
        CALL metis_estimatememory(MNP,XADJ,ADJNCY,NUMFLAG,
     &        OPTYPE,NBYTES)
 
        print *, ""
        print *, "Grid Partition Data"
        print *, "METIS 4.0 will require approximately ",nbytes," bytes"
C
        CALL metis_partgraphkway( MNP,XADJ,ADJNCY,VWGTS,EWGTS,
     &      WEIGHTFLAG,NUMFLAG,NPARTS,OPTIONS,EDGECUT,PROC)
C
        print *, "Total Edges Cut = ",EDGECUT 

        print *, "writing mesh partition to file: partmesh.txt"
        OPEN(990,FILE='partmesh.txt')
        DO I=1, MNP
           WRITE(990,*) PROC(I)
        ENDDO
        CLOSE(990)

 100    FORMAT(4I10)
 200    FORMAT(100I10)
C
        RETURN
        END
