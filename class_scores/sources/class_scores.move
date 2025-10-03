module class_scores::class_scores{
    //This is the code for a class score table in a 10 subjects
    use std::String; //this is used to import a string
    use std::vector; //this is used to import a vector
    use sui::error; //this is used to import the error module

    const EInvalidScore: u8 = 1; 
    //this error means that the score is invalid
    const EInvalidSubjectsLength: u8 = 2; 
    //this means that the subjects scores provided for the student is invalid: greater than or less than ten

    public struct Student has key, store{
        id: UID,
        name: String,
        scores: vector<u8>,
        address: address,
        level: u8,
    }//this sturct stores the metadata of a student

    let students: vector<Student>;//this is a vector to hold all students

    public struct Teacher has key, store{
        id: UID,
        name: String,
        address: address,
        subject: String,
    }

    public struct TeacherCap has key{
        id: UID
    }

    public init(
        ctx: &mut TxContext,
        name: String,
        subject: String,
        address: address
    ): TeacherCap{
        let new_teacher = Teacher{
            id: ctx(new),
            name,
            address,
            subject,
        }
        public_transfer(new_teacher, address);
        TeacherCap{id: new_teacher.id};
    }

    public fun create_student(
        ctx: &mut TxContext,
        _: &TeacherCap,
        name: String,
        address: address,
        level: u8
    ): Student{
        let mut student_scores = vector::empty();//we created a vector that is empty
        let num = 0;//this symbolizes the first subject score
        let subject_size = 10;//every student offers 10 courses
        while(num < subject_size){
            vector::push_back(&mut student_scores, 0);
            num = num + 1;
        }
        let new _student = Student{
            id: ctx(new),
            name,
            scores: student_scores,//we chnaged this from score to scores
            address,
            level,
        };
        public_transfer(new_student, address);
        vector::push_back(&mut students, new_student);
        new_student
    }
    
    public fun add_student_scores(//this was changed from add_student_score to add_student_scores
        _: &TeacherCap,
        student: &mut Student,
        new_scores: vector<u8>
    ){
        assert!(vector::length(new_scores) != 10, EInvalidSubjectsLength);
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
        let i = 0;
        while(i < subjects_len){
            assert!(vector::borrow(new_scores, i) <= 100, EInvalidScore);
            i = i + 1;
        }
        //assert!(condition, error_code);
        //this line means that if the condition is false, the program will abort with error code 1

        //add student scores through looping
        let student_new_scores = vector::empty();//a new vector to store the student scores
        let i = 0;
        while(i < length){
            vector::push_back(student_new_scores, vector::borrow(new_scores, i));
            i = i + 1;
        }
        //created a new student
        let new_student = Student{
            id: student.id,
            name: student.name.clone(),
            scores: student_new_scores,
            address: student.address,
            level: student.level,
        }
        move_to(&student.address, new_student);
        vector::remove_item(&mut students, student);
        vector::push_back(&mut students, new_student);
        //move the updated student back to the student's address
    }

    public fun get_student_score(
        student: &Student
    ): u8{
        student.score
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
        student.name.clone()
        //this is returning the students name
    }

    public fun delete_student(
        _: &TeacherCap,
        student: Student
    ){
        let i = 0;
        while(i < vector::length(&students) - 1){
            if(vector::borrow(&students, i).id == student.id){
                vector::remove(&mut students, i);
                break;
            }
            i = i + 1;
        }
        //this function deletes the student record
        //by not moving it anywhere, it will be deleted when the function ends
    }

}