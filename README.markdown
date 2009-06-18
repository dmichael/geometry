geometry + xml
==============

This program, run from the command line, takes a single argument which is a local path to an XML file. If none is provided, the one in the test folder is used. An assumption has been made that it is well formed.

The program can be run by calling the following. 

    $ ruby geometry_and_xml.rb test/geometry.xml
    
Run the tests with the following command.

    $ rake test
    
This is an example XML file

    <?xml version="1.0""?> 
    <geometry>  
      <shape id="shape1"> 
        <point x="0" y="0"/> 
        <point x="10" y="0"/> 
        <point x="10" y="10"/> 
        <point x="0" y="10"/>  
      </shape> 
    </geometry>  
