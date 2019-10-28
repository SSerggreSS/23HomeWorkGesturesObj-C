//
//  ViewController.m
//  23HomeWorkGesturesObj-C
//
//  Created by Сергей on 23.10.2019.
//  Copyright © 2019 Sergei. All rights reserved.
//

#pragma mark - Task

//Ученик✅
//
//1. Добавьте квадратную картинку на вьюху вашего контроллера
//2. Если хотите, можете сделать ее анимированной
//
//Студент✅
//
//3. По тачу анимационно передвигайте картинку с ее позиции в позицию тача
//4. Если я вдруг делаю тач во время анимации, то картинка должна двигаться в новую точку без рывка (как будто она едет себе и все)
//
//Мастер✅
//
//5. Если я делаю свайп вправо, то давайте картинке анимацию поворота по часовой стрелке на 360 градусов
//6. То же самое для свайпа влево, только анимация должна быть против часовой (не забудьте остановить предыдущее кручение)
//7. По двойному тапу двух пальцев останавливайте анимацию
//
//Супермен ✅
//
//8. Добавьте возможность зумить и отдалять картинку используя пинч
//9. Добавьте возможность поворачивать картинку используя ротейшн


#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *testImageView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightSwipeGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *leftSwipeGesture;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapDoubleTouch;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGesture;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationGesture;

@property (strong, nonatomic) CABasicAnimation *animation;
@property (assign, nonatomic) CGFloat testViewRotation;
@property (assign, nonatomic) CGFloat testViewScale;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.view.multipleTouchEnabled = YES;
    [self.testImageView setUserInteractionEnabled:YES];
    
    self.testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100.0,
                                                                       CGRectGetMidY(self.view.bounds) - 100.0,
                                                                       200.0, 200.0)];
    

    
    //self.testImageView.backgroundColor = [UIColor redColor];
    /*
    self.testImageView.animationImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"1humanWalk.png"],
                                                                          [UIImage imageNamed:@"2humanWalk.png"],
                                                                          [UIImage imageNamed:@"3humanWalk.png"],
                                                                          [UIImage imageNamed:@"4humanWalk.png"],
                                                                          [UIImage imageNamed:@"5humanWalk.png"],
                                                                          [UIImage imageNamed:@"6humanWalk.png"],
                                                                          [UIImage imageNamed:@"7humanWalk.png"], nil];
     */
    
    self.testImageView.image = [UIImage imageNamed:@"spinner.png"];
    
    self.testImageView.animationDuration = 3;
    
    [self.testImageView startAnimating];
    
    [self.view addSubview:self.testImageView];
 
#pragma mark - Tap
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    [self.view addGestureRecognizer:self.tapGesture];
    
#pragma mark - Swipe
    
    self.rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    self.rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.rightSwipeGesture];
    
    self.leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    self.leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftSwipeGesture];
    
    self.doubleTapDoubleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlDoubleTapDoubleTouch:)];
    self.doubleTapDoubleTouch.numberOfTapsRequired = 2;
    self.doubleTapDoubleTouch.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:self.doubleTapDoubleTouch];
    
    [self.tapGesture requireGestureRecognizerToFail:self.doubleTapDoubleTouch];
    
#pragma mark - Pinch
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    self.pinchGesture.delegate = self;
    
    [self.view addGestureRecognizer:self.pinchGesture];
    
#pragma mark - Rotation
    
    self.rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    self.rotationGesture.delegate = self;
    
    [self.view addGestureRecognizer:self.rotationGesture];
}

#pragma mark - Methods

-(void)handleTap:(UIGestureRecognizer *)tapGestures {
    NSLog(@"handleTap");
    CGPoint pointLocation = [tapGestures locationInView:self.view];

    [UIView animateWithDuration:3.f animations:^{

        self.testImageView.center = pointLocation;

    }];
    
}

-(void)handleRightSwipe:(UIGestureRecognizer *)rightSwipeGesture {
    NSLog(@"handleRightSwipe");
    
    [self.testImageView.layer removeAnimationForKey:@"rotationLeftAnimation"];

    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        self.testImageView.transform = CGAffineTransformIdentity;
        self.animation = [self spinAnimationWithDuration:0.3 clockwise:YES repeat:YES];
        [self.testImageView.layer addAnimation:self.animation forKey:@"rotationRightAnimation"];
        
    } completion:^(BOOL finished) {

        NSLog(@"Finished flag = %i", finished);

        }];
}

-(void)handleLeftSwipe:(UIGestureRecognizer *)leftSwipeGesture {
    NSLog(@"handleLeftSwipe");
    
        [self.testImageView.layer removeAnimationForKey:@"rotationRightAnimation"];

        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            self.testImageView.transform = CGAffineTransformIdentity;
            self.animation = [self spinAnimationWithDuration:0.3 clockwise:NO repeat:YES];
            [self.testImageView.layer addAnimation:self.animation forKey:@"rotationLeftAnimation"];

        } completion:^(BOOL finished) {

            NSLog(@"Finished flag = %i", finished);

        }];

}

-(void)handlDoubleTapDoubleTouch:(UITapGestureRecognizer *)doubleTapDoubleTouch {
    NSLog(@"handlDoubleTapDoubleTouch");
    
    [self.testImageView.layer removeAnimationForKey:@"rotationRightAnimation"];
    [self.testImageView.layer removeAnimationForKey:@"rotationLeftAnimation"];
    
    
}

-(void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture {
    NSLog(@"handlePinch:");
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        
        self.testViewScale = 1.f;
        
    }
    
    CGFloat newScale = 1.f + pinchGesture.scale - self.testViewScale;
    CGAffineTransform currentTransform = self.testImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    
    self.testImageView.transform = newTransform;
    
    self.testViewScale = pinchGesture.scale;
    
}

-(void)handleRotationGesture:(UIRotationGestureRecognizer *)rotatGesture {
    
    NSLog(@"handleRotationGesture:");
    
    if (rotatGesture.state == UIGestureRecognizerStateBegan) {
        
        self.testViewRotation = 0;
        
    }
    
    CGFloat newRotation = rotatGesture.rotation - self.testViewRotation;
    
    CGAffineTransform currentTransform = self.testImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, newRotation);

    self.testImageView.transform = newTransform;
    
    self.testViewRotation = rotatGesture.rotation;
}


#pragma mark - Methods animation

- (CABasicAnimation *)spinAnimationWithDuration:(CGFloat)duration clockwise:(BOOL)clockwise repeat:(BOOL)repeats {
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.toValue = clockwise ? @(M_PI * 2.0) : @(M_PI * -2.0);
    anim.duration = duration;
    anim.cumulative = YES;
    anim.repeatCount = repeats ? CGFLOAT_MAX : 0;
    
    return anim;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   
    
    return YES;
}

@end

