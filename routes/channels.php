<?php

use Illuminate\Support\Facades\Broadcast;

/*
|--------------------------------------------------------------------------
| Broadcast Channels
|--------------------------------------------------------------------------
|
| Here you may register all of the event broadcasting channels that your
| application supports. The given channel authorization callbacks are
| used to check if an authenticated user can listen to the channel.
|
*/

Broadcast::channel('App.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

/**
 * Verify if user has been logged in 
 */
Broadcast::channel('notifications', function ($user) {
    return $user != null;
});

Broadcast::channel('chat', function ($user) {

    if ($user != null) {
        return ['id' => $user->id, 'name' => $user->name];
    }
});

//Private channel. It only allows see message owned by specific user
Broadcast::channel('chat.greet.{receiver}', function ($user, $receiver) {
    return (int) $user->id === (int) $receiver;
});
