extends XRToolsPickable


func _process(delta):
	pass
	


func action():
	super.action()
	$SpotLight3D.visible = !$SpotLight3D.visible
