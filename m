Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F8833E713
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Mar 2021 03:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCQCnw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Mar 2021 22:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhCQCnq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Mar 2021 22:43:46 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C342BC06174A
        for <ceph-devel@vger.kernel.org>; Tue, 16 Mar 2021 19:43:45 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id p8so132144ejb.10
        for <ceph-devel@vger.kernel.org>; Tue, 16 Mar 2021 19:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GvkSjbOflTYrrhQW/IujV+Vj77yNYWLHdlNlegrHH4E=;
        b=ASGp57d2AB3YJwzE0HztUK7znMoqHLdCpnr808cyahGXOlRg55T2zYUWxFwELsX85a
         rS35PH4RkUyQRe4gbJq52No3U0lb3SmDBGMBrHHk9qd67i95PxSvEvT+Mngdku3IDOLo
         nnwpKbepa9C5Dlkm18/FC8Ew/qk9tKjgUsJpA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GvkSjbOflTYrrhQW/IujV+Vj77yNYWLHdlNlegrHH4E=;
        b=ODxJ+rlb1Xwdr0IqwiXzW1Xd3WavKGORvxrmZfbfN8sRTwzx64yUzYOVaBM0E5afqi
         lRYIN3GrLNQvgG7scEjP97bD4if2pN/yaVL+Oq7AHe7NSPMTOryEA5keSUb556BZIV3R
         mVvYfmS/RhUsxm6i4jLTCegOYwls0Wh8h0+6vypiquf0T9OYw+Yy7v6q6mPy/tUKY7DX
         pSzXVIrBmZyyznVcq6ZUJQ6mfTlWdy1Bs+LGqFYGpkP3lXe+H8EA8iGv6xCx9L0CPgT8
         wtsDEWo+95bVM1OQeg2J618TIxY3A6rFCuIIUsII4Y+XsvitKbz3ITULrI20rmx74g3z
         SxHg==
X-Gm-Message-State: AOAM532XzPHsCSB8Jg2ds6qT+DY3wBD+SAPrysuKrFy0EikD53LkxGZO
        CGA/JWjDVHJK6O/tQz2SKW7HBj4GnASO8w==
X-Google-Smtp-Source: ABdhPJwf0IUAYf3CdE1lGDYqN751qi6zFP/iKdDhPP3mKRnnf6yPLTpqhFlwMn4zC6XGfvOHMcDv7g==
X-Received: by 2002:a17:906:8408:: with SMTP id n8mr31731192ejx.152.1615949024314;
        Tue, 16 Mar 2021 19:43:44 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id v8sm11492895edx.38.2021.03.16.19.43.43
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 19:43:44 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id bm21so167771ejb.4
        for <ceph-devel@vger.kernel.org>; Tue, 16 Mar 2021 19:43:43 -0700 (PDT)
X-Received: by 2002:a05:6512:398d:: with SMTP id j13mr922688lfu.41.1615948533286;
 Tue, 16 Mar 2021 19:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <161539526152.286939.8589700175877370401.stgit@warthog.procyon.org.uk>
 <161539528910.286939.1252328699383291173.stgit@warthog.procyon.org.uk>
 <20210316190707.GD3420@casper.infradead.org> <CAHk-=wjSGsRj7xwhSMQ6dAQiz53xA39pOG+XA_WeTgwBBu4uqg@mail.gmail.com>
 <887b9eb7-2764-3659-d0bf-6a034a031618@toxicpanda.com>
In-Reply-To: <887b9eb7-2764-3659-d0bf-6a034a031618@toxicpanda.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 16 Mar 2021 19:35:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=whWoJhGeMn85LOh9FX-5d2-Upzmv1m2ZmYxvD31TKpUTA@mail.gmail.com>
Message-ID: <CAHk-=whWoJhGeMn85LOh9FX-5d2-Upzmv1m2ZmYxvD31TKpUTA@mail.gmail.com>
Subject: Re: [PATCH v4 02/28] mm: Add an unlock function for PG_private_2/PG_fscache
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Matthew Wilcox <willy@infradead.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linux-MM <linux-mm@kvack.org>, linux-cachefs@redhat.com,
        linux-afs@lists.infradead.org,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 16, 2021 at 7:12 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
>
> Yeah it's just a flag, we use it to tell that the page is part of a range that
> has been allocated for IO.  The lifetime of the page is independent of the page,
> but is generally either dirty or under writeback, so either it goes through
> truncate and we clear PagePrivate2 there, or it actually goes through IO and is
> cleared before we drop the page in our endio.

Ok, that's what it looked like from my very limited "looking at a
couple of grep cases", but I didn't go any further than that.

> We _always_ have PG_private set on the page as long as we own it, and
> PG_private_2 is only set in this IO related context, so we're safe
> there because of the rules around PG_dirty/PG_writeback. We don't need
> it to have an extra ref for it being set.

Perfect. That means that at least as far as btrfs is concerned, we
could trivially remove PG_private_2 from that page_has_private() math
- you'd always see the same result anyway, exactly because you have
PG_private set.

And as far as I can tell, fscache doesn't want that PG_private_2 bit
to interact with the random VM lifetime or migration rules either, and
should rely entirely on the page count. David?

There's actually a fair number of page_has_private() users, so we'd
better make sure that's the case. But it's simplified by this but
really only being used by btrfs (which doesn't care) and fscache, so
this cleanup would basically be entirely up to the whole fscache
series.

Hmm? Objections?

            Linus
