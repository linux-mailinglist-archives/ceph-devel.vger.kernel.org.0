Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9264D9C4
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 20:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbfFTSvc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 14:51:32 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35148 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfFTSvc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 14:51:32 -0400
Received: by mail-qk1-f196.google.com with SMTP id l128so2665664qke.2
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 11:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EjgoAc9KCin0BqIaTADEJVR3jVs927RbtZifkXDxpOg=;
        b=J37ssWj+yf6+CLlj/jhpCZ96UTg3tIgBzfVP7y9WooE3uKph1nQyNNKFNwTi5zmiwU
         K0oXjU7WfWfLxcZrSWxf16CaJf2uruq62lbQb5mIS0xPmJixCoiCBa2sq+wv2aEO87VH
         LYQ+IVOLoOdz/mOBMpj7SdT9DOAJ00pqcfgvUYIuYUlYwvwQAoZCSxYBVx+iH87gkNJm
         u8zdpZYU30aVaoFB0MoNFQYy2u/dtRIJnCw1qNY60GSx9ZwTMIKXZ56uBY+SmMBquwAU
         IXMp/urWtrQApcCQPCWhYDBSBfjH5Iw3ev+c2jusid/QO0sCzdjNXoLw/pLa/vFTREp/
         snlg==
X-Gm-Message-State: APjAAAWofaYq6/jiJr25e1+LtBGEEKRXTKyqRBXEkO0Y7dskCrSK4/L/
        Xy4Rv5ZQqiPxrPLgdws+11EJqmFyv1FUWKaVNuw2UDUv
X-Google-Smtp-Source: APXvYqzGAPBBHFwjeiQMG1KSm97Ka8xkjgB3bKj0bYL8Y7ALMlVFzLEm7EupA5MIm/Byn+LUfC9t7yT9SdlkGZnFBNw=
X-Received: by 2002:a05:620a:1106:: with SMTP id o6mr89009547qkk.272.1561056691515;
 Thu, 20 Jun 2019 11:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-9-zyan@redhat.com>
 <CA+2bHPZBy8pFkhvSRnjBzD4dosP2E-n_hNWHXJxQPDqch=+y0Q@mail.gmail.com>
 <c0a3e8d3c1313810606f5a1f9fb8d0c4be322a51.camel@redhat.com>
 <CA+2bHPZtLvUF2c+GsU2smoh-KJ2OquYNj4QP23=jA9N3Ziyb_A@mail.gmail.com> <cc0f77b2058d363ce2efc2a7e9dec036161c2b38.camel@redhat.com>
In-Reply-To: <cc0f77b2058d363ce2efc2a7e9dec036161c2b38.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 20 Jun 2019 11:51:04 -0700
Message-ID: <CA+2bHPZMd2WhHrkZRj_EKCNXEEcty08bgcwMqsm-OssEjyDUjg@mail.gmail.com>
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

On Thu, Jun 20, 2019 at 11:18 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Thu, 2019-06-20 at 10:19 -0700, Patrick Donnelly wrote:
> > On Mon, Jun 17, 2019 at 1:45 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > Again, I'd like to see SIGLOST sent to the application here. Are there
> > > > any objections to reviving whatever patchset was in flight to add
> > > > that? Or just writeup a new one?
> > > >
> > >
> > > I think SIGLOST's utility is somewhat questionable. Applications will
> > > need to be custom-written to handle it. If you're going to do that, then
> > > it may be better to consider other async notification mechanisms.
> > > inotify or fanotify, perhaps? Those may be simpler to implement and get
> > > merged.
> >
> > The utility of SIGLOST is not well understood from the viewpoint of a
> > local file system. The problem uniquely applies to distributed file
> > systems. There simply is no way to recover from a lost lock for an
> > application through POSIX mechanisms. We really need a new signal to
> > just kill the application (by default) because recovery cannot be
> > automatically performed even through system call errors. I don't see
> > how inotify/fanotify (not POSIX interfaces!) helps here as it assumes
> > the application will even use those system calls to monitor for lost
> > locks when POSIX has no provision for that to happen.
> >
>
> (cc'ing Anna in case she has an opinion)
>
> SIGLOST isn't defined in POSIX either, so I'm not sure that argument
> carries much weight. The _only_ way you'd be able to add SIGLOST is if
> it defaults to SIG_IGN, such that only applications that are watching
> for it will react to it. Given that, you're already looking at code
> modifications.

Why does the default need to be SIG_IGN? Is that existing convention
for new signals in Linux?

> So, the real question is: what's the best method to watch for lost
> locks? I don't have a terribly strong opinion about any of these
> notification methods, tbh. I only suggested inotify/fanotify because
> they'd likely be much simpler to implement.
>
> Adding signals is a non-trivial affair as we're running out of bits in
> that space. The lower 32 bits are all taken and the upper ones are
> reserved for realtime signals. My signal.h has a commented out SIGLOST:
>
> #define SIGIO           29
> #define SIGPOLL         SIGIO
> /*
> #define SIGLOST         29
> */
>
> Sharing the value with SIGIO/SIGPOLL makes it distinctly less useful. I
> think it'd probably need its own value. Maybe there is some way to have
> the application ask that one of the realtime signals be set up for this?

Well, SIGPOLL is on its way out according to the standards. So SIGIO
looks like what Linux uses instead. Looking at the man page for
signal.h, I wonder if we could use SIGIO with si_code==POLL_LOST (a
new code); si_band==POLL_MSG; and si_fd==<locked fd>. Then the inotify
interface could then be used to process the event?

The one nit here is that we would be generating SIGIO for regular
files (and directories?) which would be new. It makes sense with what
we want to do though. Also, SIGIO default behavior is to terminate the
process.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
