Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A946D3EF240
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 20:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhHQStA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 14:49:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233003AbhHQStA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 14:49:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629226106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WUZB5n8q8EAFTNFz5MVi46zJa+7kD8yj/EaRCpaPS74=;
        b=FPj+J527fhI/tImCRAUvVLILpHrjPeNfGPIp+yqWaZvVfPGMSE+rqDuchdTUNJe1vtrk1y
        MJgO5OS8NlVrrlb66VU85DXNQ/4G0ym0kepkTfTwFP7cIMld3wms9ntO2Mj4uwI9+txYo6
        KilHeydtBPSin1vl2o7NjZj1r9NmKdY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-k-RxKG2kMqScDOjoXVG7OQ-1; Tue, 17 Aug 2021 14:48:25 -0400
X-MC-Unique: k-RxKG2kMqScDOjoXVG7OQ-1
Received: by mail-qk1-f200.google.com with SMTP id b4-20020a3799040000b02903b899a4309cso16164133qke.14
        for <ceph-devel@vger.kernel.org>; Tue, 17 Aug 2021 11:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WUZB5n8q8EAFTNFz5MVi46zJa+7kD8yj/EaRCpaPS74=;
        b=ZH9nCTNwly7wSguDrIKdxD1mHZ5w53wwG88TYerbtqaMrOp30FphX7sPmm5f9kYXaX
         R+cO1DJP1EOy93G9SLS4k69jPR1L4SIAW1pqt4BWgqLkymF78rmZ80+bFaw5kPsjyTk3
         gy0wu/1zeDqWfhZwaKU3oM8qjBS6Q3mnXKi+UFbNFhTfRvdGZ//1aRn4n0tGUSLqO9Ys
         5ILF2mUZA/oca/V/m52URqR0L4o2ht2snvYq13EbuBUNj06bCKrTpo4TWvyNeXR8Elpg
         8TeD7OPCi3qlnUO0/u5dA4foB2sqjDy8gnR5nQ1FnoauTKZnTW1c+jr3/RYmaPwRFVjT
         nMMg==
X-Gm-Message-State: AOAM532oB1/tMBmUPblXG85UBPWNHApQUJJSI5/PoHqYcJzKniKjZQwu
        OkrRDL1bckd5y0MfXdvk6vbijpL3QZ4h8ZRi29vZAhCHeIAWnFNUtHFpOIsPKzhWDng85yMlq5I
        OOmTsHtMmP8xPdo9k182DnoAxnAijIxLBHu6yEw==
X-Received: by 2002:ad4:4973:: with SMTP id p19mr4846350qvy.30.1629226104786;
        Tue, 17 Aug 2021 11:48:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7JadxP2sxyqphEunzkYmnn09LU/0yS3olUqENio7cRzHj5zph/BWCNp9z5va9fUrUWeDRrkueSMxT22SqfpE=
X-Received: by 2002:ad4:4973:: with SMTP id p19mr4846309qvy.30.1629226104338;
 Tue, 17 Aug 2021 11:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210812041042.132984-1-xiubli@redhat.com> <bc940c0fe07921d6e63b4a2316e93d84c96da201.camel@kernel.org>
 <CAJ4mKGb5oR-3mOKpoQ-d2aHbRhq0qMHm4gBCAqz-Lrm4n4kQgg@mail.gmail.com> <6b29b8b523fa3e45635b02c455dfecd5a0cf9b88.camel@kernel.org>
In-Reply-To: <6b29b8b523fa3e45635b02c455dfecd5a0cf9b88.camel@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 17 Aug 2021 11:48:13 -0700
Message-ID: <CAJ4mKGZPvHCmda5=8vB+N5YU37zGGXwHTukGwAGaQrBRiAiPRA@mail.gmail.com>
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

On Tue, Aug 17, 2021 at 11:14 AM Jeff Layton <jlayton@kernel.org> wrote:
> On Tue, 2021-08-17 at 10:56 -0700, Gregory Farnum wrote:
> > While I agree we don=E2=80=99t want to crash on unexpected input from t=
he
> > network, if we are tossing out a map we need to shut down the mount as
> > well. If we think the system metadata is invalid, that=E2=80=99s not re=
ally a
> > recoverable condition and continuing to do IO is a mistake from the
> > whole-system perspective =E2=80=94 either the server has failed horribl=
y or
> > there=E2=80=99s something the client doesn=E2=80=99t understand which m=
ay be critical
> > to correctness; either way there's a big problem with the basic system
> > operation. (I mean, if we hit this point obviously the server has
> > failed horribly since we should have gated it, but it may have failed
> > horribly in some non-code-logic fashion.)
> > -Greg
> >
>
> I see this as essentially the same as any other parsing error in the
> mdsmap. When we hit one of those, we currently just do this:
>
>     pr_err("error decoding fsmap\n");
>
> ...and soldier on. It's been this way since the beginning, afaict.

Oh. That's, uh, interesting.
I mean, you're right, this case isn't any more special. I just didn't
know that's how the kernel client handles it. (The userspace client
inherits the usual userspace decode logic and any accompanying
asserts.)

