Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583AFE09E
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Apr 2019 12:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfD2Kg7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Apr 2019 06:36:59 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:59977 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbfD2Kgx (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Mon, 29 Apr 2019 06:36:53 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Mon, 29 Apr 2019 12:36:50 +0200
Received: from [192.168.178.28] (nwb-a10-snat.microfocus.com [10.120.13.201])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Mon, 29 Apr 2019 11:36:44 +0100
Subject: Re: Teuthology & Rook (& DeepSea, ceph-ansible, ...)
To:     Gregory Farnum <gfarnum@redhat.com>,
        Travis Nielsen <tnielsen@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Cc:     Vasu Kulkarni <vakulkar@redhat.com>,
        Nathan Cutler <ncutler@suse.cz>
References: <CAJ4mKGbdphjcW65YpCV8HTkrqeJbwwas-jQvLuo_ejEU=T-5XA@mail.gmail.com>
From:   Sebastian Wagner <sebastian.wagner@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=swagner@suse.com; prefer-encrypt=mutual; keydata=
 mQENBFgkpqgBCACl4ZHmEEhiZiofnuiVR3wc4ZH3ty2Y7Fgv/ttDAtyQSM3l5MrwFVEkTUKW
 zZOaLPsVl8FwBoy1ciK3cS6nOKwgYogStBBqX8mvnlb915kvhtQ84bSPQ9W5206tKfQDKmZ8
 jWjgEKCwFxH3O2teG2Jc8HFVjNWeUEdF1s9OrL6s6RQmiDf7gkzZL5ew5vS0G1yIWzJBpQzS
 GJEcjm1TmnZWN1jgkKOENBzbDQcBg/IDiLDnbSpAL4LG7RAaavMMdSyVXMOGpmbgV9vNkpTw
 0qpVttsU2t919B02bLTEbYBb3Amsfy8S+ahzQgjg2xiT94xyC7ukLQI4nKEseolN9uERABEB
 AAG0I1NlYmFzdGlhbiBXYWduZXIgPHN3YWduZXJAc3VzZS5jb20+iQE7BBMBAgAlAhsDBgsJ
 CAcDAgYVCAIJCgsEFgIDAQIeAQIXgAUCWCWwgwIZAQAKCRCNJEKAfml5+CdFB/wPI/8K94em
 Zi7GvN6FwCy0Ts+CKSYJcJoX7m0Jp6i3PaTgZMjhmH+KGH/mwXAUPE1NB/Pe/iIwrhRR9tnP
 iJgFcOh4Qe64dsk1DwftVOIk+xEBPYPb6S0FDVLdRkdJUT+2/R+yQirEQACcakHHZvbGru3e
 kF+P8OPQxX6llR3kK6MUa3RX2ZlrwiLNsw4LABKSInl0wsVlzH10LaQxujaqs/NFELR7kkZx
 wd2L3uVAmNxu2XAD6h3oEabQCN6Ol9MDPwX+QZNJ6ZTT5Qofba7Vm1zA5Tmj6mMxMK4M62qu
 5ekGxgWDRmf5Sx6PPphJ1JZY/N/TqchUlpeNIxyHGGMRuQENBFgkpqgBCAC8AHCom5ZNqJhB
 Jsftllb+TTVAtGMt/2R5c+5BfRrrd8rsN7st5hG2RECaokswFHrBWsJvxTex1V+v+ctej4SQ
 64TII9Z2ffySTzdqGFWssOUrHoJvk+4BRuJ48f+bSRETGlXILqIiAISRAfeYOJIGCbsRmijx
 fMjRPzMel2TobmCBW3YsSNVLo/3cMzF7sYHDK9IiAeb9fWrG/p5brtItlfJUmsw+1aZ42TaR
 94mcjKK0U2tTtj1fGkjhb0bRNTiXMQEWIx0xAyCaR61mGpqMhRE8FJ7eY19mAl9G5zTs604I
 ToEcJ6Bd518hJ0HXFJrqKJ/TUKL/dKR4iMViFUORABEBAAGJAR8EGAECAAkFAlgkpqgCGwwA
 CgkQjSRCgH5pefiqQwf/U+POJe0SgWBzX6+69CuRUwE68Uu0qGrNWOfWphaKPksBDx46IhhA
 UlmBJbEoo9h6E7utwwgDNf92O2Lv6yClR+2D2BA9mHLm0DBsmH04bahHGsicU1qK0rBgujqc
 GNrrgYPx3z66C7MB/o6/smS26baOChtrs5XeX3r4zE5+1yZCPb9AR8pwitNF+N81FIXE0DXp
 XhxSviD3KT4QH6Oo6f1PJ3kYnHHX9FmS/3f6hDU2o/kBwOfaP2C0ZWIcbh8VH0ENWdGl6/OK
 QJO68y6QM2NCeCAvfyISE4GERtb7/oRlvtBwWfq7OBsqLXkrKobW4sdx8Scbwb728fF14Oyn 2A==
Message-ID: <2f93b774-ac12-541a-3c34-ffcd75e2171e@suse.com>
Date:   Mon, 29 Apr 2019 12:36:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ4mKGbdphjcW65YpCV8HTkrqeJbwwas-jQvLuo_ejEU=T-5XA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Greg,

let me share my experience in automatically testing the rook orchestrator.

Am 24.04.19 um 16:49 schrieb Gregory Farnum:
> The ceph task itself
> (https://github.com/ceph/ceph/blob/master/qa/tasks/ceph.py) is pretty
> large and supports a big set of functionality. It’s responsible for
> actually turning on the Ceph cluster, cleaning up when the test is
> over, and providing some validation. This includes stuff like running
> with valgrind, options to make sure the cluster goes healthy or scrubs
> at the end of a test, checking for issues in the logs, etc. However,
> most of that stuff can be common code once we have the right
> interfaces. The parts that get shared out to other tasks are 1)
> functions to stop and restart specific daemons, 2) functions to check
> if a cluster is healthy and to wait for failures, 3) the “task”
> function that serves to actually start up the Ceph cluster, and most
> importantly 4) exposing a “DaemonGroup” that links to the
> “RemoteProcess” representing each Ceph daemon in the system. I presume
> 1-3 are again not too complicated to map onto Rook commands we can get
> at programmatically.

