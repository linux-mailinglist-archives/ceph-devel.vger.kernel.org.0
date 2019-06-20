Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24A94D4B3
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 19:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfFTRUX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 13:20:23 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37286 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfFTRUW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 13:20:22 -0400
Received: by mail-qt1-f196.google.com with SMTP id y57so3993775qtk.4
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 10:20:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Be2ZDOkuDepAQx8zPZt2RjtvnW3+XADviHPJSFIj//0=;
        b=k7vQzPh2ecY6EuCAK/R+FxBhnsZe4Anp7CqzT13v5Aiof+/KQY07LWRAakW6APy4CN
         +BiXqgyoRCjGYsC6tHNQlYmBaJBn4yOPodgpXjaXOlp2HcO3CyYvE1LsprMwRDl00o3/
         /hlUhYZZXlQ18OJG/lK8o5cekNeakfzCF2WIE2+91jr2gOymfSJEBmFu1/eU75KCH/QP
         G+kbN1V7nARMUEK7Y5DojeZLWh1YEzsz3Y2m7aKB7lTr79aRvMp7t60tOpmAJ0XnRs1/
         IRehD8AS2B7n5yXWCnUbEcJzcX6i+Lpe7vB02s5Hcm+Xpbazqv9FKbfX/n+WdmBBJh72
         uyBQ==
X-Gm-Message-State: APjAAAUN+stB/mt5FNEg9wWGZP0DiD5OBj9AzY2UiSVbe1O23AScuZzC
        GzzM/FJbpTZUIdDJ0wy12WMxk0TUJiaPcRcEgcLuWVlw
X-Google-Smtp-Source: APXvYqw6EEhzvM7JUSuCoG3E5EKFfYcU+QAthABw9BjUtTfKGNITlPcQ1YMqCZHsv/sqmCNfbyNyXPUx8sXAaYyFbOc=
X-Received: by 2002:a0c:93cb:: with SMTP id g11mr21592929qvg.133.1561051222026;
 Thu, 20 Jun 2019 10:20:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-9-zyan@redhat.com>
 <CA+2bHPZBy8pFkhvSRnjBzD4dosP2E-n_hNWHXJxQPDqch=+y0Q@mail.gmail.com> <c0a3e8d3c1313810606f5a1f9fb8d0c4be322a51.camel@redhat.com>
In-Reply-To: <c0a3e8d3c1313810606f5a1f9fb8d0c4be322a51.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 20 Jun 2019 10:19:55 -0700
Message-ID: <CA+2bHPZtLvUF2c+GsU2smoh-KJ2OquYNj4QP23=jA9N3Ziyb_A@mail.gmail.com>
Subject: Re: [PATCH 8/8] ceph: return -EIO if read/write against filp that
 lost file locks
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 1:45 PM Jeff Layton <jlayton@redhat.com> wrote:
> > Again, I'd like to see SIGLOST sent to the application here. Are there
> > any objections to reviving whatever patchset was in flight to add
> > that? Or just writeup a new one?
> >
>
> I think SIGLOST's utility is somewhat questionable. Applications will
> need to be custom-written to handle it. If you're going to do that, then
> it may be better to consider other async notification mechanisms.
> inotify or fanotify, perhaps? Those may be simpler to implement and get
> merged.

The utility of SIGLOST is not well understood from the viewpoint of a
local file system. The problem uniquely applies to distributed file
systems. There simply is no way to recover from a lost lock for an
application through POSIX mechanisms. We really need a new signal to
just kill the application (by default) because recovery cannot be
automatically performed even through system call errors. I don't see
how inotify/fanotify (not POSIX interfaces!) helps here as it assumes
the application will even use those system calls to monitor for lost
locks when POSIX has no provision for that to happen.

It's worth noting as well that the current behavior of the mount
freezing on blacklist is not an acceptable status quo. The application
will just silently stall the next time it tries to access the mount,
if it ever does.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
