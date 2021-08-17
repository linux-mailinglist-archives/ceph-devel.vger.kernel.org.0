Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B8A3EF128
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 19:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbhHQR5F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 13:57:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36478 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232281AbhHQR5B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 13:57:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629222986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=27oDLPY3NUsvERqqixFQFD/1qN6q/FDchKuVaFziu4w=;
        b=UFqinM30h3vT55gczyAc2nK8BeTdcte4J5ndYs6rx0hdlrWuy6L27nl/EqFi5la5cELa+u
        JvFP/fOE1J1z0iIpW/0JV/xN7bzcFFe5S3xbmVOGfuXHt11VgYTmumkjSaAiJdxff506In
        q2rhd7maORfaICguk5KqHEPX0RlOAHk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-jjxUyQPSOauDM0GsMnzHgg-1; Tue, 17 Aug 2021 13:56:25 -0400
X-MC-Unique: jjxUyQPSOauDM0GsMnzHgg-1
Received: by mail-qk1-f198.google.com with SMTP id d202-20020a3768d3000000b003d30722c98fso6882043qkc.10
        for <ceph-devel@vger.kernel.org>; Tue, 17 Aug 2021 10:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=27oDLPY3NUsvERqqixFQFD/1qN6q/FDchKuVaFziu4w=;
        b=PTQRzVbzkwFZpC0+iig4WhHiYF5yyyh1G8m/6jSoy7e/xmidjbXCeFg/CnC4z1QvKp
         VWg8hjDcwOVP19fIzOAZYHBZu0ZWArsV4vFWfA9AB7WgeIK5GpegUVE+6NeRIVcyOJmY
         ukF55IZVZdceJcUPon81XCnVlzgh61PVUFsr/yLw9Ykg2lpKRYh9qTLhNQAXuVnbOYyQ
         GoCMgVlIGzLeFRWPn/KPZiL0oVeV1HFnHHhOozwU42BI6dRQ6dzcOlNwxCN2wRKkf75G
         Pq6i8ch/VFe5NacRUH+UjmaxZUf4vXC6RHPvpJSbL5wL96cMLBGYGcTr7mB9ahbRkY+S
         Byug==
X-Gm-Message-State: AOAM533bWsauMOy5fE5T7n2dh4IHAHvlUOmiBDP023xFVJEChT2uP1RW
        IeoZZRaQrgHILH4cquKnYFdjGO0Q4u+944wBTWQIM6UgduHrbLdtL357LST5/RDYahYShWoYy2Z
        9UeWSKxi6WgOaqAysuhijpqVmhDTIZst8QgqnYA==
X-Received: by 2002:ac8:5d8d:: with SMTP id d13mr4190301qtx.386.1629222985058;
        Tue, 17 Aug 2021 10:56:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKbRpP6CTY/C2xKhdApxSqquuhTUkZjmLH7S5xPvcMTq7qEvTzky4MsosiqdemwnGL/3NagxoGvGaiApLKjcU=
X-Received: by 2002:ac8:5d8d:: with SMTP id d13mr4190269qtx.386.1629222984595;
 Tue, 17 Aug 2021 10:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210812041042.132984-1-xiubli@redhat.com> <bc940c0fe07921d6e63b4a2316e93d84c96da201.camel@kernel.org>
