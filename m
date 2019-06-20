Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D064D75C
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 20:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfFTSS1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 14:18:27 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34507 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfFTSS0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 14:18:26 -0400
Received: by mail-yw1-f66.google.com with SMTP id x75so1175416ywd.1
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 11:18:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=C38JR16D0uCCFp3uN7sBnus6zV3AViMarCCy3SdyRaA=;
        b=Q6A4ot33LSDvC4AXkH6XUo+Da/TlocsApZKfE/xIbSvq00IVczUSNpsco1soYkDvBn
         iZjI3LiQdZOF1iuRULAocHJvszpxp4fNRaSyi0+Pw09uBdXvnfv6h3DLnJMsAMrUvIk9
         tVmlXaf7RM9XuFEBWqKbuuNdPGiTolwBFZ8dw6jwIQCth4IOHgBI/fdB4fGhrs77HUi5
         /WAXvCOHoK+yf7bIseSPYGMOrSunPseKgqejlVtdtTfUl5WRgl/3eAm0u08S2G3URuwg
         CZoNaHraHqgXqohcESThXCSzUjBBsanlkVJL0NVsqDn4K6gHrrM9M28f4C1TZMgJM03t
         4vcw==
X-Gm-Message-State: APjAAAXUjndIHOXJ+5XGIf2qgdsXrDZxVYNLC1BYhdwcFdVmeocPNQAj
        x/KfF127w4/MTswjVR7Fhv9NlA==
X-Google-Smtp-Source: APXvYqxTh3Lnagzb9AcvY2tl5Nt6kfjXdohLSDXh6N+CdUgFSHM1bH8Rw7LxlHqe+ZLb/DtBdJOg0A==
X-Received: by 2002:a81:30d7:: with SMTP id w206mr62530505yww.263.1561054705571;
        Thu, 20 Jun 2019 11:18:25 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-5C3.dyn6.twc.com. [2606:a000:1100:37d::5c3])
        by smtp.gmail.com with ESMTPSA id x85sm68008ywx.63.2019.06.20.11.18.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 11:18:25 -0700 (PDT)
Message-ID: <cc0f77b2058d363ce2efc2a7e9dec036161c2b38.camel@redhat.com>
Subject: Re: [PATCH 8/8] ceph: return -EIO if read/write against filp that
 lost file locks
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Anna Schumaker <Anna.Schumaker@netapp.com>
Date:   Thu, 20 Jun 2019 14:18:23 -0400
In-Reply-To: <CA+2bHPZtLvUF2c+GsU2smoh-KJ2OquYNj4QP23=jA9N3Ziyb_A@mail.gmail.com>
References: <20190617125529.6230-1-zyan@redhat.com>
         <20190617125529.6230-9-zyan@redhat.com>
         <CA+2bHPZBy8pFkhvSRnjBzD4dosP2E-n_hNWHXJxQPDqch=+y0Q@mail.gmail.com>
         <c0a3e8d3c1313810606f5a1f9fb8d0c4be322a51.camel@redhat.com>
         <CA+2bHPZtLvUF2c+GsU2smoh-KJ2OquYNj4QP23=jA9N3Ziyb_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-06-20 at 10:19 -0700, Patrick Donnelly wrote:
> On Mon, Jun 17, 2019 at 1:45 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > Again, I'd like to see SIGLOST sent to the application here. Are there
> > > any objections to reviving whatever patchset was in flight to add
> > > that? Or just writeup a new one?
> > > 
> > 
> > I think SIGLOST's utility is somewhat questionable. Applications will
> > need to be custom-written to handle it. If you're going to do that, then
> > it may be better to consider other async notification mechanisms.
> > inotify or fanotify, perhaps? Those may be simpler to implement and get
> > merged.
> 
> The utility of SIGLOST is not well understood from the viewpoint of a
> local file system. The problem uniquely applies to distributed file
> systems. There simply is no way to recover from a lost lock for an
> application through POSIX mechanisms. We really need a new signal to
> just kill the application (by default) because recovery cannot be
> automatically performed even through system call errors. I don't see
> how inotify/fanotify (not POSIX interfaces!) helps here as it assumes
> the application will even use those system calls to monitor for lost
> locks when POSIX has no provision for that to happen.
> 

(cc'ing Anna in case she has an opinion)

SIGLOST isn't defined in POSIX either, so I'm not sure that argument
carries much weight. The _only_ way you'd be able to add SIGLOST is if
it defaults to SIG_IGN, such that only applications that are watching
for it will react to it. Given that, you're already looking at code
modifications.

So, the real question is: what's the best method to watch for lost
locks? I don't have a terribly strong opinion about any of these
notification methods, tbh. I only suggested inotify/fanotify because
they'd likely be much simpler to implement.

Adding signals is a non-trivial affair as we're running out of bits in
that space. The lower 32 bits are all taken and the upper ones are
reserved for realtime signals. My signal.h has a commented out SIGLOST:

#define SIGIO           29
#define SIGPOLL         SIGIO
/*
#define SIGLOST         29
*/

Sharing the value with SIGIO/SIGPOLL makes it distinctly less useful. I
think it'd probably need its own value. Maybe there is some way to have
the application ask that one of the realtime signals be set up for this?

> It's worth noting as well that the current behavior of the mount
> freezing on blacklist is not an acceptable status quo. The application
> will just silently stall the next time it tries to access the mount,
> if it ever does.

Fair enough.
-- 
Jeff Layton <jlayton@redhat.com>

