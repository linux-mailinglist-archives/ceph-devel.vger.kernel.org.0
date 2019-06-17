Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABAB49193
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 22:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfFQUpV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 16:45:21 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38907 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727813AbfFQUpU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Jun 2019 16:45:20 -0400
Received: by mail-qt1-f194.google.com with SMTP id n11so12527427qtl.5
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jun 2019 13:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8TqmPskf0njDpD2GlgZgTI3pr2V49D6lJzOJ3o1kO3E=;
        b=fO+8pQ1B6wLc9XWKxO1M57gACALPj3mgp+/TQUfvEbWwBuDacMVmn8hZ3y9oyXNaMz
         CaXOGIrXzJ4KnFb7WdzJrlcDOoWmw+uAM1tlllpTXr6DLbqGMsmDgJa/VgMNr2Z4yK+v
         Cl8/prxInR7N+p2sXt98bMI10S3wnYoIDZiH/NKcrLLuXbNxi+zupo/f5uPjgCRurKsn
         98YK4gi9YutjHu+6k3xWrtyg/MIo9scDb68mycM122sMphPou7bxR94B6DUcMs0gV0pJ
         gF83qMTVpHrem3ErIAz8p1HnNyeEBHWBtMsIJJuSllCRUBihBe6BzilkQC1wkxBtDmXx
         EBXg==
X-Gm-Message-State: APjAAAUnALiyqGeEJiVYYIU+M8/obEwAPRHgsgfzJvjhIm79Tagd7EMW
        AGO1o9yyjSWScBaDka+rQqFOgYipcfw=
X-Google-Smtp-Source: APXvYqyXCRYwTowRZKrBgEO7ZFeQ3BVFjB/mKTox1grwWsOfmmapWrL2eSFCsZRK/MWWyr8eAtHJmA==
X-Received: by 2002:a0c:b929:: with SMTP id u41mr23536332qvf.50.1560804319778;
        Mon, 17 Jun 2019 13:45:19 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-8C7.dyn6.twc.com. [2606:a000:1100:37d::8c7])
        by smtp.gmail.com with ESMTPSA id w189sm6236118qkc.38.2019.06.17.13.45.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 13:45:19 -0700 (PDT)
Message-ID: <c0a3e8d3c1313810606f5a1f9fb8d0c4be322a51.camel@redhat.com>
Subject: Re: [PATCH 8/8] ceph: return -EIO if read/write against filp that
 lost file locks
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Date:   Mon, 17 Jun 2019 16:45:17 -0400
In-Reply-To: <CA+2bHPZBy8pFkhvSRnjBzD4dosP2E-n_hNWHXJxQPDqch=+y0Q@mail.gmail.com>
References: <20190617125529.6230-1-zyan@redhat.com>
         <20190617125529.6230-9-zyan@redhat.com>
         <CA+2bHPZBy8pFkhvSRnjBzD4dosP2E-n_hNWHXJxQPDqch=+y0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-06-17 at 13:32 -0700, Patrick Donnelly wrote:
> On Mon, Jun 17, 2019 at 5:56 AM Yan, Zheng <zyan@redhat.com> wrote:
> > After mds evicts session, file locks get lost sliently. It's not safe to
> > let programs continue to do read/write.
> 
> I think one issue with returning EIO on a file handle that did hold a
> lock is that the application may be programmed to write to other files
> assuming that lock is never lost, yes? In that case, it may not ever
> write to the locked file in any case.
> 

Sure, applications do all sorts of crazy things. We can only cater to so
much craziness. I'll assert that most applications don't have these
sorts of weirdo usage patterns, and an error on read/write is more
reasonable.

Note that this behavior is already documented in fcntl(2) as well, as is
SIGLOST not being implemented.

> Again, I'd like to see SIGLOST sent to the application here. Are there
> any objections to reviving whatever patchset was in flight to add
> that? Or just writeup a new one?
> 

I think SIGLOST's utility is somewhat questionable. Applications will
need to be custom-written to handle it. If you're going to do that, then
it may be better to consider other async notification mechanisms.
inotify or fanotify, perhaps? Those may be simpler to implement and get
merged.
-- 
Jeff Layton <jlayton@redhat.com>

