Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F04188BF1
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Mar 2020 18:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgCQRYo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Mar 2020 13:24:44 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43897 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgCQRYo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Mar 2020 13:24:44 -0400
Received: by mail-io1-f66.google.com with SMTP id n21so21836718ioo.10
        for <ceph-devel@vger.kernel.org>; Tue, 17 Mar 2020 10:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yvYYNyiRGrsoBvBNihIBKmCQPNoL+g7y5TB55KeFFGI=;
        b=HfqLEVnMO5l3jXuV6hqkNmnJ3jPELI0iKnBjQ5kIyHX2piEGbnB+B2ZWVFrjhypYKy
         us/IHeaXGdIoMCvoV+8Zqmnu95PkDN7xd40r33fqcolUxXe0/ATwJf9+siU8ii1iaLHz
         /H/SiSiDiit3YMePmRqQQAB21Q1/EFWNhD5J9YRm+hDNnHNj9F7yqPiFEAPHlusqFRY4
         KUHRZPaVU44F7yRb80x6Z6TjfYoL+gPMnk19XDr5ZgvSp13HjpjfWisZER+R5846Ce7N
         CT67Y91KbroeXAjlL5oXOYawgoazlSUtuwfFdVg8xKXN589i9AMP41gqXQyBYi0iccyk
         BA9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvYYNyiRGrsoBvBNihIBKmCQPNoL+g7y5TB55KeFFGI=;
        b=Wo/p3waCzJKOHChTTckyVz2lvaO43adOffSf7HcovDBfH+EqGAycWNknb/cmZj7PQi
         mMUybWVB1zj0naWMwihc24mYqLy4pQAYF7fpeo+zkQX3OmNPgZpmZ1HMuE1gpq+b/JtQ
         0yKy0k8Ji5W/0Gmhe+DuBXe2wPp5G/5/GCLE/GjHQ5I+py+AcddnXOdlZFxzyx9H9vEu
         EMfZL7AjBaIoSe2GTUDJzY3+H2Cfp/V5xlCIKYPGDGywTMaUh0qOIyIjPIRNRoZM+CWp
         fAN3flNkOpXLNzbpeV0GPabazZdzxsWBNRTbRgBNQMc3pXeDLFT8EAUl58OcAqDwyJM0
         PkKw==
X-Gm-Message-State: ANhLgQ22i4XcIO92WRDEvjG4LuPpFZZgxzZKyT0ANR8Q7OuyccG7oERg
        HY9I1zIl2Q6OAox/EsNg0S/TPLlyd413QtgyS50=
X-Google-Smtp-Source: ADFU+vts6DWYL0TLrW95H+IOx5RR8zRuQms9JxuddzJsDH/nbLfeg3rFByqAA+FjVh1+2q9Ticj51MG+umewEoxrvH4=
X-Received: by 2002:a02:cc45:: with SMTP id i5mr413001jaq.96.1584465883054;
 Tue, 17 Mar 2020 10:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200317120422.3406-1-idryomov@gmail.com> <CA+aFP1DkGftqkWF6_g6Op0prYBXgv50ynfsG=yyCinLDm++uRg@mail.gmail.com>
In-Reply-To: <CA+aFP1DkGftqkWF6_g6Op0prYBXgv50ynfsG=yyCinLDm++uRg@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 17 Mar 2020 18:24:47 +0100
Message-ID: <CAOi1vP-LJPzywiFb1pyXpdFRCO0UVom8N_xCx0qQb=+oU_Q4pw@mail.gmail.com>
Subject: Re: [PATCH 0/3] rbd: fix some issues around flushing notifies
To:     Jason Dillaman <dillaman@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 17, 2020 at 5:41 PM Jason Dillaman <jdillama@redhat.com> wrote:
>
> On Tue, Mar 17, 2020 at 8:06 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > Hello,
> >
> > A recent snapshot-based mirroring experiment exposed a deadlock on
> > header_rwsem in the error path of rbd_dev_image_probe() (i.e. "rbd
> > map").
> >
> > Thanks,
> >
> >                 Ilya
> >
> >
> > Ilya Dryomov (3):
> >   rbd: avoid a deadlock on header_rwsem when flushing notifies
> >   rbd: call rbd_dev_unprobe() after unwatching and flushing notifies
> >   rbd: don't test rbd_dev->opts in rbd_dev_image_release()
> >
> >  drivers/block/rbd.c | 23 ++++++++++++++---------
> >  1 file changed, 14 insertions(+), 9 deletions(-)
> >
> > --
> > 2.19.2
> >
>
> The "get_snapcontext" call still going to hang (albeit in an
> interruptible state) if the image has > 510 snapshots, correct?

Yes, this has been a limitation of the messenger and its interface
since day one.  This is a krbd ticket specifically about snapshots,
but this limitation affects a lot more than that:

  https://tracker.ceph.com/issues/12874

It is engraved pretty deeply, but I'm planning to address it while
the messenger is opened up for surgery.

Thanks,

                Ilya
