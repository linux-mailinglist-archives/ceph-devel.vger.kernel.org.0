Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128B54D9E5
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 21:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfFTTAk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 15:00:40 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41255 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfFTTAj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 15:00:39 -0400
Received: by mail-yw1-f67.google.com with SMTP id y185so1617633ywy.8
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 12:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=kyVXr+b1TUagb5aKtsMJx7dAEpH1m6UJPFhAxwFCFBg=;
        b=nTomA4acbWCf/U51aKUAtYzvqQ5sP3NSTRbQXGP3ke595bXP9NQxNg9Dv+T54ofRwR
         bCvupUWqqoPVDwQOeH/IEqG5TLLldKx9USmurU4KgcPB7AExfXW4GS97q0REO03OLEIk
         lr1UHa9c9CXQCa3TLyolGuxHvha7nB+7CjtXqER21/oCChsq2iq/NqE4jww2zyJggGSz
         nxS6qc7r/GZfm6lBtjtAuCo/pb+eWZeEu6xu7k9e1CSWWErnpnvBsumswQMeoKPlW9Im
         RVIeG8fv4jrOuyastcTbXHQW+VuS7wiLdKF6iTEHt6varElP+MBcZDH5+pIjOAoVb775
         GNUA==
X-Gm-Message-State: APjAAAW8+wuPxFKLOWA8axsAIXLidxAIZ7EZIOAj9EFotU9f0cjSQyUN
        D96Arvz309Smhkyahvt/CD3N7Q==
X-Google-Smtp-Source: APXvYqzixUAm62XcB1IIW2mo2bmxI0BUFrhC5z+1nZ/+pDV7a3LUsa/0h6Mml1xFajRcE6k0bEz+RQ==
X-Received: by 2002:a0d:d714:: with SMTP id z20mr47671759ywd.23.1561057238676;
        Thu, 20 Jun 2019 12:00:38 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-5C3.dyn6.twc.com. [2606:a000:1100:37d::5c3])
        by smtp.gmail.com with ESMTPSA id 197sm84588ywb.56.2019.06.20.12.00.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 12:00:38 -0700 (PDT)
Message-ID: <7ec066c518675254a9011f562b9005a2e5920afa.camel@redhat.com>
Subject: Re: [PATCH 8/8] ceph: return -EIO if read/write against filp that
 lost file locks
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Anna Schumaker <Anna.Schumaker@netapp.com>
Date:   Thu, 20 Jun 2019 15:00:37 -0400
In-Reply-To: <CA+2bHPZMd2WhHrkZRj_EKCNXEEcty08bgcwMqsm-OssEjyDUjg@mail.gmail.com>
References: <20190617125529.6230-1-zyan@redhat.com>
         <20190617125529.6230-9-zyan@redhat.com>
         <CA+2bHPZBy8pFkhvSRnjBzD4dosP2E-n_hNWHXJxQPDqch=+y0Q@mail.gmail.com>
         <c0a3e8d3c1313810606f5a1f9fb8d0c4be322a51.camel@redhat.com>
         <CA+2bHPZtLvUF2c+GsU2smoh-KJ2OquYNj4QP23=jA9N3Ziyb_A@mail.gmail.com>
         <cc0f77b2058d363ce2efc2a7e9dec036161c2b38.camel@redhat.com>
         <CA+2bHPZMd2WhHrkZRj_EKCNXEEcty08bgcwMqsm-OssEjyDUjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-06-20 at 11:51 -0700, Patrick Donnelly wrote:
> On Thu, Jun 20, 2019 at 11:18 AM Jeff Layton <jlayton@redhat.com> wrote:
> > On Thu, 2019-06-20 at 10:19 -0700, Patrick Donnelly wrote:
> > > On Mon, Jun 17, 2019 at 1:45 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > Again, I'd like to see SIGLOST sent to the application here. Are there
> > > > > any objections to reviving whatever patchset was in flight to add
> > > > > that? Or just writeup a new one?
> > > > > 
> > > > 
> > > > I think SIGLOST's utility is somewhat questionable. Applications will
> > > > need to be custom-written to handle it. If you're going to do that, then
> > > > it may be better to consider other async notification mechanisms.
> > > > inotify or fanotify, perhaps? Those may be simpler to implement and get
> > > > merged.
> > > 
> > > The utility of SIGLOST is not well understood from the viewpoint of a
> > > local file system. The problem uniquely applies to distributed file
> > > systems. There simply is no way to recover from a lost lock for an
> > > application through POSIX mechanisms. We really need a new signal to
> > > just kill the application (by default) because recovery cannot be
> > > automatically performed even through system call errors. I don't see
> > > how inotify/fanotify (not POSIX interfaces!) helps here as it assumes
> > > the application will even use those system calls to monitor for lost
> > > locks when POSIX has no provision for that to happen.
> > > 
> > 
> > (cc'ing Anna in case she has an opinion)
> > 
> > SIGLOST isn't defined in POSIX either, so I'm not sure that argument
> > carries much weight. The _only_ way you'd be able to add SIGLOST is if
> > it defaults to SIG_IGN, such that only applications that are watching
> > for it will react to it. Given that, you're already looking at code
> > modifications.
> 
> Why does the default need to be SIG_IGN? Is that existing convention
> for new signals in Linux?
> 

No, it's just that if you don't do that, and locks are lost, then you'll
have a bunch of applications suddenly crash. That sounds scary.

> > So, the real question is: what's the best method to watch for lost
> > locks? I don't have a terribly strong opinion about any of these
> > notification methods, tbh. I only suggested inotify/fanotify because
> > they'd likely be much simpler to implement.
> > 
> > Adding signals is a non-trivial affair as we're running out of bits in
> > that space. The lower 32 bits are all taken and the upper ones are
> > reserved for realtime signals. My signal.h has a commented out SIGLOST:
> > 
> > #define SIGIO           29
> > #define SIGPOLL         SIGIO
> > /*
> > #define SIGLOST         29
> > */
> > 
> > Sharing the value with SIGIO/SIGPOLL makes it distinctly less useful. I
> > think it'd probably need its own value. Maybe there is some way to have
> > the application ask that one of the realtime signals be set up for this?
> 
> Well, SIGPOLL is on its way out according to the standards. So SIGIO
> looks like what Linux uses instead. Looking at the man page for
> signal.h, I wonder if we could use SIGIO with si_code==POLL_LOST (a
> new code); si_band==POLL_MSG; and si_fd==<locked fd>. Then the inotify
> interface could then be used to process the event?
> 
> The one nit here is that we would be generating SIGIO for regular
> files (and directories?) which would be new. It makes sense with what
> we want to do though. Also, SIGIO default behavior is to terminate the
> process.
> 

That sounds like it could have unintended side-effects. A systemwide
event that causes a ton of userland processes to suddenly catch a fatal
signal seems rather nasty.

It's also not clear to me how you'll identify recipients for this
signal. What tasks will get a SIGLOST when this occurs? Going from file
descriptors or inodes to tasks that are associated with them is not
straightforward.
-- 
Jeff Layton <jlayton@redhat.com>

