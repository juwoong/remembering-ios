//
//  ModelConsts.swift
//  remembering
//
//  Created by 배주웅 on 1/17/25.
//

enum LearningChoice: Int {
    case AGAIN = 0
    case HARD = 1
    case GOOD = 2
    case EASY = 3
}

enum LearningPhase: Int {
    case NEW = 0
    case LEARN = 1
    case EXPONENTIAL = 2
    case RELEARN = 3
}

enum ScheduleState: Int {
    case NOT_STARTED = 0
    case IN_PROGRESS = 1
    case FINISHED = 2
}
