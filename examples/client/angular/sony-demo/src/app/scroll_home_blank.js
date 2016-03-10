node7 = true;

function graphicsb_data3()
{


    /*---------------------------------------------
    Scroll Bar Images
    ---------------------------------------------*/


	this.up_button = "/assets/images/sb3_up.gif";                                          //image path and name only
	this.up_button_roll = "/assets/images/sb3_up_roll.gif";                                //image path and name only
	this.down_button = "/assets/images/sb3_down.gif";                                      //image path and name only
	this.down_button_roll = "/assets/images/sb3_down_roll.gif";                            //image path and name only


	this.slider_tile_bg_style = "background-image:url(/assets/images/sb3_slider_bg.gif);";  //image defined as CSS style


	this.bubble_top_cap = "/assets/images/sb3_bubble_topcap.gif,2";                        //image path and name, height - (width is automatically set to scroll bar width)
	this.bubble_bottom_cap = "/assets/images/sb3_bubble_bottomcap.gif,2";                  //image path and name, height - ""
	this.bubble_center = "/assets/images/sb3_bubble_center.gif,7";                         //image path and name, height - ""
	this.bubble_tile_bg_style = "/assets/images/sb3_bubble_bg.gif";                        //image path and name only





    /*---------------------------------------------
    Scroll Bar Container and Content
    ---------------------------------------------*/


	this.container_width = 1;
	this.container_height = 1;

	this.container_bg_color = "";



	this.content_padding = 0;
	this.content_styles = "font-family:Verdana;font-weight:normal;font-size:10px;";
	this.content_class_name = "";




    /*---------------------------------------------
    Scroll Bar Behaviour and Width
    ---------------------------------------------*/


	this.scroll_bar_width = 1;                     //The width of the bar in pixels.
	this.scroll_increment = 1;                     //The distance to scroll when clicking the up or down buttons.


	this.allow_hover_scroll = false;                //Auto scroll while hovering over top and bottom buttons.
	this.hover_scroll_delay = 1;                   //Milliseconds (1/1000 second)


	this.use_hand_cursor = false;




}