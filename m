Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0C73E95A3
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Aug 2021 18:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhHKQNr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Aug 2021 12:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhHKQNq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Aug 2021 12:13:46 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AA1C061765
        for <ceph-devel@vger.kernel.org>; Wed, 11 Aug 2021 09:13:22 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id i13so3395361ilm.11
        for <ceph-devel@vger.kernel.org>; Wed, 11 Aug 2021 09:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ijYECg5JNrlfPJSds+O5wiVbE6WGCsjwwXJz3O1we9g=;
        b=RTBKFHhz7zo7yV5ORdQNMFF6GNGnAmX+0iY9/mNITcgD0uly05O/w4b596g4jOZ5vC
         p3wkxa+GEXBidY/o3/FDOZy4tbYFaefrpdzMe6ZXxWckk+HH9524GXKTKhJ0meWMNMZ4
         GTlsA2KUC/wu9IJ13wMI5mAMcHWLi1RAXs8kkmbr6ZW57PqvfG6UWd6wRLjUYaINYh5L
         zLumlN4Ic9Yviw93J5AiUb8t5r7WjXiF+anUIgc92M4EFEAD8x6xEBVvrt0bEzg9swPi
         3bmQ1KB544R1QkwYRuzjuqDmBeilZ9pvIw9PA8U0QF8FsmZqUadcR9Np8izjTbBIk/V4
         CVrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ijYECg5JNrlfPJSds+O5wiVbE6WGCsjwwXJz3O1we9g=;
        b=IRpV/DHHZrXajntSrd3fy37A4BKO3XIt93Hkx7FnEb00FO9xO/O+/LHDfpriIf248Z
         optJz2P3tmlYOlhIGNBEW+7rUnMD14qdUM56NFhSdrKQ+/rLA8IkyF9dNwhPojYIUMCE
         MzNTc+EyXrZ1Ssf6UsDMgu/Qo3laB5+8a2F+6uMK4QMLwfdBzkqBxtrlHADH+v2p/AXY
         T9RdB0DkylVD4k02VF8/OfmzcUWiXk4jlZX9pSjGkUHll3tS0TTHqYWrG8evQIJ32Pmq
         L3gpghLGh+gyql/SLF3x/QFKWMuM+OZXN/i+fVce6bR7TEraB4KxGW71SOix6LiaEbZx
         zSkQ==
X-Gm-Message-State: AOAM532QewE6/UU/bM06nw9Wy8SII3uZI7hg4OjXRE+WUmlhbJoxXsIT
        aXDeFz2zUn80ytpFfmJw8ilVom4w/aOLHDrTLkg=
X-Google-Smtp-Source: ABdhPJxq/RwlQ9cZQpLE8fC2msOL69k1TgRxwqqRN7VdhUXh5X+LOE0jGS2RoLsgvSbtmH6YyqCt5dkGy6sqe54URps=
X-Received: by 2002:a05:6e02:108f:: with SMTP id r15mr545929ilj.281.1628698402286;
 Wed, 11 Aug 2021 09:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210811111927.8417-1-jlayton@kernel.org> <87o8a4qc8f.fsf@suse.de>
 <5b8b45707e019c16852b2aa8c9b8928fbdc60008.camel@kernel.org>
In-Reply-To: <5b8b45707e019c16852b2aa8c9b8928fbdc60008.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 11 Aug 2021 18:12:26 +0200
Message-ID: <CAOi1vP8PK1G7qi43Y4_FeL1uyKafCyMidepzZ+Z8FCcgLaxTRw@mail.gmail.com>
Subject: Re: [PATCH] ceph: remove dead code in ceph_sync_write
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Luis Henriques <lhenriques@suse.de>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 11, 2021 at 4:44 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2021-08-11 at 15:37 +0100, Luis Henriques wrote:
> > Jeff Layton <jlayton@kernel.org> writes:
> >
> > > We've already checked these flags near the top of the function and
> > > bailed out if either were set.
> >
> > The flags being checked at the top of the function are CEPH_OSDMAP_FULL
> > and CEPH_POOL_FLAG_FULL; here we're checking the *_NEARFULL flags.
> > Right?  (I had to look a few times to make sure my eyes were not lying.)
> >
> > Cheers,
>
> Oof. You're totally right. Dropping this patch!

But it would have made https://github.com/ceph/ceph/pull/42749
unfounded! ;)

Thanks,

                Ilya
