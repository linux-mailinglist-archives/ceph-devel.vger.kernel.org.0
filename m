Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422324DAAF
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 21:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfFTTuz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 15:50:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38524 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfFTTuz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 15:50:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id n11so4468996qtl.5
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 12:50:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQ3H79c/yyPby4fK6scYkB9AAt8XRRiNh/nqCLngxpI=;
        b=r+BMqhpRDOmHw5gIKrkdrWaGYhRoGowt5GJoF0PTxTJHtiYnlSjnYt3KV8DRe8Xs6W
         NJyXXCXYh9HTrmTXa65Tew1BXetzJfvkx8JQTAX32Oyr1OpEgULQwVLYfU/feZxvjPqN
         SiCQ9QHO3YZHwqlKEaMIgBjWeYWgXiqsj3DmQT7r2kZ69f2/ZFCqTBBXrvyrwVOaY0k0
         AeshMo3ckRcbMlQ4/aE9SE6dtL2quQLOeC36bRvH+Laccv6u/Z6muj2b2Tbn0UueU78J
         wbfJl9BP46TzG8ueZ1lyCCMeidq/KJj04n1W3SB1dGSJAefvMMyO4aTr4PbtI4gA7I3s
         FZWA==
X-Gm-Message-State: APjAAAUDpqHwMsjDz6V6UIYEktVazvOJJawV3ZCbnWklnRMPTewVW3XN
        23T2RkA4Apc00mMeBO0z4/UEzPqh/ZjDQ8b39pbr1Rkr
X-Google-Smtp-Source: APXvYqxrWIdqau+68UEC7uZCSYYZ/EiiNIz1sO7y5P7usO0hubPjzVRreGwqLfBcYSWldMLxALSHN3YYJXWin0Hmh8k=
X-Received: by 2002:a0c:ff46:: with SMTP id y6mr41035095qvt.214.1561060254304;
 Thu, 20 Jun 2019 12:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-9-zyan@redhat.com>
 <CA+2bHPZBy8pFkhvSRnjBzD4dosP2E-n_hNWHXJxQPDqch=+y0Q@mail.gmail.com>
 <c0a3e8d3c1313810606f5a1f9fb8d0c4be322a51.camel@redhat.com>
 <CA+2bHPZtLvUF2c+GsU2smoh-KJ2OquYNj4QP23=jA9N3Ziyb_A@mail.gmail.com>
 <cc0f77b2058d363ce2efc2a7e9dec036161c2b38.camel@redhat.com>
 <CA+2bHPZMd2WhHrkZRj_EKCNXEEcty08bgcwMqsm-OssEjyDUjg@mail.gmail.com> <7ec066c518675254a9011f562b9005a2e5920afa.camel@redhat.com>
In-Reply-To: <7ec066c518675254a9011f562b9005a2e5920afa.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 20 Jun 2019 12:50:27 -0700
Message-ID: <CA+2bHPbggV7LriUhBv-pqD1CjErUf0vPeneL4mHnZ2PBCtBquA@mail.gmail.com>
Subject: Re: [PATCH 8/8] ceph: return -EIO if read/write against filp that
 lost file locks
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Anna Schumaker <Anna.Schumaker@netapp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 20, 2019 at 12:00 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Thu, 2019-06-20 at 11:51 -0700, Patrick Donnelly wrote:
> > On Thu, Jun 20, 2019 at 11:18 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > On Thu, 2019-06-20 at 10:19 -0700, Patrick Donnelly wrote:
> > > > On Mon, Jun 17, 2019 at 1:45 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > Again, I'd like to see SIGLOST sent to the application here. Are there
> > > > > > any objections to reviving whatever patchset was in flight to add
> > > > > > that? Or just writeup a new one?
> > > > > >
> > > > >
> > > > > I think SIGLOST's utility is somewhat questionable. Applications will
> > > > > need to be custom-written to handle it. If you're going to do that, then
> > > > > it may be better to consider other async notification mechanisms.
> > > > > inotify or fanotify, perhaps? Those may be simpler to implement and get
> > > > > merged.
> > > >
> > > > The utility of SIGLOST is not well understood from the viewpoint of a
> > > > local file system. The problem uniquely applies to distributed file
> > > > systems. There simply is no way to recover from a lost lock for an
> > > > application through POSIX mechanisms. We really need a new signal to
> > > > just kill the application (by default) because recovery cannot be
> > > > automatically performed even through system call errors. I don't see
> > > > how inotify/fanotify (not POSIX interfaces!) helps here as it assumes
> > > > the application will even use those system calls to monitor for lost
> > > > locks when POSIX has no provision for that to happen.
> > > >
> > >
> > > (cc'ing Anna in case she has an opinion)
> > >
> > > SIGLOST isn't defined in POSIX either, so I'm not sure that argument
> > > carries much weight. The _only_ way you'd be able to add SIGLOST is if
> > > it defaults to SIG_IGN, such that only applications that are watching
> > > for it will react to it. Given that, you're already looking at code
> > > modifications.
> >
> > Why does the default need to be SIG_IGN? Is that existing convention
> > for new signals in Linux?
> >
>
> No, it's just that if you don't do that, and locks are lost, then you'll
> have a bunch of applications suddenly crash. That sounds scary.
>
> > > So, the real question is: what's the best method to watch for lost
> > > locks? I don't have a terribly strong opinion about any of these
> > > notification methods, tbh. I only suggested inotify/fanotify because
> > > they'd likely be much simpler to implement.
> > >
> > > Adding signals is a non-trivial affair as we're running out of bits in
> > > that space. The lower 32 bits are all taken and the upper ones are
> > > reserved for realtime signals. My signal.h has a commented out SIGLOST:
> > >
> > > #define SIGIO           29
> > > #define SIGPOLL         SIGIO
> > > /*
> > > #define SIGLOST         29
> > > */
> > >
> > > Sharing the value with SIGIO/SIGPOLL makes it distinctly less useful. I
> > > think it'd probably need its own value. Maybe there is some way to have
> > > the application ask that one of the realtime signals be set up for this?
> >
> > Well, SIGPOLL is on its way out according to the standards. So SIGIO
> > looks like what Linux uses instead. Looking at the man page for
> > signal.h, I wonder if we could use SIGIO with si_code==POLL_LOST (a
> > new code); si_band==POLL_MSG; and si_fd==<locked fd>. Then the inotify
> > interface could then be used to process the event?
> >
> > The one nit here is that we would be generating SIGIO for regular
> > files (and directories?) which would be new. It makes sense with what
> > we want to do though. Also, SIGIO default behavior is to terminate the
> > process.
> >
>
> That sounds like it could have unintended side-effects. A systemwide
> event that causes a ton of userland processes to suddenly catch a fatal
> signal seems rather nasty.

To be clear: that's only if the mount is configured in the most
conservative way. Killing only userland processes with file locks
would be an intermediate option (and maybe a default).

> It's also not clear to me how you'll identify recipients for this
> signal. What tasks will get a SIGLOST when this occurs? Going from file
> descriptors or inodes to tasks that are associated with them is not
> straightforward.

We could start with file locks (which do have owners?) and table the
idea of killing all tasks that have any kind of file descriptor open.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
