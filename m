Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBF251B0F
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jun 2019 20:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbfFXS7X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jun 2019 14:59:23 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43499 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfFXS7X (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Jun 2019 14:59:23 -0400
Received: by mail-yb1-f196.google.com with SMTP id 5so2549072ybj.10
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jun 2019 11:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4gIcKKWiE6jpSB+y23YYVMxj3baAa+R5jdFjvVZh6pE=;
        b=E7fwKpaH7f3Ev67PJZpGPsUyriRNLGteJIHLopjxnL+9LSBOzDYY76kWvkau4qHEA8
         EkeuF5lbpg/MU9gI+0g2xt3v+EyKJ7u5O6JGlNJtajW+viubsjd3KBAyp+w9WwwTR2fw
         cYadtEgUdZSAyUHiflA3y18E16zI4JY9WX5z4BsL8NwgbtXssUYl7LLz9zDohcCsXuAJ
         qyjFhVwM7/zjWCJ2vzR9XuTYLE3NHOyeFVV8qK+827DsNuY7FqSrZj0wTqnpXNLJ293F
         G/OI1guIvepuB/waIG56rTaI+L7t/F9VIC5IOPfXilQT1TpcuoE6dXFsfjAJj13fdJp/
         /Oig==
X-Gm-Message-State: APjAAAVzXwwQUZUxZP3I/zoGV4bXWbwNH30cnF7DeQDYaqMO6uzJ6kTt
        W5sCpDKxRlyaZhhWSu09+2Adhw==
X-Google-Smtp-Source: APXvYqw77BZX8y8Ji2fqAAsD75v0xLpHKhERUgfj+kDJBowfZK7AOwx+TQc+/4QUqyqUnF+mDDwatQ==
X-Received: by 2002:a25:cd48:: with SMTP id d69mr53556452ybf.204.1561402762030;
        Mon, 24 Jun 2019 11:59:22 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-C58.dyn6.twc.com. [2606:a000:1100:37d::c58])
        by smtp.gmail.com with ESMTPSA id u3sm3024672ywc.104.2019.06.24.11.59.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 11:59:21 -0700 (PDT)
Message-ID: <6c8bf99ba7c32f40a5028ba15a83c30eab2e712e.camel@redhat.com>
Subject: Re: [PATCH 8/8] ceph: return -EIO if read/write against filp that
 lost file locks
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Anna Schumaker <Anna.Schumaker@netapp.com>
Date:   Mon, 24 Jun 2019 14:59:19 -0400
In-Reply-To: <CA+2bHPaNu9CX0t7tf7y=KywdTec5OM+XZ13pxWVZVw=Hgu+umw@mail.gmail.com>
References: <20190617125529.6230-1-zyan@redhat.com>
         <20190617125529.6230-9-zyan@redhat.com>
         <CA+2bHPZBy8pFkhvSRnjBzD4dosP2E-n_hNWHXJxQPDqch=+y0Q@mail.gmail.com>
         <c0a3e8d3c1313810606f5a1f9fb8d0c4be322a51.camel@redhat.com>
         <CA+2bHPZtLvUF2c+GsU2smoh-KJ2OquYNj4QP23=jA9N3Ziyb_A@mail.gmail.com>
         <cc0f77b2058d363ce2efc2a7e9dec036161c2b38.camel@redhat.com>
         <CA+2bHPZMd2WhHrkZRj_EKCNXEEcty08bgcwMqsm-OssEjyDUjg@mail.gmail.com>
         <7ec066c518675254a9011f562b9005a2e5920afa.camel@redhat.com>
         <CA+2bHPbggV7LriUhBv-pqD1CjErUf0vPeneL4mHnZ2PBCtBquA@mail.gmail.com>
         <8b57db35ec3f3212b8219890d8e8c3e3bbff99f9.camel@redhat.com>
         <CA+2bHPaNu9CX0t7tf7y=KywdTec5OM+XZ13pxWVZVw=Hgu+umw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-06-20 at 15:25 -0700, Patrick Donnelly wrote:
