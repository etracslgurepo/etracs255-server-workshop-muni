[deleteAllHeaders]
DELETE FROM image_header WHERE refid = $P{refid}

[deleteAllItems]
DELETE FROM image_chunk 
WHERE parentid IN (
	SELECT objid FROM image_header WHERE refid = $P{refid} 
)

[getImages]	
SELECT * FROM image_header WHERE refid = $P{refid} ORDER BY title 


[getItems]	
SELECT * FROM image_chunk WHERE parentid = $P{objid} ORDER BY fileno

[deleteItems]
DELETE FROM image_chunk WHERE parentid = $P{objid}




[insertPreviousSketch]
insert into image_header(
	objid, refid, title, filesize, extension
)
select 
	$P{newrefid} as objid, 
	$P{newrefid} as refid, 
	title, 
	filesize, 
	extension
from image_header 
where refid = $P{prevrefid}
and title = 'SKETCH'


[insertPreviousSketchItems]
insert into image_chunk(
	objid, parentid, fileno, byte
)
select 
	concat(objid, '-', $P{ry}) as objid, 
	$P{newrefid} as parentid, 
	fileno,
	byte 
from image_chunk 
where parentid = $P{prevrefid}
