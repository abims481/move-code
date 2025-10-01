module class_scores::class_scores{
    //This is the code for a class score table in a single subject
    use std::String;
    use std::vector;

    const EInvalidScore: u64 = 1;

    public struct Student has key, store{
        id: UID,
        name: String,
        score: u8,
        address: address,
        level: u8,
    }

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
        let new _student = Student{
            id: ctx(new),
            name,
            score: 0,
            address,
            level,
        };
        public_transfer(new_student, address);
        vector::push_back(&mut students, new_student);
        new_student
    }
    
    public fun add_student_score(
        _: &TeacherCap,
        student: &mut Student,
        new_score: u8
    ){
        assert!(score <= 100, 1);
        //assert!(condition, error_code);
        //this line means that if the condition is false, the program will abort with error code 1
        
        let new_student = Student{
            id: student.id,
            name: student.name.clone(),
            score: new_score,
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