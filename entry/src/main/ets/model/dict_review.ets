import { WordCard } from '.';
import { ReviewLog } from '../fsrs';

export interface ReviewDict{
  wordCard: WordCard,
  log: ReviewLog | null
}