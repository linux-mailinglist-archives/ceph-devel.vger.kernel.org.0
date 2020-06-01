Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7271EA27F
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jun 2020 13:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgFALON (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jun 2020 07:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgFALOK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jun 2020 07:14:10 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3694C061A0E
        for <ceph-devel@vger.kernel.org>; Mon,  1 Jun 2020 04:14:10 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 18so8935590iln.9
        for <ceph-devel@vger.kernel.org>; Mon, 01 Jun 2020 04:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JARlygIbOmoA2KXZBuj07+8dgxoXzn3qZ/uyTbghdrQ=;
        b=f00pXois8MGFeJohr+uSJaf+ce6JSwUNwoeZFoCYH0XvnQZbquTA35sVpTfw0rrVVB
         V0E6SFq2cU/QLHWpYOqeJvluY2Uk021qeuWaYhfgKJ4tMLs2L8JynX7EMVyfP7Rwr21Q
         B/5ZAL9rXlAlVUWUVC1Z6qgefCzgfof58g3gzwQcPQYYRHgU0kN5E7amUcG8eCx3LXq1
         luKZZHGLYd0SALNB6rbMGqgh1zxXobvWzUnqlfXdV7WTn81fJGz8d6G8KiNeL3eGcjvB
         dWSDTQLz1D7bu3dJI4YzTwjFC+3Zbw0mCDThVJvDJf1McSvI4l6hZUid5SLX7mEvQafp
         2Zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JARlygIbOmoA2KXZBuj07+8dgxoXzn3qZ/uyTbghdrQ=;
        b=ltnZrwNiuqpouVuyNAuG/q627CAqUBfQcIsgSSUVNZu3oaYqoZkRVJl2+QtiBdIm9G
         oO8n237+Bx1J1z1i+aoPzPE2DInV7501uQNd6wd3ScOicbSZANXRLcdzkADhQQd3vIt4
         HxjYMCK6WPyxsK2fxqXmM/GkGl+GiZ8C9mgSN44zW7PPrJk3kozlvKgdNRNFdluV1VBN
         RW/mi6x1D9i0VL4D40RcEbTHQY4zqlEBQL3jKV1PBVRGi5gu1cc+eW5k/lVXr26H2sD7
         WACa8ZXOEAm2TeN5MMU5GWWJ867R6GG6024UzNOMxq1drGDVzy0Mtnc1nxIkeqGSRmbz
         Pvxg==
X-Gm-Message-State: AOAM533SCxUJnyj+sTYkoHNyfN31bp10k+jtirUnSiVUuKvCJPsKYR+D
        MJYAqYL4b5fOQuOpQTeot8xFJtfHjT6poOjWI2E=
X-Google-Smtp-Source: ABdhPJwDucwRFg3UJErFNtBCsxGhqrWB8ndR6cdoJmpdXtn66xwxR40GVdv/rVUKquRaBtUvCh47VSsFucB7619aYnc=
X-Received: by 2002:a92:cf09:: with SMTP id c9mr433727ilo.143.1591010050042;
 Mon, 01 Jun 2020 04:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200530153439.31312-1-idryomov@gmail.com> <20200530153439.31312-3-idryomov@gmail.com>
 <ce644470a74c0d7865ea92cdf29c13dbe609fca9.camel@kernel.org>
In-Reply-To: <ce644470a74c0d7865ea92cdf29c13dbe609fca9.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 1 Jun 2020 13:14:15 +0200
Message-ID: <CAOi1vP8aKTGi10K0jz-PUBtTiHMS453DANhfZSLPg4vVKndceQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] libceph: decode CRUSH device/bucket types and names
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 1, 2020 at 12:49 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Sat, 2020-05-30 at 17:34 +0200, Ilya Dryomov wrote:
> > These would be matched with the provided client location to calculate
> > the locality value.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  include/linux/crush/crush.h |  6 +++
> >  net/ceph/crush/crush.c      |  3 ++
> >  net/ceph/osdmap.c           | 85 ++++++++++++++++++++++++++++++++++++-
> >  3 files changed, 92 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/crush/crush.h b/include/linux/crush/crush.h
> > index 38b0e4d50ed9..29b0de2e202b 100644
> > --- a/include/linux/crush/crush.h
> > +++ b/include/linux/crush/crush.h
> > @@ -301,6 +301,12 @@ struct crush_map {
> >
> >       __u32 *choose_tries;
> >  #else
> > +     /* device/bucket type id -> type name (CrushWrapper::type_map) */
> > +     struct rb_root type_names;
> > +
> > +     /* device/bucket id -> name (CrushWrapper::name_map) */
> > +     struct rb_root names;
> > +
>
> I'm not as familiar with the OSD client-side code, but I don't see any
> mention of locking here. What protects these new rbtrees? From reading
> over the code, I'd assume the osdc->lock, but it might be nice to have a
> comment here that makes that clear.

Yes, everything osdmap and CRUSH (except for the actual invocation) is
protected by osdc->lock.  But these trees don't even need that -- they
are static and could be easily replaced with sorted arrays to save two
pointers per name.

Thanks,

                Ilya