This sounds very much incompatible to how a Rook cluster is deployed in
my scenario:

> https://github.com/sebastian-philipp/test-rook-orchestrator/blob/f0fbaaaa63cfc5ee6a2ebafb44a2af292b706138/fixtures.py#L42-L64

Like for example:

* There is no control about which physical processes are running
* There is no access to physical log files
* You're not supposed to start or stop individual daemons
* Pods are automatically restarted, thus waiting for failed daemons will
  be hard and only possible via looking for CrashLoopBackOff
* No remote processes (except for calling ceph commands in a separated
  and isolated pod)

Adding support for anything in this list, like executing remote
processes inside running pods, would introduce a very tight coupling
between Rook and Teuthology, as the processes and daemons started by
Rook are an implementation detail of Rook itself.

Things that are easy:

* Calling the `ceph` command
* Running kubectl
* Querying Pods

> 
> The most interesting part of this interface, and of the teuthology
> model more generally, is the RemoteProcess. Teuthology was created to
> interface with machines via a module called “orchestra”
> (https://github.com/ceph/teuthology/tree/master/teuthology/orchestra)
> that wraps SSH connections to remote nodes. That means you can invoke
> “remote.run” on host objects that passes a literal shell command and
> get back a RemoteProcess object
> (https://github.com/ceph/teuthology/blob/master/teuthology/orchestra/run.py#L21)
> representing it. On that RemoteProcess you can wait() until it’s done
> and/or look at the exitstatus(), you can query if it’s finished()
> running. And you can access the stdin, stdout, and stderr channels!
> Most of this usage tends to fall into a few patterns: stdout is used
> to get output, stderr is mostly used for prettier error output in the
> logs, and stdin is used in a few places for input but is mostly used
> as a signal to tasks to shut down when the channel closes.
> 
> So I’d like to know how this all sounds.

Agreeing with Sage here.

> In particular, how
> implausible is it that we can ssh into Ceph containers and execute
> arbitrary shell commands?

I'd recommend against doing this.

> Is there a good replacement interface for
> most of what I’ve described above? While a lot of the role-to-host
> mapping doesn’t matter, in a few test cases it is critical — is there
> a good way to deal with that (are tags flexible enough for us to force
> this model through)?

There is support for executing Pods on specific hosts in Rook, but
that's not yet supported in the mgr/rook orchestrator.

> Anybody have any other thoughts I’ve missed out on?

As long as the tests are only using a very limited subset of Teuthlogy,
it might be possible to let them run in a Rook environment. Maybe some
of the Dashboard tests?


> -Greg
> 

-- 
SUSE Linux GmbH, Maxfeldstrasse 5, 90409 Nuernberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB 21284 (AG Nürnberg)
