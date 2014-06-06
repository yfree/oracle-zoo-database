# Zoo Database 
## IS-410 Oracle Database Project
by Yaakov Freedman

### Overview
This database's primary functionality is the relationship between employees, 
supplies, and the animals. This includes tracking supplies, tracking animal 
needs, and generating which employees are responsible for each animal need. 
These needs are categorized as non-medical and medical. Most of these 
needs can be ordered into a daily schedule, such as receiving food or medicine.
However, specific medical needs that arise cannot be scheduled as a daily task 
and therefore a ticket system is set up for medical personnel to respond to 
such issues.

### Limitations: 
In a real zoo, animals are not necessarily fed on a daily schedule.
This database is modelled on the assumption that animals receive the same 
rations on a daily basis and a more elaborate feeding schedule is beyond the scope of this 
project.

Likewise, employees are assumed to have the same daily schedules throughout the 
week. However, employees can have different responsibilities for 
different shifts.

This database can be expanded to work with a weekly or monthly schedule if needed.

## Privilege requirements:
connect, resource, create view 
