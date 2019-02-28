(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (packing-location ?l) (not(available ?l)) (ships ?s ?o) (not(complete ?s)))
      :effect (and (complete ?s) (available ?l) (not(packing-at ?s ?l)) (not (started ?s)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?li - location ?lf - location)
      :precondition (and (free ?r) (connected ?li ?lf) (no-robot ?lf) (at ?r ?li))
      :effect (and (at ?r ?lf) (no-robot ?li) (not (at ?r ?li)) (not(no-robot ?lf)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?r - robot ?li - location ?lf - location ?p - pallette)
      :precondition (and (connected ?li ?lf) (at ?p ?li) (at ?r ?li) (no-robot ?lf) (no-pallette ?lf))
      :effect (and (has ?r ?p) (no-robot ?li) (no-pallette ?li) (not(no-pallette ?lf)) (not(at ?p ?li)) (not(at ?r ?li)) (at ?r ?lf) (at ?p ?lf))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?s - shipment ?o - order ?l - location ?i - saleitem ?p - pallette)
      :precondition (and (at ?p ?l) (contains ?p ?i) (not(includes ?s ?i)) (packing-location ?l) (packing-at ?s ?l))
      :effect (and (not(contains ?p ?i)) (includes ?s ?i))
   )
   
   

)