> If we want to do something more involved there, then that could probably
> be done, but it's not as simple as throwing a switch. We may have open
> files and dirty data to deal with. We do have some code to deal with
> attempting to reconnect after a blacklist event, so you might be able to
> treat this similarly.

Hmm, my guess is this only happens if the MDS is spewing nonsense out
over its pipe, or we've made a logic error and let a client join
across a non-backwards-compatible encoding/feature change. I think we
probably just start throwing EIO and don't try to remount, rather than
going for anything more polite. *shrug*

> In any case, this would be a pretty unusual situation, and I don't see
> us having the manpower to spend on coding up an elegant solution to this
> potential problem anytime soon. It might be worth opening a tracker for
> it though if that changes in the future.

Makes sense. Ticket done: https://tracker.ceph.com/issues/52303
-Greg

>
>
> > >
> > > > +                     export_targets[m_info->export_targets[i]] =3D=
 1;
> > > > +             }
> > > > +     }
> > > > +
> > > >       for (i =3D 0; i < oldmap->possible_max_rank && i < mdsc->max_=
sessions; i++) {
> > > >               if (!mdsc->sessions[i])
> > > >                       continue;
> > > > @@ -4242,6 +4253,8 @@ static void check_new_map(struct ceph_mds_cli=
ent *mdsc,
> > > >               if (s->s_state =3D=3D CEPH_MDS_SESSION_RESTARTING &&
> > > >                   newstate >=3D CEPH_MDS_STATE_RECONNECT) {
> > > >                       mutex_unlock(&mdsc->mutex);
> > > > +                     if (export_targets)
> > > > +                             export_targets[i] =3D 0;
> > > >                       send_mds_reconnect(mdsc, s);
> > > >                       mutex_lock(&mdsc->mutex);
> > > >               }
> > > > @@ -4264,6 +4277,47 @@ static void check_new_map(struct ceph_mds_cl=
ient *mdsc,
> > > >               }
> > > >       }
> > > >
> > > > +     for (i =3D 0; i < newmap->possible_max_rank; i++) {
> > >
> > > The condition on this loop is slightly different from the one below i=
t,
> > > and I'm not sure why. Should this also be checking this?
> > >
> > >     i < newmap->possible_max_rank && i < mdsc->max_sessions
> > >
> > > ...do we need to look at export targets where i >=3D mdsc->max_sessio=
ns ?
> > >
> > > > +             if (!export_targets)
> > > > +                     break;
> > > > +
> > > > +             /*
> > > > +              * Only open and reconnect sessions that don't
> > > > +              * exist yet.
> > > > +              */
> > > > +             if (!export_targets[i] || __have_session(mdsc, i))
> > > > +                     continue;
> > > > +
> > > > +             /*
> > > > +              * In case the export MDS is crashed just after
> > > > +              * the EImportStart journal is flushed, so when
> > > > +              * a standby MDS takes over it and is replaying
> > > > +              * the EImportStart journal the new MDS daemon
> > > > +              * will wait the client to reconnect it, but the
> > > > +              * client may never register/open the sessions
> > > > +              * yet.
> > > > +              *
> > > > +              * It will try to reconnect that MDS daemons if
> > > > +              * the MDSes are in the export targets and is the
> > > > +              * RECONNECT state.
> > > > +              */
> > > > +             newstate =3D ceph_mdsmap_get_state(newmap, i);
> > > > +             if (newstate !=3D CEPH_MDS_STATE_RECONNECT)
> > > > +                     continue;
> > > > +             s =3D __open_export_target_session(mdsc, i);
> > > > +             if (IS_ERR(s)) {
> > > > +                     err =3D PTR_ERR(s);
> > > > +                     pr_err("failed to open export target session,=
 err %d\n",
> > > > +                            err);
> > > > +                     continue;
> > > > +             }
> > > > +             dout("send reconnect to target mds.%d\n", i);
> > > > +             mutex_unlock(&mdsc->mutex);
> > > > +             send_mds_reconnect(mdsc, s);
> > > > +             mutex_lock(&mdsc->mutex);
> > > > +             ceph_put_mds_session(s);
> > >
> > > Suppose we end up in this part of the code, and we have to drop the
> > > mdsc->mutex like this. What ensures that an earlier session in the ar=
ray
> > > won't end up going back into CEPH_MDS_STATE_RECONNECT before we can g=
et
> > > into the loop below? This looks racy.
> > >
> > > > +     }
> > > > +
> > > >       for (i =3D 0; i < newmap->possible_max_rank && i < mdsc->max_=
sessions; i++) {
> > > >               s =3D mdsc->sessions[i];
> > > >               if (!s)
> > > > @@ -4278,6 +4332,8 @@ static void check_new_map(struct ceph_mds_cli=
ent *mdsc,
> > > >                       __open_export_target_sessions(mdsc, s);
> > > >               }
> > > >       }
> > > > +
> > > > +     kfree(export_targets);
> > > >  }
> > > >
> > > >
> > >
> > > --
> > > Jeff Layton <jlayton@kernel.org>
> > >
> >
>
> --
> Jeff Layton <jlayton@kernel.org>
>

