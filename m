Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE24B76C56F
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Aug 2023 08:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjHBGmk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Aug 2023 02:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjHBGmj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Aug 2023 02:42:39 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414D53583
        for <ceph-devel@vger.kernel.org>; Tue,  1 Aug 2023 23:42:05 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9936b3d0286so991305066b.0
        for <ceph-devel@vger.kernel.org>; Tue, 01 Aug 2023 23:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690958523; x=1691563323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5FE5cbMIHJ4nI8wgZO61NH+kr/wLqTioCzP0BabbCQ=;
        b=dADZnJZMHJakwrkRYiBlDfO+/MkqYb4uZKdXyOKBxjhbBH8TeC4nUAeuqtBNDxq736
         BCR7YKLheZi/6fJ4hPhDlwGSynFuV+53uPWdWFUMTd325h9DQbepZ26ffy/d4Ers1ViI
         XaJX0hwxU/q99c+FgTJ2TFER7oQsrcFsNZ0L+bgd7laiFmjmHjj/2M4AtsxHG9QgWzeB
         NZkWjVrSBl+737nTDe6wI9sRvHYDIB325Yk3Ua/zdUcg1qvdbZzaUBVbu97KmeBNoqAo
         GrcSBE3ECbbsDomKNtZpowXv1XSI9eZgZw+eqy0xbSfrOX1Ov8PwS4cnEfYbv4n+F/VT
         oOyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690958523; x=1691563323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+5FE5cbMIHJ4nI8wgZO61NH+kr/wLqTioCzP0BabbCQ=;
        b=BsmVUgJpfVNHaC7mVM3FOZ7qwc7IfvZj9NFdsTJto984CR9jg/QOyCC/ww0QdP0+fA
         FpkacBAcnGloksKRIlVeLJP2xe86oEv/lsj+rwIE/f+0brRV+upSrxA9kgsurjlwKrZm
         iDDmSUYO9t34qet3MfG6Cp2ZONPSleiamhhKxkqpFSz5xFS3kYecDJhlLfofzXu4n8ey
         0Vy+LrKdzPPFGlW8RbSt59Xkl19HBCtirYDwejCAwYcRMvcS879huw2VvojUBhpaOOrU
         9Mc+oSwyjMmKcsNwzglKlgiwk2yZ3wtT/K7Im+SMSD+SIXq1OMiuKE7x5ilTe2PL3bLp
         GcGg==
X-Gm-Message-State: ABy/qLZw4GuZBVx3gHHsmAKqmkmBms74jHoMC8g/IIVKesBlVRzMOD/8
        QeBMVFql5fKkTYhfhTvPB5uhxDkKwIiGJPJ3ZfCA/ouzGQM=
X-Google-Smtp-Source: APBJJlEN8SL3vbJyaelAjAGLlpezF1BcxEByLwvXkPVbsELPnFSVDNq8NMGrOfVwYbPZIBmLIF0XiSxAHiCHoTetokY=
X-Received: by 2002:a17:906:31d2:b0:99b:cddb:cf42 with SMTP id
 f18-20020a17090631d200b0099bcddbcf42mr4070428ejf.69.1690958523134; Tue, 01
 Aug 2023 23:42:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230801222238.674641-1-idryomov@gmail.com> <99bdb9ff-be19-6f3c-6b6f-0423f3d12796@easystack.cn>
In-Reply-To: <99bdb9ff-be19-6f3c-6b6f-0423f3d12796@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 2 Aug 2023 08:41:51 +0200
Message-ID: <CAOi1vP9s_4j8QLBYRyCTi3XCKdPagtZusM=S+z7BJDbHAVye_Q@mail.gmail.com>
Subject: Re: [PATCH] rbd: prevent busy loop when requesting exclusive lock
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 2, 2023 at 8:36=E2=80=AFAM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
> Hi Ilya
>
> =E5=9C=A8 2023/8/2 =E6=98=9F=E6=9C=9F=E4=B8=89 =E4=B8=8A=E5=8D=88 6:22, I=
lya Dryomov =E5=86=99=E9=81=93:
> > Due to rbd_try_acquire_lock() effectively swallowing all but
> > EBLOCKLISTED error from rbd_try_lock() ("request lock anyway") and
> > rbd_request_lock() returning ETIMEDOUT error not only for an actual
> > notify timeout but also when the lock owner doesn't respond, a busy
> > loop inside of rbd_acquire_lock() between rbd_try_acquire_lock() and
> > rbd_request_lock() is possible.
> >
> > Requesting the lock on EBUSY error (returned by get_lock_owner_info()
> > if an incompatible lock or invalid lock owner is detected) makes very
> > little sense.  The same goes for ETIMEDOUT error (might pop up pretty
> > much anywhere if osd_request_timeout option is set) and many others.
> >
> > Just fail I/O requests on rbd_dev->acquiring_list immediately on any
> > error from rbd_try_lock().
> >
> > Cc: stable@vger.kernel.org # 588159009d5b: rbd: retrieve and check lock=
 owner twice before blocklisting
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >   drivers/block/rbd.c | 28 +++++++++++++++-------------
> >   1 file changed, 15 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 24afcc93ac01..2328cc05be36 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -3675,7 +3675,7 @@ static int rbd_lock(struct rbd_device *rbd_dev)
> >       ret =3D ceph_cls_lock(osdc, &rbd_dev->header_oid, &rbd_dev->heade=
r_oloc,
> >                           RBD_LOCK_NAME, CEPH_CLS_LOCK_EXCLUSIVE, cooki=
e,
> >                           RBD_LOCK_TAG, "", 0);
> > -     if (ret)
> > +     if (ret && ret !=3D -EEXIST)
> >               return ret;
> >
> >       __rbd_lock(rbd_dev, cookie);
>
> If we got -EEXIST here, we will call __rbd_lock() and return 0. -EEXIST
> means lock is held by myself, is that necessary to call __rbd_lock()?

Hi Dongsheng,

Yes, because the reason rbd_lock() gets called in the first place is
that the kernel client doesn't "know" that it's still holding the lock
in RADOS.  This can happen if the unlock operation times out, for
example.

Notice

        WARN_ON(__rbd_is_lock_owner(rbd_dev) ||
                rbd_dev->lock_cookie[0] !=3D '\0');

at the top of rbd_lock().

Thanks,

                Ilya
