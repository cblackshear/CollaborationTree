
# Collaboration Tree

The tree visualizes University of Mississippi Medical Center's educational hierarchy with end node containing the contact person for that department. 
This tree is developed by University of Mississippi Medical Center's Biostatistician Chad Blackshear and Data Scientist Radhikesh Ranadive.

------

## Description
-   The tree is variation of the original [collapsible tree.][]

-   Some of the modifications from the original visualization are making it vertical, adding separation between nodes and adding             zooming in functionality.

-   The data input has to be n+1 column CSV file, where n is the number of hierarchical levels in the tree.

-   Schema of the CSV :
    -   `parent (int/string)`: The parent name of the hierarchical tree, this will be the first node in the hierarchy and is at level 0.
    -   `child_1 (int/string)`: This node is at level 1 contains school name and is the child of parent node.
    -   `child_2 (int/string)`: This node is at level 2 conains department name and is the child of child_1 node.
    -   `child_3 (int/string)`: This node is at level 3 and contains child of child_2 node
    -   `email_id (string)`: Email id of the contact person in the respective department.
    -   `contact_name (string)`: Contact name of the person in the respective department.

-   Following steps are used to convert the CSV file into hierarchical form :
    - Convert the wide data in each row of the CSV file to long format having two columns `level_num` and `node_name`, not including           `contact_name` column from CSV file.
    - Adding a `parent_name` column which will show the parent node at each level.
    - Create a contingency table with `parent_name` and `node_name` and filtering results having frequency >=1.
    - To get the contact name that we left in the first step, we need to merge by `node_name` (contains email_id) in the filtered.             results of contingency table with `email_id` in CSV file (just include `email_id` and `contact_name` columns from CSV file).
    - In merged results, if `node_name` column contains email_id then store it in new column `email_id`.
    - If a `node_name` contains email_id  then replace it with `contact_name`.
    - Finally convert the dataframe into json format using d3_json function from d3r library in R. 
    - Pass the json data into the index.html file.
------

## References
-  [D3 Tree Tutorial][]
-  [Stack overflow][]
    
<!-- external links -->
[collapsible tree.]:https://bl.ocks.org/mbostock/4339083
[D3 Tree Tutorial]: http://www.d3noob.org/2014/01/tree-diagrams-in-d3js_11.html
[Stack overflow]: https://stackoverflow.com/questions/17558649/d3-tree-layout-separation-between-nodes-using-nodesize

