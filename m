Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0115EA0166
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2019 14:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfH1MPN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Aug 2019 08:15:13 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33817 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfH1MPN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Aug 2019 08:15:13 -0400
Received: by mail-qt1-f196.google.com with SMTP id a13so2713995qtj.1
        for <ceph-devel@vger.kernel.org>; Wed, 28 Aug 2019 05:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vBMZN702eMdAy0KjeaaJACmBGjmAAL5f64HvtbW1wAE=;
        b=DX+kjP4oKbxKX8KMgXnjNQVdAGxKXttN4XNdtobjeDUDavPrLid9vb53oVVvsb0pHE
         3e99tLORkHaPh+cPEBQMLoBTmkDd4KhtRVH9HwA+nvprOSi+FiNbkQ5+mKYCOjFFDo8m
         tZ+La9GwgiWahqjxHCNALbytzIowr2filPg5n5GkU1laLcd+zMPY7W/zjip8iZhVdpMe
         GpXiuT62rCQsApqNp7QodxlLFtqPTiHHelsKayC1wl1kilh3FNreiZqnPo4Y/pIxylIX
         u5icdIStkmScs+yTs7wvKMjAlclifOtBpjAZ+z1qqtOT9KOa42M/zVZLtX3gKqAldIAq
         Ee7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vBMZN702eMdAy0KjeaaJACmBGjmAAL5f64HvtbW1wAE=;
        b=jOuBSxk8O1FGP8CQ3HjgjgRYmuqLhg6GqtZgqyKv6pARht/S3cCPklmtW8urb6giwX
         nsi+k6Z2VFrSmOj3lv2GDdb/665MhFq7kHwFVnCJSkfkOe6ojok8bwj7hEKwld4D42Uc
         JVTXQNdhTFJ0X2IRfKoOsJgU1L0qndQF3V7Hb5zCfaLGxMmenMGkH8kUrilaAy7oOHP3
         8mZkc7vnOflbijZOgfZR3CY+ClVsq6FNjkBjwhY5yQbsDB0nT0egO8Kce7nug0ytovut
         rovV3uT/A2Dk7mfQW1dQUieH+qvTRGykrvNDxyLbmByGBDG7iZbqBXm7IOj2zdA4Rae4
         YPUA==
X-Gm-Message-State: APjAAAX9sWMDS5UB2bqcq8o/xi5Atq/Z89eRnSkXMANCuIXVvg0AVMt5
        4qbLRW9euniZ/fQj+ylQNnl2CL9M+OZbCUCxQVU=
X-Google-Smtp-Source: APXvYqxUA0j9ImZRfYx/dEsxNDzmwdj7W0RTBoOKiX9IFfQ+oV0Ym1Vv5PVwIniHJ3hlRlIKSc74DpkV23BrK324MnA=
X-Received: by 2002:a0c:e28e:: with SMTP id r14mr2428590qvl.32.1566994512121;
 Wed, 28 Aug 2019 05:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190828094855.49918-1-chenerqi@gmail.com> <c568f3b8453a55516dd13bfd617edb778a6f7b1c.camel@kernel.org>
In-Reply-To: <c568f3b8453a55516dd13bfd617edb778a6f7b1c.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 28 Aug 2019 20:14:57 +0800
Message-ID: <CAAM7YAkNmkMhuqU-xjNhBd5dx0RcjxKh4WHXkdazFn2t0BP7Zg@mail.gmail.com>
Subject: Re: [PATCH] ceph: reconnect connection if session hang in opening state
To:     Jeff Layton <jlayton@kernel.org>
Cc:     chenerqi@gmail.com, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 28, 2019 at 8:05 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2019-08-28 at 17:48 +0800, chenerqi@gmail.com wrote:
> > From: Erqi Chen <chenerqi@gmail.com>
> >
> > If client mds session is evicted in CEPH_MDS_SESSION_OPENING state,
> > mds won't send session msg to client, and delayed_work skip
> > CEPH_MDS_SESSION_OPENING state session, the session hang forever.
> > ceph_con_keepalive reconnct connection for CEPH_MDS_SESSION_OPENING
> > session to avoid session hang.
> >
> > Fixes: https://tracker.ceph.com/issues/41551
> > Signed-off-by: Erqi Chen chenerqi@gmail.com
> > ---
> >  fs/ceph/mds_client.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 920e9f0..eee4b63 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -4044,7 +4044,7 @@ static void delayed_work(struct work_struct *work)
> >                               pr_info("mds%d hung\n", s->s_mds);
> >                       }
> >               }
> > -             if (s->s_state < CEPH_MDS_SESSION_OPEN) {
> > +             if (s->s_state < CEPH_MDS_SESSION_OPENING) {
> >                       /* this mds is failed or recovering, just wait */
> >                       ceph_put_mds_session(s);
> >                       continue;
>
> Just for my own edification:
>
> OPENING == we've sent (or are sending) the session open request
> OPEN == we've gotten the reply from the MDS and it was successful
>
> So in this case, the client got blacklisted after sending the request
> but before the reply? Ok.
>
> So this should make it send a keepalive (or cap) message, at which point
> the client discovers the connection is closed and then goes to reconnect
> the session. This sounds sane to me, but I wonder if this would be
> better expressed as:
>
>     if (s->s_state == CEPH_MDS_SESSION_NEW)
>

should also avoid keepalive for CEPH_MDS_SESSION_RESTARTING and
CEPH_MDS_SESSION_REJECTED



> It always seems odd to me that we rely on the numerical values in this
> enum. That said, we do that all over the code, so I'm inclined to just
> merge this as-is (assuming Zheng concurs).
>
> --
> Jeff Layton <jlayton@kernel.org>
>
