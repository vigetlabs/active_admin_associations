# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    title "My Great Post"
    body %q{"Keep back!" said several. The crowd swayed a little, and I elbowed my way through.  Every one seemed greatly excited.  I heard a peculiar humming sound from the pit. "I say!" said Ogilvy; "help keep these idiots back.  We don't know what's in the confounded thing, you know!" I saw a young man, a shop assistant in Woking I believe he was, standing on the cylinder and trying to scramble out of the hole again. The crowd had pushed him in. The end of the cylinder was being screwed out from within.  Nearly two feet of shining screw projected.  Somebody blundered against me, and I narrowly missed being pitched onto the top of the screw.  I turned, and as I did so the screw must have come out, for the lid of the cylinder fell upon the gravel with a ringing concussion.  I stuck my elbow into the person behind me, and turned my head towards the Thing again.  For a moment that circular cavity seemed perfectly black. I had the sunset in my eyes. I think everyone expected to see a man emerge--possibly something a little unlike us terrestrial men, but in}
    published_at 2.days.from_now
    featured false
    association :creator, :factory => :user
  end
end