> On Thu, Jun 20, 2019 at 1:06 PM Jeff Layton <jlayton@redhat.com> wrote:
> > On Thu, 2019-06-20 at 12:50 -0700, Patrick Donnelly wrote:
> > > On Thu, Jun 20, 2019 at 12:00 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > On Thu, 2019-06-20 at 11:51 -0700, Patrick Donnelly wrote:
> > > > > On Thu, Jun 20, 2019 at 11:18 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > On Thu, 2019-06-20 at 10:19 -0700, Patrick Donnelly wrote:
> > > > > > > On Mon, Jun 17, 2019 at 1:45 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > Again, I'd like to see SIGLOST sent to the application here. Are there
> > > > > > > > > any objections to reviving whatever patchset was in flight to add
> > > > > > > > > that? Or just writeup a new one?
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > I think SIGLOST's utility is somewhat questionable. Applications will
> > > > > > > > need to be custom-written to handle it. If you're going to do that, then
> > > > > > > > it may be better to consider other async notification mechanisms.
> > > > > > > > inotify or fanotify, perhaps? Those may be simpler to implement and get
> > > > > > > > merged.
> > > > > > > 
> > > > > > > The utility of SIGLOST is not well understood from the viewpoint of a
> > > > > > > local file system. The problem uniquely applies to distributed file
> > > > > > > systems. There simply is no way to recover from a lost lock for an
> > > > > > > application through POSIX mechanisms. We really need a new signal to
> > > > > > > just kill the application (by default) because recovery cannot be
> > > > > > > automatically performed even through system call errors. I don't see
> > > > > > > how inotify/fanotify (not POSIX interfaces!) helps here as it assumes
> > > > > > > the application will even use those system calls to monitor for lost
> > > > > > > locks when POSIX has no provision for that to happen.
> > > > > > > 
> > > > > > 
> > > > > > (cc'ing Anna in case she has an opinion)
> > > > > > 
> > > > > > SIGLOST isn't defined in POSIX either, so I'm not sure that argument
> > > > > > carries much weight. The _only_ way you'd be able to add SIGLOST is if
> > > > > > it defaults to SIG_IGN, such that only applications that are watching
> > > > > > for it will react to it. Given that, you're already looking at code
> > > > > > modifications.
> > > > > 
> > > > > Why does the default need to be SIG_IGN? Is that existing convention
> > > > > for new signals in Linux?
> > > > > 
> > > > 
> > > > No, it's just that if you don't do that, and locks are lost, then you'll
> > > > have a bunch of applications suddenly crash. That sounds scary.
> > > > 
> > > > > > So, the real question is: what's the best method to watch for lost
> > > > > > locks? I don't have a terribly strong opinion about any of these
> > > > > > notification methods, tbh. I only suggested inotify/fanotify because
> > > > > > they'd likely be much simpler to implement.
> > > > > > 
> > > > > > Adding signals is a non-trivial affair as we're running out of bits in
> > > > > > that space. The lower 32 bits are all taken and the upper ones are
> > > > > > reserved for realtime signals. My signal.h has a commented out SIGLOST:
> > > > > > 
> > > > > > #define SIGIO           29
> > > > > > #define SIGPOLL         SIGIO
> > > > > > /*
> > > > > > #define SIGLOST         29
> > > > > > */
> > > > > > 
> > > > > > Sharing the value with SIGIO/SIGPOLL makes it distinctly less useful. I
> > > > > > think it'd probably need its own value. Maybe there is some way to have
> > > > > > the application ask that one of the realtime signals be set up for this?
> > > > > 
> > > > > Well, SIGPOLL is on its way out according to the standards. So SIGIO
> > > > > looks like what Linux uses instead. Looking at the man page for
> > > > > signal.h, I wonder if we could use SIGIO with si_code==POLL_LOST (a
> > > > > new code); si_band==POLL_MSG; and si_fd==<locked fd>. Then the inotify
> > > > > interface could then be used to process the event?
> > > > > 
> > > > > The one nit here is that we would be generating SIGIO for regular
> > > > > files (and directories?) which would be new. It makes sense with what
> > > > > we want to do though. Also, SIGIO default behavior is to terminate the
> > > > > process.
> > > > > 
> > > > 
> > > > That sounds like it could have unintended side-effects. A systemwide
> > > > event that causes a ton of userland processes to suddenly catch a fatal
> > > > signal seems rather nasty.
> > > 
> > > To be clear: that's only if the mount is configured in the most
> > > conservative way. Killing only userland processes with file locks
> > > would be an intermediate option (and maybe a default).
> > > 
> > 
> > A disable switch for this behavior would be a minimum requirement, I
> > think.
> > 
> > > > It's also not clear to me how you'll identify recipients for this
> > > > signal. What tasks will get a SIGLOST when this occurs? Going from file
> > > > descriptors or inodes to tasks that are associated with them is not
> > > > straightforward.
> > > 
> > > We could start with file locks (which do have owners?) and table the
> > > idea of killing all tasks that have any kind of file descriptor open.
> > 
> > Well...we do track current->tgid for l_pid, so you could probably go by
> > that for traditional POSIX locks.
> > 
> > For flock() and OFD locks though, the tasks are owned by the file
> > description and those can be shared between processes. So, even if you
> > kill the tgid that acquired the lock, there's no guarantee other
> > processes that might be using that lock will get the signal. Not that
> > that's a real argument against doing this, but this approach could have
> > significant gaps.
> 
> I wonder if it's actually common for a process to share locked file
> descriptors? I'm not even sure what that should mean.
> 
> > OTOH, reporting a lost lock via fanotify would be quite straightforward
> > (and not even that difficult). Then, any process that really cares could
> > watch for these events.
> > 
> > Again, I really think I'm missing the big picture on the problem you're
> > attempting to solve with this.
> 
> I may be zooming farther than you want, but here's "The Big Picture":
> a kernel cephfs mount should recover after blacklist and continue to
> be usable at least for new processes/applications. Recovery should be
> automatic without admin intervention.
> 
> > For instance, I was operating under the assumption that you wanted this
> > to be an opt-in thing, but it sounds like you're aiming for something
> > that is more draconian. I'm not convinced that that's a good idea --
> > especially not initially. Enabling this by default could be a very
> > unwelcome surprise in some environments.
> 
> Losing file locks is a serious issue that is grounds for terminating
> applications. Reminder once-again: status quo is the application is
> freezing without _any way to recover_. Almost any change is an
> improvement over that behavior, including termination because then
> monitor processes/init may recover.
> 
> I'm not looking to build "opt-in" mechanisms (because the alternative
> is what? hang forever?) but I am happy to make the behavior
> configurable via mount options.
> 

FWIW, here are some links to old linux-nfs threads on SIGLOST/SIGIO
handling (from 2011 and 2013):

    https://marc.info/?l=linux-nfs&m=137114937610166&w=4

    https://marc.info/?l=linux-nfs&m=131101162420308&w=4

The original patcheset used SIGIO (since that's what SIGLOST is aliased
to on most arches), with plans to use siginfo to distinguish a SIGLOST
signal vs SIGIO.
-- 
Jeff Layton <jlayton@redhat.com>

