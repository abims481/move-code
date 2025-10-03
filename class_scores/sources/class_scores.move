#[allow(unused_field, duplicate_alias)]
module class_scores::class_scores{
    //This is the code for a class score table in a 10 subjects
    use std::string::String; //this is used to import a string
    use sui::transfer; //this is used to import the transfer module

    #[error]
    const EInvalidScore: u64 = 1; 
    //this error means that the score is invalid
    #[error]
    const EInvalidSubjectsLength: u64 = 2; 
    //this means that the subjects scores provided for the student is invalid: greater than or less than ten

    public struct Student has key, store{
        id: UID,
        name: String,
        scores: vector<u8>,
        address: address,
        level: u8,
        gpa: u8,
    }//this sturct stores the metadata of a student

    public struct TeacherCap has key{
        id: UID
    }

    fun init(
        ctx: &mut TxContext
    ){
        let teacher_cap = TeacherCap{
            id: object::new(ctx)
        };
        transfer::transfer(teacher_cap, ctx.sender());
    }

    public fun create_student(
        ctx: &mut TxContext,
        _teacher_cap: &TeacherCap,
        name: String,
        address: address,
        level: u8
    ): Student{
        let mut student_scores = vector::empty();//we created a vector that is empty []
        let mut num = 0;//this symbolizes the first subject score index
        let subject_size = 10;//every student offers 10 courses
        while(num < subject_size){
            vector::push_back(&mut student_scores, 0);
            num = num + 1;
        };
        let new_student = Student{
            id: object::new(ctx),
            name,
            scores: student_scores,//we chnaged this from score to scores
            address,
            level,
            gpa: 0, //initially the gpa is 0
        };
        new_student //this returns the new student
    }
    
    public fun add_student_scores(//this was changed from add_student_score to add_student_scores
        _teacher_cap: &TeacherCap,
        student: &mut Student,
        new_scores: vector<u8>
    ){
        assert!(vector::length(&new_scores) == 10, EInvalidSubjectsLength); //fastest
        /* This method checks for both greater and less length in two lines
        * assert!(vector::length(new_scores) > 10, 2);//this one is checking if the number of scores put in is greater than 10
        * assert!(vector::length(new_scores) < 10, 3);//this one is checking if the number of scores put in is less than 10  
        */
        /*
        * if(vector::length(new_scores) > 10 || vector::length(new_score) < 10){
            abort EScoreLengthInvalid
            //we can define the error as : const EScoreLengthInvalid = 1000;
            }
        */      
        let subjects_len = 10;
        let mut i = 0;
        while(i < subjects_len){
            assert!(*vector::borrow(&new_scores, i) <= 100, EInvalidScore);
            //sui uses fail fast which is assert! in move
            i = i + 1;
        };
        //assert!(condition, error_code);
        //this line means that if the condition is false, the program will abort with error code 1

        //add student scores through looping
        let mut student_new_scores = vector::empty();//a new vector to store the student scores
        let mut i = 0;
        let length = vector::length(&new_scores);
        while(i < length){
            vector::push_back(&mut student_new_scores, *vector::borrow(&new_scores, i));
            i = i + 1;
        };
        student.scores = student_new_scores;
    }

    public fun calculate_gpa(
        _teacher_cap: &TeacherCap, //we want to make sure only the teacher can calculate the gpa
        student: &mut Student //we need to make the student mutable because we are going to update the gpa
    ): u8{
        let total_units = 30;
        let mut total_score = 0;
        let each_course_unit = 3; //each course has 3 units

        let mut i = 0; //this is the initial index
        let subjects_len = 10; //this is the length of the subjects vector
        while(i < subjects_len){
            //the total score is the grade equivialent multiplied by the course unit
            let grade_equivalent = get_grade_equivalent(*vector::borrow(&student.scores, i));
            total_score = total_score + (grade_equivalent * each_course_unit);
            i = i + 1;
        };
        let gpa = total_score / total_units; //this is the gpa calculation
        student.gpa = gpa; //we update the student's gpa
        gpa //this returns the gpa
    }

    public fun get_grade_equivalent(
        score: u8
    ): u8{
        if(score >= 70){
            5 //this is the grade equivalent for a score of 70 and above
        }else if(score >= 60){
            4 //this is the grade equivalent for a score of 60 to 69
        }else if(score >= 50){
            3 //this is the grade equivalent for a score of 50 to 59
        }else if(score >= 45){
            2 //this is the grade equivalent for a score of 45 to 49
        }else if(score >= 40){
            1 //this is the grade equivalent for a score of 40 to 44
        }else{
            0 //this is the grade equivalent for a score of less than 40
        }
    }

    public fun get_student_scores(
        student: &Student
    ): vector<u8>{
        student.scores
        //this is returning the students score
    }

    public fun get_student_level(
        student: &Student
    ): u8{
        student.level
        //this is returning the students level
    }

    public fun get_student(
        student: &Student
    ): String{
        student.name
        //this is returning the students name
    }

    public fun delete_student(
        _teacher_cap: &TeacherCap,
        student: Student
    ){
        let Student{id, name: _, scores: _, address: _, level: _, gpa: _} = student;
        object::delete(id);
        //this function deletes the student record
        //by not moving it anywhere, it will be deleted when the function ends
    }

}