In-Reply-To: <bc940c0fe07921d6e63b4a2316e93d84c96da201.camel@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 17 Aug 2021 10:56:13 -0700
Message-ID: <CAJ4mKGb5oR-3mOKpoQ-d2aHbRhq0qMHm4gBCAqz-Lrm4n4kQgg@mail.gmail.com>
Subject: Re: [PATCH] ceph: try to reconnect to the export targets
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 16, 2021 at 5:06 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2021-08-12 at 12:10 +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > In case the export MDS is crashed just after the EImportStart journal
> > is flushed, so when a standby MDS takes over it and when replaying
> > the EImportStart journal the MDS will wait the client to reconnect,
> > but the client may never register/open the sessions yet.
> >
> > We will try to reconnect that MDSes if they're in the export targets
> > and in RECONNECT state.
> >
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/mds_client.c | 58 +++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 57 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 14e44de05812..7dfe7a804320 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -4182,13 +4182,24 @@ static void check_new_map(struct ceph_mds_clien=
t *mdsc,
> >                         struct ceph_mdsmap *newmap,
> >                         struct ceph_mdsmap *oldmap)
> >  {
> > -     int i;
> > +     int i, err;
> > +     int *export_targets;
> >       int oldstate, newstate;
> >       struct ceph_mds_session *s;
> > +     struct ceph_mds_info *m_info;
> >
> >       dout("check_new_map new %u old %u\n",
> >            newmap->m_epoch, oldmap->m_epoch);
> >
> > +     m_info =3D newmap->m_info;
> > +     export_targets =3D kcalloc(newmap->possible_max_rank, sizeof(int)=
, GFP_NOFS);
> > +     if (export_targets && m_info) {
> > +             for (i =3D 0; i < m_info->num_export_targets; i++) {
> > +                     BUG_ON(m_info->export_targets[i] >=3D newmap->pos=
sible_max_rank);
>
> In general, we shouldn't BUG() in response to bad info sent by the MDS.
> It would probably be better to check these values in
> ceph_mdsmap_decode() and return an error there if it doesn't look right.
> That way we can just toss out the new map instead of crashing.

While I agree we don=E2=80=99t want to crash on unexpected input from the
network, if we are tossing out a map we need to shut down the mount as
well. If we think the system metadata is invalid, that=E2=80=99s not really=
 a
recoverable condition and continuing to do IO is a mistake from the
whole-system perspective =E2=80=94 either the server has failed horribly or
there=E2=80=99s something the client doesn=E2=80=99t understand which may b=
e critical
to correctness; either way there's a big problem with the basic system
operation. (I mean, if we hit this point obviously the server has
failed horribly since we should have gated it, but it may have failed
horribly in some non-code-logic fashion.)
-Greg

>
> > +                     export_targets[m_info->export_targets[i]] =3D 1;
> > +             }
> > +     }
> > +
> >       for (i =3D 0; i < oldmap->possible_max_rank && i < mdsc->max_sess=
ions; i++) {
> >               if (!mdsc->sessions[i])
> >                       continue;
> > @@ -4242,6 +4253,8 @@ static void check_new_map(struct ceph_mds_client =
*mdsc,
> >               if (s->s_state =3D=3D CEPH_MDS_SESSION_RESTARTING &&
> >                   newstate >=3D CEPH_MDS_STATE_RECONNECT) {
> >                       mutex_unlock(&mdsc->mutex);
> > +                     if (export_targets)
> > +                             export_targets[i] =3D 0;
> >                       send_mds_reconnect(mdsc, s);
> >                       mutex_lock(&mdsc->mutex);
> >               }
> > @@ -4264,6 +4277,47 @@ static void check_new_map(struct ceph_mds_client=
 *mdsc,
> >               }
> >       }
> >
> > +     for (i =3D 0; i < newmap->possible_max_rank; i++) {
>
> The condition on this loop is slightly different from the one below it,
> and I'm not sure why. Should this also be checking this?
>
>     i < newmap->possible_max_rank && i < mdsc->max_sessions
>
> ...do we need to look at export targets where i >=3D mdsc->max_sessions ?
>
> > +             if (!export_targets)
> > +                     break;
> > +
> > +             /*
> > +              * Only open and reconnect sessions that don't
> > +              * exist yet.
> > +              */
> > +             if (!export_targets[i] || __have_session(mdsc, i))
> > +                     continue;
> > +
> > +             /*
> > +              * In case the export MDS is crashed just after
> > +              * the EImportStart journal is flushed, so when
> > +              * a standby MDS takes over it and is replaying
> > +              * the EImportStart journal the new MDS daemon
> > +              * will wait the client to reconnect it, but the
> > +              * client may never register/open the sessions
> > +              * yet.
> > +              *
> > +              * It will try to reconnect that MDS daemons if
> > +              * the MDSes are in the export targets and is the
> > +              * RECONNECT state.
> > +              */
> > +             newstate =3D ceph_mdsmap_get_state(newmap, i);
> > +             if (newstate !=3D CEPH_MDS_STATE_RECONNECT)
> > +                     continue;
> > +             s =3D __open_export_target_session(mdsc, i);
> > +             if (IS_ERR(s)) {
> > +                     err =3D PTR_ERR(s);
> > +                     pr_err("failed to open export target session, err=
 %d\n",
> > +                            err);
> > +                     continue;
> > +             }
> > +             dout("send reconnect to target mds.%d\n", i);
> > +             mutex_unlock(&mdsc->mutex);
> > +             send_mds_reconnect(mdsc, s);
> > +             mutex_lock(&mdsc->mutex);
> > +             ceph_put_mds_session(s);
>
> Suppose we end up in this part of the code, and we have to drop the
> mdsc->mutex like this. What ensures that an earlier session in the array
> won't end up going back into CEPH_MDS_STATE_RECONNECT before we can get
> into the loop below? This looks racy.
>
> > +     }
> > +
> >       for (i =3D 0; i < newmap->possible_max_rank && i < mdsc->max_sess=
ions; i++) {
> >               s =3D mdsc->sessions[i];
> >               if (!s)
> > @@ -4278,6 +4332,8 @@ static void check_new_map(struct ceph_mds_client =
*mdsc,
> >                       __open_export_target_sessions(mdsc, s);
> >               }
> >       }
> > +
> > +     kfree(export_targets);
> >  }
> >
> >
>
> --
> Jeff Layton <jlayton@kernel.org>
>

