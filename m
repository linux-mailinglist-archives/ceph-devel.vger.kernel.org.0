Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C0AAFDC6
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 15:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfIKNdg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 09:33:36 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39920 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbfIKNdf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Sep 2019 09:33:35 -0400
Received: by mail-io1-f66.google.com with SMTP id d25so45828472iob.6
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2019 06:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Xoo6l4F2Pk5XEf9omz9OQQmWDtqGeVytsL5N6pgpho=;
        b=EiOgxOx+k3kL7A75YeUxfZvJx2QrWIsicTmrAVnD2KdX9HicA66s7fxMfGt851qo7r
         dtYClJn/IG95ITAvXlz9LTydz1JJz9gBj2I2dVWnU7idXvea2PMJt8s82YeBLEvlq/3a
         NuvRtydDQeOsHk7XPAMW+AcLpUivIO2K4lCSsBDL6bcm2nkCBRlDEVOYqTORZ3YyPds7
         ZLtv/0V6gKD78fhQxO9Wfgwpy8I20bBB+/mo3tGYMA8fJvY6f/jFhLpyiktA+IGBQ94R
         yhL5WU7obe26nHYcIwhLA39Vq+dNLfg8qNFClR0G8LBX0at86pCBWUq9z8fOC8ehkaAg
         gIkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Xoo6l4F2Pk5XEf9omz9OQQmWDtqGeVytsL5N6pgpho=;
        b=JJ/F5C3juR3Iuka88xYQ5sktYoiZbgZdYtIdHR0N8H1XGjiSt8ehINuhEl/OdRjns3
         5kXv+enGisGahVvJvC2CRpSLUZn5RQ/iGvkXgdhaDXDvP16s1vNjX6Vm4f8Ae0/n5s0n
         VnFYuzYPlLoP1/zxFJgiXn9Uergg3ClR4Jqocc1obEiFaTziZAknP/UKsxyyFHL+HxRP
         cZiMVRvSeEBUWoCMOKuR0/kg8odo7zzEb8P9uU6uASIpraOFoGZGYlDogelJIFBSU0yC
         vpSMa57fY7oF8Y4C3DfTr//KHN3yfvFjYpM6Ei4b2dabm5w/6AkH9Csvrc41VdXaDV3J
         iP+A==
X-Gm-Message-State: APjAAAUyA33vpsE844y4gQxy44lHu2QM2aDJxmYMTwzvfK26yZ+ByuSc
        mwSjgZERvSgpVS7kYpIc5SY5g/PFu3cC5llewUXhHJjGzeU=
X-Google-Smtp-Source: APXvYqyAcfVVsHrTlbYH5NycgOJl3xLFYHeEtm+7tXGGqgKYHyMPykYdUUQZeoOcBKsXTyBOQ/nBnYdqC3jjsraF+v0=
X-Received: by 2002:a02:b882:: with SMTP id p2mr5670148jam.16.1568208813623;
 Wed, 11 Sep 2019 06:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190910151748.914-1-idryomov@gmail.com> <20190911063159.GA25496@infradead.org>
In-Reply-To: <20190911063159.GA25496@infradead.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 11 Sep 2019 15:33:27 +0200
Message-ID: <CAOi1vP-unOFL2RMweG9gjfSY=xrmED=0bJxd5H0KrKsMSiMdmA@mail.gmail.com>
Subject: Re: [PATCH] libceph: avoid a __vmalloc() deadlock in ceph_kvmalloc()
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 11, 2019 at 8:32 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Sep 10, 2019 at 05:17:48PM +0200, Ilya Dryomov wrote:
> > The vmalloc allocator doesn't fully respect the specified gfp mask:
> > while the actual pages are allocated as requested, the page table pages
> > are always allocated with GFP_KERNEL.  ceph_kvmalloc() may be called
> > with GFP_NOFS and GFP_NOIO (for ceph and rbd respectively), so this may
> > result in a deadlock.
> >
> > There is no real reason for the current PAGE_ALLOC_COSTLY_ORDER logic,
> > it's just something that seemed sensible at the time (ceph_kvmalloc()
> > predates kvmalloc()).  kvmalloc() is smarter: in an attempt to reduce
> > long term fragmentation, it first tries to kmalloc non-disruptively.
> >
> > Switch to kvmalloc() and set the respective PF_MEMALLOC_* flag using
> > the scope API to avoid the deadlock.  Note that kvmalloc() needs to be
> > passed GFP_KERNEL to enable the fallback.
>
> If you can please just stop using GFP_NOFS altogether and set
> PF_MEMALLOC_* for the actual contexts.

Hi Christoph,

ceph_kvmalloc() is indirectly called from dozens of places, everywhere
a new RPC message is allocated.  Some of them are used for client setup
and don't need a scope (GFP_KERNEL is fine), but the vast majority do.
I don't think wrapping each call is practical.

As for getting rid of GFP_NOFS and GFP_NOIO entirely (i.e. dropping the
gfp mask from all libceph APIs and using scopes instead), it's something
that I have had in the back of my head for a while now because we cheat
in a few places and hard-code GFP_NOIO as the lowest common denominator
instead of properly propagating the gfp mask.  It's more of a project
though, and won't be backportable.

Thanks,

                Ilya
