Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1832199805
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Mar 2020 16:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbgCaOBA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 31 Mar 2020 10:01:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44728 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730818AbgCaOBA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 31 Mar 2020 10:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585663259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p6FNSkvs5rUGfPPHw8ymoaTWyaNJARfFJ0GlEo0pJI4=;
        b=Xt+ZqwfbEYO8jXXsmH8/ASS4TCM6s7EvpQfeOHQZp9hR/36hhYr88dJbK4fXZoERZ3x12n
        pLxC4FO1ojSjs6yfDm0hmUh2qm99W08lI2V/6Cqs4M5GmsG0K4ipKrw3uJqY5/V1aL2ZrD
        f/bxEOpKR5Kin35ujTkLbc9QyKqMqzg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-JO1cfqJ6MnmRqcjIRsP33w-1; Tue, 31 Mar 2020 10:00:55 -0400
X-MC-Unique: JO1cfqJ6MnmRqcjIRsP33w-1
Received: by mail-qt1-f198.google.com with SMTP id f7so18016471qtq.3
        for <ceph-devel@vger.kernel.org>; Tue, 31 Mar 2020 07:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p6FNSkvs5rUGfPPHw8ymoaTWyaNJARfFJ0GlEo0pJI4=;
        b=EStkqsW6ok+WxcyiRdG83wzlgxKtV461HvfQSPWAMSTUH1+pmsg/sd9uIaGVf/faDE
         CAPwwxmlRfHD/U38qR6/GHSBBuueNRDVNnbSYpyUvcTgyfYAMezIcJLs1C1Mus2DSkbR
         J+149aX/2V+d8NM8lXNd9rrAgu0GyP5yx9ju4ub94/UY8AUdQRACozIJUxDSHW6D37l6
         UyisfX1DbhbeF+9+H/G5IHzWmZodcqNmp7/a1sjjXtydhB5xVtyZ42Poy/2QSvD9iOCa
         PHHCz54iVvsGVq+I4HVhnKOqK2aSlCnKUhiK03ecnWUQYyjUTC/7G3VmNvNBSwlBPjwi
         R4dg==
X-Gm-Message-State: ANhLgQ3H7S83oatC6POsY22sovVcRFz4Am+q7K0A4StUs2NtIJbqIFyt
        BjOco8GwmrH+JloZnruDnPB1hTzlrdYsYKxj64Eb45y8N0ICkhdGX99+99TwCeOvJiix3LVGVcf
        M5rgLJN4OJ+v3sb78X5STI4qF9oHX/xC3iqqEvg==
X-Received: by 2002:ac8:31af:: with SMTP id h44mr5055738qte.252.1585663252940;
        Tue, 31 Mar 2020 07:00:52 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu5rQdU4/iPAhGX0Rw6uQRrtxTtP3jEvTfDgJcDPfW1Q+L9k/o/PiO4WvLJKinCTs9B+v7/hcloBRWwnNhREIA=
X-Received: by 2002:ac8:31af:: with SMTP id h44mr5055495qte.252.1585663250534;
 Tue, 31 Mar 2020 07:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200331105223.9610-1-jlayton@kernel.org> <CAAM7YAmzyYrREBtmX+JrEQMMuo9LhZ2J2c-PyahQaAiVVEn2fQ@mail.gmail.com>
In-Reply-To: <CAAM7YAmzyYrREBtmX+JrEQMMuo9LhZ2J2c-PyahQaAiVVEn2fQ@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 31 Mar 2020 07:00:39 -0700
Message-ID: <CAJ4mKGbMgoQ6tgsiQchR2QirxOW_oPOuNo5X26YKpy66yHD+FA@mail.gmail.com>
Subject: Re: [PATCH] ceph: request expedited service when flushing caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Jan Fajerski <jfajerski@suse.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 31, 2020 at 6:49 AM Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Tue, Mar 31, 2020 at 6:52 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > Jan noticed some long stalls when flushing caps using sync() after
> > doing small file creates. For instance, running this:
> >
> >     $ time for i in $(seq -w 11 30); do echo "Hello World" > hello-$i.txt; sync -f ./hello-$i.txt; done
> >
> > Could take more than 90s in some cases. The sync() will flush out caps,
> > but doesn't tell the MDS that it's waiting synchronously on the
> > replies.
> >
> > When ceph_check_caps finds that CHECK_CAPS_FLUSH is set, then set the
> > CEPH_CLIENT_CAPS_SYNC bit in the cap update request. This clues the MDS
> > into that fact and it can then expedite the reply.
> >
> > URL: https://tracker.ceph.com/issues/44744
> > Reported-and-Tested-by: Jan Fajerski <jfajerski@suse.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/caps.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 61808793e0c0..6403178f2376 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -2111,8 +2111,11 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >
> >                 mds = cap->mds;  /* remember mds, so we don't repeat */
> >
> > -               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> > -                          retain, flushing, flush_tid, oldest_flush_tid);
> > +               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE,
> > +                          (flags & CHECK_CAPS_FLUSH) ?
> > +                           CEPH_CLIENT_CAPS_SYNC : 0,
> > +                          cap_used, want, retain, flushing, flush_tid,
> > +                          oldest_flush_tid);
> >                 spin_unlock(&ci->i_ceph_lock);
> >
>
> this is too expensive for syncfs case. mds needs to flush journal for
> each dirty inode.  we'd better to track dirty inodes by session, and
> only set the flag when flushing the last inode in session dirty list.

Yeah, see the userspace Client::_sync_fs() where we have an internal
flags argument which is set on the last cap in the dirty set and tells
the actual cap message flushing code to set FLAG_SYNC on the
MClientCaps message. I presume the kernel is operating on a similar
principle here?
-Greg


>
>
> >                 __send_cap(mdsc, &arg, ci);
> > --
> > 2.25.1
> >
>

