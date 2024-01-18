Return-Path: <ceph-devel+bounces-581-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F14583169A
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 11:24:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D06B1F22D26
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jan 2024 10:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D04D208AE;
	Thu, 18 Jan 2024 10:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A54lbX7X"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648CC2033F
	for <ceph-devel@vger.kernel.org>; Thu, 18 Jan 2024 10:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573477; cv=none; b=tgyNRTa9ghhngTz6H8m0E25KFzs3osJGMJ/ksVb6pTJh3egSBpBtG3dzO93u71CZUb+9kezB1I9cRkYT2jp1pF7F2teEtnGtOsWP2tzJhdo5HHQfVXJddq049KNL/EeokqsXP4uXDjZj8F5U3gr+Mvm3NeQ3GCFmJLAVee5rlts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573477; c=relaxed/simple;
	bh=9i9pPWAGpxsejIMz6N9DNbq6SwsWgav1KMPUAAf3TOQ=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=Jik6yTEkO5Lhe9al6fM5bTMP2qlADKpNMB2S5VgTvq/6oofD/ABiO54rb2VwmSYPdSQGkw61wIcNnVgmCUQR27KzzkH4QMi/lPNGZo8Rn+vNUJTKPn6Ef5sqqsup2o4y2rGytUaJ6k2vkWh4bSJ6Ap6W4H/WP2qoG8ErbjSa/GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A54lbX7X; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2108bbf0040so1615263fac.0
        for <ceph-devel@vger.kernel.org>; Thu, 18 Jan 2024 02:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705573475; x=1706178275; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCRxf5YGw/gFA/M3XVrR5YK8BW0qK1AXF6XTKoNzxnI=;
        b=A54lbX7XDgO9diZQSC3pPZEEp1gtahD++AY83fUpHACW9OI4jZdJLrfpE0LgNB86Cx
         sflW2Qty7TjrDoy5HHjviD6aXJJrYY795TW0ThKJjf+gjQ2b5QEXBCdpWyD37/gpswmQ
         AhfMzZUBry3kjEDEzZntc3KXvR6/uZfieWMGW36bvSpVJqx9a5qgyl2K151yj/RxIYb+
         PKpiFXb5DwOxZWLQdrGO36SwaCK3WSycLwkJCCHgQMvXAE+vJqbiRbXFiu7t6PqX+zji
         P1uM1pUPx2MytaFsvBEXNwl27mxAeABdxv1FEtZya+8FuKdHA6ao96K6yBtmG68mpfFx
         Uv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705573475; x=1706178275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCRxf5YGw/gFA/M3XVrR5YK8BW0qK1AXF6XTKoNzxnI=;
        b=qxIgT9Fx1+sDM++0C/cnFCHTFo0LYpqIrHhtBydJjZKMF8wJii2J+UIlFZKqYMDnpc
         aGjuRpXqsRkNorCg1K1IakC7+qMoPZILhGXAIzcNHriskgBMdD/xHreE0K9ct8G0Lwz7
         bPKUfGU215UM68nJo/KoVQWvOvDzOgY4ym87R8VYZCIIBJc//M+mvALGmVXmUkFiMp3o
         osCaFuQPSjATMPkzBgHZQeRZ0WArFjH3mzF8y2BNhsLFWZ4pXNvjwOW+whLUGkj/K+gd
         oOwtp2KS3qzl1VgQdycrI/plTB55Xcibx2prNkChxJiPFqYWwYClPR4nGuBaofypkwbF
         u6GA==
X-Gm-Message-State: AOJu0YwVPMdVUBmkYWygLxAkB+uHfF8KUbulb6h7agYMaAIXkznEb0lN
	8M+BoYv3cYkILxN+oMKmphg1hCIi66ZOFMyyTNBFFQldnPkMN/PcvVnsi5DO8ZOD2AqFLm/Niwf
	WqNrDPVEZWiUf4uXcUeNeRLDr1xQWvbcdDdk=
X-Google-Smtp-Source: AGHT+IE0buuJY4Qv+Lrs7PDCqQlJKbMPoU7uyxTcGDW9JlGv+bXT0HYFy2ITlYrBXUcQeSWFLSOQnYBIlmEwvW1p2BE=
X-Received: by 2002:a05:6870:7246:b0:203:d7a8:b4ff with SMTP id
 y6-20020a056870724600b00203d7a8b4ffmr490310oaf.33.1705573475358; Thu, 18 Jan
 2024 02:24:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240117183542.1431147-1-idryomov@gmail.com> <88e01e98-6e1b-446f-7d23-a576a2b5f890@easystack.cn>
