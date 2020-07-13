<?php

namespace App\Http\Controllers;

use App\User;
use App\Events\MessageSent;
use App\Events\GreetingSent;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function showChat()
    {
        return view('chat.show');
    }

    public function messageRecived(Request $request)
    {
        $rules = [
            'message' => 'required',
        ];

        $request->validate($rules);

        \broadcast(new MessageSent($request->user(), $request->message));
        
        return \response()->json('Message broadcasted');
    }
    
    public function greetRecived(Request $request, User $userGreeted)
    {
        //Current user is $request->user(). $userGreeted is the user that I have greeted

        //This message appears on the view of the user that I have greeted. Not on the view of the user that have made the action
        //I broadcast on a private channel of the user greeted
        \broadcast(new GreetingSent($userGreeted, "{$request->user()->name} greeted you"));

        //This message appears on the view of the user that made the action
        //I broadacast on a private channel of the current login user
        \broadcast(new GreetingSent($request->user(), "You greeted {$userGreeted->name}"));

        return "Greeting {$userGreeted->name} from {$request->user()->name}";
    }
}
