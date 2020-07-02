<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Events\RamainingTimeChanged;
use App\Events\WinnerNumberGenerated;

class GameExecutor extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'game:execute';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Starts executing the game';

    private $time = 15;

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        while(true) {
            \broadcast(new RamainingTimeChanged($this->time . 's'));
            
            $this->time--;
            \sleep(1);
            
            if($this->time === 0) {
                $this->time = 'Waiting to start';
                \broadcast(new RamainingTimeChanged($this->time));
                
                \broadcast(new WinnerNumberGenerated(mt_rand(1, 12)));
                sleep(5);

                $this->time = 15;
            }
        }
    }
}
