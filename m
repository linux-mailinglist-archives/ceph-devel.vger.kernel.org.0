Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0817E17F4
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Oct 2019 12:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404454AbfJWK3q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Oct 2019 06:29:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:41816 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404447AbfJWK3p (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 06:29:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2DF28ABB1;
        Wed, 23 Oct 2019 10:29:43 +0000 (UTC)
References: <20191017144636.28617-1-lhenriques@suse.com> <a68eeb81a5b193be2da49b83dfedce7d2782fb40.camel@kernel.org> <87a79unocw.fsf@suse.com> <CAAM7YA=dg8ufUWqrD_V8pSdvxrnU+knOW4uW4io_b=Lwjhpg5Q@mail.gmail.com> <20191022134700.GA23308@hermes.olymp>
From:   Luis Henriques <lhenriques@suse.com>
To:     "Yan\, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: Fix use-after-free in __ceph_remove_cap
In-reply-to: <20191022134700.GA23308@hermes.olymp>
Date:   Wed, 23 Oct 2019 11:29:42 +0100
Message-ID: <878spboiuh.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Luis Henriques <lhenriques@suse.com> writes:

> On Tue, Oct 22, 2019 at 08:48:56PM +0800, Yan, Zheng wrote:
>> On Mon, Oct 21, 2019 at 10:55 PM Luis Henriques <lhenriques@suse.com> wrote:
>> 
>> >
>> > Jeff Layton <jlayton@kernel.org> writes:
>> >
>> > > On Thu, 2019-10-17 at 15:46 +0100, Luis Henriques wrote:
>> > >> KASAN reports a use-after-free when running xfstest generic/531, with
>> > the
>> > >> following trace:
>> > >>
>> > >> [  293.903362]  kasan_report+0xe/0x20
>> > >> [  293.903365]  rb_erase+0x1f/0x790
>> > >> [  293.903370]  __ceph_remove_cap+0x201/0x370
>> > >> [  293.903375]  __ceph_remove_caps+0x4b/0x70
>> > >> [  293.903380]  ceph_evict_inode+0x4e/0x360
>> > >> [  293.903386]  evict+0x169/0x290
>> > >> [  293.903390]  __dentry_kill+0x16f/0x250
>> > >> [  293.903394]  dput+0x1c6/0x440
>> > >> [  293.903398]  __fput+0x184/0x330
>> > >> [  293.903404]  task_work_run+0xb9/0xe0
>> > >> [  293.903410]  exit_to_usermode_loop+0xd3/0xe0
>> > >> [  293.903413]  do_syscall_64+0x1a0/0x1c0
>> > >> [  293.903417]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> > >>
>> > >> This happens because __ceph_remove_cap() may queue a cap release
>> > >> (__ceph_queue_cap_release) which can be scheduled before that cap is
>> > >> removed from the inode list with
>> > >>
>> > >>      rb_erase(&cap->ci_node, &ci->i_caps);
>> > >>
>> > >> And, when this finally happens, the use-after-free will occur.
>> > >>
>> > >> This can be fixed by protecting the rb_erase with the s_cap_lock
>> > spinlock,
>> > >> which is used by ceph_send_cap_releases(), before the cap is freed.
>> > >>
>> > >> Signed-off-by: Luis Henriques <lhenriques@suse.com>
>> > >> ---
>> > >>  fs/ceph/caps.c | 4 ++--
>> > >>  1 file changed, 2 insertions(+), 2 deletions(-)
>> > >>
>> > >> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> > >> index d3b9c9d5c1bd..21ee38cabe98 100644
>> > >> --- a/fs/ceph/caps.c
>> > >> +++ b/fs/ceph/caps.c
>> > >> @@ -1089,13 +1089,13 @@ void __ceph_remove_cap(struct ceph_cap *cap,
>> > bool queue_release)
>> > >>      }
>> > >>      cap->cap_ino = ci->i_vino.ino;
>> > >>
>> > >> -    spin_unlock(&session->s_cap_lock);
>> > >> -
>> > >>      /* remove from inode list */
>> > >>      rb_erase(&cap->ci_node, &ci->i_caps);
>> > >>      if (ci->i_auth_cap == cap)
>> > >>              ci->i_auth_cap = NULL;
>> > >>
>> > >> +    spin_unlock(&session->s_cap_lock);
>> > >> +
>> > >>      if (removed)
>> > >>              ceph_put_cap(mdsc, cap);
>> > >>
>> > >
>> > > Is there any reason we need to wait until this point to remove it from
>> > > the rbtree? ISTM that we ought to just do that at the beginning of the
>> > > function, before we take the s_cap_lock.
>> >
>> > That sounds good to me, at least at a first glace.  I spent some time
>> > looking for any possible issues in the code, and even run a few tests.
>> >
>> > However, looking at git log I found commit f818a73674c5 ("ceph: fix cap
>> > removal races"), which moved that rb_erase from the beginning of the
>> > function to it's current position.  So, unless the race mentioned in
>> > this commit has disappeared in the meantime (which is possible, this
>> > commit is from 2010!), this rbtree operation shouldn't be changed.
>> >
>> > And I now wonder if my patch isn't introducing a race too...
>> > __ceph_remove_cap() is supposed to always be called with the session
>> > mutex held, except for the ceph_evict_inode() path.  Which is where I'm
>> > seeing the UAF.  So, maybe what's missing here is the s_mutex.  Hmm...
>> >
>> >
>> we can't lock s_mutex here, because i_ceph_lock is locked
>
> Well, my idea wasn't to get s_mutex here but earlier in the stack.
> Maybe in ceph_evict_inode, protecting the call to __ceph_remove_caps.
> But I didn't really looked into that yet, so I'm not really sure if

Ok, I looked into that now and obviously that's not possible.  So, I
guess my original patch is still the best option.

Cheers,
-- 
Luis

> that's feasible (or even if that would fix this UAF).  I suspect that's
> not possible anyway, due to the comment above __ceph_remove_cap:
>
>   caller will not hold session s_mutex if called from destroy_inode.