In-Reply-To: <88e01e98-6e1b-446f-7d23-a576a2b5f890@easystack.cn>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 18 Jan 2024 11:24:23 +0100
Message-ID: <CAOi1vP8qAN3JivSUaqjNODRLQqhcYDg1w-ByKgHcdStNjP_-Jg@mail.gmail.com>
Subject: Re: [PATCH] rbd: don't move requests to the running list on errors
To: Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc: ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 18, 2024 at 4:13=E2=80=AFAM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
>
> =E5=9C=A8 2024/1/18 =E6=98=9F=E6=9C=9F=E5=9B=9B =E4=B8=8A=E5=8D=88 2:35, =
Ilya Dryomov =E5=86=99=E9=81=93:
> > The running list is supposed to contain requests that are pinning the
> > exclusive lock, i.e. those that must be flushed before exclusive lock
> > is released.  When wake_lock_waiters() is called to handle an error,
> > requests on the acquiring list are failed with that error and no
> > flushing takes place.  Briefly moving them to the running list is not
> > only pointless but also harmful: if exclusive lock gets acquired
> > before all of their state machines are scheduled and go through
> > rbd_lock_del_request(), we trigger
> >
> >      rbd_assert(list_empty(&rbd_dev->running_list));
> >
> > in rbd_try_acquire_lock().
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 637cd060537d ("rbd: new exclusive lock wait/wake code")
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >   drivers/block/rbd.c | 22 ++++++++++++++--------
> >   1 file changed, 14 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 63897d0d6629..12b5d53ec856 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -3452,14 +3452,15 @@ static bool rbd_lock_add_request(struct rbd_img=
_request *img_req)
> >   static void rbd_lock_del_request(struct rbd_img_request *img_req)
> >   {
> >       struct rbd_device *rbd_dev =3D img_req->rbd_dev;
> > -     bool need_wakeup;
> > +     bool need_wakeup =3D false;
> >
> >       lockdep_assert_held(&rbd_dev->lock_rwsem);
> >       spin_lock(&rbd_dev->lock_lists_lock);
> > -     rbd_assert(!list_empty(&img_req->lock_item));
> > -     list_del_init(&img_req->lock_item);
> > -     need_wakeup =3D (rbd_dev->lock_state =3D=3D RBD_LOCK_STATE_RELEAS=
ING &&
> > -                    list_empty(&rbd_dev->running_list));
> > +     if (!list_empty(&img_req->lock_item)) {
> > +             list_del_init(&img_req->lock_item);
> > +             need_wakeup =3D (rbd_dev->lock_state =3D=3D RBD_LOCK_STAT=
E_RELEASING &&
> > +                            list_empty(&rbd_dev->running_list));
> > +     }
> >       spin_unlock(&rbd_dev->lock_lists_lock);
> >       if (need_wakeup)
> >               complete(&rbd_dev->releasing_wait);
> > @@ -3842,14 +3843,19 @@ static void wake_lock_waiters(struct rbd_device=
 *rbd_dev, int result)
> >               return;
> >       }
> >
> > -     list_for_each_entry(img_req, &rbd_dev->acquiring_list, lock_item)=
 {
> > +     while (!list_empty(&rbd_dev->acquiring_list)) {
> > +             img_req =3D list_first_entry(&rbd_dev->acquiring_list,
> > +                                        struct rbd_img_request, lock_i=
tem);
> >               mutex_lock(&img_req->state_mutex);
> >               rbd_assert(img_req->state =3D=3D RBD_IMG_EXCLUSIVE_LOCK);
> > +             if (!result)
> > +                     list_move_tail(&img_req->lock_item,
> > +                                    &rbd_dev->running_list);
> > +             else
> > +                     list_del_init(&img_req->lock_item);
> >               rbd_img_schedule(img_req, result);
> >               mutex_unlock(&img_req->state_mutex);
> >       }
> > -
> > -     list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running=
_list);
>
> Hi Ilya,
>         If we dont move these requests to ->running_list, then the need_w=
akeup
> is always false for these requests. So who will finally complete the
> &rbd_dev->releaseing_wait ?

Hi Dongsheng,

These requests are woken up explicitly in rbd_img_schedule().  Because
img_req->work_result would be set to an error, the state machine would
finish immediately on:

    case RBD_IMG_EXCLUSIVE_LOCK:
            if (*result)
                    return true;

rbd_dev->releasing_wait doesn't need to be completed in this case
because these requests are terminated while still on the acquiring
list.  Waiting for their state machines to get scheduled just to hit
that "if (*result)" check and bail isn't necessary.

Thanks,

                Ilya

