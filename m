Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9E14D469
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 19:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfFTRAR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 13:00:17 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40400 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfFTRAR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 13:00:17 -0400
Received: by mail-qk1-f193.google.com with SMTP id c70so2404885qkg.7
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 10:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xLCHidqkn/Hd5ZQCJK+DvIYFt6wxHL2p6xnTDsAkugc=;
        b=GxHZneuYXa7cIsBGeDfZ9XL8bCk7j60Hlfa1wN1WmjPSyi6F1OkTkUYydOA6ZaGSml
         sMLCqQWjQiwTGeEpMaGhyjbZp+Y2ptsF0Vqvpzz2dOq3ht4MRXfAhq4+I+4NzRqqGO0f
         b/Wap3xfh0LuW1fclPtVQG6KUY/KQze6f875e3O+KIKjIgNMLrP6eZyNoN3Oua+Ds+Wf
         w8cacqQvHl6B//y1fckvwOdpAP6xMBLKLrIYKys9TL/fJUv3uDw2OA7HHCq4jxGPIkmq
         cdcyLg0UViYx5MOBzpMpk7WNEVTr0JAwyUjoWblszub/1JRbuk8OGB5TKmZfRYk2PCKY
         7lsg==
X-Gm-Message-State: APjAAAWZaaYM6zYtwqpnIEXiy9/Tb1SuMTv7BaNiNjaO5auU271i3Cku
        GqQh/ZfVnjh3dwKn2gmDe92ydXv7OuD1LDQmOG2BvA==
X-Google-Smtp-Source: APXvYqxj6zUIM1fue+DglF07Qa7jRDamtyqfNhrkrAOuTTU+Jbi7Eg1TkTyikxse/NexiD5V02v79Xif714MkxxXkCQ=
X-Received: by 2002:a37:4ad7:: with SMTP id x206mr101813329qka.85.1561050016198;
 Thu, 20 Jun 2019 10:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-9-zyan@redhat.com>
 <CA+2bHPZBy8pFkhvSRnjBzD4dosP2E-n_hNWHXJxQPDqch=+y0Q@mail.gmail.com> <c0a3e8d3c1313810606f5a1f9fb8d0c4be322a51.camel@redhat.com>
In-Reply-To: <c0a3e8d3c1313810606f5a1f9fb8d0c4be322a51.camel@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Thu, 20 Jun 2019 09:59:17 -0700
Message-ID: <CAJ4mKGa-sNfZ7EYwyXDGXMFUUfXe9rEfaPXZ4UdXyfdrUBOYJQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] ceph: return -EIO if read/write against filp that
 lost file locks
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 1:46 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Mon, 2019-06-17 at 13:32 -0700, Patrick Donnelly wrote:
> > On Mon, Jun 17, 2019 at 5:56 AM Yan, Zheng <zyan@redhat.com> wrote:
> > > After mds evicts session, file locks get lost sliently. It's not safe to
> > > let programs continue to do read/write.
> >
> > I think one issue with returning EIO on a file handle that did hold a
> > lock is that the application may be programmed to write to other files
> > assuming that lock is never lost, yes? In that case, it may not ever
> > write to the locked file in any case.
> >
>
> Sure, applications do all sorts of crazy things. We can only cater to so
> much craziness. I'll assert that most applications don't have these
> sorts of weirdo usage patterns, and an error on read/write is more
> reasonable.

It wouldn't surprise me if it's a niche use case, but I hear about a
*lot* of applications which know they're running on a distributed fs
using file locks as a primitive leader election to select amongst
multiple processes (this happens a lot not only in HPC, but also in
distributed database and/or compute projects). That tends to involve
precisely what Patrick is describing.

Given that as you've said SIGLOST doesn't actually exist in Linux I
don't have a good alternative, but if there was some more proactive
way we could tell the application (or let applications enable a more
proactive way, like getting EIO on any file access once a lock is
lost?) it would probably be good.

>
> Note that this behavior is already documented in fcntl(2) as well, as is
> SIGLOST not being implemented.
>
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
> --
> Jeff Layton <jlayton@redhat.com>
>
